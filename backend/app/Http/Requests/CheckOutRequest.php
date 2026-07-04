<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class CheckOutRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'check_out_location' => 'nullable|string|max:255',
            'remarks' => 'nullable|string|max:500',
        ];
    }
}