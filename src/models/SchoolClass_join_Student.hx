package models;
import models.BaseDbModel;

class SchoolClass_join_Student extends BaseDbModel 
{
	public var id;
	public var classID;
	public var studentID;
	public var schoolClass;
	public var student;
	
	public static var manager = new hxbase.DbManager(SchoolClass_join_Student);
	
	public function new() 
	{
		super();
	}
	
	static function RELATIONS() 
	{
		return new [{prop: "schoolClass", key: "classID", manager: SchoolClass.manager},
					{prop: "student", key: "studentID", manager: Student.manager}]
	}
}
