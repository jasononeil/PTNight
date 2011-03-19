<?php

class models_Parent extends hxbase_BaseDbModel {
	public function __construct() {
		if( !php_Boot::$skip_constructor ) {
		parent::__construct();
	}}
	public $id;
	public $firstName;
	public $lastName;
	public $familyID;
	public $email;
	public $children;
	public function getter_children() {
		return models_Student::$manager->search(_hx_anonymous(array("familyID" => $this->familyID)), null);
	}
	public $interviews;
	public function getter_interviews() {
		return models_Interview::$manager->search(_hx_anonymous(array("parentID" => $this->id)), false);
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
	function __toString() { return 'models.Parent'; }
}
models_Parent::$manager = new hxbase_DbManager(_hx_qtype("models.Parent"));
