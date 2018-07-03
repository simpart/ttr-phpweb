<?php
/**
 * @file   JsonConf.php
 * @brief  JsonConf class
 * @author simpart
 */
namespace com;

/**
 * @class JsonConf
 * @brief json type config reader,writer
 */
class JsonConf {
    private $base = null;
    private $name = null;
    
    public function __construct ($b=null, $n) {
        try {
            if ((null === $b) || (null === $n)) {
                throw new \Exception('invalid parameter');
            }
            $this->base = $b;
            $this->name = $n;
        } catch (\Exception $e) {
            throw new \Exception(
                PHP_EOL   .
                'File:'   . __FILE__         . ',' .
                'Line:'   . __line__         . ',' .
                'Class:'  . get_class($this) . ',' .
                'Method:' . __FUNCTION__     . ',' .
                $e->getMessage()
            );
        }
    }
    
    public function get () {
        try {
            $fpath = __DIR__ . '/../../../conf/' . $this->base . '/' . $this->name . '.json';
            $jcnf  = file_get_contents($fpath);
            $temp  = json_decode($jcnf);
            
            return $this->parse($temp);
        } catch (\Exception $e) {
            throw new \Exception(
                PHP_EOL   .
                'File:'   . __FILE__         . ',' .
                'Line:'   . __line__         . ',' .
                'Class:'  . get_class($this) . ',' .
                'Method:' . __FUNCTION__     . ',' .
                $e->getMessage()
            );
        }
    }
    
    private function parse ($prm) {
        try {
            if ((false === is_array($prm)) && (false === is_object($prm))) {
                return $prm;
            }
            $ret = null;
            if (true === is_object($prm)) {
                foreach ($prm as $key => $val) {
                    $ret[$key] = $this->parse($val);
                }
            } else if (array_values($prm) === $prm) {
                foreach ($prm as $val) {
                    $ret[] = $this->parse($val);
                }
            } else {
                throw new \Exception('invalid parameter');
            }
            return $ret;
        } catch (\Exception $e) {
            throw new \Exception(
                PHP_EOL   .
                'File:'   . __FILE__         . ',' .
                'Line:'   . __line__         . ',' .
                'Class:'  . get_class($this) . ',' .
                'Method:' . __FUNCTION__     . ',' .
                $e->getMessage()
            );
        }
    }
    
    public function save ($cnf) {
        try {
            $fpath   = __DIR__ . '/../../../conf/' . $this->base . '/' . $this->name . '.json';
            $set_cnf = json_encode($cnf);
            file_put_contents($fpath, $set_cnf);
        } catch (\Exception $e) {
            throw new \Exception(
                PHP_EOL   .
                'File:'   . __FILE__         . ',' .
                'Line:'   . __line__         . ',' .
                'Class:'  . get_class($this) . ',' .
                'Method:' . __FUNCTION__     . ',' .
                $e->getMessage()
            );
        }
    }
}
/* end of file */
