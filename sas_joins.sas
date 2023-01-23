/* inner joins - two ways to do this */

proc sql noprint;
   create table join_1 as
   select a.*, b.density_2010
   from sashelp.prdsal2 a, sashelp.us_data b
   where a.state = b.statename;
quit;

proc sql noprint;
   create table join_2 as
   select a.*, b.density_2010
   from sashelp.prdsal2 a inner join sashelp.us_data b
   on a.state = b.statename;
quit;

/* left join example */
proc sql;
   create table join_3 as
   select a.*, b.*
   from sashelp.gcstate a left join sashelp.us_data b
   on a.mapidname=b.statename;
quit;

/* right join example */
proc sql;
   create table join_4 as
   select a.*, b.*
   from sashelp.gcstate a right join sashelp.us_data b
   on a.mapidname=b.statename;
quit;

/* full join examples */
proc sql;
   create table join_5 as
   select a.*, b.*
   from sashelp.gcstate a full join sashelp.us_data b
   on a.mapidname=b.statename;
quit;

proc sql;
   create table join_6 as
   select coalesce(a.mapidname,b.statename) as new_state_name, a.*, b.*
   from sashelp.gcstate a full join sashelp.us_data b
   on a.mapidname=b.statename;
quit;

/* coalesce function - additional example */
proc sql;
   create table coalesce_1 as
   select statename, 
          coalesce(reps_1910,reps_1920,reps_1930,reps_1950,reps_1960) as reps 
   from sashelp.us_data;
quit;
   
