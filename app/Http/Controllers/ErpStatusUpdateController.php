<?php
namespace App\Http\Controllers;

use Illuminate\Support\Facades\Request;
// use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use view;
use DateTime;
use Illuminate\Support\Facades\Input;
use DB;

date_default_timezone_set('Asia/Dhaka');

ini_set('memory_limit', '3072M');
ini_set('max_execution_time', 1800);
use Log;
use Carbon\Carbon;
use Illuminate\Support\Facades\Storage;
use File;
use Illuminate\Support\Facades\Session;
use App\Services\ApiControllerVersionServices\ServerURLService;
use App\Http\Controllers\HealthInsurance\HealthInsuranceController;
header('Content-Type: application/json; charset=utf-8');

class ErpStatusUpdateController extends Controller
{
    public function statusUpdate(Request $request)
    {
        // Log::channel('health')->info('get_health_status request: ' . json_encode($request->all()));

        $db = config('database.db');
        $getData = DB::Table($db . ".cronjob_lastsync_time")->get();
        if (!$getData->isEmpty()) {
            foreach ($getData as $row) {
                $BranchCode = $row->branchcode;
                $lastsynctime = $row->lastsynctime;
                $serverurl = (new ServerURLService())->server_url();
                if (gettype($serverurl) == 'string') {
                    return $serverurl;
                }
                $base_url = 'https://' . parse_url($serverurl[0])['host'] . '/';

                // $base_url = 'https://bracapitesting.brac.net/';
                $updatedTime = Carbon::now('Asia/Dhaka')->format('Y-m-d H:i:s');
                $url = $base_url . "migateway/services/enrollment/api/dcs/v1/branches/$BranchCode/buffer-insurances?updatedAt=$lastsynctime";
                $token = (new HealthInsuranceController())->get_token(); //$this->get_token();

                if (gettype($token) == 'array') {
                    Log::error("Error Message" . $token['status_code'] . " Message: " . $token['data']['error']);
                    // return $this->ExceptionMessage($token['status_code'], $token['data']['error'].' '.$token['data']['error_description']);
                }

                try {
                    // Send the request with Bearer Token and query parameters
                    $response = Http::withToken($token)->get($url);
                    // dd($response->json());
                    Log::channel('health')->info('get_health_status responce: ' . json_encode($response->json()));
                    // Check if the request was successful
                    if ($response->successful()) {
                        $dataset = $response->json(); // Return the response as JSON
                        if ($dataset != null) {
                            foreach ($dataset as $row) {
                                // dd($row);
                                $enrollmentid = $row['id'];
                                // dd($enrollmentid);
                                $branchcode = $row['branchCode'];
                                $pin = $row['assignedPoPin'];
                                $status = $row['status'];
                                $polycno = $row['insuranceInfo']['insurancePolicyNumber'];
                                DB::table($db . ".health_insurance")->where('enrolment_id', $enrollmentid)->where('branchcode', $branchcode)->where('cono', $pin)->update(['status' => $status, 'insurance_policy_no' => $polycno, 'updated_at' => Carbon::now('Asia/Dhaka')->format('Y-m-d H:i:s')]);
                            }
                            DB::table($db . ".cronjob_lastsync_time")->where('branchcode', $BranchCode)->update(['lastsynctime' => $updatedTime]);
                        }
                    } else {
                        $status_code = $response->status();
                        $message = 'Request failed.';
                        Log::error("Error Status" . $status_code . " Message: " . $message);
                    }
                } catch (RequestException $e) {
                    // Handle HTTP request exceptions
                    $status_code = $e->getCode();
                    $message = $e->getMessage() . 'line_no: ' . $e->getLine();
                    Log::error("Error Status" . $status_code . " Message: " . $message);
                } catch (\Exception $e) {
                    // Handle other general exceptions
                    $status_code = $e->getCode();
                    $message = $e->getMessage() . 'line_no: ' . $e->getLine();
                    Log::error("Error Status" . $status_code . " Message: " . $message);
                }
            }
        }
    }
}