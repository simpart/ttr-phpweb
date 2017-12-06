<?php
/**
 * @file api.php
 * @brief url routing contoroller
 */
namespace rtg;
require_once(__DIR__ . '/../rest/responce.php');
require_once(__DIR__ . '/func.php');
require_once 'Net/URL/Mapper.php';
define('DCOM_APP_TITLE', '@apptitle');

try {
//    global $Grtg_api_ret;
//    $Grtg_api_ret = null;
    
    $uri  = getUri($_SERVER['REQUEST_URI']);
    $path = getRoutePath($uri);
    
    
    
    require_once(getRoutePath($uri));
    
    if (null !== $Grtg_api_ret) {
        \ttr\rest\resp($Grtg_api_ret);
    }
} catch (\Exception $e) {
    \ttr\rest\errResp($e->getMessage());
}
/* end of file */
