<?php
/**
 * @file   login.php
 * @brief  util function for login authentication
 * @author simpart
 */
namespace auth;
require_once(__DIR__ . '/../com/define.php');
require_once(__DIR__ . '/func.php');
require_once(__DIR__ . '/define.php');
 
try {
    ///* set session */
    $ses   = new \ttr\session\Controller(DCOM_APP_TITLE);
    $ses->set(DATH_LGNCHK, false);
    
    return true;
} catch (\Exception $e) {
    throw new \Exception(
               PHP_EOL .
               'File:' . __FILE__     . ',' .
               'Line:' . __line__     . ',' .
               'Func:' . __FUNCTION__ . ',' .
               $e->getMessage()
          );
}
/* end of file */
