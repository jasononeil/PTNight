package models;
import models.BaseDbModel;

class StudentCategory extends BaseDbModel 
{
	public function new() 
	{
		super();
	}
	public var id;
	public var name;
	
	public function getter_timeslots() 
	{
		list = new List();
		if (id !== null) 
		{
			jList = Timeslot_join_StudentCategory.manager.search({"studentCategoryID": id});
			for (join in jList)
			{
				list.add(join.timeslot);
			}
		}
		return list;
	}
	
	public static var manager = new hxbase.DbManager(StudentCategory);
}
