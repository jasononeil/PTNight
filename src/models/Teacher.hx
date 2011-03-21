package models;
import basehx.BaseDbModel;
import models.Interview;

class Teacher extends BaseDbModel {
	public var id:Int;
	public var firstName:String;
	public var lastName:String;
	public var username:String;
	public var email:String;
	public var classes(getter_classes,null):List<SchoolClass>;
	public function getter_classes() 
	{
		return SchoolClass.manager.search({teacherID: id});
	}
	public var interviews(getter_interviews,null):List<Interview>;
	public function getter_interviews() 
	{
		var list = new List();
		for (schoolClass in classes)
		{
			var tmpList = schoolClass.interviews;
			for (interview in tmpList)
			{
				list.add(interview);
			}
		}
		// it is possible some interviews exist that are not tied to a class...
		for (interview in Interview.manager.search({ teacherID: id, classID: null }))
		{
				list.add(interview);
		}
		
		return list;
	}
	
	public static var manager = new basehx.DbManager<Teacher>(Teacher);
	
	public function new() 
	{
		super();
	}
}
