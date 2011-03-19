<?php

class models_SchoolClass_join_Student extends hxbase_BaseDbModel {
	public function __construct() {
		if( !php_Boot::$skip_constructor ) {
		parent::__construct();
	}}
	public $id;
	public $classID;
	public $studentID;
	public function get_schoolClass() { return call_user_func($this->get_schoolClass); }
	public $get_schoolClass;
	public function set_schoolClass($v) { return call_user_func($this->set_schoolClass, $v); }
	public $set_schoolClass;
	public function get_student() { return call_user_func($this->get_student); }
	public $get_student;
	public function set_student($v) { return call_user_func($this->set_student, $v); }
	public $set_student;
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->»dynamics[$m]) && is_callable($this->»dynamics[$m]))
			return call_user_func_array($this->»dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call «'.$m.'»');
	}
	static function RELATIONS() {
		return new _hx_array(array(_hx_anonymous(array("prop" => "schoolClass", "key" => "classID", "manager" => models_SchoolClass::$manager)), _hx_anonymous(array("prop" => "student", "key" => "studentID", "manager" => models_Student::$manager))));
	}
	static $manager;
	function __toString() { return 'models.SchoolClass_join_Student'; }
}
models_SchoolClass_join_Student::$manager = new hxbase_DbManager(_hx_qtype("models.SchoolClass_join_Student"));
