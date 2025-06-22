<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\HealthInsurance\HealthInsuranceController;
use App\Http\Controllers\ErpStatusUpdateController;
use App\Http\Controllers\DcsPushNotificationController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

/** Health Insurance */
Route::post('/HealthInsurance_Data_Store',[HealthInsuranceController::class,'HealthInsurance_Store']);
Route::post('HealthInsurance_Data',[HealthInsuranceController::class,'HealthInsurance']);
Route::post('/health_insurance_enrollement_list',[HealthInsuranceController::class,'get_health_enrollment_list']);
Route::post('/health_insurance_claim_list',[HealthInsuranceController::class,'get_health_claim_list']);
Route::post('/health_insurance_status',[HealthInsuranceController::class,'get_health_status']);
Route::post('/health_insurance_image_upload',[HealthInsuranceController::class,'image_upload']);
Route::post('/bm_actions_on_health_insurance',[HealthInsuranceController::class,'bm_actions_on_health_insurance']);

Route::get('/statusUpdate',[ErpStatusUpdateController::class,'statusUpdate']);

Route::post('/CropPushNotification',[DcsPushNotificationController::class, 'PushJsonDataForCropInsurance']);