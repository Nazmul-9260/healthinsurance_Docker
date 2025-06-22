<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\DcsPushNotificationController;

Route::get('/healthinsurance', function () {
    return view('welcome');
});
Route::get('logs', [\Rap2hpoutre\LaravelLogViewer\LogViewerController::class, 'index']);

Route::post('create-credentials',[DcsPushNotificationController::class, 'BearerToken']);
Route::post('/HealthPushNotification',[DcsPushNotificationController::class, 'PushJsonDataForHealthInsurance']);