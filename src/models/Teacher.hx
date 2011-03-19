<?php

class models_Teacher extends hxbase_BaseDbModel {
	public function __construct() {
		if( !php_Boot::$skip_constructor ) {
		parent::__construct();
	}}
	public $id;
	public $firstName;
	public $lastName;
	public $username;
	public $email;
	public $classes;
	public function getter_classes() {
		return models_SchoolClass::$manager->search(_hx_anonymous(array("teacherID" => $this->id)), null);
	}
	public $interviews;
	public function getter_interviews() {
		$list = new HList();
		$»it = $this->getter_classes()->iterator();
		while($»it->hasNext()) {
		$schoolClass = $»it->next();
		{
			$tmpList = $schoolClass->getter_interviews();
			$»it2 = $tmpList->iterator();
			while($»it2->hasNext()) {
			$interview = $»it2->next();
			{
				$list->add($interview);
				;
			}
			}
			unset($»it2,$tmpList,$interview);
		}
		}
		return $list;
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
	function __toString() { return 'models.Teacher'; }
}
models_Teacher::$manager = new hxbase_DbManager(_hx_qtype("models.Teacher"));
