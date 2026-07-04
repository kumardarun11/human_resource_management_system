<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class PayrollRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [

            'basic_salary' => 'required|numeric',

            'allowances' => 'nullable|numeric',

            'deductions' => 'nullable|numeric',

            'net_salary' => 'required|numeric',

            'salary_month' => 'required|string'

        ];
    }
}