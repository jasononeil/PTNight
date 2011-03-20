package models;
import basehx.BaseDbModel;

class Teacher extends BaseDbModel {
	public var id:Int;
	public var firstName:String;
	public var lastName:String;
	public var username:String;
	public var email:String;
	public var classes:List<SchoolClass>;
	public function getter_classes() {
		return SchoolClass.manager.search({teacherID: id});
	}
	public var interviews:List<Interview>;
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
		return list;
	}
	
	public static var manager = new basehx.DbManager<Teacher>(Teacher);
	
	public function new() 
	{
		super();
	}
}
