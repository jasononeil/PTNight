<?php

class hxbase_BaseController {
	public function __construct($args) {
		if( !php_Boot::$skip_constructor ) {
		$this->actions = new Hash();
		$thisClass = Type::getClass($this);
		$fields = Type::getInstanceFields($thisClass);
		{
			$_g = 0;
			while($_g < $fields->length) {
				$field = $fields[$_g];
				++$_g;
				if(Reflect::isFunction(Reflect::field($this, $field))) {
					if($field != "hprint" && $field != "toString" && $field != "clearOutput") {
						$this->actions->set(strtolower($field), Reflect::field($this, $field));
					}
				}
				unset($field);
			}
		}
		$firstArg = $args[0];
		if($this->actions->exists($firstArg)) {
			$args->shift();
			Reflect::callMethod($this, $this->actions->get($firstArg), $args);
		}
		else {
			$this->defaultAction($args, null);
		}
	}}
	public $isCacheable;
	public $actions;
	public $output;
	public function defaultAction($args, $action) {
		haxe_Log::trace("default action is: " . $action, _hx_anonymous(array("fileName" => "BaseController.hx", "lineNumber" => 71, "className" => "hxbase.BaseController", "methodName" => "defaultAction")));
		$action = strtolower($action);
		if($this->actions->exists($action)) {
			haxe_Log::trace("and it exists", _hx_anonymous(array("fileName" => "BaseController.hx", "lineNumber" => 75, "className" => "hxbase.BaseController", "methodName" => "defaultAction")));
			Reflect::callMethod($this, $this->actions->get($action), $args);
		}
	}
	public function doNothing($myString) {
		haxe_Log::trace("Value: " . $myString, _hx_anonymous(array("fileName" => "BaseController.hx", "lineNumber" => 82, "className" => "hxbase.BaseController", "methodName" => "doNothing")));
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
