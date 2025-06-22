<?php

namespace App\Http\Controllers\HealthInsurance;

use App\Http\Controllers\Controller;
use App\Services\ApiControllerVersionServices\ServerURLService;
use Carbon\Carbon;
use Illuminate\Http\Client\RequestException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Session;
use Illuminate\Support\Facades\Validator;
use ZipArchive;

class HealthInsuranceController extends Controller
{
    public function HealthInsurance(Request $request)
    {
        // return "Huda";
        // public function HealthInsurance($db, $BranchCode, $ProjectCode, $Pin, $LastSyncTime, $AppId, $token)
        // {
        try {
            $db =  config('database.db');
            // dd($db);
            $apikey = '7f30f4491cb4435984616d1913e88389';
            // $AppId =  $AppId; //$request->header('AppId');
            // $AppVersionCode = ''; //$request->header('AppVersionCode');
            // $AppVersionName = ''; //$request->header('AppVersionName');
            // $ApiKey = $token; //$request->input('ApiKey');
            // $Pin = $Pin; //$request->input('Pin');
            // $BranchCode = $BranchCode; //$request->input('BranchCode');
            // $ProjectCode = $ProjectCode; //$request->input('ProjectCode');
            // $LastSyncTime = $LastSyncTime; //$request->input('LastSyncTime');
            $AppId = $request->header('AppId');
            $AppVersionCode = $request->header('AppVersionCode');
            $AppVersionName = $request->header('AppVersionName');
            $ApiKey = $request->input('ApiKey');
            $Pin = $request->input('Pin');
            $BranchCode = $request->input('BranchCode');
            $ProjectCode = $request->input('ProjectCode');
            $LastSyncTime = $request->input('LastSyncTime');
            // dd($LastSyncTime);
            $CurrentTimes = date('Y-m-d H:i:s');
            Log::info('Health'.$BranchCode.'-'.$LastSyncTime.'-'.$Pin);
            $HealthDataSet = [];
            // dd($BranchCode);
            if ($apikey == $ApiKey) {
                $HealthData = $this->Get_Data_HealthInsurance($db, $BranchCode, $Pin, $ProjectCode, $AppId, $LastSyncTime); // Health Insurance Data
                $LookupTable =  $this->LookupTable($db, $LastSyncTime);
                $category = $LookupTable[0];
                $status = $LookupTable[1];
                $claim_status = $LookupTable[2];
                $health_products = $LookupTable[3];
                $health_config = $LookupTable[4];

                $HealthDataSet['HealthData'] = $HealthData;
                $HealthDataSet['category'] = $category;
                $HealthDataSet['status'] = $status;
                $HealthDataSet['claim_status'] = $claim_status;
                $HealthDataSet['health_products'] = $health_products;
                $HealthDataSet['health_config'] = $health_config;
                // return $HealthDataSet;
                $arrayFile = array("status" => "success", "time" => $CurrentTimes, "message" => "", "data" => $HealthDataSet);
                $jsonFile = json_encode($arrayFile);
                /**  Zip File Create */
                return $this->Create_Zip($db, $Pin, $BranchCode, $AppId, $CurrentTimes, $ProjectCode, $jsonFile);
            } else {
                $status_code = 400;
                $message = 'Api Key Not Macth!';
                return $this->ExceptionMessage($status_code, $message);
            }
        } catch (\Exception $e) {
            $status_code = 400;
            $message = "HealthController-HealthInsurance-LineNo" . $e->getLine() . "-" . $e->getMessage();
            Log::channel('health')->error($message);
            return $this->ExceptionMessage($status_code, $message);
        }
    }
    public function HealthInsurance_Store(Request $request)
    {

        // Log::channel('health')->info('HealthInsurance_Store healthInsuranceJson: ' . $request->input('HealthInsuranceJson'));
        Log::channel('health')->info('HealthInsurance_Store request: ' . json_encode($request->all()));
        // dd('hihi HealthInsurance_Store');

        // /**Validation start */
        // $validator = $this->get_validated($request);

        // if (gettype($validator) == 'string') {
        //     return $validator;
        // }
        // /**Validation end */

        // dd($request->all());
        $db =  config('database.db');
        // Log::channel('health')->info('healthInsuranceJson: '.$request->input('HealthInsuranceJson'));
        // Log::channel('health')->info('healthInsuranceJson: ' . $request->input('HealthInsuranceJson'));
        $apikey = '7f30f4491cb4435984616d1913e88389';
        $AppId =  $request->header('AppId');
        $ApiKey = $request->input('ApiKey'); // 7f30f4491cb4435984616d1913e88389
        $BranchCode = $request->input('BranchCode');
        $AppVersionCode = $request->header('AppVersionCode');
        $HealthInsuranceData = $request->input('HealthInsuranceJson');
        // $HealthInsuranceData = json_encode([$request->all()]);
        Log::channel('health')->info("HealthInsurance" . $HealthInsuranceData);
        // Log::channel('health')->info("HealthInsurance" . json_encode($HealthInsuranceData));
        // Log::info($HealthInsuranceData);
        // dd($HealthInsuranceData);
        // return $HealthInsuranceData;
        if ($apikey == $ApiKey) {
            $jsonDecode =  json_decode($HealthInsuranceData);
            if ($jsonDecode != NULL || $jsonDecode != '') {
                foreach ($jsonDecode as $row) {
                    DB::beginTransaction();
                    try {
                        /** update or insert Health Insurance Data */

                        // $found = DB::table($db . '.health_insurance')->where('enrolment_id', $row->enrollment_id)->first();
                        $found = DB::table($db . '.health_insurance')->where('enrolment_id', $row->EnrollId)->first();
                        // $found = DB::table($db . '.health_insurance')->where('erp_member_id', $row->erp_member_id)->first();
                        // dd($found);
                        $image_front = null;
                        $image_back = null;



                        /**image store */
                        $uploadDir = '/var/www/html/uploads/health_insurance/' . $BranchCode . '/';

                        // Create directory if it doesn't exist
                        if (!File::isDirectory($uploadDir)) {
                            File::makeDirectory($uploadDir, 0755, true, true);
                        }

                        // Handle nominee image front
                        if ($request->hasFile('nomineeImageFront') && $request->file('nomineeImageFront')->isValid()) {
                            $image = $request->file('nomineeImageFront');
                            $imageName = time() . '_' . $image->getClientOriginalName();  // Generate a unique name for the image

                            // Move the file to the specified directory
                            $image->move($uploadDir, $imageName);
                            $image_front = $imageName;
                        }

                        // Handle nominee image back
                        if ($request->hasFile('nomineeImageBack') && $request->file('nomineeImageBack')->isValid()) {
                            $image = $request->file('nomineeImageBack');
                            $imageName = time() . '_' . $image->getClientOriginalName();  // Generate a unique name for the image

                            // Move the file to the specified directory
                            $image->move($uploadDir, $imageName);
                            $image_back = $imageName;
                        }
                        /**image store */


                        $array = [
                            "branchcode" => $BranchCode,
                            "project_code" => $row->ProjectCode,
                            "cono" => $row->CoNo,
                            "orgno" => $row->OrgNo,
                            "orgmemno" => $row->OrgMemNo,
                            "enrolment_id" => $row->EnrollId,
                            "contact_no" => $row->Phone,
                            "any_disease" => $row->AnyDisese,
                            "insurance_policy_id" => $row->PolicyName,
                            "insurance_type_id" => $row->InsuranceType,
                            "category_id" => $row->Category,
                            "premium_amnt" => (int)$row->PremiumAmount,
                            "insurance_tenure" => $row->Duration,
                            // "insurance_policy_no" => $row->Insurance_policy_no,
                            "nominee_name" => $row->NomineeName,
                            "nominee_phone_no" => $row->NomineePhone,
                            // "nominee_birthdate" => $row->nominee_birthdate,
                            "nominee_birthdate" => Carbon::createFromFormat('d-m-Y', $row->NomineeDOB)->format('Y-m-d'),
                            "nominee_typeof_card_id" => $row->NomineeIDType,
                            "nominee_card_id" => $row->NomineeIDNumber,
                            "nominee_relation_id" => $row->NomineeRelation,
                            "status" => 5, //5 is bm pending
                            "erp_member_id" => $row->ErpMemId,
                            // "created_at" => $row->created_at,
                            "updated_at" => Carbon::now('Asia/Dhaka')->format('Y-m-d H:i:s'),
                            "nominee_id_front" => $image_front,
                            "nominee_id_back" => $image_back,
                            'card_issue_country' => isset($row->NomineeIDPlaceOfIssue) ? $row->NomineeIDPlaceOfIssue : 'Bangladesh',
                            'card_issue_date' => ($row->NomineeIDIssueDate != "") ? Carbon::createFromFormat('d-m-Y', $row->NomineeIDIssueDate)->format('Y-m-d') : null,
                            'card_expiry_date' => ($row->NomineeIDExpiryDate != "") ?  Carbon::createFromFormat('d-m-Y', $row->NomineeIDExpiryDate)->format('Y-m-d') : null,
                            'member_name' => isset($row->MemberName) ? $row->MemberName : null
                        ];


                        if ($image_front == null) {
                            unset($array['nominee_id_front']);
                        }
                        if ($image_back == null) {
                            unset($array['nominee_id_back']);
                        }

                        if ($found) {
                            DB::table($db . '.health_insurance')
                                ->where('enrolment_id', $row->EnrollId)
                                // ->where('cono', $row->cono)
                                ->where('branchcode', $BranchCode)
                                ->update($array);
                        } else {
                            DB::table($db . '.health_insurance')->insert($array);
                        }

                        DB::commit();

                        // return  response()->json(["status" => "S", "message" => "Health Insurance Data submited Successfully."]);
                        return  response()->json(["status" => "S", "message" => "অভিনন্দন ! স্বাস্থ্য বীমা আবেদনটি সফলভাবে সাবমিট হয়েছে। "]);
                    } catch (\Exception $e) {
                        DB::rollBack();
                        $status_code = $e->getCode();
                        $message = "HealthController-HealthInsurance store-LineNo " . $e->getLine() . "-" . $e->getMessage();
                        return $this->ExceptionMessage($status_code, $message);
                    }
                }

                return response()->json(["status" => "S", "message" => "Success"]);
            } else {
                $status_code = 404;
                $message = 'Missing Data Set!';
                return $this->ExceptionMessage($status_code, $message);
            }
        } else {
            $status_code = 400;
            $message = 'Api Key Not Macth!';
            return $this->ExceptionMessage($status_code, $message);
        }
    }
    public function Get_Data_HealthInsurance($db, $BranchCode, $Pin, $ProjectCode, $AppId, $LastSyncTime)
    {
        // Log::channel('health')->info('Get_Data_HealthInsurance last_sync_time: ' . $LastSyncTime);
        try {
            if ($AppId == 'bmsmerp') {
                $getHealthInsuranceData = DB::Table("$db.health_insurance")->where('branchcode', $BranchCode)->where('updated_at', '>=', $LastSyncTime)->get();
            } else {
                $getHealthInsuranceData = DB::Table("$db.health_insurance")->where('branchcode', $BranchCode)->where('cono', $Pin)->where('updated_at', '>=', $LastSyncTime)->get();
            }
            if ($getHealthInsuranceData->isEmpty()) {
                // $dataset = [];
                return [];
            } else {
                return $getHealthInsuranceData;
            }
        } catch (\Exception $e) {
            $status_code = $e->getCode();
            $message = "HealthController-Get_Data_HealthInsurance store-LineNo " . $e->getLine() . "-" . $e->getMessage();
            return $this->ExceptionMessage($status_code, $message);
        }
    }
    public function LookupTable($db, $LastSyncTime)
    {
        $category = DB::Table("$db.health_category")->where('updated_at', '>=', $LastSyncTime)->get();
        $status = DB::Table("$db.health_insurance_status")->where('updated_at', '>=', $LastSyncTime)->get();
        $claim_status = DB::Table("$db.health_claim_status")->where('updated_at', '>=', $LastSyncTime)->get();
        $health_products = DB::Table("$db.health_insurance_products")->where('updated_at', '>=', $LastSyncTime)->get();
        $health_config = DB::Table("$db.health_configurations")->where('updated_at', '>=', $LastSyncTime)->get();

        return [$category, $status, $claim_status, $health_products, $health_config];
    }
    public function ExceptionMessage($status_code, $message, $data = null)
    {
        Log::channel('health')->error('status_code: ' . $status_code);
        Log::channel('health')->error('message: ' . $message);
        Log::channel('health')->error(json_encode(array('status' => 'E', 'message' => $message), $status_code));
        // return json_encode(array('status' => 'E', 'message' => $message, 'data' => $data), $status_code);
        return json_encode(array('status' => 'E', 'message' => $message), $status_code);
    }
    public function Create_Zip($db, $Pin, $BranchCode, $Appid, $CurrentTimes, $ProjectCode, $jsonFile)
    {
        $baseurl = '/var/www/html/Json/health/';
        $serverUrl = "https://insurance.brac.net/html/Json/health/";

        $mainFile = $baseurl . $Pin . 'Health.zip';
        //echo $mainFile;
        if (is_file($mainFile)) {
            // if (!unlink($mainFile)) {
            //   echo ("Error deleting $mainFile");
            // }
        }
        $writeFile = $baseurl . $Pin . 'healthresults.json';
        if (!is_file($writeFile)) {
        }
        $fp = fopen($baseurl . $Pin . 'healthresults.json', 'w');
        fwrite($fp, $jsonFile);
        fclose($fp);
        $zip = new ZipArchive;
        if ($zip->open($mainFile, ZipArchive::CREATE) === TRUE) {
            // Add files to the zip file
            $zip->addFile($writeFile, $Pin . 'healthresults.json');
            //$zip->addFile('/var/www/html/json/'.$PIN.'transtrail.json',$PIN.'transtrail.json');
            //$zip->addFile('test.pdf', 'demo_folder1/test.pdf');

            // All files are added, so close the zip file.
            $zip->close();
        }
        if (unlink($writeFile)) {
        }
        $fileurl = $serverUrl . $Pin . 'Health.zip';
        $encypt = $this->encrypt("dnusr:Qsoft@BRAC$2023", "Q-soft@BRAC$2023");
        $message = array("status" => "Health", "time" => $CurrentTimes, "message" => "Please Download File!!", "download_url" => $fileurl, "crv" => $encypt);
        $json2 = json_encode($message);
        Log::channel('health')->info("message-" . $json2);
        return $json2;
        // die;
    }
    public function encrypt($data, $key)
    {
        // $iv = openssl_random_pseudo_bytes(16);
        // $encrypted = openssl_encrypt($data, 'aes-256-cbc', $key, OPENSSL_RAW_DATA, $iv);
        return base64_encode($data);
    }


    /**
     * get_validated
     * validates health insurance data
     * @param  mixed $request
     * @return void
     */
    private function get_validated($request)
    {
        /**making array to validate */
        $array_to_validate = [
            'branchcode' => 'required|string|max:4',
            'project_code' => 'required|integer',
            'cono' => 'nullable|string|max:8',
            'orgno' => 'nullable|string|max:6',
            'orgmemno' => 'nullable|string|max:10',
            'enrolment_id' => 'nullable|uuid',
            'contact_no' => 'nullable|string|max:20',
            'any_disease' => 'nullable|boolean',
            'insurance_policy_id' => 'nullable|integer',
            'insurance_type_id' => 'nullable|integer',
            'category_id' => 'nullable|integer',
            'premium_amnt' => 'nullable|integer',
            'insurance_tenure' => 'nullable|integer',
            // 'Insurance_policy_no' => 'nullable|string|max:50',
            'Insurance_policy_no' => 'nullable',
            'nominee_name' => 'nullable|string|max:100',
            'nominee_phone_no' => 'nullable|string|max:15',
            'nominee_birthdate' => 'nullable',
            'nominee_typeof_card_id' => 'nullable|integer',
            'nominee_card_id' => 'required|string|max:20',
            'nominee_relation_id' => 'nullable|integer',
            'status' => 'nullable|integer',
        ];

        /**get validated */
        $validator = Validator::make((array)json_decode($request->HealthInsuranceJson)[0], $array_to_validate);

        /** on validation fail making json */
        if ($validator->fails()) {
            $message = '';
            $v_errors = ($validator->messages())->messages();
            foreach ($v_errors as $key => $value) {
                $message = $message . $value[0] .  "\n";
            }
            Log::channel('health')->error('Health Insurance validation fail: ' . $message);
            return json_encode(["status" => "E", "message" => $message], 400);
        } else {
            return true;
        }
    }


    /** api call section start -----------------------------------------------------------------------------*/

    /**
     * Summary of generate_token
     * generates token for health insurance apis
     * @return array
     */
    public function generate_token(): array
    {
        // dd('hihi');
        $serverurl = (new ServerURLService())->server_url();
        if (gettype($serverurl) == 'string') {
            return $serverurl;
        }
        $base_url = 'https://' . parse_url($serverurl[0])['host'] . '/';

        // $base_url = 'https://bracapitesting.brac.net/';

        $url = $base_url . 'idp/realms/brac/protocol/openid-connect/token';
        // dd($url);
        try {
            $response = Http::withHeaders([
                'Content-Type' => 'application/x-www-form-urlencoded',
            ])->asForm()->post($url, [
                'grant_type' => 'client_credentials',
                'client_id' => 'dcs-microinsurance',
                'client_secret' => 'wWtB4DbpCsOuJj8eJaLLJ81pOpiHOCah',
            ]);
            // $response = Http::withHeaders([
            //     'Content-Type' => 'application/x-www-form-urlencoded',
            // ])->asForm()->post($url, [
            //     'grant_type' => 'client_credentials',
            //     'client_id' => 'dcs-microinsurance',
            //     'client_secret' => 'OMshhY3PtPYHVGz9kL0LiV7Swhcx73AI',
            // ]);
            // dd($response->json());
            $response_data = [
                'success' => $response->successful(),
                'status_code' => $response->status(),
                'data' => $response->json(),
                'body' => $response->body(),
            ];

            if ($response_data['status_code'] === 200) {
                Session::put('health_token_response', [
                    'health_access_token' => $response_data['data']['access_token'],
                    'timestamp' => Carbon::now('Asia/Dhaka')->format('Y-m-d H:i:s')
                ]);
            } else {
                return $response_data;
            }

            return $response_data;
        } catch (RequestException $e) {
            // Handle request exceptions (4xx and 5xx responses)
            return [
                'error' => true,
                'success' => false,
                'message' => 'HTTP request failed',
                'status' => $e->response->status(),
                'body' => $e->response->body(),
            ];
        } catch (\Exception $e) {
            // Handle any other exceptions
            return [
                'error' => true,
                'success' => false,
                'message' => 'An error occurred: ' . $e->getMessage(),
            ];
        }
    }


    /**
     * get_token
     * get and returns token for health insurance apis if time have passed
     * @return mixed
     */
    public function get_token(): mixed
    {
        $health_token_response = Session::get('health_token_response');
        // $currentTime = Carbon::now('Asia/Dhaka')->format('Y-m-d H:i:s');
        $currentTime = Carbon::now('Asia/Dhaka');

        if ($health_token_response) {
            $storedTime = Carbon::parse($health_token_response['timestamp']);

            // Check if less than 3600 seconds (1 hour) has passed
            if ($currentTime->diffInSeconds($storedTime) < 300) {
                return $health_token_response['health_access_token'];
            }
        }

        // If token is not present or expired, generate a new one
        $generated_token = $this->generate_token();

        if ($generated_token['success'] == true) {
            // Update the session with the new token
            $health_token_response = Session::get('health_token_response');
            return $health_token_response['health_access_token'];
        }
        // Return error or token generation response
        return $generated_token;
    }

    /**
     * call_health_enrollment_api
     * this function call health enrollment api to enroll health insurance
     * @param  array $request_data
     * @return void
     */
    public function call_health_enrollment_api($request_data)
    {
        $db =  config('database.db');
        // dd($request_data);
        $BranchCode = $request_data['branchcode'];

        $serverurl = (new ServerURLService())->server_url();
        if (gettype($serverurl) == 'string') {
            return $serverurl;
        }

        $base_url = 'https://' . parse_url($serverurl[0])['host'] . '/';

        // $base_url = 'https://bracapitesting.brac.net/';

        $url = $base_url . 'migateway/services/enrollment/api/dcs/v1/branches/' . $BranchCode . '/buffer-insurance';

        // Bearer Token
        $token = $this->get_token();

        if (gettype($token) == 'array') {
            return $this->ExceptionMessage($token['status_code'], $token['data']['error'].' '.$token['data']['error_description']);
        }
        // dd($token);
        // Request body

        $insurance_info = DB::table($db . '.health_configurations')
            ->select('premium_installment_amount', 'sum_insured')
            ->where('insurance_product_id', $request_data['insurance_policy_id'])
            ->where('insurance_policy_id', $request_data['category_id'])
            ->first();

        $card_info = $this->get_card_info($request_data);
        // dd($insurance_info');

        $data = [
            "id" => $request_data['enrolment_id'], //enrollment_id
            "assignedPoPin" => $request_data['cono'], //cono
            "flag" => $request_data['insurance_type_id'], //insurance_type_id
            // "applicationDate" => Carbon::now('Asia/Dhaka')->format('Y-m-d'),
            "applicationDate" => '2024-09-20',
            "projectCode" => (string)$request_data['project_code'], //project_code
            "voCode" => (int)$request_data['orgno'], //orgno
            "memberId" => (int)$request_data['erp_member_id'], //from table health_insu35528726
            "memberNumber" => $request_data['orgmemno'], //orgmemno
            "contactNo" => $request_data['contact_no'], //contact_no
            "nominee" => [
                "name" => $request_data['nominee_name'], //nominee_name
                "dateOfBirth" => $request_data['nominee_birthdate'], //nominee_birthdate
                "relationshipId" => $request_data['nominee_relation_id'], //nominee_relation_id
                "mobileNo" => $request_data['nominee_phone_no'], //nominee_phone_no
                "nationalIdNo" => $card_info['nationalIdNo'], //nominee_card_id
                "birthCertificateNo" => $card_info['birthCertificateNo'], //from payload_data table
                "passportNo" => $card_info['passportNo'], //from payload_data table
                "smartCardNo" => $card_info['smartCardNo'] //from payload_data table
            ],
            "insuranceInfo" => [
                "insuranceProductId" => $request_data['insurance_policy_id'], //insurance_policy_id
                "insurancePolicyId" => (int)$request_data['category_id'], //insurance_type_id
                "insurancePolicyNumber" => null, //Insurance_policy_no,
                "sumInsured" => $insurance_info->sum_insured ?? null, // from configuration table
                "totalPremiumAmount" => $insurance_info->premium_installment_amount ?? null // from configuration table
            ],
            "enrolmentApprover" => 3
        ];

        Log::channel('health')->info('health_enrollment_api data: ' . json_encode($data));
        try {
            // Send the request
            $response = Http::withToken($token)
                ->withHeaders([
                    'Content-Type' => 'application/json',
                ])
                ->post($url, $data);

            // dd($response->json());
            Log::channel('health')->info('health_enrollment_api response: ' . json_encode($response->json()));
            // Check if the request was successful
            if ($response->successful()) {
                // return $response->json();  // Return the response as JSON
                // return response()->json(["status" => "S", "message" => "Success", "data" => $response->json()]);
                return json_encode(["status" => "S", "message" => "Success", "data" => $response->json()]);
            } else {
                $status_code = $response->status();
                // $message = 'Request failed.';
                // $message = $response->json();

                if (array_key_exists("errors", $response->json())) {
                    $message = $response->json()["errors"][0]['message'];
                } else {
                    $message = 'Request failed.';
                }
                // dd($message, gettype($message));
                return $this->ExceptionMessage($status_code, $message, $response->json()); // Return the error status
            }
        } catch (RequestException $e) {
            // Handle any request exceptions
            $status_code = $e->getCode();
            $message = $e->getMessage() . 'line_no: ' . $e->getLine();
            return $this->ExceptionMessage($status_code, $message);
        } catch (\Exception $e) {
            // Handle any general exceptions
            $status_code = $e->getCode();
            $message = $e->getMessage() . 'line_no: ' . $e->getLine();
            return $this->ExceptionMessage($status_code, $message);
        }
    }


    /**
     * get_card_info
     * helper function to get which card type is given for nominee
     * @param  mixed $request_data
     * @return void
     */
    public function get_card_info($request_data): array
    {
        $db =  config('database.db');
        $pay_load_data_card_type = (DB::table($db . '.payload_data')
            ->select('data_name')
            ->where('data_id', $request_data['nominee_typeof_card_id'])
            ->where('data_type', 'cardTypeId')
            ->first())->data_name;


        $data = [
            "nationalIdNo" => null,
            "birthCertificateNo" => null,
            "passportNo" => null,
            "smartCardNo" => null
        ];
        switch ($pay_load_data_card_type) {
            case 'Birth Certificate':
                $data['birthCertificateNo'] = $request_data['nominee_card_id'];
                break;

            case 'National ID':
                $data['nationalIdNo'] = $request_data['nominee_card_id'];
                break;

            case 'Passport':
                $data['passportNo'] = $request_data['nominee_card_id'];
                break;

            case 'Smart Card':
                $data['smartCardNo'] = $request_data['nominee_card_id'];
                break;
        }

        return $data;
    }

    /**
     * get_health_enrollment_list
     * returns health insurance enrollment list on success
     * @param  mixed $request
     * @return void
     */
    public function get_health_enrollment_list(Request $request)
    {
        Log::channel('health')->info('get_health_enrollment_list request: ' . json_encode($request->all()));
        $apikey = '7f30f4491cb4435984616d1913e88389';
        $AppId =  $request->header('AppId');
        $ApiKey = $request->input('ApiKey'); // 7f30f4491cb4435984616d1913e88389
        $BranchCode = $request->input('BranchCode');
        $projectCode = (int)$request->input('projectCode');
        $memberId = $request->input('memberId');
        $AppVersionCode = $request->header('AppVersionCode');

        if ($apikey == $ApiKey) {

            $serverurl = (new ServerURLService())->server_url();
            if (gettype($serverurl) == 'string') {
                return $serverurl;
            }
            $base_url = 'https://' . parse_url($serverurl[0])['host'] . '/';

            // $base_url = 'https://bracapitesting.brac.net/';

            $url = $base_url . 'migateway/services/enrollment/api/dcs/v1/branches/' . $BranchCode . '/health-insurance-enrollments?projectCode=' . $projectCode . '&updatedAt=2024-01-01 12:00:00&memberId=' . $memberId;
            // dd($url);

            $token = $this->get_token();
            if (gettype($token) == 'array') {
                return $this->ExceptionMessage($token['status_code'], $token['data']['error'].' '.$token['data']['error_description']);
            }
            // dd($token);
            try {
                // Send the request with Bearer Token and query parameters
                $response = Http::withToken($token)->get($url);
                // dd($response);
                Log::channel('health')->info('get_health_enrollment_list responce: ' . json_encode($response->json()));
                // Check if the request was successful
                if ($response->successful()) {
                    // return $response->json();  // Return the response as JSON
                    return json_encode(['status' => 'S', 'message' => 'Success enrollment_list', 'data' => $response->json()]);  // Return the response as JSON
                } else {
                    $status_code = $response->status();
                    $message = 'Request failed.';
                    return $this->ExceptionMessage($status_code, $message, $response->json());
                }
            } catch (RequestException $e) {
                // Handle HTTP request exceptions
                $status_code = $e->getCode();
                $message = $e->getMessage() . 'line_no: ' . $e->getLine();
                return $this->ExceptionMessage($status_code, $message);
            } catch (\Exception $e) {
                // Handle other general exceptions
                $status_code = $e->getCode();
                $message = $e->getMessage() . 'line_no: ' . $e->getLine();
                return $this->ExceptionMessage($status_code, $message);
            }
        } else {
            $status_code = 400;
            $message = 'Api Key Not Macth!';
            return $this->ExceptionMessage($status_code, $message);
        }
    }
    /**
     * get_health_claim_list
     * on success returns health insurance claim list
     * @param  mixed $request
     * @return void
     */
    public function get_health_claim_list(Request $request)
    {
        // dd("test");
        // Log::channel('health')->info('get_health_claim_list request: ' . json_encode($request->all()));
        $apikey = '7f30f4491cb4435984616d1913e88389';
        $AppId =  $request->header('AppId');
        $ApiKey = $request->input('ApiKey'); // 7f30f4491cb4435984616d1913e88389
        $BranchCode = $request->input('BranchCode');
        $projectCode = (int)$request->input('projectCode');
        $memberId = $request->input('memberId');
        $updatedAt = $request->input('updatedAt');
        $AppVersionCode = $request->header('AppVersionCode');

        if ($apikey == $ApiKey) {

            $serverurl = (new ServerURLService())->server_url();
            if (gettype($serverurl) == 'string') {
                return $serverurl;
            }
            $base_url = 'https://' . parse_url($serverurl[0])['host'] . '/';
            
            // $base_url = 'https://bracapitesting.brac.net/';

            $url = $base_url . 'migateway/services/claim/api/dcs/v1/branches/' . $BranchCode . '/health-insurance-claims?projectCode=' . $projectCode . '&updatedAt='.$updatedAt.'&memberId=' . $memberId;
            // Log::channel('health')->info('get_health_claim_list url: ' . $url);

            $token = $this->get_token();
            if (gettype($token) == 'array') {
                return $this->ExceptionMessage($token['status_code'], $token['data']['error'].' '.$token['data']['error_description']);
            }
            // Log::channel('health')->info('get_health_claim_list token: ' . $token);
            try {
                // Send the request with Bearer Token and query parameters
                $response = Http::withToken($token)->get($url);
                Log::channel('health')->info('get_health_claim_list responce: ' . json_encode($response->json()));
                // Check if the request was successful
                if ($response->successful()) {
                    // return $response->json();  // Return the response as JSON
                    return json_encode(['status' => 'S', 'message' => 'Success claim_list', 'data' => $response->json()]);  // Return the response as JSON
                } else {
                    $status_code = $response->status();
                    $message = 'Request failed. url: ' . $url;
                    return $this->ExceptionMessage($status_code, $message);
                }
            } catch (RequestException $e) {
                // Handle HTTP request exceptions
                $status_code = $e->getCode();
                $message = $e->getMessage() . 'line_no: ' . $e->getLine();
                return $this->ExceptionMessage($status_code, $message);
            } catch (\Exception $e) {
                // Handle other general exceptions
                $status_code = $e->getCode();
                $message = $e->getMessage() . 'line_no: ' . $e->getLine();
                return $this->ExceptionMessage($status_code, $message);
            }
        } else {
            $status_code = 400;
            $message = 'Api Key Not Macth!';
            return $this->ExceptionMessage($status_code, $message);
        }
    }
    /**
     * get_health_status
     * on success returns health insurance status
     * @param  mixed $request
     * @return void
     */
    public function get_health_status(Request $request)
    {
        Log::channel('health')->info('get_health_status request: ' . json_encode($request->all()));
        $apikey = '7f30f4491cb4435984616d1913e88389';
        $AppId =  $request->header('AppId');
        $ApiKey = $request->input('ApiKey'); // 7f30f4491cb4435984616d1913e88389
        $BranchCode = $request->input('BranchCode');
        $projectCode = (int)$request->input('projectCode');
        $memberId = $request->input('memberId');
        $AppVersionCode = $request->header('AppVersionCode');

        if ($apikey == $ApiKey) {

            $serverurl = (new ServerURLService())->server_url();
            if (gettype($serverurl) == 'string') {
                return $serverurl;
            }
            $base_url = 'https://' . parse_url($serverurl[0])['host'] . '/';

            // $base_url = 'https://bracapitesting.brac.net/';

            $url = $base_url . 'migateway/services/enrollment/api/dcs/v1/branches/' . $BranchCode . '/buffer-insurances?updatedAt=2024-01-01 12:00:00&memberId=' . $memberId;
            $token = $this->get_token();

            if (gettype($token) == 'array') {
                return $this->ExceptionMessage($token['status_code'], $token['data']['error'].' '.$token['data']['error_description']);
            }

            try {
                // Send the request with Bearer Token and query parameters
                $response = Http::withToken($token)->get($url);
                // dd($response->json());
                Log::channel('health')->info('get_health_status responce: ' . json_encode($response->json()));
                // Check if the request was successful
                if ($response->successful()) {
                    // $this->update_health_insurance($response->json());
                    // return $response->json();  // Return the response as JSON
                    return json_encode(['status' => 'S', 'message' => 'Success health_status', 'data' => $response->json()]);  // Return the response as JSON
                } else {
                    $status_code = $response->status();
                    $message = 'Request failed.';
                    return $this->ExceptionMessage($status_code, $message);
                }
            } catch (RequestException $e) {
                // Handle HTTP request exceptions
                $status_code = $e->getCode();
                $message = $e->getMessage() . 'line_no: ' . $e->getLine();
                return $this->ExceptionMessage($status_code, $message);
            } catch (\Exception $e) {
                // Handle other general exceptions
                $status_code = $e->getCode();
                $message = $e->getMessage() . 'line_no: ' . $e->getLine();
                return $this->ExceptionMessage($status_code, $message);
            }
        } else {
            $status_code = 400;
            $message = 'Api Key Not Macth!';
            return $this->ExceptionMessage($status_code, $message);
        }
    }



    public function bm_actions_on_health_insurance(Request $request)
    {
        // dd($request->all());
        Log::channel('health')->info('bm_actions_on_health_insurance request: ' . json_encode($request->all()));
        $apikey = '7f30f4491cb4435984616d1913e88389';
        $AppId =  $request->header('AppId');
        $AppVersionCode = $request->header('AppVersionCode');
        $ApiKey = $request->input('ApiKey'); // 7f30f4491cb4435984616d1913e88389
        $BranchCode = $request->input('BranchCode');
        $projectCode = $request->input('projectCode');
        $poPin = $request->input('poPin');
        $enrollmentId = $request->input('enrollmentId');
        $action = $request->input('action'); //can be 'sendback','reject', 'approve'

        if ($apikey == $ApiKey) {

            if ($action === 'sendback') {
                return $this->bm_sendback_health_insurance($request);
            } elseif ($action === 'reject') {
                return $this->bm_reject_health_insurance($request);
            } else {
                return $this->bm_approve_health_insurance($request);
            }
        } else {
            $status_code = 400;
            $message = 'Api Key Not Macth!';
            return $this->ExceptionMessage($status_code, $message);
        }
    }

    public function bm_sendback_health_insurance($request)
    {
        $db =  config('database.db');



        $update = DB::table($db . '.health_insurance')
            ->where('enrolment_id', $request->enrollmentId)
            ->where('cono', $request->poPin)
            ->where('branchcode', $request->BranchCode)
            ->update([
                "status" => 6, //6 is BM Sendback
                "remarks" => $request->remarks,
                'updated_at' => Carbon::now('Asia/Dhaka')->format('Y-m-d H:i:s')
            ]); //6 is BM Sendback


        if ($update) {
            Log::channel('health')->info('bm_sendback_health_insurance responce: ' . json_encode(["status" => "S", "message" => "Sendback Success"]));
            // return json_encode(["status" => "S", "message" => "Sendback Success"]);
            return json_encode(["status" => "S", "message" => "অভিনন্দন ! স্বাস্থ্য বীমা আবেদনটি সফলভাবে সেন্ডব্যাক করা  হয়েছে।"]);
        } else {
            $code = 400;
            $message = 'Sendback Failed';
            return $this->ExceptionMessage($code, $message);
            // return json_encode(["status" => "E", "message" => "Sendback Failed"]);
        }

        // return response()->json(["status" => "S", "message" => "Sendback Success"]);

    }
    public function bm_reject_health_insurance($request)
    {
        $db =  config('database.db');
        $update = DB::table($db . '.health_insurance')
            ->where('enrolment_id', $request->enrollmentId)
            ->where('cono', $request->poPin)
            ->where('branchcode', $request->BranchCode)
            ->update([
                "status" => 7, //7 is BM Rejected
                "remarks" => $request->remarks,
                'updated_at' => Carbon::now('Asia/Dhaka')->format('Y-m-d H:i:s')
            ]);

        if ($update) {
            Log::channel('health')->info('bm_reject_health_insurance responce: ' . json_encode(["status" => "S", "message" => "Reject Success"]));
            // return response()->json(["status" => "S", "message" => "Reject Success"]);
            return response()->json(["status" => "S", "message" => "অভিনন্দন ! স্বাস্থ্য বীমা আবেদনটি সফলভাবে রিজেক্ট  করা  হয়েছে।"]);
        } else {
            $code = 400;
            $message = 'Reject Failed';
            return $this->ExceptionMessage($code, $message);
        }
    }
    public function bm_approve_health_insurance($request)
    {
        $db =  config('database.db');
        $array = (array)(DB::table($db . '.health_insurance')
            ->where('enrolment_id', $request->enrollmentId)
            ->where('cono', $request->poPin)
            ->where('branchcode', $request->BranchCode)
            ->first());

        if (!empty($array)) {
            /**call enrollment api here */
            $enrollment_api_response = $this->call_health_enrollment_api($array);
            // dd($enrollment_api_response);
            if (json_decode($enrollment_api_response)->status == 'S') {
                $update = DB::table($db . '.health_insurance')
                    ->where('enrolment_id', $request->enrollmentId)
                    ->where('cono', $request->poPin)
                    ->where('branchcode', $request->BranchCode)
                    ->update([
                        "status" => 1, //1 is ERP Pending
                        'updated_at' => Carbon::now('Asia/Dhaka')->format('Y-m-d H:i:s')
                    ]);

                if ($update) {
                    Log::channel('health')->info('bm_approve_health_insurance responce: ' . json_encode(["status" => "S", "message" => "BM Approve Success"]));
                    // return response()->json(["status" => "S", "message" => "BM Approve Success"], 200);
                    return response()->json(["status" => "S", "message" => "অভিনন্দন ! স্বাস্থ্য বীমা আবেদনটি সফলভাবে ইআরপি তে পাঠানো  হয়েছে। "], 200);
                } else {
                    $code = 400;
                    $message = 'BM Approve Success, but Update Failed';
                    return $this->ExceptionMessage($code, $message);
                }
            } else {
                return $enrollment_api_response;
            }
        } else {
            return $this->ExceptionMessage(400, 'Insurence data not found.');
        }
    }



    public function image_upload(Request $request)
    {
        // dd('hihihihih');
        Log::channel('health')->info('image_upload request: ' . json_encode($request->all()));
        $BranchCode = $request->input('BranchCode');
        $id_front = null;
        $id_back = null;

        // Define custom directory
        $uploadDir = '/var/www/html/uploads/health_insurance/' . $BranchCode . '/';

        // Create directory if it doesn't exist
        if (!File::isDirectory($uploadDir)) {
            File::makeDirectory($uploadDir, 0755, true, true);
        }


        try {

            /**image upload */
            if ($request->nominee_image_front) {
                // Generate a unique file name and move the uploaded file to the custom directory
                $imageName = time() . '_' . basename($_FILES['nominee_image_front']['name']);
                // dd($imageName);
                $request->nominee_image_front->move($uploadDir, $imageName);
                $id_front = $imageName;
            }
            if ($request->nominee_image_back) {
                // Generate a unique file name and move the uploaded file to the custom directory
                $imageName = time() . '_' . basename($_FILES['nominee_image_back']['name']);
                $request->nominee_image_back->move($uploadDir, $imageName);
                $id_back = $imageName;
            }

            $data = [
                'status' => 'S',
                'message' => 'Image upload successfull.',
                'data' => [
                    'nominee_id_front' => $id_front,
                    'nominee_id_back' => $id_back
                ]
            ];
            Log::channel('health')->info('image_upload response: ' . json_encode($data));
            return response()->json($data);
        } catch (\Exception $e) {
            return $this->ExceptionMessage(400, 'Image upload failed.');
        }
    }


    public function update_health_insurance($data)
    {
        // dd($data);
        $db =  config('database.db');
        foreach ($data as $key => $value) {
            DB::table($db . '.health_insurance')
                ->where('enrolment_id', $value['id'])
                ->where('cono', $value['assignedPoPin'])
                ->where('branchcode', $value['branchCode'])
                ->update([
                    "status" => $value['status'],
                    "insurance_policy_no" => $value['insuranceInfo']['insurancePolicyNumber'],
                    'updated_at' => Carbon::now('Asia/Dhaka')->format('Y-m-d H:i:s')
                ]);
        }
    }

    /** api call section end -----------------------------------------------------------------------------*/
}
