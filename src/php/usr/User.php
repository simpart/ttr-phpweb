<?php
/**
 * @file User.php
 * @brief user common class
 */
namespace usr;
require_once(__DIR__ . '/../com/define.php');
require_once(__DIR__ . '/define.php');

class User extends \ttr\db\mongo\Document {
    
    function __construct ($nm=null, $pwd=null, $rle=null) {
        try {
            parent::__construct(
                array('name', 'password', 'role'),
                array('name', 'password', 'role')
            );
            $this->name($nm);
            $this->password($pwd);
            $this->role($rle);
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
   
    public function name ($prm=null) {
        try {
            if (null === $prm) {
                /* getter */
                return $this->contents()['name'];
            }
            /* setter */
            if ('string' !== gettype($prm)) {
                throw new \Exception('invalid data type');
            }
            $this->contents(
                array('name' => $prm)
            );
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
    
    
    public function password ($prm=null, $md5=true) {
        try {
            if (null === $prm) {
                /* getter */
                return $this->contents()['password'];
            }
            /* setter */
            if ('string' !== gettype($prm)) {
                throw new \Exception('invalid data type');
            }
            
            /**
             * @attention this password hash is so weak
             *            this is workaround
             */
            $set_pwd = (true === $md5) ? md5($prm) : $prm;
            $this->contents(
                array('password' => $set_pwd)
            );
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
    
    public function role ($prm=null) {
        try {
            if (null === $prm) {
                /* getter */
                return $this->contents()['role'];
            }
            /* setter */
            if ( (DUSR_ROLE_ADMIN !== $prm) &&
                 (DUSR_ROLE_USER !== $prm) ) {
                throw new \Exception('invalid parameter');
            }
            $this->contents(
                array('role' => $prm)
            );
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
