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
            return json_decode($jcnf);
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
