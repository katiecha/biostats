proc printto log='/home/u63543119/BIOS511/Logs/lab13_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 13
*
* Program name : lab13_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-10-11
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) Using DATA step statements
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
ods pdf file='/home/u63543119/BIOS511/Output/lab13_730460523.pdf';

/* ------------------------Question 1------------------------*/
* Create a temporary version of the lb data set in the course folder;
data new_lb;
	set classDat.lb;
	where visit = 'Week 32';
	lbcat = propcase(lbcat);
	length lbcat_test $100;
	lbcat_test = catx(': ', lbcat, lbtest);
	keep usubjid visit lbstresn lbcat_test;
run;

/* ------------------------Question 2------------------------*/
* Run a PROC CONTENTS step on the data set created in #1;
ods exclude enginehost; * exclude engine/host info;
title1 'Summary data for updated lb data set';
title2 'PROC CONTENTS (data=new_lb)';
proc contents data=new_lb;
run;
ods exclude none;

/* ------------------------Question 3------------------------*/
* Create a temporary version of the sashelp.snacks data set;
data new_snacks;
	set sashelp.snacks;
	if product = 'Cheese puffs';
	salePrice = (0.95 * price);
	label salePrice = '95 % of Price Variable';
	drop price;
run;

/* ------------------------Question 4------------------------*/
* Run a PROC CONTENTS step on the data set created in #3;
ods exclude enginehost; * exclude engine/host info;
title1 'Summary data for updated snacks data set';
title2 'PROC CONTENTS (data=new_snacks)';
proc contents data=new_snacks;
run;
ods exclude none;

/* ------------------------Question 5------------------------*/
* Create a temporary version of the employee_donations data set in the course data set;
data new_employee_donations;
	set classDat.employee_donations;
	yearTotal = sum(Qtr1, Qtr2, Qtr3, Qtr4);
	label yearTotal = 'Yearly Total Donation Amount';
run;

/* ------------------------Question 6------------------------*/
* Using PROC MEANS, summarize the data created in step #5;
ods noproctitle; * supress printing of proc name;

title1 'Summary statistics for updated employee donations data set';
title2 'PROC MEANS (data=new_employee_donations)';
proc means data=new_employee_donations n mean nonobs;
	class paid_by;
run;

/* ------------------------CLOSING------------------------*/
ods pdf close;

proc printto; run;