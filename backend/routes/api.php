<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\AttendanceController;
use App\Http\Controllers\Api\LeaveRequestController;
use App\Http\Controllers\Api\PayrollController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\EmployeeController;
use App\Http\Controllers\Api\AdminController;
use App\Http\Controllers\Api\DepartmentController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// Public Routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/verify-email', [
    AuthController::class,
    'verifyEmail'
]);

// Protected Routes
Route::middleware('auth:sanctum')->group(function () {

    Route::post('/logout', [AuthController::class, 'logout']);

    Route::get('/profile', [AuthController::class, 'profile']);

    Route::post('/change-password', [AuthController::class, 'changePassword']);

    Route::post('/refresh-token', [AuthController::class, 'refreshToken']);

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

/*
|--------------------------------------------------------------------------
| Payroll Routes
|--------------------------------------------------------------------------
*/

Route::prefix('payroll')->group(function () {

    Route::get('/', [
        PayrollController::class,
        'index'
    ]);

    Route::middleware('admin')->group(function () {

        Route::post('/', [
            PayrollController::class,
            'store'
        ]);

    });

    Route::get('/download/{id}', [
        PayrollController::class,
        'downloadPayslip'
    ]);

    Route::get('/{id}', [
        PayrollController::class,
        'show'
    ]);

});
Route::middleware('employee')->group(function(){

    Route::get('/employee/profile',[EmployeeController::class,'profile']);

    Route::put('/employee/profile',[EmployeeController::class,'updateProfile']);

});

Route::middleware('admin')->group(function(){

    Route::get('/employees',[EmployeeController::class,'index']);

    Route::get('/employees/{id}',[EmployeeController::class,'show']);

    Route::post('/employees',[EmployeeController::class,'store']);

    Route::put('/employees/{id}',[EmployeeController::class,'update']);

    Route::delete('/employees/{id}',[EmployeeController::class,'destroy']);

});
/*
|--------------------------------------------------------------------------
| Admin Routes
|--------------------------------------------------------------------------
*/

Route::middleware('admin')->prefix('admin')->group(function () {

    Route::get('/employees',[AdminController::class,'index']);

    Route::post('/employees',[AdminController::class,'store']);

    Route::get('/employees/{id}',[AdminController::class,'show']);

    Route::put('/employees/{id}',[AdminController::class,'update']);

    Route::delete('/employees/{id}',[AdminController::class,'destroy']);

});
Route::middleware('admin')->prefix('departments')->group(function(){

    Route::get('/',[DepartmentController::class,'index']);

    Route::post('/',[DepartmentController::class,'store']);

    Route::get('/{id}',[DepartmentController::class,'show']);

    Route::put('/{id}',[DepartmentController::class,'update']);

    Route::delete('/{id}',[DepartmentController::class,'destroy']);

});
Route::middleware('employee')->group(function () {

    Route::get('/dashboard/employee', [DashboardController::class, 'employeeDashboard']);

});

Route::middleware('admin')->group(function () {

    Route::get('/dashboard/admin', [DashboardController::class, 'adminDashboard']);

});
});