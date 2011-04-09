<p>Please select the time slots you would like to meet each teacher in.  
To ensure smooth operations on the night, we recommend not booking 
interviews back to back.</p>
<form method="post" action="{Controller.URL}/makebookings/">
<fieldset>
<hxLoop name="category">
<p><b>Please note, you can scroll to the right to view more times.</b></p>
<table class="verticalZebra scrollOverflow">
	<tr>
		<th><span class="rotate90CCW small"> </span></th>
		<hxLoop name="timeslotHeader">
		<th><span class="rotate90CCW small">{time}</span></th>
		</hxLoop>
	</tr>
	<hxLoop name="bookingLine">
	<tr>
		<td class="nobreak"><b>{teacher.firstName} {teacher.lastName}</b>
		<br /><span class="small">
			{class.className}
			<br />{student.firstName}
		</span></td>
		<hxLoop name="timeslot">
		<td>
			<hxLoop name="showCheckboxChecked"><input type="checkbox" name="Bookings[]" value="{student.id},{class.id},{timeslotID}" checked="yes" /></hxLoop>
			<hxLoop name="showCheckboxUnchecked"><input type="checkbox" name="Bookings[]" value="{student.id},{class.id},{timeslotID}" /></hxLoop>
		</td>
		</hxLoop>
	</tr>
	</hxLoop>
</table>
</hxLoop>
<input type="button" value="Start Again" class="button left" onclick="location.href='{Controller.URL}/selectteachers/'" />
<input type="submit" value="Make Bookings" class="button" />
</fieldset>
</form>
