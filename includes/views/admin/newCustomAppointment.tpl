<h2>New Appointment</h2>
<p>Booking a custom appointment with {parent.firstName} {parent.lastName}</p>
<form method="post" action="{Controller.URL}/settimescustomappointment/">
<fieldset>
	<input type="hidden" name="interviewID" value="{interview.id}" />
	<input type="hidden" name="parentID" value="{parent.id}" />
	<label for="studentID">Child:</label>
	<select id="studentID" name="studentID">
		<hxLoop name="studentSelected"><option value="{student.id}" selected="selected">{student.firstName} {student.lastName}</option></hxLoop>
		<option value="">---</option>
		<hxLoop name="student"><option value="{student.id}">{student.firstName} {student.lastName}</option></hxLoop>
	</select>
	
	<br /><label for="teacherID">Teacher:</label>
	<select id="teacherID" name="teacherID">
		<hxLoop name="teacherSelected"><option value="{teacher.id}" selected="selected">{teacher.firstName} {teacher.lastName}</option></hxLoop>
		<option value="">---</option>
		<hxLoop name="teacher"><option value="{teacher.id}">{teacher.firstName} {teacher.lastName}</option></hxLoop>
	</select>
	
	<br /><input type="submit" value="Select Times" class="button next" />
</fieldset>
</form>