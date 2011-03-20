package models;
import basehx.BaseDbModel;

class SchoolClass_join_Student extends BaseDbModel 
{
	public var id:Int;
	public var classID:Int;
	public var studentID:Int;
	public var schoolClass:SchoolClass;
	public var student:Student;
	
	public static var manager = new basehx.DbManager<SchoolClass_join_Student>(SchoolClass_join_Student);
	
	public function new() 
	{
		super();
	}
	
	static function RELATIONS() 
	{
		return [{prop: "schoolClass", key: "classID", manager: SchoolClass.manager},
					{prop: "student", key: "studentID", manager: Student.manager}];
	}
}
