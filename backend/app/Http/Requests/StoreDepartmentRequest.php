<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreDepartmentRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [

            'department_code'=>'required|string|max:20|unique:departments',

            'department_name'=>'required|string|max:255',

            'email'=>'nullable|email',

            'phone'=>'nullable|string|max:20',

            'description'=>'nullable|string',

            'status'=>'required|in:Active,Inactive'

        ];
    }
}