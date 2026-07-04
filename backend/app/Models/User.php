<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Notifications\Notifiable;

use App\Models\Department;
use App\Models\Attendance;
use App\Models\LeaveRequest;
use App\Models\Payroll;

class User extends Authenticatable implements MustVerifyEmail
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable,HasApiTokens;

    /**
     * The attributes that are mass assignable.
     */
    protected $fillable = [
        'employee_id',
        'name',
        'email',
        'phone',
        'password',
        'role',
        'profile_photo',
        'date_of_birth',
        'gender',
        'department_id',
        'designation',
        'joining_date',
        'address',
        'city',
        'state',
        'country',
        'postal_code',
        'employment_status',
        'emergency_contact_name',
        'emergency_contact_phone',
        'emergency_contact_relation',
        'device_id',
    ];

    /**
     * The attributes that should be hidden.
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'date_of_birth' => 'date',
        'joining_date' => 'date',
        'password' => 'hashed',
    ];

    /*
    |--------------------------------------------------------------------------
    | Relationships
    |--------------------------------------------------------------------------
    */

    /**
     * User belongs to one department.
     */
    public function department()
    {
        return $this->belongsTo(Department::class, 'department_id');
    }

    /**
     * User has many attendance records.
     */
    public function attendances()
    {
        return $this->hasMany(Attendance::class);
    }

    /**
     * User has many leave requests.
     */
    public function leaveRequests()
    {
        return $this->hasMany(LeaveRequest::class);
    }

    /**
     * Admin has approved many leave requests.
     */
    public function approvedLeaves()
    {
        return $this->hasMany(LeaveRequest::class, 'approved_by');
    }

    /**
     * User has many payroll records.
     */
    public function payrolls()
    {
        return $this->hasMany(Payroll::class);
    }

    /*
    |--------------------------------------------------------------------------
    | Helper Methods
    |--------------------------------------------------------------------------
    */

    /**
     * Check if the user is an Admin.
     */
    public function isAdmin(): bool
    {
        return $this->role === 'admin';
    }

    /**
     * Check if the user is an Employee.
     */
    public function isEmployee(): bool
    {
        return $this->role === 'employee';
    }
}