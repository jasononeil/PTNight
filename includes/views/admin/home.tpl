<div class="hidden">
	<h3>Add timeslots for:</h3>
	<ul>
	<li><a href="{Controller.URL}/addtimeslots/2011-05-03/16:00:00/20:00:00/300/Y08,Y09,Y10,Y11,Y12/">Add all years, 3rd May, 4-8pm, 5min slots.</a></li>
	<li><a href="{Controller.URL}/addtimeslots/2011-05-11/16:00:00/20:00:00/300/Y08,Y09,Y10,Y11,Y12/">Add allyears, 11th May, 4-8pm, 5min slots.</a></li>
	</ul>
	<div class="hidden">
	<form method="post" action="{Controller.URL}/addtimeslots/">
		Jason
	</form>
	</div>
</div>

<div class="hidden">
	<h3>Import Data:</h3>
	<h4>WARNING: Don't do this if you have ANY LIVE DATA (at all!).  It'll probably break it all...</h4>
	<form method="post" action="{Controller.URL}/importmazedata/" enctype='multipart/form-data'>
		<p><b>SQL Query to use:</b><br />
		<pre>
		SELECT ST.STKEY AS 'Student-MazeID',
		ST.FIRST_NAME AS 'Student-firstName',
		ST.SURNAME AS 'Student-lastName',
		ST.SCHOOL_YEAR AS 'Student-yearGroup',
		SU.FULLNAME AS 'Class-ClassName',
		STMA.IDENT AS 'Class-MazeID',
		THTQ.T1TEACH AS 'Teacher-MazeID',
		SF.FIRST_NAME AS 'Teacher-First',
		SF.SURNAME AS 'Teacher-Last',
		DF.DFKEY AS 'Parent-FamilyKey',
		DF.MNAME AS 'Parent-MumFirst',
		DF.MSURNAME AS 'Parent-MumLast',
		DF.M_EMAIL AS 'Parent-MumEmail',
		DF.FNAME AS 'Parent-DadFirst',
		DF.FSURNAME AS 'Parent-DadLast',
		DF.F_EMAIL AS 'Parent-DadEmail'
		FROM ST LEFT OUTER JOIN STMA ON STMA.SKEY = ST.STKEY
		LEFT OUTER JOIN SU ON STMA.MKEY = SU.SUKEY
		LEFT OUTER JOIN DF ON ST.FAMILY = DF.DFKEY
		LEFT OUTER JOIN THTQ ON STMA.IDENT = THTQ.IDENT
		LEFT OUTER JOIN SF ON SF.SFKEY = THTQ.T1TEACH
		WHERE STMA.TTPERIOD = '2010T3'
		AND ST.STATUS = 'Full'
		GROUP BY ST.STKEY, ST.FIRST_NAME, ST.SURNAME, SU.FULLNAME, STMA.IDENT,
		THTQ.T1TEACH, SF.FIRST_NAME, SF.SURNAME, DF.DFKEY, DF.MNAME, DF.MSURNAME,
		DF.M_EMAIL, DF.FNAME, DF.FSURNAME, DF.F_EMAIL, ST.SCHOOL_YEAR
		</pre></p>
		<p><b>Upload:</b></p>
		<input type="file" name="mazedata" />
		
		<p><input type="submit" value="Import now" /></p>
	</form>
</div>

<div class="">
	<h3>View your timetable</h3>
	<p><a href="{App.URL}/teacher/">Click here</a></p>
</div>

<div class="">
	<h3>Parents</h3>
	<p><a href="{Controller.URL}/viewallparents/">View / Edit Parent Timetables</a></p>
</div>

<div class="">
	<h3>Teachers</h3>
	<p><a href="{Controller.URL}/viewallteachers/">View Individual Teacher Timetables</a></p>
	<p><a href="{Controller.URL}/printallteachers/">Print All Teacher Timetables</a></p>
</div>
