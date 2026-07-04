<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Department extends Model
{
    use HasFactory;

    /**
     * Mass Assignable Attributes
     */
    protected $fillable = [
        'department_code',
        'department_name',
        'email',
        'phone',
        'description',
        'status',
    ];

    /**
     * Attribute Casting
     */
    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    /*
    |--------------------------------------------------------------------------
    | Relationships
    |--------------------------------------------------------------------------
    */

    /**
     * One Department has many Employees
     */
    public function users()
    {
        return $this->hasMany(User::class);
    }

    /*
    |--------------------------------------------------------------------------
    | Helper Methods
    |--------------------------------------------------------------------------
    */

    /**
     * Get Active Employees
     */
    public function activeUsers()
    {
        return $this->hasMany(User::class)
                    ->where('employment_status', 'Active');
    }

    /**
     * Count Total Employees
     */
    public function getTotalEmployeesAttribute()
    {
        return $this->users()->count();
    }

    /**
     * Count Active Employees
     */
    public function getActiveEmployeesAttribute()
    {
        return $this->activeUsers()->count();
    }
}