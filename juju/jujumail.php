<?php

$to = "kiyoshi.kyokai@gmail.com";
$from = $_REQUEST['from'];
$subject = $_REQUEST['subject'];	
$body = $_REQUEST['body'];

$headers = "From: {$from}\r\n" .
		   "X-Mailer: php";	   
		   
mail($to, $subject, $body, $headers)
?>