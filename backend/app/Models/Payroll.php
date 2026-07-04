<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Payroll extends Model
{
    use HasFactory;

    /**
     * Mass Assignable Attributes
     */
    protected $fillable = [
        'user_id',
        'payroll_month',
        'payroll_year',
        'basic_salary',
        'house_allowance',
        'medical_allowance',
        'transport_allowance',
        'bonus',
        'overtime',
        'tax',
        'provident_fund',
        'other_deductions',
        'gross_salary',
        'net_salary',
        'payment_status',
        'payment_date',
        'payment_method',
        'remarks',
    ];

    /**
     * Attribute Casting
     */
    protected $casts = [
        'basic_salary' => 'decimal:2',
        'house_allowance' => 'decimal:2',
        'medical_allowance' => 'decimal:2',
        'transport_allowance' => 'decimal:2',
        'bonus' => 'decimal:2',
        'overtime' => 'decimal:2',
        'tax' => 'decimal:2',
        'provident_fund' => 'decimal:2',
        'other_deductions' => 'decimal:2',
        'gross_salary' => 'decimal:2',
        'net_salary' => 'decimal:2',
        'payment_date' => 'date',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    /*
    |--------------------------------------------------------------------------
    | Relationships
    |--------------------------------------------------------------------------
    */

    /**
     * Payroll belongs to one Employee
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /*
    |--------------------------------------------------------------------------
    | Helper Methods
    |--------------------------------------------------------------------------
    */

    /**
     * Check if payroll is paid
     */
    public function isPaid()
    {
        return $this->payment_status === 'Paid';
    }

    /**
     * Check if payroll is pending
     */
    public function isPending()
    {
        return $this->payment_status === 'Pending';
    }

    /**
     * Check if payroll is cancelled
     */
    public function isCancelled()
    {
        return $this->payment_status === 'Cancelled';
    }

    /**
     * Calculate Total Earnings
     */
    public function getTotalEarningsAttribute()
    {
        return
            $this->basic_salary +
            $this->house_allowance +
            $this->medical_allowance +
            $this->transport_allowance +
            $this->bonus +
            $this->overtime;
    }

    /**
     * Calculate Total Deductions
     */
    public function getTotalDeductionsAttribute()
    {
        return
            $this->tax +
            $this->provident_fund +
            $this->other_deductions;
    }
}