<?php

class models_Family extends hxbase_BaseDbModel {
	public function __construct() {
		if( !php_Boot::$skip_constructor ) {
		parent::__construct();
	}}
	public $id;
	public $mazeKey;
	public $studentID;
	public $children;
	public function getter_children() {
		return models_Student::$manager->search(_hx_anonymous(array("familyID" => $this->id)), null);
	}
	public $parents;
	public function getter_parents() {
		return models_Parent::$manager->search(_hx_anonymous(array("familyID" => $this->id)), null);
	}
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
	static $manager;
	function __toString() { return 'models.Family'; }
}
models_Family::$manager = new hxbase_DbManager(_hx_qtype("models.Family"));
