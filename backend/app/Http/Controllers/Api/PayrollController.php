<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\PayrollRequest;
use App\Models\Payroll;
use Illuminate\Http\Request;

class PayrollController extends Controller
{
    public function index()
    {
        $payrolls = Payroll::with('user')
            ->latest()
            ->get();
    
        return response()->json([
            'success' => true,
            'message' => 'Payroll List',
            'data' => $payrolls
        ]);
    }
    public function show($id)
    {
        $payroll = Payroll::with('user')->find($id);

        if (!$payroll) {

            return response()->json([
                'success' => false,
                'message' => 'Payroll not found.'
            ],404);

        }

        return response()->json([
            'success' => true,
            'data' => $payroll
        ]);
    }
    public function downloadPayslip($id)
    {
        $payroll = Payroll::with('user')->find($id);

        if (!$payroll) {

            return response()->json([
                'success' => false,
                'message' => 'Payroll not found.'
            ],404);

        }

        return response()->json([
            'success' => true,
            'message' => 'Payslip downloaded successfully.',
            'data' => $payroll
        ]);
    }
    
}