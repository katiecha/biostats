proc printto log='/home/u63543119/BIOS511/Logs/lab23_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 23
*
* Program name : lab23_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-11-20
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) Creating macro variables and using them in code
* 
* Revision History :
*
* Note: Standard header taken from :
* https://www.phusewiki.org/wiki/index.php?title=Program_Header
****************************************************************************/

%put %upcase(no)TE: Program being run by 730460523;
options nofullstimer;

/* ------------------------LIBNAME------------------------*/
* assigns libref for class data;
LIBNAME classDat "/home/u63543119/my_shared_file_links/u49231441/Data" access=readonly;

* assigns libref for my data;
LIBNAME myDat "/home/u63543119/BIOS511/Data";

/* ------------------------Question 1------------------------*/
/* Create a macro variable to hold your PID. */
%let macropid = 730460523;

/* ------------------------Question 2------------------------*/
/* Create a macro variable that holds the path where you store your output files. */
%let macropath = /home/u63543119/BIOS511/Output/;

/* ------------------------Question 3------------------------*/
/* Use the macro variables created in #1 and #2 in your ODS PDF statement that creates
your output file. */
ods pdf file = "&macropath.lab23_&macropid..pdf";

/* ------------------------Question 4------------------------*/
/* Create a macro variable containing the text: BIOS 511 LAB 23 Macro Variables. Use this
macro variable as the first title in all of the generated output. */
%let macrotitle = BIOS 511 LAB 23 Macro Variables;

/* ------------------------Question 5------------------------*/
/* The goal of this task is to put the student counts for each learning modality into macro
variables. */
title1 "&macrotitle.";
title2 'PROC MEANS (data=classDat.learn_modalities)';
proc means data=classDat.learn_modalities noprint;
	class learning_modality;
	var student_count;
	output out=modsum sum=sumamt;
run;

data _null_;
   set modsum;
   if learning_modality = 'In Person' then call symputx("count_in_person", sumamt);
   else if learning_modality = 'In Person' then call symputx("count_in_person", sumamt);
   else if learning_modality = 'Hybrid' then call symputx("count_hybrid", sumamt);
   else if learning_modality = 'Remote' then call symputx("count_remote", sumamt);
   if learning_modality = ' ' then call symputx("tots", sumamt);
run;

/* ------------------------Question 6------------------------*/
/* Write the values of the macro variables created in #5b to the log. */
%put In Person=&count_in_person;
%put Hybrid=&count_hybrid; 
%put Remote=&count_remote; 
%put Tots=&tots;

/* ------------------------Question 7------------------------*/
/* Generate a horizontal bar chart of the frequency of the learning modality variable in the
learn_modality data set. */
title1 "&macrotitle.";
title2 "Overall Student Total = &tots.";

proc sgplot data=classDat.learn_modalities;
    hbar learning_modality / stat=freq datalabel;
    xaxis label = 'Frequency';
    yaxis label = 'Learning Modality';
run;

/* ------------------------Question 8------------------------*/
/* Programmatically (meaning you can’t use %LET) create a macro variable containing a list
of the names of the character variables from the ae data set in the course folder. The
variables should be listed in the order they appear in the data set. Use the code below
as a template. */

* get variable info;
proc contents data=classDat.ae out=ae_contents(where=(type=2)) noprint;
run;
* sort variable info;
proc sort data=ae_contents; 
	by varnum;
run;
data _null_;
	set ae_contents end=last;
	length varlist $500;
	retain varlist;
		varlist = catx(' ', varlist, name); * concatenate names into macroname;
	if last then call symputx('macrovarlist', varlist);
run;

* %put &=macrovarlist;

/* ------------------------Question 9------------------------*/
/* Using the macro variable created in #9, an ARRAY statement, and a DO loop, change the
values of the character variables in the ae data set to be all lowercase. */
data ae_lower;
	set classDat.ae;
	array characters {*} &macrovarlist.;
	do i = 1 to dim(characters);
		characters{i} = lowcase(characters{i});
	end;
	drop i;
run;

/* ------------------------Question 10------------------------*/
/* Print five observations from the data set created in #9. */
title1 macrotitle;
proc print data=ae_lower (obs=5) noobs;
	var &macrovarlist.;
run;

/* ------------------------Question 11------------------------*/
/* Create a series of macro variables, vstest1 – vstestN. Each macro variable will hold the
code name of one of the vital sign tests from the vs data set in the course folder.
Create a second series of macro variables containing the corresponding full name of the
test, vsname1 – vsnameN. Use the code below as a template. */
proc sort data=classDat.vs (keep=vstestcd vstest) out=vs_sort nodupkey;
	by vstestcd vstest;
run;

data _null_;
	set vs_sort;
	call symputx(cats('vstest', _n_), vstestcd);
	call symputx(cats('vsname', _n_), vstest);
run;

/* ------------------------Question 12------------------------*/
/* Create a report, using PROC REPORT, based on the vs data set. */
title1 "&macrotitle.";
title2 "Value = &vsname1.";
proc report data=classDat.vs;
	where vstestcd = "&vstest1."; * Subset the table to show only records for the tests that match vstest1;
	
	* Use the report-items: visit number, visit name, and result;
	columns visitnum visit vsstresn;
	
	* ordered and consolidated by the visit number;
    define visitnum / group order=internal noprint;
    
    * ordered and consolidated by the visit name;
    define visit / group order=internal;
    
    * request the mean statistic for the vital sign result;
    define vsstresn / mean 'Mean Stat';
run;


/* ------------------------Question 13------------------------*/
/* Repeat #12 for each of the remaining vstest values. */
title1 "&macrotitle.";
title2 "Value = &vsname2.";
proc report data=classDat.vs;
	where vstestcd = "&vstest2.";
	columns visitnum visit vsstresn;
    define visitnum / group order=internal noprint;
    define visit / group order=internal;
    define vsstresn / mean 'Mean Stat';
run;

title1 "&macrotitle.";
title2 "Value = &vsname3.";
proc report data=classDat.vs;
	where vstestcd = "&vstest3.";
	columns visitnum visit vsstresn;
    define visitnum / group order=internal noprint;
    define visit / group order=internal;
    define vsstresn / mean 'Mean Stat';
run;

title1 "&macrotitle.";
title2 "Value = &vsname4.";
proc report data=classDat.vs;
	where vstestcd = "&vstest4.";
	columns visitnum visit vsstresn;
    define visitnum / group order=internal noprint;
    define visit / group order=internal;
    define vsstresn / mean 'Mean Stat';
run;

title1 "&macrotitle.";
title2 "Value = &vsname5.";
proc report data=classDat.vs;
	where vstestcd = "&vstest5.";
	columns visitnum visit vsstresn;
    define visitnum / group order=internal noprint;
    define visit / group order=internal;
    define vsstresn / mean 'Mean Stat';
run;

/* ------------------------CLOSING------------------------*/
ods pdf close;

proc printto; run;