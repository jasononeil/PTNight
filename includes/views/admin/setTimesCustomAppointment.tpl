<form method="post" action="{Controller.URL}/bookcustomappointment/">
<fieldset>
<label for="timeslotID">Timeslot</label>
<select name="timeslotID">
	<hxLoop name="timeslotSelected"><option value="{id}" selected="selected">{time}</option></hxLoop>
	<option value="">---</option>
	<hxLoop name="timeslot"><option value="{id}">{time}</option></hxLoop>
</select>

<input type="hidden" name="interviewID" value="{interviewID}" />
<input type="hidden" name="parentID" value="{parentID}" />
<input type="hidden" name="studentID" value="{studentID}" />
<input type="hidden" name="teacherID" value="{teacherID}" />

<br /><input type="submit" value="Make Booking" class="button next" />
</fieldset>
</form>