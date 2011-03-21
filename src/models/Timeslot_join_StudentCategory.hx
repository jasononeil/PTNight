package models;
import basehx.BaseDbModel;
import models.StudentCategory;
import models.Timeslot;

class Timeslot_join_StudentCategory extends BaseDbModel 
{
	public var id:Int;
	public var timeslotID:Int;
	public var studentCategoryID:Int;
	public var studentCategory(dynamic,dynamic):StudentCategory;
	public var timeslot(dynamic,dynamic):Timeslot;
	
	public static var manager = new basehx.DbManager<Timeslot_join_StudentCategory>(Timeslot_join_StudentCategory);
	
	public function new() 
	{
		super();
	}
	
	static function RELATIONS() 
	{
		return [{prop: "timeslot", key: "timeslotID", manager: Timeslot.manager}, 
					{prop: "studentCategory", key: "studentCategoryID", manager: StudentCategory.manager}];
	}
	
}
