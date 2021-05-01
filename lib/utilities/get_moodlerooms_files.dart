// DOWNLOAD PARAMETERS
//Note: The service associated to the user token must allow "file download" !
//      in the administration, edit the service to check the setting (click "advanced" button on the edit page).
//Normally you retrieve the file download url from calling the web service core_course_get_contents()
//However to be quick to demonstrate the download call,
//you are going to retrieve the file download url manually:
//1- In Moodle, create a forum with an attachment
//2- look at the attachment link url, and copy everything after http://YOURMOODLE/pluginfile.php
//   into the above variable
const $token = '98e74de004450cf8be0668ba33507d5a';
const $domainName = 'http://imt.mrooms.net';
const $relativepath =
    '/11156/mod_folder/content/0/Aula%2007%20-%20Curvas%20no%20espa%C3%A7o%20tridimensional/Aula%2007-%20Curvas%20e%20parametriza%C3%A7%C3%A3o%20no%20R%5E3.pptx?forcedownload=1';
//CHANGE THIS ! This is where you will store the file.
//Don't forget to allow 'write permission' on the folder for your web server.
const $path = 'C:\Users\Henrique\Desktop\Estuda Mauá';
// DOWNLOAD IMAGE - Moodle 2.2 and later
var $url =
    '${$domainName}/webservice/pluginfile.php${$relativepath}'; //NOTE: normally you should get this download url from your previous call of core_course_get_contents()
final $tokenUrl =
    '${$url}?token=${$token}'; //NOTE: in your client/app don't forget to attach the token to your download url
//$fp = fopen($path, 'w');
//$ch = curl_init($tokenUrl);
//curl_setopt($ch, CURLOPT_FILE, $fp);
//$data = curl_exec($ch);
//curl_close($ch);
//fclose($fp);
