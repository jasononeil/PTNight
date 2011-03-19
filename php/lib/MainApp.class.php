<?php

class MainApp {
	public function __construct(){}
	static function main() {
		basehx_App::initiate();
	}
	static $pageTemplateFile = "views/MainView.tpl";
	static function initiatePageTemplate() {
		$template = new basehx_tpl_HxTpl();
		$template->loadTemplateFromFile(MainApp::$pageTemplateFile);
		return $template;
	}
	function __toString() { return 'MainApp'; }
}
