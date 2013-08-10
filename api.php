<?php

$api_key = ""; // load from file
define('API_KEY', $api_key);

function http_status_text($code){
  switch($code){
    case 404: return 'Not Found';
    case 400: return 'Bad Request';
    case 500: return 'Internal Server Error';
    case 403: return 'Forbidden';
    default:
      // write a warning to the log
      return 'Internal Server Error';
  }
}

function api_crash($code, $message=NULL){
  $text = http_status_text($code);

  if(is_null($message)){
    $message = $text;
  }

  echo $message;
  echo "\r\n";
  header("HTTP/1.1 $code $text", true, $code);
  die();
}

function error_handler($errno, $errstr, $errfile, $errline){
  api_crash(500);
}

function exception_handler($e){
  api_crash(500);
}

set_error_handler('error_handler');

function api_post($handler){
  if(!ISSET($_SERVER['HTTPS'])){
    api_crash(400);
  }

  if(!ISSET($_SERVER['CONTENT_TYPE']) || $_SERVER['CONTENT_TYPE'] != 'application/json'){
    api_crash(400);
  }

  $request_body = file_get_contents('php://input');
  $params = json_decode($request_body);
  if(is_null($params)){
    api_crash(400);
  }

  if($params['api_key'] != API_KEY){
    api_crash(403);
  }

  try{
    $handler($params);
  }
  catch(Exception $e){
    exception_handler($e);
  }
}
