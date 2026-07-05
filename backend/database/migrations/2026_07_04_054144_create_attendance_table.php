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
        Schema::create('attendances', function (Blueprint $table) {

            $table->id();

            // Employee
            $table->foreignId('user_id')
                  ->constrained('users')
                  ->cascadeOnDelete();

            // Attendance Date
            $table->date('attendance_date');

            // Check In / Out
            $table->time('check_in')->nullable();
            $table->time('check_out')->nullable();

            // Break Time
            $table->time('break_start')->nullable();
            $table->time('break_end')->nullable();

            // Working Hours
            $table->decimal('working_hours', 5, 2)->default(0);

            // Attendance Status
            $table->enum('status', [
                'Present',
                'Absent',
                'Half Day',
                'Leave',
                'Late'
            ])->default('Present');

            // Location (Optional)
            $table->string('check_in_location')->nullable();
            $table->string('check_out_location')->nullable();

            // Remarks
            $table->text('remarks')->nullable();

            $table->timestamps();

            // Prevent duplicate attendance for the same employee on the same day
            $table->unique(['user_id', 'attendance_date']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('attendances');
    }
};