<?php

class hxbase_BaseController {
	public function __construct($args) {
		if( !php_Boot::$skip_constructor ) {
		$this->actions = new Hash();
		$fields = Type::getInstanceFields(Type::getClass($this));
		{
			$_g = 0;
			while($_g < $fields->length) {
				$field = $fields[$_g];
				++$_g;
				if(Reflect::isFunction(Reflect::field($this, $field))) {
					if($field != "hprint" && $field != "toString" && $field != "clearOutput") {
						$this->actions->set($field, Reflect::field($this, $field));
					}
				}
				unset($field);
			}
		}
		haxe_Log::trace("number of actions available: " . Lambda::count($this->actions), _hx_anonymous(array("fileName" => "BaseController.hx", "lineNumber" => 51, "className" => "hxbase.BaseController", "methodName" => "new")));
	}}
	public $isCacheable;
	public $actions;
	public $output;
	public function doNothing($args) {
		;
	}
	public function toString() {
		return $this->output;
	}
	public function hprint($str) {
		$this->output = $this->output . Std::string($str);
	}
	public function clearOutput() {
		$this->output = "";
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
	static $aliases;
	function __toString() { return $this->toString(); }
}
hxbase_BaseController::$aliases = new _hx_array(array());
