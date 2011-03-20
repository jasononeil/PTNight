package models;
import basehx.BaseDbModel;

class Interview extends BaseDbModel 
{
	public var id:Int;
	public var parentID:Int;
	public var studentID:Int;
	public var classID:Int;
	public var timeslotID:Int;
	public var teacherID:Int;
	public var parent:Parent;
	public var student:Student;
	public var schoolClass:SchoolClass;
	public var teacher:Teacher;
	public var timeslot:Timeslot;
	
	public static var manager = new basehx.DbManager<Interview>(Interview);
	
	public function new() 
	{
		super();
	}
	
	static function RELATIONS() 
	{
		return [{prop: "parent", key: "parentID", manager: Parent.manager}, 
					{prop: "student", key: "studentID", manager: Student.manager},
					{prop: "schoolClass", key: "classID", manager: SchoolClass.manager},
					{prop: "teacher", key: "teacherID", manager: Teacher.manager},
					{prop: "timeslot", key: "timeslotID", manager: Timeslot.manager}];
	}
}
