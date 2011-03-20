package models;
import basehx.BaseDbModel;
import models.Timeslot;

class StudentCategory extends BaseDbModel 
{
	public function new() 
	{
		super();
	}
	public var id:Int;
	public var name:String;
	public var timeslots(getter_timeslots,null):List<Timeslot>;
	public function getter_timeslots() 
	{
		var list = new List();
		if (id != null) 
		{
			var jList = Timeslot_join_StudentCategory.manager.search({studentCategoryID: id});
			for (join in jList)
			{
				list.add(join.timeslot);
			}
		}
		return list;
	}
	
	public static var manager = new basehx.DbManager<StudentCategory>(StudentCategory);
}
