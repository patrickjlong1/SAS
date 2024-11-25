/* https://www.sas.com/content/dam/SAS/documents/technical/certification/content-guide/programming-fundamentals.pdf */
/* SAS 9.4 Programming Fundamentals Exam */
/* 1. Fundamental SAS Concepts */
/* - Recall general rules of DATA and PROC steps. */
/* 1. Data steps are used to read, manipulate or create data in SAS */
/* 2. PROC Steps are used to perform analysis or reporting */
data cars_subset;
	set sashelp.cars;
	where MPG_City > 25;
run;

proc means data=cars_subset mean;
	var msrp;
run;

/* - Recognize general rules of SAS statements including global statements. */
/* 1. Statement is SAS end with a semicolon (;) */
/* 2. Global Statements are valid anywhere in a SAS program. e.g. OPTIONS, TITLE and LIBNAME */
options nodate nonumber;

proc print data=work.cars_subset;
	title "My cars subset.";
run;

/* - Interpret the SAS log. */
/* Example of common error: */
data mistake set sashelp.cars;
run;

/* - Distinguish between syntax and logic errors. */
/* Syntax Error - Violation of a SAS rule (e.g. missing ;)
Logic Error - Programs without syntax error but gets the wrong results */
/* • Recall SAS syntax rules. */
/*- case insensistive for keywords.
- Data names must start with a letter or an underscore */
data _123;
	set work.cars_subset;
run;

/* • Recognize different types of syntax errors and be able to resolve common problems. */
/* • Recall use of the PUTLOG statement to troubleshoot logic errors. */
data putlog_example;
	set sashelp.cars;

	if MPG_City < 12 then
		do;
			putlog "Low MPG Vehicle detected" model=make=MPG_City=;
		end;
run;

/* 2. Explore SAS Data Sets */
/* Recall naming conventions used for SAS data sets and variables. */
/*  Dataset and variables name must: 1. Start with an underscore or a letter,
2. There's a maximum length of 32 characters, and 3. only contain letters, numbers or underscores */
data invalid_data;
	set sashelp.class;
	2^age=age**2;
run;

/* Recognize variable types (character and numeric). */
proc contents data=sashelp.class;
run;

/* Explain how to create and manipulate SAS date values. */
/* • Explain how SAS stores date values. */
/* - SAS stores dates as the number days since Jan 1 1960, they be displayed in varous formats*/
/* • Recall how to use SAS date formats to specify how the values are displayed. */
data date_example;
	Name='Bob';
	birth_date='15JAN2005'd;

	/*date literal*/
	current_date=today();

	/*todays date*/
	day_old=current_date - birth_date;
	format birth_date current_date mmmddyy8.;
run;

/* Recognize how SAS stores missing data. */
/* 2 data types Numeric(.) and Character (' ') */
data missing_example;
	set sashelp.class;

	if age < 13 then
		height=.;

	/*assigning missing value - numeric */
	if age > 15 then
		name=" ";

	/*assigning missing value - character*/
run;

/* Use the LIBNAME statement to read SAS data sets. */
/* libname my_lib "C:\users\me\path\to\folder"; */
libname my_lib "/home/u49221476";

/*8 character limit for librefs*/
data my_lib.my_class;
	set sashelp.class;
run;

libname read_lib "/home/u49221476" access=readonly;

data my_class;
	set read_lib.my_class;
run;

/* Use PROC CONTENTS to view the descriptor portion of a data set. */
proc contents data=sashelp.cars;
run;

/* Recall how to use Data Set options: DROP=, KEEP=, RENAME=, OBS=. */
data filtered_class;
	set sashelp.class(keep=name age rename=(age=age_of_student) obs=2);
run;

/*3. Using the DATA Step to Access SAS Data Sets */
/* Use the DATA statement to create one or multiple data sets. */
data young_students middle_students old_students;
	/*multiple datasets*/
	set sashelp.class;

	if age <=13 then
		output young_students;
	else if age=14 then
		output middle_students;
	else
		output old_students;
run;

/* Use the SET statement to read a data set. */
data my_cars;
	set sashelp.cars;
run;

/* Explain how to combine data sets. */
/* • Use MERGE and BY statements to combine multiple data sets horizontally. */
data class_m;
	set sashelp.class;
	where sex='M';
	keep name age sex;
run;

data class_f;
	set sashelp.class;
	where sex='F';
	keep name age sex;
run;

data combined_class;
	merge class_m class_f;
	by name;
run;

/* • Use the IN= option on the MERGE statement to control processing. */
data young_students;
	set sashelp.class;
	where age <=13;
run;

data old_students;
	set sashelp.class;
	where age >=13;
run;

data combined_class;
	merge young_students(in=y) old_students(in=o);
	by name;

	if y and o;
run;

/* • Use the SET statement to combine multiple data sets vertically. */
data set_stacked;
	set old_students young_students;
run;

/* Explain the compilation and execution process of the DATA step. */
/* • Describe how the Program Data Vector PDV is created. */
/* - PDV is a logical area where SAS builds and processes data one observation at a time */
/* • Explain how the LENGTH statement affects the default behavior of the PDV. */
data pdv_example;
	set sashelp.class;
	length inital_first $1;
	inital_first=substr(name, 1, 1);
run;

/* • Describe the process of the data step iteration. */
/* - Each datastep iteration processes one observation at a time */
/* Subset observations and variables. */
/* • Use the WHERE statement to subset observations during input. */
data old_students;
	set sashelp.class;
	where age >=13;
run;

/* • Use the IF statement to subset observations during processing. */
data young_students middle_students old_students;
	/*multiple datasets*/
	set sashelp.class;

	if age <=13 then
		output young_students;
	else if age=14 then
		output middle_students;
	else
		output old_students;
run;

/* • Use DROP/KEEP statements to subset variables at output. */
data cars_few_variables;
	set sashelp.cars;
	keep make model mpg_highway;

	/* drop model; */
run;

/* • Use DROP=/KEEP= options to subset variables at input and output. */
data cars_few_variables(keep=make model mpg_highway);
	set sashelp.cars(drop=mpg_city);
run;

/* 4. Using the DATA Step to Manipulate Data */
/* Create or update variables. */
/* • Use the assignment statement to create character and numeric variables. */
data create_variables;
	set sashelp.class;
	BMI=weight / (height**2)*703;
	full_name=name || " Smith-Jones";
run;

/* • Recall how to assign a date constant to a variable. */
data date_constant_example;
	set create_variables;
	BMI_assesment_date=today();

	/*'15JAN2023'd */
	format BMI_assesment_date date9.;
run;

/* Recognize SAS Functions. */
/* • Use Character Functions: UPCASE, PROPCASE, SUBSTR, SCAN, FIND, LENGTH, CATX. */
data character_functions;
	set sashelp.class;
	name_upper=upcase(name);
	name_proper=propcase(name_upper);
	initial_1=substr(name, 1, 1);
	full_name=catx(" ", name, "Smith-Jones");
	first_name=scan(full_name, 1, " ");
	name_length=length(full_name);
run;

/* • Use Date Functions: MONTH, DAY, YEAR, TODAY, MDY. */
data stocks;
	set sashelp.stocks;
	month=month(date);
	day=day(date);
	year=year(date);
	current_date=today();
	date_new=mdy(month, '01', year);
	format date_new current_date date9.;
run;

/* • Use Truncation Functions: ROUND, INT. */
data stocks;
	set sashelp.stocks;
	rounded_open=round(open, 10);
	integer_open=int(open);
run;

/* • Use Descriptive Stats Functions: MEAN, SUM. */
data stats_functions;
	set sashelp.stocks;
	average=mean(open, close);
	total=sum(open, close);
run;

/* Perform conditional processing. */
/* • Use the IF-THEN and ELSE statements. */
data conditional;
	set sashelp.stocks;

	if int(close-open) >=0 then
		group='gain';
	else
		group='loss';
run;

/* • Use IF-THEN DO and ELSE DO statements. */
data conditional_do;
	set sashelp.class;

	if age < 13 then
		do;
			group='child';
			discount_code='KID12UNDER';
		end;
	else
		do;
			group='teen';
			discount_code='TEENDISC';
		end;
run;

/* • Use the LENGTH statement for assigning byte size of character variables. */
data length_example;
    length initial $1;
    set sashelp.class;
    initial = substr(name,1,1);
run;
/* Control the output of observations. */
/* • Use the OUTPUT statement to output to a specific data set. */
data ibm intel;
    set sashelp.stocks;
    if upcase(stock) = 'IBM' then output ibm;
    else if upcase(stock) = 'INTEL' then output intel;
run; 
/* • Use the OUTPUT statement to control output timing. */
data output_timing;
    set sashelp.stocks;
    if upcase(stock) = 'IBM' then output;
run;
/* Create an accumulating variable.  */
/* • Use the SUM statement. */
data accumulating;
set sashelp.class;
retain total_weight 0; /*keep a running total */
total_weight + weight;
run;

/* • Use BY group processing with FIRST. and LAST to accumulate in groups. */
proc sort data=sashelp.class
          out=sorted_class;
    by sex;
run;

data group_accumulation;
    set sorted_class;
    by sex;
    retain total_age 0;
    if first.sex then total_age=0;
    total_age + age;
    if last.sex then output;
    keep sex total_age;
run; 
   

/* Explain the function of iterative DO loops. */
data do_loop_example;
    do age = 1 to 10;
       weight = (age * 5) + 25;
       output;
    end;
run;

/* Assign permanent attributes. */
/* • Use the FORMAT statement to change the display of the variable value. */
data format_example;
   set sashelp.class;
   height_2 = height;
   format height_2 5.2;
run;
/* • Use the LABEL statement to change the display of the variable name. */
data label_example;
   set sashelp.class;
   label height = 'The height of the Student';
run;

/* 5. Generate Reports Using PROC Steps */
/* Use PROC PRINT to generate a detail report. */
/* • Use the LABEL option and NOOBS options to enhance the report. */
proc print data=sashelp.baseball noobs label;
run;

/* • Use the VAR statement to control the display of variables. */
proc print data=sashelp.baseball label;
var name team natbat;
run;

/* Use PROC MEANS to generate a summary report. */
/* • Use the MAXDEC= option to control the display of decimal places. */
proc means data=sashelp.class maxdec=3;
var height weight;
run;

/* • Use VAR and CLASS statements to control the structure of the report. */
proc means data=sashelp.class maxdec=3;
class sex;
var height weight;
run;

/* Use PROC FREQ to generate a frequency report. */
/* • Use the ORDER=option to control the order of the rows of the report. */
proc freq data=sashelp.class order=freq;
tables age;
run;
/* • Use the TABLES statement for one-way and two-way tables. */
proc freq data=sashelp.class order=freq; /*one-way*/
tables age;
run;

proc freq data=sashelp.class order=freq; /*two-way*/
tables sex*age;
run;
/* • Use the NOCUM and NOPERCENT options in a one-way table. */
proc freq data=sashelp.class order=freq; 
tables age / nocum nopercent;
run;

/* • Use the CROSSLIST option to control the layout of two-way tables. */
proc freq data=sashelp.class order=freq; 
tables sex*age / crosslist;
run;

/* Identify methods to enhance reports. */
/* • Use TITLE statement. */
/* • Use FOOTNOTE statement. */
title 'Displaying top 5 Rows in SASHELP Baseball Dataset';
footnote 'Finished displaying the top 5 Rows in SASHELP Baseball Dataset';

proc print data=sashelp.baseball(obs=5) label;
var name team natbat;
run;

/* • Use FORMAT statement for temporary attributes. */
proc print data=sashelp.class(obs=10);
format height 5.2 weight 5.1;
run;

/* • Use the LABEL statement for temporary attributes. */
proc print data=sashelp.class(obs=10) label;
label height = "Student Heights";
var name height;
run;
/* • Use the WHERE statement for subsetting observations. */
proc print data=sashelp.baseball;
var name team natbat nhome;
where nhome > 30;
run;

/* 6. Use Utility Procedures */
/* Use PROC SORT to sort a report based on values of a variable. */
/* • Use the OUT= option to create an output data set that contains the data in sorted order. */
/* • Use the BY statement to specify the variable(s) whose values are used to sort the data. */
proc sort data=sashelp.baseball(keep=name team natbat nhome) out=my_baseball;
by nhome;
run;

/* • Use the DESCENDING option with the BY statement to sort options in descending order. */
proc sort data=sashelp.baseball(keep=name team natbat nhome) out=my_baseball_desc;
by descending nhome;
run;

/* Use PROC FORMAT to define custom formats. */
/* • Use the VALUE statement to display one or more values. */
proc format;
    value $gender_fmt
    	'M' = 'Male'
    	'F' = 'Female';
    value age_fmt
    	low-12 = 'Kid'
    	13-high = 'Teen';
run;

data formatted_class;
	set sashelp.class;
	format sex $gender_fmt. age age_fmt.;
run;

/* • Use the keyword OTHER to label missing values. */

proc format;
	value height_fmt
		. = 'Missing'
		50-<60='Short'
		60-<70='Medium'
		70-high='Tall'
		other='Unknown';
run;

data height_labelled;
set sashelp.class;
if mod(_N_,5) = 0 then Height = 10;
format height height_fmt.;
run;

/* 7. Import and Export non-SAS files */
/* Use a procedure to transfer a CSV file. */

/* • Use the PROC EXPORT to export to a CSV file. */
proc export data=sashelp.baseball
  outfile='/home/u49221476/baseball.csv'
  dbms=csv
  replace;
run;

/* • Use PROC IMPORT to import a CSV file. */
proc import datafile='/home/u49221476/baseball.csv'
  out=my_imported_csv_data
  dbms=csv
  replace;
  getnames=yes;
run;

/* used for demontration only */
proc export data=sashelp.baseball
  outfile='/home/u49221476/baseball.xlsx'
  dbms=xlsx
  replace;
run;
/* Use the LIBNAME statement to import/export an Excel file with XLSX engine. */
libname myxlsx xlsx '/home/u49221476/baseball.xlsx';

data myxlsx.class; /*writing out a worksheet to the .xlsx file in the libname statement*/
set sashelp.class;
run;

libname myxlsx clear; /* clears the libname if you want to */
/* Use ODS to direct reports to external files. */
/* • Use the destinations of PDF, RTF, EXCEL. */
ods pdf file="/home/u49221476/baseball.pdf";

proc print data=sashelp.baseball(keep=name team natbat nhome obs=5) noobs;
title "Baseball Stats Report";
run;

ods pdf close;

ods rtf file="/home/u49221476/baseball.rtf";

proc print data=sashelp.baseball(keep=name team natbat nhome obs=5) noobs;
title "Baseball Stats Report";
run;

ods rtf close;

/* • Use the options of FILE= and STYLE=. */

ods excel file="/home/u49221476/baseball_new_new.xlsx" style=plateau;

proc print data=sashelp.baseball(keep=name team natbat nhome obs=5) noobs;
title "Baseball Stats Report";
run;

ods excel close;