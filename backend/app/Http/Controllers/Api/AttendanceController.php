<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\CheckInRequest;
use App\Http\Requests\CheckOutRequest;
use App\Models\Attendance;
use Illuminate\Http\Request;
use Carbon\Carbon;

class AttendanceController extends Controller
{

    public function index()
    {
        $attendance = Attendance::with('user')->latest()->get();

        return response()->json([
            'success' => true,
            'message' => 'Attendance List',
            'data' => $attendance
        ]);
    }
    public function show($id)
    {
        $attendance = Attendance::with('user')->find($id);

        if (!$attendance) {
            return response()->json([
                'success' => false,
                'message' => 'Attendance record not found.'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Attendance Details',
            'data' => $attendance
        ]);
    }
    public function store(Request $request)
    {
        $attendance = Attendance::create([
            'user_id' => $request->user_id,
            'attendance_date' => $request->attendance_date,
            'check_in' => $request->check_in,
            'check_out' => $request->check_out,
            'status' => $request->status,
            'remarks' => $request->remarks,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Attendance created successfully.',
            'data' => $attendance
        ], 201);
    }
    public function checkIn(CheckInRequest $request)
    {
        $user = auth()->user();

        // Check if attendance already exists for today
        $attendance = Attendance::where('user_id', $user->id)
            ->whereDate('attendance_date', Carbon::today())
            ->first();

        if ($attendance) {
            return response()->json([
                'success' => false,
                'message' => 'You have already checked in today.'
            ], 409);
        }

        $checkInTime = Carbon::now();

        // Office starts at 9:15 AM
        $status = $checkInTime->gt(Carbon::today()->setTime(9, 15))
            ? 'Late'
            : 'Present';

        $attendance = Attendance::create([
            'user_id' => $user->id,
            'attendance_date' => Carbon::today(),
            'check_in' => $checkInTime->format('H:i:s'),
            'status' => $status,
            'check_in_location' => $request->check_in_location,
            'remarks' => $request->remarks,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Checked in successfully.',
            'data' => $attendance,
        ], 201);
    }
    public function checkOut(CheckOutRequest $request)
    {
        $user = auth()->user();

        // Find today's attendance
        $attendance = Attendance::where('user_id', $user->id)
            ->whereDate('attendance_date', Carbon::today())
            ->first();

        if (!$attendance) {
            return response()->json([
                'success' => false,
                'message' => 'You have not checked in today.'
            ], 404);
        }

        // Prevent multiple checkouts
        if ($attendance->check_out) {
            return response()->json([
                'success' => false,
                'message' => 'You have already checked out today.'
            ], 409);
        }

        $checkOutTime = Carbon::now();

        // Calculate working hours
        $checkInTime = Carbon::parse($attendance->check_in);

        $workingMinutes = $checkInTime->diffInMinutes($checkOutTime);

        $workingHours = round($workingMinutes / 60, 2);

        // Update attendance
        $attendance->update([
            'check_out' => $checkOutTime->format('H:i:s'),
            'working_hours' => $workingHours,
            'check_out_location' => $request->check_out_location,
            'remarks' => $request->remarks,
        ]);

        // Half Day Logic
        if ($workingHours < 4) {
            $attendance->status = 'Half Day';
            $attendance->save();
        }

        return response()->json([
            'success' => true,
            'message' => 'Checked out successfully.',
            'data' => $attendance
        ]);
    }
    public function attendanceHistory()
    {
        $attendance = Attendance::where('user_id', auth()->id())
            ->orderBy('attendance_date', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Attendance History',
            'data' => $attendance
        ]);
    }
    public function destroy($id)
    {
        $attendance = Attendance::find($id);
    
        if (!$attendance) {
            return response()->json([
                'success' => false,
                'message' => 'Attendance not found.'
            ],404);
        }
    
        $attendance->delete();
    
        return response()->json([
            'success' => true,
            'message' => 'Attendance deleted successfully.'
        ]);
    }
}