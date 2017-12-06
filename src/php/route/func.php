<?php
/**
 * @file func.php
 * @brief function for routing
 */
namespace rtg;
require_once 'Net/URL/Mapper.php';
require_once(__DIR__ . '/../ttr/file/require.php');

define('DPATH_TO_TOP', __DIR__ . '/../../../');

function getRoutePath($uri) {
    try {
        /* check kanban */
        $map = \Net_URL_Mapper::getInstance();
        $map->connect('/' . DCOM_APP_TITLE . '/api/:func/:act/');
        $mch = $map->match($uri);
        if (null !== $mch) {
            $api_pth = __DIR__ . '/../' . $mch['func'] . '/' . $mch['act'] . '.php';
            if (false === \ttr\file\isExists($api_pth) ) {
                throw new \Exception('invalid parameter');
            }
            return $api_pth;
        }
        throw new \Exception('invalid parameter');
    } catch( \Exception $e ) {
        throw new \Exception(
                  PHP_EOL   .
                  'File:'   . __FILE__   . ',' .
                  'Line:'   . __line__   . ',' .
                  'Func:' . __FUNCTION__ . ',' .
                  $e->getMessage()
              );
    }
}

function getInxConts () {
    try {
        if (true === \ath\isLoggedin()) {
            require_once(DPATH_TO_TOP . 'html/top.html');
        } else {
            require_once(DPATH_TO_TOP . 'html/login.html');
        }
    } catch( \Exception $e ) {
        throw new \Exception(
            PHP_EOL   .
            'File:'   . __FILE__   . ',' .
            'Line:'   . __line__   . ',' .
            'Func:' . __FUNCTION__ . ',' .
            $e->getMessage()
        );
    }
}

function getUri( $upath ) {
    try {
        $ret_val = '';
        $uexp    = explode( '/' , $upath );
        for ( $loop=0 ; $loop < count($uexp) ; $loop++ ) {
            if( $loop == count($uexp)-1 ) {
                $gexp     = explode( '?' , $uexp[$loop] );
                $ret_val .= $gexp[0];
            } else {
                $ret_val .= $uexp[$loop] . '/';
            }
        }
        return $ret_val;
    } catch( \Exception $e ) {
        throw new \Exception(
                  PHP_EOL   .
                  'File:'   . __FILE__   . ',' .
                  'Line:'   . __line__   . ',' .
                  'Func:' . __FUNCTION__ . ',' .
                  $e->getMessage()
              );
    }
}
/* end of file */
