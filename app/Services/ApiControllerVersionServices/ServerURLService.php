<?php

namespace App\Services\ApiControllerVersionServices;

use Illuminate\Support\Facades\DB;

class ServerURLService
{
    private $db = 'healthinsurance';        //dcs db name


    public function server_url()
    {
        $db = $this->db;
        $url = '';
        $url2 = '';
        $baseurl = '';
        // server_status = 3 is for testserver,
        $serverurl = DB::Table($db . '.server_url')->where('server_status', 1)->where('status', 1)->first();
        //dd($serverurl);
        if (empty($serverurl)) {
            $statuss = array("status" => "CUSTMSG", "message" => "Server Api Not Found");
            $json = json_encode($statuss);
            // echo $json;
            // die;
            return $json;
        } else {
            //dd($serverurl->url);
            $url = $serverurl->url;
            $url2 = $serverurl->url2;
            $baseurl = $serverurl->server_url;
            $servermessage = $serverurl->maintenance_message;
            $serverstatus = $serverurl->maintenance_status;
            if ($serverstatus == '1') {
                $statuss = array("status" => "CUSTMSG", "message" => $servermessage);
                $json = json_encode($statuss);
                // echo $json;
                // die;
                return $json;
            }
        }
        $urlaray = array($url, $url2, $baseurl);
        return $urlaray;
    }
}
