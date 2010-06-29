<?php

class models_TodoItem extends hxbase_BaseDbModel {
	public function __construct() {
		if( !php_Boot::$skip_constructor ) {
		parent::__construct();
	}}
	public $id;
	public $userId;
	public $subject;
	public $text;
	public $priority;
	public $completion;
	public function get_user() { return call_user_func($this->get_user); }
	public $get_user;
	public function set_user($v) { return call_user_func($this->set_user, $v); }
	public $set_user;
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
		return new _hx_array(array(_hx_anonymous(array("prop" => "user", "key" => "userId", "manager" => models_User::$manager))));
	}
	static $manager;
	function __toString() { return 'models.TodoItem'; }
}
models_TodoItem::$manager = new php_db_Manager(_hx_qtype("models.TodoItem"));
