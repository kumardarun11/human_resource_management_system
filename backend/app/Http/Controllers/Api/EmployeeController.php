<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class EmployeeController extends Controller
{
    public function index()
{
    $employees = User::where('role', 'employee')
        ->with('department')
        ->orderBy('name')
        ->get();

    return response()->json([

        'success' => true,

        'message' => 'Employee List',

        'data' => $employees

    ]);
}
public function show($id)
{
    $employee = User::where('role','employee')
        ->with('department')
        ->find($id);

    if(!$employee){

        return response()->json([

            'success'=>false,

            'message'=>'Employee not found.'

        ],404);

    }

    return response()->json([

        'success'=>true,

        'data'=>$employee

    ]);
}
public function store(Request $request)
{
    $request->validate([

        'employee_id'=>'required|unique:users',

        'name'=>'required|string|max:255',

        'email'=>'required|email|unique:users',

        'password'=>'required|min:8',

        'phone'=>'nullable',

        'department_id'=>'nullable|exists:departments,id',

        'designation'=>'nullable|string|max:255',

    ]);

    $employee = User::create([

        'employee_id'=>$request->employee_id,

        'name'=>$request->name,

        'email'=>$request->email,

        'email_verified_at' => now(),

        'password'=>Hash::make($request->password),

        'phone'=>$request->phone,

        'department_id'=>$request->department_id,

        'designation'=>$request->designation,

        'role'=>'employee',

    ]);

    return response()->json([

        'success'=>true,

        'message'=>'Employee created successfully.',

        'data'=>$employee->load('department')

    ],201);
}
public function update(Request $request, $id)
{
    $employee = User::find($id);

    if (!$employee) {
        return response()->json([
            'success' => false
        ], 404);
    }

    $request->validate([
        'employee_id' => 'required|unique:users,employee_id,' . $employee->id,
        'name' => 'required|string|max:255',
        'email' => 'required|email|unique:users,email,' . $employee->id,
        'phone' => 'nullable',
        'department_id' => 'nullable|exists:departments,id',
        'designation' => 'nullable|string|max:255',
    ]);

    return response()->json([
        'validated' => true
    ]);
}
public function destroy($id)
{
    $employee = User::find($id);

    if(!$employee){

        return response()->json([

            'success'=>false,

            'message'=>'Employee not found.'

        ],404);

    }

    $employee->delete();

    return response()->json([

        'success'=>true,

        'message'=>'Employee deleted successfully.'

    ]);
}
public function profile(Request $request)
{
    return response()->json([

        'success'=>true,

        'message'=>'Employee Profile',

        'data'=>$request->user()->load('department')

    ]);
}
public function updateProfile(Request $request)
{
    $user = $request->user();

    $request->validate([

        'name'=>'required|string|max:255',

        'phone'=>'nullable|string|max:20',

        'address'=>'nullable|string',

        'city'=>'nullable|string',

        'state'=>'nullable|string',

        'country'=>'nullable|string',

        'postal_code'=>'nullable|string',

    ]);

    $user->update([

        'name'=>$request->name,

        'phone'=>$request->phone,

        'address'=>$request->address,

        'city'=>$request->city,

        'state'=>$request->state,

        'country'=>$request->country,

        'postal_code'=>$request->postal_code,

    ]);

    return response()->json([

        'success'=>true,

        'message'=>'Profile updated successfully.',

        'data'=>$user->load('department')

    ]);
}
}