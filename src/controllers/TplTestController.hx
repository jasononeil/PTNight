package controllers;
import basehx.BaseController;
import basehx.App;
import basehx.util.Error;
using Lambda;

class TplTestController extends BaseController 
{
	public function new(args) 
	{
		super(args);
		//if (!session) { die("Here too"); }
	}
	
	override public function getDefaultAction() 
	{
		return this.home;
	}
	
	public function home() 
	{
		var message = null;
		loadTemplate();
		
		// test a simple assign
		template.assign("name", "Jason");
		
		// test a switch
		var sw = view.setSwitch("showThis", true);
		sw.newLoop("show3times");
		sw.newLoop("show3times").assign("name", "that guy");
		sw.newLoop("show3times");
		
		// test a loop
		for (rowID in 1...20)
		{
			var row = view.newLoop("row").assign("rowID",rowID);
			for (columnID in 1...10)
			{
				var column = row.newLoop("column");
				column.assign("columnID",columnID);
			}
		}
		
		
		printTemplate();
		
		App.printStats();
	}
	
	public static var aliases = [];
}
