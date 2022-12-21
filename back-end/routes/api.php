<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\ExpertController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
Route::post('register', [AuthController::class, "register"]);
Route::post('login', [AuthController::class, "login"]);
Route::get("getAllSpecialties", [ExpertController::class, "getAllSpecialties"]);
Route::group(["middleware" => ["auth:api"]], function () {

    Route::post("logout", [AuthController::class, "logout"]);
    Route::post("expertData", [ExpertController::class, "expertData"]);
    Route::post("addAvailableTimes", [ExpertController::class, "addAvailableTimes"]);
    Route::get("getAllExperts", [ExpertController::class, "getAllExperts"]);
    Route::post("addAppointment", [AuthController::class, "addAppointment"]);
    Route::get("getAvailableTimes", [ExpertController::class, "getAvailableTimes"]);
    Route::get("getAppointment", [ExpertController::class, "getAppointment"]);
    Route::get("getExpert", [ExpertController::class, "getExpert"]);
    Route::post("AddToFavorite", [AuthController::class, "AddToFavorite"]);
    Route::get("userProfile", [AuthController::class, "userProfile"]);
    Route::post("AddRate", [AuthController::class, "AddRate"]);
});
