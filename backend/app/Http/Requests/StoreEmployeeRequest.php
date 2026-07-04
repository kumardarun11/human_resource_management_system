<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreEmployeeRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [

            'employee_id'=>'required|unique:users',

            'name'=>'required|string|max:255',

            'email'=>'required|email|unique:users',

            'password'=>'required|min:8',

            'phone'=>'nullable|string|max:20',

            'department_id'=>'nullable|exists:departments,id',

            'designation'=>'nullable|string|max:255',

        ];
    }
}