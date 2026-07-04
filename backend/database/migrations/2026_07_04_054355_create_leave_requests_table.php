<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('leave_requests', function (Blueprint $table) {

            $table->id();

            // Employee
            $table->foreignId('user_id')
                  ->constrained('users')
                  ->cascadeOnDelete();

            // Leave Details
            $table->enum('leave_type', [
                'Paid Leave',
                'Sick Leave',
                'Casual Leave',
                'Emergency Leave',
                'Unpaid Leave'
            ]);

            $table->date('from_date');
            $table->date('to_date');

            // Total Leave Days
            $table->integer('total_days');

            // Reason
            $table->text('reason')->nullable();

            // Status
            $table->enum('status', [
                'Pending',
                'Approved',
                'Rejected',
                'Cancelled'
            ])->default('Pending');

            // Admin Approval
            $table->foreignId('approved_by')
                  ->nullable()
                  ->constrained('users')
                  ->nullOnDelete();

            $table->timestamp('approved_at')->nullable();

            $table->text('admin_comment')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('leave_requests');
    }
};