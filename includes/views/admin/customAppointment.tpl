<h2>Current Appointments</h2>
<table class="zebra">
	<tr>
		<th>Time</th>
		<th>Teacher</th>
		<th>Class</th>
		<th>Child</th>
		<th>Edit</th>
		<th>Delete</th>
	</tr>
	<hxLoop name="interview">
	<tr>
		<td>{startTime}</td>
		<td><b>{teacher.firstName} {teacher.lastName}</b></td>
		<td>{class.className}</td>
		<td>{student.firstName}</td>
		<td><a href="{Controller.URL}/editcustomappointment/{interviewID}/">Edit</a></td>
		<td><a href="{Controller.URL}/deletecustomappointment/{interviewID}/">Del</a></td>
	</tr>
	</hxLoop>
</table>
<p><a href="{Controller.URL}/newcustomappointment/{parent.id}/">Create new appointment</a></p>