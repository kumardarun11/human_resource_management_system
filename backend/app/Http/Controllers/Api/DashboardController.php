<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Attendance;
use App\Models\LeaveRequest;
use App\Models\Department;
use App\Models\Payroll;

class DashboardController extends Controller
{
    /**
     * Admin Dashboard
     */
    public function adminDashboard()
    {
        return response()->json([

            'success' => true,

            'message' => 'Admin Dashboard',

            'data' => [

                'total_employees' => User::where('role', 'employee')->count(),

                'total_departments' => Department::count(),

                'attendance_records' => Attendance::count(),

                'leave_requests' => LeaveRequest::count(),

                'payroll_records' => Payroll::count(),

                'present_today' => Attendance::whereDate('attendance_date', today())
                    ->where('status', 'Present')
                    ->count(),

                'late_today' => Attendance::whereDate('attendance_date', today())
                    ->where('status', 'Late')
                    ->count(),

                'half_day_today' => Attendance::whereDate('attendance_date', today())
                    ->where('status', 'Half Day')
                    ->count(),

                'pending_leaves' => LeaveRequest::where('status', 'Pending')->count(),

                'approved_leaves' => LeaveRequest::where('status', 'Approved')->count(),

                'rejected_leaves' => LeaveRequest::where('status', 'Rejected')->count(),

            ]

        ]);
    }

    /**
     * Employee Dashboard
     */
    public function employeeDashboard()
    {
        $user = auth()->user();

        return response()->json([

            'success' => true,

            'message' => 'Employee Dashboard',

            'data' => [

                'employee_name' => $user->name,

                'department' => optional($user->department)->name,

                'designation' => $user->designation,

                'attendance_count' => Attendance::where('user_id', $user->id)->count(),

                'present_days' => Attendance::where('user_id', $user->id)
                    ->where('status', 'Present')
                    ->count(),

                'late_days' => Attendance::where('user_id', $user->id)
                    ->where('status', 'Late')
                    ->count(),

                'leave_count' => LeaveRequest::where('user_id', $user->id)->count(),

                'pending_leaves' => LeaveRequest::where('user_id', $user->id)
                    ->where('status', 'Pending')
                    ->count(),

                'approved_leaves' => LeaveRequest::where('user_id', $user->id)
                    ->where('status', 'Approved')
                    ->count(),

                'latest_attendance' => Attendance::where('user_id', $user->id)
                    ->latest()
                    ->first(),

                'latest_leave' => LeaveRequest::where('user_id', $user->id)
                    ->latest()
                    ->first(),

                'latest_payroll' => Payroll::where('user_id', $user->id)
                    ->latest()
                    ->first(),

            ]

        ]);
    }
}