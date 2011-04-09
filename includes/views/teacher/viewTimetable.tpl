<h2>{teacher.firstName} {teacher.lastName}</h2>
<hxLoop name="category">
<h3>{date}</h3>
<table class="zebra">
	<tr>
		<th>Time</th>
		<th>Parent</th>
		<th>Class</th>
		<th>Child</th>
	</tr>
	<hxLoop name="interview">
	<tr>
		<td>{startTime}</td>
		<td><b><hxVar name="parent.firstName">Unavailable</hxVar> {parent.lastName}</b></td>
		<td>{classCategory}: {class.className}</td>
		<td>{student.firstName} {student.lastName}</td>
	</tr>
	</hxLoop>
</table>
</hxLoop>
<p>All interviews are scheduled for five minutes blocks.</p>
<p>Please note: The website is still accepting new bookings, so this timetable is not yet final.</p>
<p class="noprint"><a href="javascript:window.print()">Print</a></p>
<!-- <form>
<fieldset>
	<input type="button" value="Switch Parent" class="button" onclick="location.href='{Controller.URL}/'" />
	<input type="button" value="Change Bookings" class="button left" onclick="location.href='{Controller.URL}/selectteachers/'" />
</fieldset>
</form> -->
