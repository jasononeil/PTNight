package models;
import models.BaseDbModel;

class Teacher extends BaseDbModel {
	public var id;
	public var firstName;
	public var lastName;
	public var username;
	public var email;
	public var classes;
	public function getter_classes() {
		return SchoolClass.manager.search({"teacherID": id});
	}
	public var interviews;
	public function getter_interviews() 
	{
		list = new List();
		for (schoolClass in classes)
		{
			tmpList = schoolClass.getter_interviews();
			for (interview in tmpList)
			{
				list.add(interview);
			}
		}
		return list;
	}
	
	public static var manager = new hxbase.DbManager(Teacher);
	
	public function new() 
	{
		super();
	}
}
