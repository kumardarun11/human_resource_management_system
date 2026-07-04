<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreDepartmentRequest;
use App\Http\Requests\UpdateDepartmentRequest;
use App\Models\Department;

class DepartmentController extends Controller
{
    public function index()
    {
        $departments = Department::withCount('users')->get();

        return response()->json([
            'success' => true,
            'message' => 'Department List',
            'data' => $departments
        ]);
    }

    public function store(StoreDepartmentRequest $request)
    {
        $department = Department::create($request->validated());

        return response()->json([
            'success' => true,
            'message' => 'Department Created Successfully',
            'data' => $department
        ],201);
    }

    public function show($id)
    {
        $department = Department::with('users')->find($id);

        if(!$department){
            return response()->json([
                'success'=>false,
                'message'=>'Department Not Found'
            ],404);
        }

        return response()->json([
            'success'=>true,
            'data'=>$department
        ]);
    }

    public function update(UpdateDepartmentRequest $request,$id)
    {
        $department = Department::find($id);

        if(!$department){
            return response()->json([
                'success'=>false,
                'message'=>'Department Not Found'
            ],404);
        }

        $department->update($request->validated());

        return response()->json([
            'success'=>true,
            'message'=>'Department Updated Successfully',
            'data'=>$department
        ]);
    }

    public function destroy($id)
    {
        $department = Department::find($id);

        if(!$department){
            return response()->json([
                'success'=>false,
                'message'=>'Department Not Found'
            ],404);
        }

        $department->delete();

        return response()->json([
            'success'=>true,
            'message'=>'Department Deleted Successfully'
        ]);
    }
}