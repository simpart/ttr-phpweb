<?php
/**
 * @file   login.php
 * @brief  util function for login authentication
 * @author simpart
 */
namespace auth;
 
try {
    return "login auth";
        // login process
        
        // successful loggedin
        // $ses   = new \ttr\session\Controller(DCOM_APP_TITLE);
        // $ses->set(DATHLGN_CHKKEY, true);
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
