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
        Schema::create('payrolls', function (Blueprint $table) {

            $table->id();

            // Employee
            $table->foreignId('user_id')
                  ->constrained('users')
                  ->cascadeOnDelete();

            // Payroll Period
            $table->string('payroll_month'); // Example: July
            $table->year('payroll_year');

            // Salary Components
            $table->decimal('basic_salary', 10, 2)->default(0);
            $table->decimal('house_allowance', 10, 2)->default(0);
            $table->decimal('medical_allowance', 10, 2)->default(0);
            $table->decimal('transport_allowance', 10, 2)->default(0);
            $table->decimal('bonus', 10, 2)->default(0);
            $table->decimal('overtime', 10, 2)->default(0);

            // Deductions
            $table->decimal('tax', 10, 2)->default(0);
            $table->decimal('provident_fund', 10, 2)->default(0);
            $table->decimal('other_deductions', 10, 2)->default(0);

            // Final Salary
            $table->decimal('gross_salary', 10, 2)->default(0);
            $table->decimal('net_salary', 10, 2)->default(0);

            // Payment Details
            $table->enum('payment_status', [
                'Pending',
                'Paid',
                'Cancelled'
            ])->default('Pending');

            $table->date('payment_date')->nullable();
            $table->string('payment_method')->nullable();

            // Remarks
            $table->text('remarks')->nullable();

            $table->timestamps();

            // Prevent duplicate payroll for same employee and month/year
            $table->unique([
                'user_id',
                'payroll_month',
                'payroll_year'
            ]);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('payrolls');
    }
};