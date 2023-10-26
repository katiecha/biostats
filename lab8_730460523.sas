proc printto log='/home/u63543119/BIOS511/Logs/lab8_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 8
*
* Program name : lab8_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-09-20
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) Using ODS SELECT and ODS EXCLUDE statements to limit printed results
* 2) Creating data sets with the ODS OUTPUT statement
* 3) Applying style changes through the STYLE=option
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

/* ------------------------Question 1.a------------------------*/
* create an rtf files that contains...;
ods rtf file='/home/u63543119/BIOS511/Output/lab8_730460523.rtf';

* create temp data set from living_data;
data livingData;
	set classDat.living_data;
run;

* ods trace on; *(used to find object name in the past);
ods noproctitle; * supress printing of the proc title;
ods select FishersExact; * used to select only Fisher's test;
* run proc freq on livingData;
title1 'Fishers Exact Test for the combination of treatment and status (data=living_data)';
proc freq data=livingData;
	tables treatment*status / fisher;
run;
* ods trace off; *(used to find object name in the past);

/* ------------------------Question 1.b------------------------*/
* create temp data set from us_data;
data usData;
	set sashelp.us_data;
run;

proc sort data=usData;
	by region;
run;

ods rtf startpage=bygroup;

* run a proc print on (sorted) usData;
title1 'US Data sorted by region (data=us_data)';
title2 '(including division, state name, and ranks from 1990, 2000, 2010)';
proc print data=usData;
	by region;
	var division statename rank_1990 rank_2000;
	var rank_2010 / style(data)={background=lightblue};
run;

ods rtf close;

/* ------------------------Question 2.a------------------------*/
* create a pdf file that contains;
ods pdf file='/home/u63543119/BIOS511/Output/lab8_730460523.pdf' style=sapphire; * add style template to entire document

/* ------------------------Question 2.b------------------------*/
* create temp data set from drivers;
data drivers;
	set classDat.drivers;
run;

* ods trace on; *(used to find object name in the past);
ods exclude all; * suppress printing of the results;
ods output TestsForLocation=locationTests;
* run a proc univariate on drivers;
title1 'Proc Univariate with drivers as analysis variable (data=drivers)';
proc univariate data=drivers;
	var drivers;
run;
* ods trace off; *(used to find object name in the past);

/* ------------------------Question 2.c------------------------*/
ods select all; * turn printing of output back on;

/* ------------------------Question 2.d------------------------*/
title1 'Tests for Location (data=locationTests)';
proc print data=locationTests;
run;

/* ------------------------Question 2.e------------------------*/
* create temp data set from drivers;
data shoes;
	set sashelp.shoes;
run;

* ods trace on; *(used to find object name in the past);
* run a proc means on shoes;
title1 'Proc Means with stores as analysis variable (data=shoes)';
ods output Summary=summary_ods;
proc means data=shoes;
	var stores;
	output out=summary_output;
run;
* ods trace off; *(used to find object name in the past);

/* ------------------------Question 2.f------------------------*/
* run a proc print on summary_ods;
title1 'Summary Statistics from ods output (data=shoes)';
proc print data=summary_ods;
run;

* run a proc print on shoes;
title1 'Summary Statistics from output out (data=shoes)';
proc print data=summary_ods;
run;

ods pdf close;

proc printto; run;