<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class LeaveRequestStore extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [

            'leave_type' => 'required|in:Paid Leave,Sick Leave,Casual Leave,Emergency Leave,Unpaid Leave',

            'from_date' => 'required|date',

            'to_date' => 'required|date|after_or_equal:from_date',

            'reason' => 'nullable|string|max:500',

        ];
    }
}