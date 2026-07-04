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
        Schema::create('email_verifications', function (Blueprint $table) {

            $table->id();

            /*
            |--------------------------------------------------------------------------
            | User Reference
            |--------------------------------------------------------------------------
            */
            $table->foreignId('user_id')
                  ->constrained('users')
                  ->cascadeOnDelete();

            /*
            |--------------------------------------------------------------------------
            | Verification OTP
            |--------------------------------------------------------------------------
            */
            $table->string('otp', 6);

            /*
            |--------------------------------------------------------------------------
            | Expiration Time
            |--------------------------------------------------------------------------
            */
            $table->timestamp('expires_at');

            /*
            |--------------------------------------------------------------------------
            | Verification Status
            |--------------------------------------------------------------------------
            */
            $table->boolean('is_verified')->default(false);

            /*
            |--------------------------------------------------------------------------
            | Timestamps
            |--------------------------------------------------------------------------
            */
            $table->timestamps();

            /*
            |--------------------------------------------------------------------------
            | Prevent Multiple OTPs For Same User
            |--------------------------------------------------------------------------
            */
            $table->unique('user_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('email_verifications');
    }
};