proc printto log='/home/u63543119/BIOS511/Logs/lab16_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 16
*
* Program name : lab16_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-10-25
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) Applying SAS-supplied formats
* 2) Creating user-defined formats
* 3) Creating new variables through the use of formats
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
ods pdf file='/home/u63543119/BIOS511/Output/lab16_730460523.pdf';

/* ------------------------Question 1------------------------*/
* Use PROC FORMAT to create a format for a numeric variable;
proc format;
	value yes_no_format
		0 = 'No'
		1 = 'Yes';
run;

/* ------------------------Question 2------------------------*/
* Use PROC FORMAT to create a format for a numeric variable;
title1 'PROC FORMAT';
title2 'Numeric Formats for Marital Status';
proc format fmtlib;
	value marital_format
		1 = 'Single'
		2 = 'Married'
		3 = 'Separated'
		4 = 'Divorced'
		5 = 'Widowed';
run;

/* ------------------------Question 3------------------------*/
* Create a stacked vertical bar graph using SGPLOT and the course.depression data set;
title1 'PROC SGPLOT (data=classDat.depression)';
title2 'Stacked Vertical Bar Graph';
proc sgplot data=classDat.depression;
	vbar marital / group=acuteillness seglabel name="vbar_chart";
	format marital marital_format.
		acuteillness yes_no_format.;
	keylegend "vbar_chart" / position=topright location=inside across=1;		
run;

/* ------------------------Question 4------------------------*/
* Calculate the difference in days between multiple dates in the dm data set;
data dm_edited;
	set classDat.dm;
	num_informed_consent = input(RFICDTC, yymmdd10.);
	num_first_study_treatment = input(RFXSTDTC, yymmdd10.);
	num_last_study_treatment = input(RFXENDTC, yymmdd10.);
	consent_treatment_diff = num_first_study_treatment - num_informed_consent;
	first_last_diff = num_last_study_treatment - num_first_study_treatment;
run;

/* ------------------------Question 5------------------------*/
* Run a PROC MEANS on the data set created in #4;
title1 'PROC MEANS (data=dm_edited)';
title2 'Classifying Data by Sex and Race';
proc means data=dm_edited;
	class sex race;
	var consent_treatment_diff first_last_diff;
run;

/* ------------------------Question 6------------------------*/
* Create a temporary version of the budget data set in the course folder;
data budget_edited;
	set classDat.budget;
	length char_per_change $15;
	per_change = (yr2020-yr2019)/yr2019;
	char_per_change = put(per_change, percent8.2);
	label char_per_change = "Character Percent Change Variable";
run;

/* ------------------------Question 7------------------------*/
* Print the first ten observations from the data set created in #6;
title1 'PROC PRINT (data=budget_edited)';
title2 'Printing First 10 Obs';
proc print data=budget_edited (obs=10) label;
	var department char_per_change;
run;

/* ------------------------CLOSING------------------------*/
ods pdf close;

proc printto; run;