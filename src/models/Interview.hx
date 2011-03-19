<?php

class models_Interview extends hxbase_BaseDbModel {
	public function __construct() {
		if( !php_Boot::$skip_constructor ) {
		parent::__construct();
	}}
	public $id;
	public $parentID;
	public $studentID;
	public $classID;
	public $timeslotID;
	public $teacherID;
	public function get_parent() { return call_user_func($this->get_parent); }
	public $get_parent;
	public function set_parent($v) { return call_user_func($this->set_parent, $v); }
	public $set_parent;
	public function get_student() { return call_user_func($this->get_student); }
	public $get_student;
	public function set_student($v) { return call_user_func($this->set_student, $v); }
	public $set_student;
	public function get_schoolClass() { return call_user_func($this->get_schoolClass); }
	public $get_schoolClass;
	public function set_schoolClass($v) { return call_user_func($this->set_schoolClass, $v); }
	public $set_schoolClass;
	public function get_teacher() { return call_user_func($this->get_teacher); }
	public $get_teacher;
	public function set_teacher($v) { return call_user_func($this->set_teacher, $v); }
	public $set_teacher;
	public function get_timeslot() { return call_user_func($this->get_timeslot); }
	public $get_timeslot;
	public function set_timeslot($v) { return call_user_func($this->set_timeslot, $v); }
	public $set_timeslot;
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
		return new _hx_array(array(_hx_anonymous(array("prop" => "parent", "key" => "parentID", "manager" => models_Parent::$manager)), _hx_anonymous(array("prop" => "student", "key" => "studentID", "manager" => models_Student::$manager)), _hx_anonymous(array("prop" => "schoolClass", "key" => "classID", "manager" => models_SchoolClass::$manager)), _hx_anonymous(array("prop" => "teacher", "key" => "teacherID", "manager" => models_Teacher::$manager)), _hx_anonymous(array("prop" => "timeslot", "key" => "timeslotID", "manager" => models_Timeslot::$manager))));
	}
	static $manager;
	function __toString() { return 'models.Interview'; }
}
models_Interview::$manager = new hxbase_DbManager(_hx_qtype("models.Interview"));
