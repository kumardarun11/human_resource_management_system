<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreEmployeeRequest;
use App\Http\Requests\UpdateEmployeeRequest;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AdminController extends Controller
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
public function store(StoreEmployeeRequest $request)
{
    $employee = User::create([

        'employee_id'=>$request->employee_id,

        'name'=>$request->name,

        'email'=>$request->email,

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
    public function update(UpdateEmployeeRequest $request,$id)
{
    $employee = User::find($id);

    if(!$employee){

        return response()->json([

            'success'=>false,

            'message'=>'Employee not found.'

        ],404);

    }

    $employee->update([

        'employee_id'=>$request->employee_id,

        'name'=>$request->name,

        'email'=>$request->email,

        'phone'=>$request->phone,

        'department_id'=>$request->department_id,

        'designation'=>$request->designation,

    ]);

    return response()->json([

        'success'=>true,

        'message'=>'Employee updated successfully.',

        'data'=>$employee->load('department')

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

}