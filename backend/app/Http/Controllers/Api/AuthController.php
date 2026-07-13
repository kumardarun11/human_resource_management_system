<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Auth\Events\Registered;
use Laravel\Sanctum\Sanctum;
use App\Models\EmailVerification;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Mail;
use App\Mail\EmailVerificationOtpMail;
use Illuminate\Support\Facades\Password;
use Illuminate\Auth\Events\PasswordReset;

class AuthController extends Controller
{
    
    /**
     * Register a new Employee / Admin
     */
    public function register(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'employee_id' => 'required|string|max:20|unique:users,employee_id',
            'name'        => 'required|string|max:255',
            'email'       => 'required|email|max:255|unique:users,email',
            'phone'       => 'nullable|string|max:20',
            'password'    => 'required|string|min:8|confirmed',
            'role'        => 'required|in:employee,admin',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed.',
                'errors'  => $validator->errors(),
            ], 422);
        }

        DB::beginTransaction();

        

        try {

            // Create User
            $user = User::create([
                'employee_id' => $request->employee_id,
                'name'        => $request->name,
                'email'       => $request->email,
                'phone'       => $request->phone,
                'password'    => Hash::make($request->password),
                'role'        => $request->role,
            ]);



            // Generate 6-digit OTP
            $otp = random_int(100000, 999999);

            // Save OTP
            EmailVerification::updateOrCreate(
                ['user_id' => $user->id],
                [
                    'otp' => $otp,
                    'expires_at' => now()->addMinutes(10),
                    'is_verified' => false,
                ]
            );

            /*
            |--------------------------------------------------------------------------
            | Send OTP Email
            */

            // Mail::to($user->email)->send(
            //     new EmailVerificationOtpMail($user, $otp)
            // );

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Registration successful. Please verify your email using the OTP sent to your email address.',
                'data' => [
                    'user_id' => $user->id,
                    'email'   => $user->email,
                ]
            ], 201);

        } catch (\Exception $e) {

            DB::rollBack();

            return response()->json([
                'success' => false,
                'message' => 'Registration failed.',
                'error'   => $e->getMessage(),
            ], 500);
        }
    }

    
    /**
     * Login User
    */
    public function login(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed.',
                'errors' => $validator->errors()
            ], 422);
        }

        if (!Auth::attempt([
            'email' => $request->email,
            'password' => $request->password
        ])) {

            return response()->json([
                'success' => false,
                'message' => 'Invalid email or password.'
            ], 401);
        }

        $user = User::with('department')->where('email', $request->email)->first();

        // Check Email Verification
        if (is_null($user->email_verified_at)) {

            Auth::logout();

            return response()->json([
                'success' => false,
                'message' => 'Please verify your email before logging in.'
            ], 403);
        }

        // Check Employee Status
        if ($user->employment_status !== 'Active') {

            Auth::logout();

            return response()->json([
                'success' => false,
                'message' => 'Your account is currently inactive. Please contact the administrator.'
            ], 403);
        }

        // Remove old tokens (Optional)
        $user->tokens()->delete();

        // Create New Token
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Login successful.',
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $user,
        ], 200);
    }

    /**
     * Logout User
     */
    public function logout(Request $request): JsonResponse
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'User logged out successfully'
        ]);
    }

    /**
     * Send Email Verification Link Again
     */
    public function resendVerificationEmail(Request $request): JsonResponse
    {
        $request->user()->sendEmailVerificationNotification();

        return response()->json([
            'success' => true,
            'message' => 'Verification email sent successfully'
        ]);
    }

    /**
     * Verify Email
     */
    public function verifyEmail(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|exists:users,id',
            'otp' => 'required|digits:6',
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed.',
                'errors' => $validator->errors(),
            ], 422);
        }
    
        $user = User::find($request->user_id);
    
        $verification = EmailVerification::where(
            'user_id',
            $user->id
        )->first();
    
        if (!$verification) {
            return response()->json([
                'success' => false,
                'message' => 'Verification request not found.',
            ], 404);
        }
    
        if ($verification->is_verified) {
            return response()->json([
                'success' => true,
                'message' => 'Email already verified.',
            ], 200);
        }
    
        if ($verification->isExpired()) {
            return response()->json([
                'success' => false,
                'message' => 'OTP has expired.',
            ], 410);
        }
    
        if ((string) $verification->otp !== (string) $request->otp) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid OTP.',
            ], 422);
        }
    
        DB::transaction(function () use ($user, $verification) {
    
            $user->markEmailAsVerified();
    
            $verification->update([
                'is_verified' => true,
            ]);
    
        });
    
        return response()->json([
            'success' => true,
            'message' => 'Email verified successfully.',
        ], 200);
    }

    /**
     * Forgot Password
     */
    public function forgotPassword(Request $request): JsonResponse
    {
        $request->validate(['email' => 'required|email']);

        $user = User::where('email', $request->email)->first();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User not found'
            ], 404);
        }

        // Here you would typically send a password reset email
        // For now, we'll just return a success message

        return response()->json([
            'success' => true,
            'message' => 'Password reset email sent successfully'
        ]);

    }

    /**
     * Reset Password
     */
    public function resetPassword(Request $request): JsonResponse
    {
        $request->validate([
            'token' => 'required',
            'email' => 'required|email',
            'password' => 'required|string|min:8|confirmed',
        ]);

        // Here you would typically verify the token and reset the password
        // For now, we'll just return a success message

        return response()->json([
            'success' => true,
            'message' => 'Password reset successfully'
        ]);
    }

    /**
     * Get Logged In User Profile
     */
    public function profile(Request $request): JsonResponse
    {
        $user = User::with('department')
            ->find($request->user()->id);

        return response()->json([
            'success' => true,
            'user' => $user
        ]);
    }

    /**
     * Change Password
     */
    public function changePassword(Request $request): JsonResponse
    {
        $request->validate([
            'current_password' => 'required',
            'new_password' => 'required|string|min:8|confirmed',
        ]);

        $user = $request->user();

        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Current password is incorrect'
            ], 400);
        }

        $user->password = Hash::make($request->new_password);
        $user->save();

        return response()->json([
            'success' => true,
            'message' => 'Password changed successfully'
        ]);
    }

    /**
     * Refresh Authentication Token
     */
    public function refreshToken(Request $request): JsonResponse
    {
        $user = $request->user();

        // Remove old tokens
        $user->tokens()->delete();

        // Generate new token
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Token refreshed successfully.',
            'access_token' => $token,
            'token_type' => 'Bearer'
        ]);
    }
}