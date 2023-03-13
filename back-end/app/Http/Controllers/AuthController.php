<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Appointment;
use App\Models\Expert;
use App\Models\Favorite;
use App\Models\Rate;
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
        $validatedData1 = request(['expert_id', 'user_id', 'time_id']);
        $validatedData1['user_id'] = $user_data['id'];
        $user = User::query()->find($validatedData1['user_id']);
        $expert = Expert::query()->find($validatedData1['expert_id']);
        $expert_user = User::query()->find($expert['user_id']);
        $time = Time::query()->find($validatedData1['time_id']);
        $time->update([
            'available' => '0',
        ]);
        $expert_user->update([
            'balance' => $expert_user['balance'] + $expert['price'],
        ]);
        $user->update([
            'balance' => $user['balance'] - $expert['price'],
        ]);
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
        $validatedData1 = request(['expert_id', 'user_id']);
        $validatedData1['user_id'] = $user_data['id'];
        $isFav = Favorite::query()->where($validatedData)->get()->first();
        if ($isFav != null) {
            Favorite::query()->where($validatedData)->delete();
            return response(['isFav' => false]);
        }
        $favorite = Favorite::create($validatedData1);
        return
            response(['isFav' => true]);
    }

    public function GetFavorites()
    {
        $user_data = auth()->user();
        $favourites = Favorite::query()->where('user_id', 'like', $user_data['id'])->get();
        return response()->json([
            'stautes' => 'true',
            'data' => $favourites
        ]);
    }

    public function userProfile()
    {
        $user_data = auth()->user();
        if ($user_data['isExpert']) {


            $cases = Expert::query()->where('user_id', 'like', $user_data['id'])->get()->first();
            $rate = Rate::query()->where('expert_id', 'like', $cases['id'])->avg('rate');
            $user_data['id'] = $cases['id'];
            $user_data['rate'] = $rate;
            $user_data['specialty_id'] = $cases['specialty_id'];
            $user_data['imageUrl'] = $cases['imageUrl'];
            $user_data['phoneNum'] = $cases['phoneNum'];
            $user_data['details'] = $cases['details'];
            $user_data['address'] = $cases['address'];
            $user_data['price'] = $cases['price'];

            return response()->json([
                "status" => true,
                "message" => "User data",
                "data" => $user_data,
                // "rate" => $rate
            ]);
        }
        //$user_data = auth()->user();
        $favorite = Favorite::query()->where('user_id', 'like', $user_data['id'])->get();
        return response()->json([
            "status" => true,
            "message" => "User data",
            "data" => $user_data,
            "favorite" => $favorite,
        ]);
    }
    public function AddRate(Request $request)
    {
        $user_data = auth()->user();
        $validatedData = $request->validate([
            'expert_id' => 'required',
            'user_id' => 'nullable',
            'rate' => 'required'
        ]);
        $validatedData1 = request(['expert_id', 'user_id', 'rate']);
        $validatedData1['user_id'] = $user_data['id'];
        $exists = Rate::query()->where('user_id', 'like', $validatedData1['user_id'])
            ->where('expert_id', 'like', $validatedData1['expert_id'])->exists();
        if ($exists) {
            return response(["message" => "You have already rated this expert"], 403);
        }
        $rate = Rate::create($validatedData1);

        return response(["message" => "rated successfully", 'rate' => $rate], 200);
    }
}
