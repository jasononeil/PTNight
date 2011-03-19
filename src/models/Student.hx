<?php

class models_Student extends hxbase_BaseDbModel {
	public function __construct() {
		if( !php_Boot::$skip_constructor ) {
		parent::__construct();
	}}
	public $id;
	public $username;
	public $firstName;
	public $lastName;
	public $familyID;
	public $categoryID;
	public function get_category() { return call_user_func($this->get_category); }
	public $get_category;
	public function set_category($v) { return call_user_func($this->set_category, $v); }
	public $set_category;
	public function get_family() { return call_user_func($this->get_family); }
	public $get_family;
	public function set_family($v) { return call_user_func($this->set_family, $v); }
	public $set_family;
	public $parents;
	public function getter_parents() {
		return models_Parent::$manager->search(_hx_anonymous(array("familyID" => $this->familyID)), null);
	}
	public $classes;
	public function getter_classes() {
		$list = new HList();
		if($this->id !== null) {
			$jList = models_SchoolClass_join_Student::$manager->search(_hx_anonymous(array("studentID" => $this->id)), null);
			$»it = $jList->iterator();
			while($»it->hasNext()) {
			$join = $»it->next();
			{
				$list->add($join->get_schoolClass());
				;
			}
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
	static function RELATIONS() {
		return new _hx_array(array(_hx_anonymous(array("prop" => "category", "key" => "categoryID", "manager" => models_StudentCategory::$manager))));
	}
	static $manager;
	function __toString() { return 'models.Student'; }
}
models_Student::$manager = new hxbase_DbManager(_hx_qtype("models.Student"));
