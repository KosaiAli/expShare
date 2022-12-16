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

Route::group(["middleware" => ["auth:api"]], function(){

    Route::post("logout", [AuthController::class, "logout"]);
    Route::post("expertData", [ExpertController::class, "expertData"]);
    Route::get("getAllExperts", [ExpertController::class, "getAllExperts"]);
    Route::get("getAllSpecialties", [ExpertController::class, "getAllSpecialties"]);
});
