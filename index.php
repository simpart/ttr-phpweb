<?php
require_once(__DIR__ . '/src/php/route/func.php');
require_once(__DIR__ . '/auth/func.php');

try {
    
    
    if (true === \ath\isLoggedin()) {
        require_once(__DIR__ . '/html/top.html');
    } else {
        require_once(__DIR__ . '/html/login.html');
    }
} catch (Exception $e) {
    echo $e->getMessage();
}
/* end of file */
