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
	public $view;
	public function defaultAction($args, $action) {
		haxe_Log::trace("default action is: " . $action, _hx_anonymous(array("fileName" => "BaseController.hx", "lineNumber" => 68, "className" => "hxbase.BaseController", "methodName" => "defaultAction")));
		$action = strtolower($action);
		if($this->actions->exists($action)) {
			haxe_Log::trace("and it exists", _hx_anonymous(array("fileName" => "BaseController.hx", "lineNumber" => 72, "className" => "hxbase.BaseController", "methodName" => "defaultAction")));
			Reflect::callMethod($this, $this->actions->get($action), $args);
		}
	}
	public function loadTemplate($str, $pos) {
		$templatePath = null;
		if($str !== null) {
			$templatePath = $str;
		}
		else {
			$controller = strtolower(str_replace("Controller", "", $pos->className));
			$action = strtolower($pos->methodName);
			$templatePath = ((("views/" . $controller) . "/") . $action) . ".tpl";
		}
		$this->view = new hxbase_tpl_HxTpl();
		$this->view->loadTemplateFromFile($templatePath);
	}
	public function printTemplate() {
		$this->clearOutput();
		if($this->view !== null) {
			$this->hprint($this->view->getOutput());
		}
		else {
			hxbase_Log::error("Trying to printTemplate() when loadTemplate() hasn't run yet.", _hx_anonymous(array("fileName" => "BaseController.hx", "lineNumber" => 111, "className" => "hxbase.BaseController", "methodName" => "printTemplate")));
		}
	}
	public function toString() {
		return $this->view->getOutput();
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
