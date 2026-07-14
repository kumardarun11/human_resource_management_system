<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Payroll;
use Illuminate\Database\QueryException;
use Illuminate\Http\Request;

class PayrollController extends Controller
{
    /**
     * Display payroll records.
     *
     * Admin can view all payroll records.
     * Employees can only view their own payroll records.
     */
    public function index(Request $request)
    {
        $user = $request->user();

        $query = Payroll::with('user')
            ->latest();

        if ($user->role !== 'admin') {
            $query->where('user_id', $user->id);
        }

        $payrolls = $query->get();

        return response()->json([
            'success' => true,
            'message' => 'Payroll List',
            'data' => $payrolls,
        ]);
    }

    /**
     * Create a new payroll record.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_id' => [
                'required',
                'integer',
                'exists:users,id',
            ],

            'payroll_month' => [
                'required',
                'string',
                'max:20',
            ],

            'payroll_year' => [
                'required',
                'integer',
                'min:2000',
                'max:2100',
            ],

            'basic_salary' => [
                'required',
                'numeric',
                'min:0',
            ],

            'house_allowance' => [
                'nullable',
                'numeric',
                'min:0',
            ],

            'medical_allowance' => [
                'nullable',
                'numeric',
                'min:0',
            ],

            'transport_allowance' => [
                'nullable',
                'numeric',
                'min:0',
            ],

            'bonus' => [
                'nullable',
                'numeric',
                'min:0',
            ],

            'overtime' => [
                'nullable',
                'numeric',
                'min:0',
            ],

            'tax' => [
                'nullable',
                'numeric',
                'min:0',
            ],

            'provident_fund' => [
                'nullable',
                'numeric',
                'min:0',
            ],

            'other_deductions' => [
                'nullable',
                'numeric',
                'min:0',
            ],

            'payment_status' => [
                'nullable',
                'in:Pending,Paid,Cancelled',
            ],

            'payment_date' => [
                'nullable',
                'date',
            ],

            'payment_method' => [
                'nullable',
                'string',
                'max:255',
            ],

            'remarks' => [
                'nullable',
                'string',
            ],
        ]);

        $basicSalary = (float) $validated['basic_salary'];

        $houseAllowance = (float) (
            $validated['house_allowance'] ?? 0
        );

        $medicalAllowance = (float) (
            $validated['medical_allowance'] ?? 0
        );

        $transportAllowance = (float) (
            $validated['transport_allowance'] ?? 0
        );

        $bonus = (float) (
            $validated['bonus'] ?? 0
        );

        $overtime = (float) (
            $validated['overtime'] ?? 0
        );

        $tax = (float) (
            $validated['tax'] ?? 0
        );

        $providentFund = (float) (
            $validated['provident_fund'] ?? 0
        );

        $otherDeductions = (float) (
            $validated['other_deductions'] ?? 0
        );

        $grossSalary =
            $basicSalary +
            $houseAllowance +
            $medicalAllowance +
            $transportAllowance +
            $bonus +
            $overtime;

        $totalDeductions =
            $tax +
            $providentFund +
            $otherDeductions;

        $netSalary =
            $grossSalary - $totalDeductions;

        if ($netSalary < 0) {
            return response()->json([
                'success' => false,
                'message' => 'Total deductions cannot exceed gross salary.',
            ], 422);
        }

        try {
            $payroll = Payroll::create([
                'user_id' => $validated['user_id'],

                'payroll_month' =>
                    $validated['payroll_month'],

                'payroll_year' =>
                    $validated['payroll_year'],

                'basic_salary' =>
                    $basicSalary,

                'house_allowance' =>
                    $houseAllowance,

                'medical_allowance' =>
                    $medicalAllowance,

                'transport_allowance' =>
                    $transportAllowance,

                'bonus' =>
                    $bonus,

                'overtime' =>
                    $overtime,

                'tax' =>
                    $tax,

                'provident_fund' =>
                    $providentFund,

                'other_deductions' =>
                    $otherDeductions,

                'gross_salary' =>
                    $grossSalary,

                'net_salary' =>
                    $netSalary,

                'payment_status' =>
                    $validated['payment_status'] ?? 'Pending',

                'payment_date' =>
                    $validated['payment_date'] ?? null,

                'payment_method' =>
                    $validated['payment_method'] ?? null,

                'remarks' =>
                    $validated['remarks'] ?? null,
            ]);
        } catch (QueryException $exception) {
            if (
                $exception->getCode() === '23000'
            ) {
                return response()->json([
                    'success' => false,
                    'message' =>
                        'Payroll already exists for this employee, month, and year.',
                ], 409);
            }

            throw $exception;
        }

        $payroll->load('user');

        return response()->json([
            'success' => true,
            'message' => 'Payroll created successfully.',
            'data' => $payroll,
        ], 201);
    }

    /**
     * Display a payroll record.
     */
    public function show(Request $request, $id)
    {
        $payroll = Payroll::with('user')->find($id);

        if (!$payroll) {
            return response()->json([
                'success' => false,
                'message' => 'Payroll not found.',
            ], 404);
        }

        $user = $request->user();

        if (
            $user->role !== 'admin' &&
            $payroll->user_id !== $user->id
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized payroll access.',
            ], 403);
        }

        return response()->json([
            'success' => true,
            'data' => $payroll,
        ]);
    }

    /**
     * Download/view payslip data.
     */
    public function downloadPayslip(
        Request $request,
        $id
    ) {
        $payroll = Payroll::with('user')->find($id);

        if (!$payroll) {
            return response()->json([
                'success' => false,
                'message' => 'Payroll not found.',
            ], 404);
        }

        $user = $request->user();

        if (
            $user->role !== 'admin' &&
            $payroll->user_id !== $user->id
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized payroll access.',
            ], 403);
        }

        return response()->json([
            'success' => true,
            'message' =>
                'Payslip downloaded successfully.',
            'data' => $payroll,
        ]);
    }
}