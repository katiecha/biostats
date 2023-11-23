proc printto log='/home/u63543119/BIOS511/Logs/lab19_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 19
*
* Program name : lab19_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-11-6
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) Utilizing FIRST. and LAST. values for conditional execution
* 2) Using RETAIN statements
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

* create an pdf file that contains selected information below;
ods pdf file='/home/u63543119/BIOS511/Output/lab19_730460523.pdf';

/* ------------------------Question 1------------------------*/
/* Using a DATA Step, create a data set based on
sashelp.baseball. The final data set should contain only one observation for each
league-division combination. */
proc sort data=sashelp.baseball out=baseball_sorted;
	by league division;
run;

data baseball_totals;
	set baseball_sorted;
	by league division;
	retain cratbat_t crbb_t;
	
	if first.division then do;
		cratbat_t = 0;
		crbb_t = 0;
	end;
	
	cratbat_t = cratbat_t + cratbat;
	crbb_t = crbb_t + crbb;
	
	if last.division then do;
		output;
	end;
	
	label cratbat_t = 'Total Cratbat';
	label crbb_t = 'Total Crbb';
	keep league division cratbat_t crbb_t;
run;

/* ------------------------Question 2------------------------*/
/* Check your totals from #1. The values for #2a and #2b should be the same. */

* PROC PRINT;
title1 'PROC PRINT (data=baseball_totals)';
proc print data=baseball_totals label; * display labels;
run;

* PROC MEANS;
title1 'PROC MEANS (data=baseball_totals)';
proc means data=sashelp.baseball sum;
	class league division;
	var cratbat crbb;
    label cratbat = 'Sum Cratbat' crbb = 'Sum Crbb';
run;

/* ------------------------Question 3------------------------*/
/* Create a temporary version of the ae data set in the course folder.
a. Standardize the value of the start date. The value of the start date does not
always have a day, it might only contain a month and a year. In that situation,
the day of the month should be the first. */
data ae_edit;
	set classDat.ae;
	
	if length(aestdtc) = 7 then aestdtc = catx('-',aestdtc,'01');
	if length(aeendtc) = 7 then aeendtc = catx('-',aeendtc,'01');
	
	num_AESTDTC = input(AESTDTC, yymmdd10.);
	num_AEENDTC = input(AEENDTC, yymmdd10.);
	
	format num_AESTDTC num_AEENDTC date9.; * add fav format;
run;

/* ------------------------Question 4------------------------*/
/* Sort the data set created in #3 by the subject and numeric start date. */
proc sort data=ae_edit out=ae_edit_sort;
	by usubjid num_AESTDTC;
run;

proc sort data=classDat.dm out=dm_sort;
	by usubjid;
run;

/* ------------------------Question 5------------------------*/
/* The goal of this task is to identify the earliest adverse event for each subject. Merge the
sorted data set from #4 with the dm data set in the course folder. */
data merge_ae_dm;
	merge ae_edit_sort(in=ae_in) dm_sort;
	by usubjid;
	if ae_in and first.usubjid;
	
	num_rfxstdtc = input(rfxstdtc, yymmdd10.);
	days_to_first_adverse = num_AESTDTC - num_rfxstdtc;
	
	label days_to_first_adverse = 'Number of days to the first adverse event';
	drop num_rfxstdtc;
run;

/* ------------------------Question 6------------------------*/
/* Use PROC SGPLOT to generate histograms for the number of days to the first adverse
event in the data set created in #5. */
proc sort data=merge_ae_dm out=merge_ae_dm_sort;
	by arm;
run;

title1 'PROC SGPLOT (data=merge_ae_dm_sort)';
proc sgplot data=merge_ae_dm_sort;
	by arm;
	histogram days_to_first_adverse;
	density days_to_first_adverse / type=normal;
	density days_to_first_adverse / type=kernel;
	label arm = 'Arm';
	keylegend / location=inside position=topright;
run;

/* ------------------------CLOSING------------------------*/
ods pdf close;

proc printto; run;