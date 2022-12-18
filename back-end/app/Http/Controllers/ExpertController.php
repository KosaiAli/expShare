<?php

namespace App\Http\Controllers;

use App\Models\Appointment;
use App\Models\Expert;
use App\Models\Speciality;
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
            'birthday'=>'required',
            'user_id' => 'nullable',
            'specialty_id' => 'required',

        ]);
        $validatedData1=request (['imageUrl','phoneNum','address','details','price','birthday','user_id','specialty_id']);
        $validatedData1['user_id']=$user_data['id'];
        $expert = Expert::create($validatedData1);
        return response(['data' => $expert]);
    }

    public function getAllExperts()
    {
        return response()->json([
            "status" => true,
            "message" => "success",
            "data" => Expert::query()->get(),
        ]);
    }
    public function getExpert(Request $request)
    {
        $validatedData = $request->validate([
            'expertId' => 'required',]);
        return response()->json([
            "status" => true,
            "message" => "success",
            "data" => Expert::query()->where('id','like',$validatedData['expertId'])->get(),
        ]);
    }
    public function getAllSpecialties()
    {
        return response()->json([
            "status" => true,
            "message" => "success",
            "data" => Speciality::query()->get(),
        ]);
    }
    public function addAvailableTimes(Request $request)
    {

        $user_data = auth()->user();
        if (!$user_data['isExpert']) {
            return response()->json([
                "message" => "not allow"
            ]); }
        $validatedData = $request->validate([
            'expert_id' => 'nullable',
            'start' => 'required',
            'end' => 'required',
            'day' => 'required',
            'available' => 'nullable'

        ]);
        $validatedData1=request (['expert_id','start','end','day','available']);
        $currExpert=Expert::query()
            ->where('user_id','like',$user_data['id'])->first(['id']);
        $validatedData1['expert_id']=$currExpert['id'];
        $time = Time::create($validatedData1);
        return response(['time' => $time]);
    }
    public function getAvailableTimes(Request $request)
    {
        $validatedData = $request->validate([
            'expertId' => 'required',]);
        return response()->json([
            "status" => true,
            "message" => "success",
            "data" => Time::query()->where('expert_id','like',$validatedData['expertId'])
                ->where('available','like','1') ->get(),
        ]);
    }
    public function getAppointment()
    {
        $user_data = auth()->user();
        $expert = Expert::query()->where('user_id','like',$user_data['id'])->first(['id']);
        return response()->json([
            "status" => true,
            "message" => "success",
            "data" => Appointment::query()->where('expert_id','like',$expert['id'])->get()
        ]);
    }

}
