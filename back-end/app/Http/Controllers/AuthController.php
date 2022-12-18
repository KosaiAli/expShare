<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Appointment;
use App\Models\Expert;
use App\Models\Favorite;
use App\Models\Speciality;
use App\Models\Time;
use App\Models\User;
use Illuminate\Http\Request;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validatedData = $request->validate([
            'name' => 'required|max:55|min:10',
            'email' => 'email|required|unique:users|email',
            'password' => 'required|min:8',
            'isExpert' => 'required'
        ]);

        $validatedData['password'] = bcrypt($request->password);

        $user = User::create($validatedData);

        $accessToken = $user->createToken('authToken')->accessToken;

        return response(['user' => $user, 'access_token' => $accessToken]);
    }

    public function login(Request $request)
    {
        $loginData = $request->validate([
            'email' => 'email|required',
            'password' => 'required|min:8'
        ]);

        if (!auth()->attempt($loginData)) {
            return response(['message' => 'Invalid Credentials']);
        }

        $accessToken = auth()->user()->createToken('authToken')->accessToken;

        return response(['user' => auth()->user(), 'access_token' => $accessToken]);
    }


    public function logout(Request $request)
    {
        // get token value
        $token = $request->user()->token();

        // revoke this token value
        $token->revoke();

        return response()->json([
            "status" => true,
            "message" => "User logged out successfully"
        ]);
    }

    public function addAppointment(Request $request)
    {
        $user_data = auth()->user();
        $validatedData = $request->validate([
            'expert_id' => 'required',
            'user_id' => 'nullable',
            'time_id' => 'required'
        ]);
        $validatedData1=request (['expert_id','user_id','time_id']);
        $validatedData1['user_id']=$user_data ['id'];
        $user = User::query()->find($validatedData1['user_id']);
        $expert = Expert::query()->find($validatedData1['expert_id']);
        $expert_user = User::query()->find($expert['user_id']);
        $time = Time::query()->find($validatedData1['time_id']);
        $time->update([
            'available' => '0', ]);
        $expert_user->update([
            'balance' => $expert_user['balance']+$expert['price'], ]);
        $user->update([
            'balance' => $user['balance']-$expert['price'], ]);
        $appointment = Appointment::create($validatedData1);
        //
        //$time=['']
        //$newTime = Time::create($nextTime);
        return response(['appointment' => $appointment]);

    }

    public function AddToFavorite(Request $request)
    {
        $user_data = auth()->user();
        $validatedData = $request->validate([
            'expert_id' => 'required',
            'user_id' => 'nullable'
        ]);
        $validatedData1=request (['expert_id','user_id']);
        $validatedData1['user_id']=$user_data ['id'];
        $favorite = Favorite::create($validatedData1);
        return response(['favorite' => $favorite]);

    }

    public function userProfile()
    {
        $user_data = auth()->user();
        $favorite=Favorite::query()->where('user_id','like',$user_data['id'])->get();
        return response()->json([
            "status" => true,
            "message" => "User data",
            "data" => $user_data,
            "favorite" => $favorite,
        ]);
    }




}
