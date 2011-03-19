package models;
import models.BaseDbModel;

class Timeslot extends BaseDbModel
{
	public function new()
	{
		super();
	}
	public var id;
	public var startTime;
	public var length;
	public var categoryID;
	public var category;
	public function getter_categories() 
	{
		list = new List();
		if (id != null) 
		{
			jList = Timeslot_join_StudentCategory.manager.search({"timeslot": id});
			for (join in jList)
			{
				list.add(join.get_studentCategory());
			}
		}
		return list;
	}
	public var endTime;
	public function getter_endTime() {
		return DateTools.delta(this.startTime, this.length * 1000);
	}
	
	static function RELATIONS() 
	{
		//return new [{prop: "timeslot", key: "categoryID", manager: StudentCategory.manager}]
		return new [];
	}
	public static var manager = new hxbase.DbManager(Timeslot);
}
