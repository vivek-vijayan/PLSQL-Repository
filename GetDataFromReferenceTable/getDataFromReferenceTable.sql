-- PROCEDURE: public.getdatafromreferencetable()

-- DROP PROCEDURE public.getdatafromreferencetable();

CREATE OR REPLACE PROCEDURE public.getdatafromreferencetable(
	)
LANGUAGE 'plpgsql'
AS $BODY$
/*
	Programmer 👨‍💻 : Vivek Vijayan
	GitHub : 🚀 https://github.com/vivek-vijayan/
	
	Structure and data in each table
	=================================
	maintable:
	rollnumber   |   studentname
	---------------------
	1          vivek
	2          master
	3      	   ''              ---> this is blank
	4		   ''              ---> this is blank

	reftable1:
	rollno       | studname
	-----------------------
	3             king

	reftable2:
	rollno       | studname
	-------------------------
	4 			  programmer
*/

DECLARE
	mainTableCursor cursor for select * from maintable;
	eachrow mainTable%ROWTYPE;
	tempValue varchar(300);
begin
	
	-- cursor
	open mainTableCursor;
	
	loop
		fetch mainTableCursor into eachrow;
		exit when not found;
		-- run the update only when any blank found in the maintable
		if eachrow.studentname = '' then
			-- checking whether the value for that blank is available in the reference table 1
			perform studname from reftable1 where rollno = eachrow.rollnumber;
			-- if found then get the data from the reference table 1 and update the main table
			if found then
				select studname into tempValue from reftable1 where rollno = eachrow.rollnumber;
				update maintable set studentname = tempValue where rollnumber = eachrow.rollnumber;
			else
				-- if no found then check the reference table 2
				perform studname from reftable2 where rollno = eachrow.rollnumber;
				-- if found then get the data from the reference table 2 and update the main table
				if found then
					select studname into tempValue from reftable2 where rollno = eachrow.rollnumber;
					update maintable set studentname = tempValue where rollnumber = eachrow.rollnumber;
				else
					raise notice 'No reference found';
				end if;
			end if; 
		end if;

	end loop;
	close mainTableCursor;
end;
$BODY$;

COMMENT ON PROCEDURE public.getdatafromreferencetable()
    IS 'getting the data from the reference 2 table and update the data in the source table.
if there is a col1<primary key> and col2 <unique> which has an blank,  which has to be updated from the reference table.';
