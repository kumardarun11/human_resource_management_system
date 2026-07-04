<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EmployeeMiddleware
{
    public function handle(Request $request, Closure $next): Response
    {
        if (!auth()->check()) {

            return response()->json([
                'success' => false,
                'message' => 'Unauthorized'
            ],401);

        }

        if (auth()->user()->role != 'employee') {

            return response()->json([
                'success' => false,
                'message' => 'Access denied. Employee only.'
            ],403);

        }

        return $next($request);
    }
}