<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;


class Attendance extends Model
{
    use HasFactory;

    /**
     * Mass Assignable Attributes
     */
    protected $fillable = [
        'user_id',
        'attendance_date',
        'check_in',
        'check_out',
        'break_start',
        'break_end',
        'working_hours',
        'status',
        'check_in_location',
        'check_out_location',
        'remarks',
    ];

    /**
     * Attribute Casting
     */
    protected $casts = [
        'attendance_date' => 'date',
        'check_in' => 'datetime:H:i',
        'check_out' => 'datetime:H:i',
        'break_start' => 'datetime:H:i',
        'break_end' => 'datetime:H:i',
        'working_hours' => 'decimal:2',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    /*
    |--------------------------------------------------------------------------
    | Relationships
    |--------------------------------------------------------------------------
    */

    /**
     * Attendance belongs to one Employee
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
     * Check if employee is present
     */
    public function isPresent()
    {
        return $this->status === 'Present';
    }

    /**
     * Check if employee is absent
     */
    public function isAbsent()
    {
        return $this->status === 'Absent';
    }

    /**
     * Check if employee is on leave
     */
    public function isLeave()
    {
        return $this->status === 'Leave';
    }

    /**
     * Check if employee is late
     */
    public function isLate()
    {
        return $this->status === 'Late';
    }

    /**
     * Check if employee is half day
     */
    public function isHalfDay()
    {
        return $this->status === 'Half Day';
    }
}