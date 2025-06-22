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

use ZipArchive;
use Log;
use Carbon\Carbon;
use Illuminate\Support\Facades\Storage;
use File;
use Illuminate\Support\Facades\Session;
//use App\Http\Controllers\TestingController_Version;
use App\Http\Controllers\ApiController;
use App\Http\Controllers\ApiControllerVersion;
header('Content-Type: application/json; charset=utf-8');

class DcsPushNotificationController extends Controller
{
    // Define the secret key in a config file or use environment variables
    // config/app.php or .env file
    // Define it like this:
    // SECRET_KEY=fakesecretkey
    public function BearerToken(Request $request)
    {
        $db = config('database.db');

        try {
            $skey = '$_%zxcvbnmpoiuytrq!@987651234&*QAZWSXEDC@%';
            $clkey = '#_QWERTYUIOP!@#9645321*&$%lkjhgfdsa';
            // $skey ='$_exyeas1343!@#fdyf%dfhdhaegaetgd';
            // $clkey='_etgdag7858!hf#$fhg%dhjfhdjsacdfde';
            $secretKey = Request::header('secretKey');
            $clientid = Request::header('clientId');
            $createtime = date('Y-m-d H:i:s');
            $expiretime = date('Y-m-d H:i:s', strtotime('+1 hours', strtotime($createtime)));
            if ($secretKey == $skey and $clientid == $clkey) {
                $accesstoken = $this->createToken($secretKey, $clientid);
                // $getauthdata = DB::connection('pgsql')->table($db.'.oauth2')->get();
                $getauthdata = DB::table($db . '.oauth2')->get();
                // dd($getauthdata);
                if (!empty($getauthdata)) {
                    foreach ($getauthdata as $row) {
                        $expiretimes = $row->expires_time;
                        $id = $row->id;
                        if ($expiretimes < $createtime) {
                            $getauthdata = DB::table($db . '.oauth2')->where('id', $id)->delete();
                        }
                    }
                }
                $insert = DB::Table($db . '.oauth2')->insert(['expires_time' => $expiretime, 'expires_in' => $createtime, 'access_token' => $accesstoken]);
                // $insert = DB::Table($db.'.oauth2')->update(['expires_time'=>$expiretime,'expires_in'=>$createtime,'access_token'=>$accesstoken]);
                return response()->json(["status" => 200, 'token' => $accesstoken, "message" => ""], 200);
            } else {
                return response()->json(["status" => 406, 'token' => "", "message" => "secretKey or clientKey Not Matched!"], 406);
            }

        } catch (\Exception $e) {
            return response()->json(["status" => 500, 'token' => "", "message" => $e->getMessage()]);
        }
    }

    public function createToken($secretKey, $clientid)
    {
        // Retrieve the secret key from a config file or environment variable
        $EnvsecretKey = env('SECRET_KEY');

        // Create a part of the token using the secret key and other data
        $tokenGeneric = $EnvsecretKey . $_SERVER["SERVER_NAME"] . $secretKey . $clientid;

        // Encoding the token
        //$token = hash('sha256', $tokenGeneric . $data);
        //$token = base64_encode($tokenGeneric.$data);
        $uniqueKey = bin2hex(random_bytes(64) . $tokenGeneric); // Generate 32 bytes of random data and convert it to hexadecimal
        $base64Key = base64_encode(hex2bin($uniqueKey)); // Convert the hexadecimal data to binary and then encode it in base64

        return $base64Key;
    }
    public function PushJsonDataForAdmission(Request $request)
    {
        $db = config('database.db');
        $json = json_encode(Request::all());
        Log::info('Admission Data From ERP ' . $json);
        // $json = '[
        //     {
        //         "updatedAt": "2023-10-30 13:58:31.179",
        //         "id": "8af98c9a-70bc-4231-8995-2c5f045b68ad",
        //         "memberId": null,
        //         "memberNumber": null,
        //         "applicationDate": "2023-10-30",
        //         "nameEn": "tahajjut",
        //         "contactNo": "01522855255",
        //         "bkashWalletNo": null,
        //         "genderId": 1,
        //         "maritalStatusId": 3,
        //         "dateOfBirth": "1996-10-30",
        //         "projectCode": "60",
        //         "voCode": "null",
        //         "voId": null,
        //         "educationId": 5,
        //         "tinNumber": null,
        //         "memberTypeId": 1,
        //         "fatherNameEn": "tt",
        //         "motherNameEn": "fr",
        //         "spouseNameEn": "",
        //         "spouseDateOfBirth": null,
        //         "spouseIdCard": {
        //             "cardTypeId": null,
        //             "idCardNo": null,
        //             "frontImageUrl": null,
        //             "backImageUrl": null,
        //             "issueDate": null,
        //             "expiryDate": null,
        //             "issuePlace": null
        //         },
        //         "idCard": {
        //             "cardTypeId": 5,
        //             "idCardNo": "5848282525",
        //             "frontImageUrl": "http://scmtest.brac.net/uploads/0611/2023-10-30 07:58:30IMG_২০২৩১০৩০_১৩৫৬২৮৪১০.jpg",
        //             "backImageUrl": "http://scmtest.brac.net/uploads/0611/2023-10-30 07:58:30IMG_২০২৩১০৩০_১৩৫৬৩৬৭৪৮.jpg",
        //             "issueDate": null,
        //             "expiryDate": null,
        //             "issuePlace": null
        //         },
        //         "permanentAddress": "House/Village:-5t,Road NO/Word No:-tvtv,Union/Pouroshova:-tvt",
        //         "permanentUpazilaId": 21,
        //         "permanentDistrictId": 4,
        //         "presentAddress": "House/Village:-5t,Road NO/Word No:-tvtv,Union/Pouroshova:-tvt",
        //         "presentUpazilaId": 21,
        //         "presentDistrictId": 4,
        //         "savingsProductId": 11,
        //         "guarantor": null,
        //         "nominees": [
        //             {
        //                 "name": "tajul",
        //                 "dateOfBirth": "1993-10-30",
        //                 "relationshipId": 5,
        //                 "idCard": {
        //                     "cardTypeId": 5,
        //                     "idCardNo": "2552425252",
        //                     "frontImageUrl": null,
        //                     "backImageUrl": null,
        //                     "issueDate": null,
        //                     "expiryDate": null,
        //                     "issuePlace": null
        //                 },
        //                 "contactNo": "01485525585"
        //             }
        //         ],
        //         "guardian": null,
        //         "assignedPoPin": "00092414",
        //         "poId": 17373,
        //         "bankId": null,
        //         "bankBranchId": null,
        //         "bankAccountNumber": null,
        //         "routingNumber": null,
        //         "passbookNumber": null,
        //         "isPassbookRequired": false,
        //         "flag": 1,
        //         "targetAmount": 100.0,
        //         "occupationId": 9,
        //         "statusId": 1,
        //         "rejectionReason": null,
        //         "updated": false,
        //         "memberImageUrl": "http://scmtest.brac.net/uploads/0611/2023-10-30 07:58:30IMG_২০২৩১০৩০_১৩৫৮২২৩৬৪.jpg",
        //         "branchCode": "0611",
        //         "orgId": 2
        //     }]';
        $jsondataDecode = json_decode($json);
        $CheckTime = date('Y-m-d H:i:s');
        if (isset($_SERVER["HTTP_AUTHORIZATION"])) {

            list($type, $data) = explode(" ", $_SERVER["HTTP_AUTHORIZATION"], 2);
            if (strcasecmp($type, "Bearer") == 0) {
                //    $BarearTokenCheck = DB::Table($db.'.oauth2')->first();

                $BarearTokenCheck = DB::table($db . '.oauth2')->where('access_token', $data)->get();
                if (empty($BarearTokenCheck)) {
                    return response()->json([["status" => 401, "message" => "Bearer Token is Empty!"], 401]);
                } else {
                    $expiretime = $BarearTokenCheck[0]->expires_time;
                    //dd($expiretime);
                    $token = $BarearTokenCheck[0]->access_token;
                    if ($expiretime <= $CheckTime) {
                        return response()->json(["status" => 401, "message" => "Bearer Token Time Expired!"], 401);
                    } else {
                        if ($token != $data) {
                            return response()->json(["status" => 401, "message" => "Bearer Token Not Matched!"], 401);
                        } else {
                            $updateAt = date('Y-m-d H:i:s');
                            if ($jsondataDecode != null) {
                                $AdmissionUpdate = DB::Table($db . '.admissions')->where('branchcode', $jsondataDecode[0]->branchCode)->where('entollmentid', $jsondataDecode[0]->id)->update(['MemberId' => $jsondataDecode[0]->memberId, 'erp_member_id' => $jsondataDecode[0]->memberId, 'ErpStatus' => $jsondataDecode[0]->statusId, 'erpstatus' => $jsondataDecode[0]->statusId, 'update_at' => $updateAt, 'reject_reason' => $jsondataDecode[0]->rejectionReason]);
                                if ($AdmissionUpdate) {
                                    return response()->json(["status" => 200, "id" => $jsondataDecode[0]->id, "message" => "Admission Data Update Successfully!"], 200);
                                } else {
                                    return response()->json(["status" => 400, "id" => $jsondataDecode[0]->id, "message" => "Admission Data Not Found!"], 400);
                                }
                            }
                        }

                    }
                }
            } else {
                return response()->json(["status" => 401, "message" => "Token Not Found!"], 401);
            }
        } else {
            return response()->json(["status" => 401, "message" => "401 Unauthorized"], 401);
        }
    }
    public function PushJsonDataForLoan(Request $request)
    {
        $db = config('database.db');
        $json = json_encode(Request::all());
        Log::info('Loan Data From ERP ' . $json);
        // $json = '[
        //     {
        //         "updatedAt": "2025-02-25 12:04:30",
        //         "id": "8fb48928-bea9-4626-885a-7fcd95dcf853",
        //         "countryId": null,
        //         "applicationDate": "2024-12-11",
        //         "disbursementDate": null,
        //         "loanProductId": 42,
        //         "loanAccountId": 0,
        //         "loanProposalId": 203045535006976,
        //         "memberId": 34145762,
        //         "proposedLoanAmount": 55000,
        //         "proposalDurationInMonths": 9,
        //         "proposedGrantAmount": 0,
        //         "schemeId": 295,
        //         "sectorId": 3,
        //         "branchCode": "0605",
        //         "microInsurance": true,
        //         "modeOfPaymentId": 1,
        //         "approvedDurationInMonths": 9,
        //         "approvedLoanAmount": 55000,
        //         "policyTypeId": 1,
        //         "secondInsurer": null,
        //         "premiumAmount": 124,
        //         "nominees": null,
        //         "projectCode": "15",
        //         "voCode": "2162",
        //         "voId": 600453,
        //         "memberTypeId": 25,
        //         "subSectorId": 15,
        //         "frequencyId": 3,
        //         "coBorrowerDto": null,
        //         "updated": false,
        //         "signConsent": false,
        //         "consentUrl": null,
        //         "loanApprover": 4,
        //         "rejectionReason": null,
        //         "loanProposalStatusId": 2,
        //         "insuranceProductId": 33,
        //         "disbursementSubStatus": null,
        //         "orgId": 2,
        //         "approverInfo": {
        //             "approverRole": 4,
        //             "approverName": "Q-Soft Precise Assistance",
        //             "approverPin": "a123",
        //             "approverDate": "2025-02-25"
        //         },
        //         "branchRecommenderInfo": null,
        //         "specialSavingsAccountNumbers": null,
        //         "progotiDocumentcheckList": null
        //     }
        // ]';
        $jsondataDecode = json_decode($json);
        $CheckTime = date('Y-m-d H:i:s');
        if (isset($_SERVER["HTTP_AUTHORIZATION"])) {

            list($type, $data) = explode(" ", $_SERVER["HTTP_AUTHORIZATION"], 2);
            if (strcasecmp($type, "Bearer") == 0) {
                //    $BarearTokenCheck = DB::Table($db.'.oauth2')->first();
                $BarearTokenCheck = DB::table($db . '.oauth2')->where('access_token', $data)->get();
                if (empty($BarearTokenCheck)) {
                    return response()->json(["status" => 401, "message" => "Bearer Token is Empty!"], 401);
                } else {
                    $expiretime = $BarearTokenCheck[0]->expires_time;
                    //dd($expiretime);
                    $token = $BarearTokenCheck[0]->access_token;
                    if ($expiretime <= $CheckTime) {
                        return response()->json(["status" => 401, "message" => "Bearer Token Time Expired!"], 401);
                    } else {
                        if ($token != $data) {
                            return response()->json(["status" => 401, "message" => "Bearer Token Not Matched!"], 401);
                        } else {
                            $updateAt = date('Y-m-d H:i:s');
                            if ($jsondataDecode != null) {
                                $LoanUpdate = DB::Table($db . '.loans')->where('branchcode', $jsondataDecode[0]->branchCode)->where('loan_id', $jsondataDecode[0]->id)->update(['ErpStatus' => $jsondataDecode[0]->loanProposalStatusId, 'erpstatus' => $jsondataDecode[0]->loanProposalStatusId, 'update_at' => $updateAt, 'reject_reason' => $jsondataDecode[0]->rejectionReason, 'disbursement_date' => $jsondataDecode[0]->disbursementDate]);
                                if ($LoanUpdate) {
                                    return response()->json(["status" => 200, "id" => $jsondataDecode[0]->id, "message" => "Loan Data Update Successfully!"], 200);
                                } else {
                                    return response()->json(["status" => 400, "id" => $jsondataDecode[0]->id, "message" => "Loan Data Not Found!"], 400);
                                }
                            }
                        }

                    }
                }
            } else {
                return response()->json(["status" => 401, "message" => "Token Not Found!"], 401);
            }
        } else {
            return response()->json(["status" => 401, "message" => "401 Unauthorized"], 401);
        }
    }
    public function PushJsonDataForHealthInsurance(Request $request)
    {
        $db = config('database.db');
        $json = [];
        $json = json_encode(Request::all());
        // $json = '[
        //     {
        //         "id": "5886bd20-edf2-4e2f-b4d2-126e60951f32",
        //         "flag": 1,
        //         "enrolmentApprover": 3,
        //         "assignedPoPin": "00258741",
        //         "voId": 620304,
        //         "voCode": "2165",
        //         "voName": "SECONDCOLONY",
        //         "officeId": 324,
        //         "memberNumber": 35,
        //         "memberId": 35168341,
        //         "contactNo": "01765458470",
        //         "projectId": 1,
        //         "projectCode": "15",
        //         "projectName": null,
        //         "branchCode": "0641",
        //         "nominee": {
        //             "id": null,
        //             "name": "test",
        //             "dateOfBirth": "1996-04-09",
        //             "relationshipId": 7,
        //             "nationalIdNo": null,
        //             "birthCertificateNo": null,
        //             "passportNo": null,
        //             "smartCardNo": "7200808564",
        //             "mobileNo": "01917542845",
        //             "healthPolicyAccount": null,
        //             "image": null
        //         },
        //         "insuranceInfo": {
        //             "insuranceProductId": 2,
        //             "insuranceProductName": null,
        //             "insurancePolicyId": 103,
        //             "insurancePolicyName": null,
        //             "insurancePolicyNumber": "1319SC1637904566460-0",
        //             "totalPremiumAmount": 700,
        //             "sumInsured": 111000
        //         },
        //         "status": 3,
        //         "enrollmentId": null,
        //         "memberName": "China Ahmed",
        //         "memberCategory": null,
        //         "memberDateOfBirth": null,
        //         "policyHolder": {
        //             "id": null,
        //             "firstName": null,
        //             "middleName": null,
        //             "lastName": null,
        //             "phone": null,
        //             "address": null,
        //             "dateOfBirth": null,
        //             "voName": null,
        //             "voCode": null,
        //             "branchName": null,
        //             "branchCode": null,
        //             "officeId": null,
        //             "erpMemberId": null,
        //             "memberRefNo": null,
        //             "projectInfoId": null,
        //             "gender": null,
        //             "genderId": null,
        //             "projectName": null,
        //             "projectRefCode": null,
        //             "groupInfoId": null,
        //             "assignedPO": null,
        //             "memberName": "China Ahmed",
        //             "memberCategory": null,
        //             "nationalIdNo": null,
        //             "smartCardIdNo": null,
        //             "passportNo": null,
        //             "otherIdNo": null,
        //             "savingsAccountNo": null,
        //             "savingsAccountId": null,
        //             "healthPolicyAccount": null
        //         },
        //         "applicationDate": "2024-09-20",
        //         "cardTypeId": "NATIONAL_ID",
        //         "idCardNo": "2354267409",
        //         "updatedAt": null
        //     }
        // ]';
        Log::info('HealthInsurance webhook data: ' . $json);
        $jsondataDecode_Health = json_decode($json);
        // dd($jsondataDecode_Health[0]->insuranceInfo->insurancePolicyNumber);
        $CheckTime = date('Y-m-d H:i:s');
        if (isset($_SERVER["HTTP_AUTHORIZATION"])) {

            Log::info('HealthInsurance Bearer Token: ' . $_SERVER["HTTP_AUTHORIZATION"]);

            list($type, $data) = explode(" ", $_SERVER["HTTP_AUTHORIZATION"], 2);
            if (strcasecmp($type, "Bearer") == 0) {
                //    $BarearTokenCheck = DB::Table($db.'.oauth2')->first();
                $BarearTokenCheck = DB::table($db . '.oauth2')->where('access_token', $data)->get();

                // dd($db,$data,$BarearTokenCheck);

                //    if(empty($BarearTokenCheck))
                if (count($BarearTokenCheck) == 0) {
                    Log::error('healthInsurance Bearer Token is Empty! ' . $jsondataDecode_Health[0]->id);
                    return response()->json(["status" => 401, "message" => "Bearer Token is Empty!"], 401);
                } else {
                    $expiretime = $BarearTokenCheck[0]->expires_time;
                    //dd($expiretime);
                    $token = $BarearTokenCheck[0]->access_token;
                    if ($expiretime <= $CheckTime) {
                        Log::error('healthInsurance Bearer Token Time Expired! ' . $jsondataDecode_Health[0]->id);
                        return response()->json(["status" => 401, "message" => "Bearer Token Time Expired!"], 401);
                    } else {
                        if ($token != $data) {
                            Log::error('healthInsurance Bearer Token Not Matched! ' . $jsondataDecode_Health[0]->id);
                            return response()->json(["status" => 401, "message" => "Bearer Token Not Matched!"], 401);
                        } else {
                            $updateAt = date('Y-m-d H:i:s');
                            //return response()->json(["status"=>200, "id"=>"provide unique identification","message"=>"Health Insurance Data Update Successfully!"],200);
                            if ($jsondataDecode_Health != null) {
                                $HealthData = DB::Table($db . '.health_insurance')->where('branchcode', $jsondataDecode_Health[0]->branchCode)->where('enrolment_id', $jsondataDecode_Health[0]->id)->update(['updated_at' => $updateAt, 'status' => $jsondataDecode_Health[0]->status, 'insurance_policy_no' => $jsondataDecode_Health[0]->insuranceInfo->insurancePolicyNumber]);
                                if ($HealthData) {
                                    return response()->json(["status" => 200, "id" => $jsondataDecode_Health[0]->id, "message" => "Health nsurance Data Update Successfully!"], 200);
                                } else {
                                    Log::error('healthInsurance Data Not Found! ' . $jsondataDecode_Health[0]->id);
                                    return response()->json(["status" => 400, "id" => $jsondataDecode_Health[0]->id, "message" => "Health Insurance Data Not Found!"], 400);
                                }
                            }
                        }

                    }
                }
            } else {
                Log::error('healthInsurance Token Not Found! ' . $jsondataDecode_Health[0]->id);
                return response()->json(["status" => 401, "message" => "Token Not Found!"], 401);
            }
        } else {
            Log::error('healthInsurance unauthorized ' . $jsondataDecode_Health[0]->id);
            return response()->json(["status" => 401, "message" => "401 Unauthorized"], 401);
        }
    }
    public function FatchAdmission(Request $request)
    {
        $Branchcode = '';
        $db = config('database.db');
        $Branchcode = Request::input('branchcode');
        if ($Branchcode != '') {
            $getAdmissionData = DB::Table($db . '.admissions')->select('branchcode', 'orgno', 'Flag', 'ApplicantsName', 'MemberId', 'entollmentid', 'ErpStatus')->where('branchcode', $Branchcode)->orderBy('id', 'desc')->get();
            return json_encode($getAdmissionData);
        }

    }
    public function FatchLoan(Request $request)
    {
        $Branchcode = '';
        $db = config('database.db');
        $Branchcode = Request::input('branchcode');
        if ($Branchcode != '') {
            $getAdmissionData = DB::Table($db . '.loans')->select('branchcode', 'orgno', 'erp_mem_id', 'loan_id', 'ErpStatus')->where('branchcode', $Branchcode)->orderBy('id', 'desc')->get();
            return json_encode($getAdmissionData);
        }

    }




    public function PushJsonDataForCropInsurance(Request $request)
    {
        // dd('hihi');
        $db = config('database.db');
        $json = [];
        $json = json_encode(Request::all());
        // $json = '[
        //     {
        //         "id": "d191dc2e-8ea6-4faf-be88-fa1e7db1991f",
        //         "updatedAt": "2024-10-03 10:49:11",
        //         "flag": 1,
        //         "enrolmentApprover": 3,
        //         "assignedPoPin": "00174882",
        //         "voId": 627599,
        //         "voCode": "2034",
        //         "voName": "NARINDA B",
        //         "officeId": 828,
        //         "memberNumber": 125,
        //         "memberId": 35528726,
        //         "contactNo": "01622547089",
        //         "projectId": 1,
        //         "projectCode": "15",
        //         "projectName": "Microfinance (Dabi)",
        //         "branchCode": "0610",
        //         "nominee": {
        //             "id": null,
        //             "name": "faruk mia ",
        //             "dateOfBirth": "1972-01-11",
        //             "relationshipId": 13,
        //             "nationalIdNo": "12341234524712345",
        //             "birthCertificateNo": null,
        //             "passportNo": null,
        //             "smartCardNo": null,
        //             "mobileNo": "01644561431",
        //             "healthPolicyAccount": null,
        //             "image": null
        //         },
        //         "insuranceInfo": {
        //             "insuranceProductId": 1,
        //             "insuranceProductName": "Momota Shastho Bima",
        //             "insurancePolicyId": 52,
        //             "insurancePolicyName": "Momota-CAT-1",
        //             "insurancePolicyNumber": "1322MC1503432349514-0",
        //             "totalPremiumAmount": 680,
        //             "sumInsured": 70000
        //         },
        //         "status": 2,
        //         "enrollmentId": null
        //     }
        // ]';
        Log::info('CropInsurance' . $json);
        $jsondataDecode_Crop = json_decode($json);
        // dd($jsondataDecode_Crop[0]->insuranceInfo->insurancePolicyNumber);
        $CheckTime = date('Y-m-d H:i:s');
        if (isset($_SERVER["HTTP_AUTHORIZATION"])) {

            list($type, $data) = explode(" ", $_SERVER["HTTP_AUTHORIZATION"], 2);
            if (strcasecmp($type, "Bearer") == 0) {
                //    $BarearTokenCheck = DB::Table($db.'.oauth2')->first();
                $BarearTokenCheck = DB::table($db . '.oauth2')->where('access_token', $data)->get();

                // dd($db,$data,$BarearTokenCheck,count($BarearTokenCheck));

                if (count($BarearTokenCheck) == 0) {
                    Log::error('cropInsurance Bearer Token Not Found in DB! ');
                    // Log::error('cropInsurance Bearer Token is Empty! '.$jsondataDecode_Crop[0]->id);
                    return response()->json([["status" => 401, "message" => "Bearer Token Not Found!"], 401]);
                } else {
                    $expiretime = $BarearTokenCheck[0]->expires_time;
                    // dd($expiretime);
                    $token = $BarearTokenCheck[0]->access_token;
                    if ($expiretime <= $CheckTime) {
                        Log::error('cropInsurance Bearer Token Time Expired! ');
                        // Log::error('cropInsurance Bearer Token Time Expired! '.$jsondataDecode_Crop[0]->id);
                        return response()->json(["status" => 401, "message" => "Bearer Token Time Expired!"], 401);
                    } else {
                        if ($token != $data) {
                            // Log::error('cropInsurance Bearer Token Not Matched! '.$jsondataDecode_Crop[0]->id);
                            Log::error('cropInsurance Bearer Token Not Matched! ');
                            return response()->json(["status" => 401, "message" => "Bearer Token Not Matched!"], 401);
                        } else {
                            $updateAt = date('Y-m-d H:i:s');
                            //return response()->json(["status"=>200, "id"=>"provide unique identification","message"=>"Health Insurance Data Update Successfully!"],200);
                            if ($jsondataDecode_Crop != null) {

                                return response()->json(["status" => 200, "message" => "Crop insurance under Development."], 200);
                                // $HealthData = DB::Table($db.'.health_insurance')->where('branchcode',$jsondataDecode_Health[0]->branchCode)->where('enrolment_id',$jsondataDecode_Health[0]->id)->update(['updated_at'=>$updateAt,'status'=>$jsondataDecode_Health[0]->status,'insurance_policy_no'=>$jsondataDecode_Health[0]->insuranceInfo->insurancePolicyNumber]);
                                // if($HealthData)
                                // {
                                //     return response()->json(["status"=>200, "id"=>$jsondataDecode_Health[0]->id,"message"=>"Health nsurance Data Update Successfully!"],200);
                                // }
                                // else{
                                //     Log::error('healthInsurance Data Not Found! '.$jsondataDecode_Health[0]->id);
                                //     return response()->json(["status"=>400, "id"=>$jsondataDecode_Health[0]->id,"message"=>"Health Insurance Data Not Found!"],400); 
                                // }
                            } else {
                                return response()->json(["status" => 401, "message" => "No Data Found."], 401);
                            }
                        }

                    }
                }
            } else {
                // Log::error('cropInsurance Token Not Found! '.$jsondataDecode_Crop[0]->id);
                Log::error('cropInsurance Token Not Found! ');
                return response()->json(["status" => 401, "message" => "Token Not Found!"], 401);
            }
        } else {
            // Log::error('cropInsurance unauthorized '.$jsondataDecode_Crop[0]->id);
            Log::error('cropInsurance unauthorized ');
            return response()->json(["status" => 401, "message" => "401 Unauthorized"], 401);
        }
    }
}