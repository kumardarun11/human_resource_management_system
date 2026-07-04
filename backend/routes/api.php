<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;

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

});