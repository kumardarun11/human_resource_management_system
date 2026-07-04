<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\AttendanceController;
use App\Http\Controllers\Api\LeaveRequestController;
use App\Http\Controllers\Api\PayrollController;
use App\Http\Controllers\Api\DashboardController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// Public Routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Protected Routes
Route::middleware('auth:sanctum')->group(function () {

    Route::post('/logout', [AuthController::class, 'logout']);

    Route::get('/profile', [AuthController::class, 'profile']);

    Route::post('/change-password', [AuthController::class, 'changePassword']);

    Route::post('/refresh-token', [AuthController::class, 'refreshToken']);

    Route::post('/verify-email', [AuthController::class, 'verifyEmail']);

    Route::post('/resend-verification', [AuthController::class, 'resendVerificationEmail']);

    Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);

    Route::post('/reset-password', [AuthController::class, 'resetPassword']);
/*
|--------------------------------------------------------------------------
| Attendance Routes
|--------------------------------------------------------------------------
*/

Route::prefix('attendance')->group(function () {

    Route::get('/', [AttendanceController::class, 'index']);

    Route::post('/', [AttendanceController::class, 'store']);

    Route::post('/check-in', [AttendanceController::class, 'checkIn']);

    Route::post('/check-out', [AttendanceController::class, 'checkOut']);

    Route::get('/history', [AttendanceController::class, 'attendanceHistory']);

    Route::get('/{id}', [AttendanceController::class, 'show']);

    Route::delete('/{id}', [AttendanceController::class, 'destroy']);

});

/*
|--------------------------------------------------------------------------
| Leave Routes
|--------------------------------------------------------------------------
*/

Route::prefix('leave')->group(function () {

    Route::get('/', [LeaveRequestController::class, 'index']);

    Route::post('/', [LeaveRequestController::class, 'store']);

    Route::get('/{id}', [LeaveRequestController::class, 'show']);

    Route::put('/approve/{id}', [LeaveRequestController::class, 'approve']);

    Route::put('/reject/{id}', [LeaveRequestController::class, 'reject']);

    Route::delete('/{id}', [LeaveRequestController::class, 'destroy']);

});

});