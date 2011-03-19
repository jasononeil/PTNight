package models;
import models.BaseDbModel;

class Timeslot_join_StudentCategory extends BaseDbModel 
{
	public var id;
	public var timeslotID;
	public var studentCategoryID;
	public var studentCategory;
	public var timeslot;
	
	public static var manager = new hxbase.DbManager(Timeslot_join_StudentCategory);
	
	public function new() 
	{
		super();
	}
	
	static function RELATIONS() 
	{
		return new [{prop: "timeslot", key: "timeslotID", manager: Timeslot.manager}, 
					{prop: "studentCategory", key: "studentCategoryID", manager: StudentCategory.manager}];
	}
	
}
