proc printto log='/home/u63543119/BIOS511/Logs/lab15_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 15
*
* Program name : lab15_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-10-23
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) Conditionally executing statements and applying values
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
ods pdf file='/home/u63543119/BIOS511/Output/lab15_730460523.pdf';

/* ------------------------Question 1------------------------*/
* Create a temporary data set based on the depression data set in the course folder;
data depression1;
	set classDat.depression;
	length category $10;
	* setting category var based on case and health var;
	if case = 0 then do;
		if 1 <= health <= 2 then category = "Good";
		else if health = 3 then category = "Acceptable";
		else category = "Unknown";
	end;
	else if case = 1 then do;
		if 1 <= health <= 3 then category = "Bad";
		else if health = 4 then category = "Very Bad";
		else category = "Unknown";
	end;
	label category = 'Case and Health Results';
run;

/* ------------------------Question 2------------------------*/
* Use a PROC FREQ to check your results for the variable created in #1a;
* You should not have any Unknown values;
title1 'PROC FREQ (data=depression1)';
title2 'Checking Results of Newly Created Case and Health Results Variable';
proc freq data = depression1;
	tables category;
run;

/* ------------------------Question 3------------------------*/
* Create the exact same data set as you did in #1, with a new name;
* Use the other conditioning method;
data depression2;
	set classDat.depression;
	length category $10;
	* setting category var based on case and health var;
	select;
		when(case = 0 and health = 1) category = "Good";
		when(case = 0 and health = 2) category = "Good";
		when(case = 0 and health = 3) category = "Acceptable";
		when(case = 0 and health = .) category = "Unknown";
		when(case = 1 and health = 1) category = "Bad";
		when(case = 1 and health = 2) category = "Bad";
		when(case = 1 and health = 3) category = "Bad";
		when(case = 1 and health = 4) category = "Very Bad";
		when(case = 1 and health = .) category = "Unknown";
		otherwise putlog 'NOTE: Missing value for Health' category = "Unknown";
	end;
	label category = 'Case and Health Results';
run;

/* ------------------------Question 4------------------------*/
* Use the following PROC COMPARE step to check that the data sets have all of the same values;
title1 'PROC COMPARE (data=depression1, depression2)';
title2 'Comparing Results of Data Sets Created Using If and Select';
proc compare base=depression1 compare=depression2;
run;

/* ------------------------Question 5------------------------*/
* Create a temporary version of the employee_donations data set in the course folder;
data employee_donations1;
	set classDat.employee_donations;
	total_donations_year_sum = sum(Qtr1, Qtr2, Qtr3, Qtr4);
	* fixing missing values for donation $;
	if Qtr1 = . then Qtr1 = 0;
	if Qtr2 = . then Qtr2 = 0;
	if Qtr3 = . then Qtr3 = 0;
	if Qtr4 = . then Qtr4 = 0;
	* summing / adding in two ways;
	total_donations_year_add = Qtr1 + Qtr2 + Qtr3 + Qtr4;
	difference = total_donations_year_sum - total_donations_year_add;
run;

/* ------------------------Question 6------------------------*/
* Use PROC MEANS to verify that all values of the difference variable from #5c are zero;
* Request the MIN, MAX, MEAN, SUM, and NMISS statistics;
title1 'PROC MEANS (data=employee_donations1)';
title2 'Checking that the Difference Variable = 0';
proc means data = employee_donations1 min max mean sum nmiss;
	var difference;
run;

/* ------------------------Question 7------------------------*/
* Create a temporary version of the learn_modalities data set in the course folder;
data learn_modalities1;
	set classDat.learn_modalities;
	* selecting only the date (not the time);
	week_date = datepart(week);
	* subsetting to dates before Jan 1, 2021;
	if week_date < "01JAN2021"d;
run;

/* ------------------------Question 8------------------------*/
* Run a PROC FREQ on the data set created in #7;
title1 'PROC FREQ (data=learn_modalities1)';
title2 'Checking that the Difference Variable = 0';
proc freq data = learn_modalities1;
	tables learning_modality;
run;

/* ------------------------CLOSING------------------------*/
ods pdf close;

proc printto; run;