proc printto log='/home/u63543119/BIOS511/Logs/lab20_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 20
*
* Program name : lab20_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-11-8
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) ????????????????????????????
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
ods pdf file='/home/u63543119/BIOS511/Output/lab20_730460523.pdf';

/* ------------------------Question 1------------------------*/
/* Using PROC TRANSPOSE, change the budget data set in the course data folder. */
proc sort data=classDat.budget out=budget_sort;
	by region;
run;

proc transpose data=budget_sort out=budget_transpose(rename=(_name_=year));
	by region;
	id department;
	var yr:;
run;

/* ------------------------Question 2------------------------*/
/* Print the region 3 observations of data set created in #1. */
title1 'PROC PRINT (data=budget_transpose)';
title2 'Region 3 Observations';
proc print data=budget_transpose;
	where region = 3;
run;

/* ------------------------Question 3------------------------*/
/* Using PROC TRANSPOSE, restructure the sashelp.stocks data set. */
proc sort data=sashelp.stocks out=stocks_sorted;
	by date;
run;

proc transpose data=stocks_sorted out=stocks_transpose(drop=_name_);
	by date;
	id stock;
	var close;
run;

/* ------------------------Question 4------------------------*/
/* Create a series graph using PROC SGPLOT and the data set created in #3 */
title1 'PROC SGPLOT (data=stocks_transpose)';
title2 'Series Graph';
proc sgplot data=stocks_transpose;
	series x=date y=Microsoft;
run;

/* ------------------------Question 5------------------------*/
/* Using a DATA step, restructure the budget data set in the course folder with one
record for each region-quarter-year combination. */
data budget_restructure;
	set classDat.budget;
	where department = 'A'; * subset to department A values;
	
	array years{5} yr:;
	
	do i = 1 to dim(years);
		budget = years{i}; * variable to hold budget values;
		format budget dollar10.;

		year = 2015 + i; * variable to hold year value;
		output;
	end;
	
	keep region qtr year budget;
	drop i yr2016-yr2020 department;
	label region = 'Region' qtr = 'Quarter' year = 'Year' budget = 'Budget'; 
run;


/* ------------------------Question 6------------------------*/
/* Run a PROC CONTENTS on the data set created in #5. */
ods select variables;
title1 'PROC CONTENTS (data=budget_restructure)';
title2 'ONly Variables Table';
proc contents data=budget_restructure;
run;

/* ------------------------CLOSING------------------------*/
ods pdf close;

proc printto; run;