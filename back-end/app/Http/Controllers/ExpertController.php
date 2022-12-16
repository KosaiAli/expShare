<?php

namespace App\Http\Controllers;

use App\Models\Appointment;
use App\Models\Expert;
use App\Models\Time;
use App\Models\User;
use Illuminate\Http\Request;

class ExpertController extends Controller
{
    public function expertData(Request $request)
    {
        $user_data = auth()->user();
        if (!$user_data['isExpert']) {
            return response()->json([
                "message" => "not allow"
            ]); }
        $validatedData = $request->validate([
            'imageUrl' => 'required',
            'phoneNum' => 'required',
            'address' => 'required|min:10',
            'details' => 'required|min:10',
            'price' => 'required',
            'user_id' => 'nullable',
            'specialty_id' => 'required'

        ]);
        $validatedData1=request (['imageUrl','phoneNum','address','details','price','user_id','specialty_id']);
        $validatedData1['user_id']=$user_data['id'];

        /*$imageName=time(). '.' .$request->imageUrl->extension ();
        $request->imageUrl->move (public_path ('images'), $imageName);
        $imgUrl =URL ::asset ('images/'.$imageName);
        $validatedData1['imageUrl']=$imgUrl;*/
        $expert = Expert::create($validatedData1);
        return response(['data' => $expert]);

    }

    public function getAllExperts()
    {
        return response()->json([
            "status" => true,
            "message" => "success",
            "data" => json_encode(Expert::query()->get()),
        ]);
    }




}
