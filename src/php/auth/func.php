<?php
/**
 * @file auth/func.php
 * @brief util function for authentication
 */
namespace auth;
require_once(__DIR__ . '/define.php');
require_once(__DIR__ . '/../com/define.php');
require_once(__DIR__ . '/../ttr/class.php');

/**
 * login authentication proceess
 * 
 */
function authLogin ($usr, $pwd) {
    try {
        /* check parameter */
        if ( ('string' !== gettype($usr)) ||
             (0 === strlen($usr)) ) {
            return false;
        }
        
        /* check login auth */
        $ctrl = new \ttr\db\mongo\ctrl\Collection(
                    DCOM_DB_HOST,
                    DCOM_APP_TITLE,
                    'user'
                );
        if (null === $ctrl->find(new \usr\User($usr, $pwd))) {
            /* invalid username or password */
            return false;
        }
        /* successful loggedin */
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
}

function isLoggedin () {
    try {
        $ses   = new \ttr\session\Controller(DCOM_APP_TITLE);
        $login = $ses->get(DATH_LGNCHK);
        if (true !== $login) {
            return false;
        }

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
}



/* end of file */
