<?php

class models_SchoolClass extends hxbase_BaseDbModel {
	public function __construct() {
		if( !php_Boot::$skip_constructor ) {
		parent::__construct();
	}}
	public $id;
	public $teacherID;
	public $className;
	public $students;
	public function getter_students() {
		$list = new HList();
		if($this->id !== null) {
			$jList = models_SchoolClass_join_Student::$manager->search(_hx_anonymous(array("classID" => $this->id)), null);
			$»it = $jList->iterator();
			while($»it->hasNext()) {
			$join = $»it->next();
			{
				$list->add($join->get_student());
				;
			}
			}
		}
		return $list;
	}
	public $interviews;
	public function getter_interviews() {
		return models_Interview::$manager->search(_hx_anonymous(array("classID" => $this->id)), null);
	}
	public function get_teacher() { return call_user_func($this->get_teacher); }
	public $get_teacher;
	public function set_teacher($v) { return call_user_func($this->set_teacher, $v); }
	public $set_teacher;
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
		return new _hx_array(array(_hx_anonymous(array("prop" => "teacher", "key" => "teacherID", "manager" => models_Teacher::$manager))));
	}
	static $manager;
	function __toString() { return 'models.SchoolClass'; }
}
models_SchoolClass::$manager = new hxbase_DbManager(_hx_qtype("models.SchoolClass"));
