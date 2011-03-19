<?php

class models_Timeslot_join_StudentCategory extends hxbase_BaseDbModel {
	public function __construct() {
		if( !php_Boot::$skip_constructor ) {
		parent::__construct();
	}}
	public $id;
	public $timeslotID;
	public $studentCategoryID;
	public function get_studentCategory() { return call_user_func($this->get_studentCategory); }
	public $get_studentCategory;
	public function set_studentCategory($v) { return call_user_func($this->set_studentCategory, $v); }
	public $set_studentCategory;
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
		return new _hx_array(array(_hx_anonymous(array("prop" => "timeslot", "key" => "timeslotID", "manager" => models_Timeslot::$manager)), _hx_anonymous(array("prop" => "studentCategory", "key" => "studentCategoryID", "manager" => models_StudentCategory::$manager))));
	}
	static $manager;
	function __toString() { return 'models.Timeslot_join_StudentCategory'; }
}
models_Timeslot_join_StudentCategory::$manager = new hxbase_DbManager(_hx_qtype("models.Timeslot_join_StudentCategory"));
