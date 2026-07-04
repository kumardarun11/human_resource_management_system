<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LeaveRequest extends Model
{
    use HasFactory;

    /**
     * Mass Assignable Attributes
     */
    protected $fillable = [
        'user_id',
        'leave_type',
        'from_date',
        'to_date',
        'total_days',
        'reason',
        'status',
        'approved_by',
        'approved_at',
        'admin_comment',
    ];

    /**
     * Attribute Casting
     */
    protected $casts = [
        'from_date' => 'date',
        'to_date' => 'date',
        'approved_at' => 'datetime',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    /*
    |--------------------------------------------------------------------------
    | Relationships
    |--------------------------------------------------------------------------
    */

    /**
     * Employee who applied for leave
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Admin who approved/rejected the leave
     */
    public function approver()
    {
        return $this->belongsTo(User::class, 'approved_by');
    }

    /*
    |--------------------------------------------------------------------------
    | Helper Methods
    |--------------------------------------------------------------------------
    */

    /**
     * Check if leave is pending
     */
    public function isPending()
    {
        return $this->status === 'Pending';
    }

    /**
     * Check if leave is approved
     */
    public function isApproved()
    {
        return $this->status === 'Approved';
    }

    /**
     * Check if leave is rejected
     */
    public function isRejected()
    {
        return $this->status === 'Rejected';
    }

    /**
     * Check if leave is cancelled
     */
    public function isCancelled()
    {
        return $this->status === 'Cancelled';
    }
}