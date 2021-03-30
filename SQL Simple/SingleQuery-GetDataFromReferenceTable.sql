/*
	Programmer 👨‍💻 : Vivek Vijayan
	GitHub : 🚀 https://github.com/vivek-vijayan/
*/

-- SINGLE QUERY CONCEPT

select rollnumber, studentname, 
	case when studentname = '' and (select count(studname) from reftable1 where rollno = rollnumber) > 0
		 then (select studname from reftable1 where rollno = rollnumber) 
		 when studentname = '' and (select count(studname) from reftable2 where rollno = rollnumber) > 0
		 then (select studname from reftable2 where rollno = rollnumber) 
		 else studentname 
	end as UpdatedNewColumn 
from maintable;

