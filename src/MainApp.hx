import basehx.App;
import basehx.tpl.HxTpl;
class MainApp 
{
	static public function main() 
	{
		App.initiate();
	}
	
	static public var pageTemplateFile = "views/MainView.tpl";
	
	static public function initiatePageTemplate() 
	{
		var template = new HxTpl();
		template.loadTemplateFromFile(pageTemplateFile);
		return template;
	}
}
