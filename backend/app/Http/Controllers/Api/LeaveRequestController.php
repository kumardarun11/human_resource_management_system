<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\LeaveRequestStore;
use App\Models\LeaveRequest;
use Carbon\Carbon;
use Illuminate\Http\Request;

class LeaveRequestController extends Controller
{
    public function index()
    {
        $leaves = LeaveRequest::with('user','approver')
                    ->latest()
                    ->get();

        return response()->json([
            'success'=>true,
            'data'=>$leaves
        ]);
    }
    public function show($id)
    {
        $leave = LeaveRequest::with('user','approver')->find($id);

        if(!$leave){

            return response()->json([
                'success'=>false,
                'message'=>'Leave request not found.'
            ],404);

        }

        return response()->json([
            'success'=>true,
            'data'=>$leave
        ]);
    }
    public function store(LeaveRequestStore $request)
    {
        $from = Carbon::parse($request->from_date);

        $to = Carbon::parse($request->to_date);

        $leave = LeaveRequest::create([

            'user_id'=>auth()->id(),

            'leave_type'=>$request->leave_type,

            'from_date'=>$from,

            'to_date'=>$to,

            'total_days'=>$from->diffInDays($to)+1,

            'reason'=>$request->reason,

            'status'=>'Pending'

        ]);

        return response()->json([

            'success'=>true,

            'message'=>'Leave request submitted successfully.',

            'data'=>$leave

        ],201);
    }
    public function approve(Request $request, $id)
    {
        $leave = LeaveRequest::find($id);

        if (!$leave) {

            return response()->json([
                'success' => false,
                'message' => 'Leave request not found.'
            ],404);

        }

        if ($leave->status != 'Pending') {

            return response()->json([
                'success'=>false,
                'message'=>'Leave request already processed.'
            ],400);

        }

        $leave->update([

            'status'=>'Approved',

            'approved_by'=>auth()->id(),

            'approved_at'=>now(),

            'admin_comment'=>$request->admin_comment

        ]);

        return response()->json([

            'success'=>true,

            'message'=>'Leave approved successfully.',

            'data'=>$leave

        ]);
    }
    public function reject(Request $request,$id)
    {
        $leave = LeaveRequest::find($id);

        if(!$leave){

            return response()->json([
                'success'=>false,
                'message'=>'Leave request not found.'
            ],404);

        }

        if($leave->status!='Pending'){

            return response()->json([
                'success'=>false,
                'message'=>'Leave request already processed.'
            ],400);

        }

        $leave->update([

            'status'=>'Rejected',

            'approved_by'=>auth()->id(),

            'approved_at'=>now(),

            'admin_comment'=>$request->admin_comment

        ]);

        return response()->json([

            'success'=>true,

            'message'=>'Leave rejected successfully.',

            'data'=>$leave

        ]);
    }
    public function destroy($id)
    {
        $leave = LeaveRequest::find($id);
    
        if(!$leave){
    
            return response()->json([
    
                'success'=>false,
    
                'message'=>'Leave request not found.'
    
            ],404);
    
        }
    
        $leave->delete();
    
        return response()->json([
    
            'success'=>true,
    
            'message'=>'Leave request deleted successfully.'
    
        ]);
    }
}
