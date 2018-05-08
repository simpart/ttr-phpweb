<?php

namespace init;
require_once(__DIR__ . '/../ttr/class.php');

define('INITDB_ING_KEY', 'target');

try {
    if (2 != $argc) {
        throw new \Exception('could not parameter');
    }
    $db_yml = yaml_parse_file($argv[1]);
    if (false === $db_yml) {
        throw new \Exception('failed parse ' . $argv[1]);
    }
    
    $ctrl     = null;
    $db_name  = null;
    $col_name = null;
    foreach ($db_yml as $db_key => $db_val) {
        /* check dbkey */
        if (0 === strcmp(INITDB_ING_KEY, $db_key)) {
            continue;
        }
        $db_name = $db_key;
        
        /* add collection */
        $didx    = 0;
        while( ($col = getCollection($db_val, $db_key, $didx)) !== null ) {
            
            $ctrl = new \ttr\db\mongo\ctrl\ComList(
                $db_yml[INITDB_ING_KEY]['host'],
                $db_name,
                $col['name']
            );
            
            /* set collection */
            $ctrl->add($col['conts']);
            $didx++;
        }
        break;
    }
    $ctrl = null;
} catch (\Exception $e) {
    throw new \Exception(
        PHP_EOL   .
        'File:'   . __FILE__   . ',' .
        'Line:'   . __line__   . ',' .
        'Func:' . __FUNCTION__ . ',' .
        $e->getMessage()
    );
}



function getCollection ($val, $dnm, $idx) {
    try {
        
        for ($vidx = 0; $vidx < count($val) ;$vidx++) {
            if ($idx === $vidx) {
                foreach ($val[$vidx] as $vkey => $conts) {
                    return array(
                        'name'  => $vkey,
                        'conts' => $conts
                    );
                }
            }
        }
        
        return null;
    } catch (\Exception $e) {
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
