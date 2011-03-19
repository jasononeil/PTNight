package models;
import models.BaseDbModel;

class SchoolClass extends BaseDbModel {
	public var id;
	public var teacherID;
	public var className;
	public var students;
	public function getter_students() {
		list = new List();
		if(id != null) 
		{
			jList = SchoolClass_join_Student.manager.search({"classID": id});
			for (join in jList)
			{
				list.add(join.student);
			}
		}
		return list;
	}
	public var interviews;
	public function getter_interviews() {
		return Interview.manager.search({"classID": id});
	}
	
	public var teacher;
	
	public static var manager = new hxbase.DbManager(SchoolClass);
	
	public function new() 
	{
		super();
	}
	
	static function RELATIONS() 
	{
		return new [{prop: "teacher", key: "teacherID", manager: Teacher.manager}]
	}
}
