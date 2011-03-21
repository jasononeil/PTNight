package models;
import basehx.BaseDbModel;

class Timeslot extends BaseDbModel
{
	public function new()
	{
		super();
	}
	public var id:Int;
	public var startTime:Date;
	public var length:Int;
	public var categoryID:Int;
	public var category:Int;
	public var categories(getter_categories,null):List<StudentCategory>;
	public function getter_categories() 
	{
		var list = new List();
		if (id != null) 
		{
			var jList = Timeslot_join_StudentCategory.manager.search({timeslot: id});
			for (join in jList)
			{
				list.add(join.studentCategory);
			}
		}
		return list;
	}
	public var endTime(getter_endTime,null):Date;
	public function getter_endTime() 
	{
		return DateTools.delta(this.startTime, this.length * 1000);
	}
	
	static function RELATIONS() 
	{
		//return [{prop: "timeslot", key: "categoryID", manager: StudentCategory.manager}];
		return [];
	}
	public static var manager = new basehx.DbManager<Timeslot>(Timeslot);
}
