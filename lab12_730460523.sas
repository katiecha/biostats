proc printto log='/home/u63543119/BIOS511/Logs/lab12_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 12
*
* Program name : lab12_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-10-09
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) Generating new data sets based on exiting data sets
* 2) Using numeric and character functions
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
ods pdf file='/home/u63543119/BIOS511/Output/lab12_730460523.pdf';

/* ------------------------Question 1------------------------*/
* Create a temporary version of the sashelp.us_data data set. Make the following changes;
data new_us_data;
	set sashelp.us_data;
	pop_per_change = round(((population_1970-population_1960)/population_1970)*100, 0.01);
	abs_difference = abs(pop_per_change-change_1970);
	total_num_seat_changes = sum(seat_change_1910, seat_change_1920, seat_change_1930, seat_change_1940, seat_change_1950, seat_change_1960, seat_change_1970);
	output;
run;

/* ------------------------Question 2------------------------*/
* Sort the data set created in #1 by descending percent change;
proc sort data=new_us_data;
	by descending pop_per_change;
run;

/* ------------------------Question 3------------------------*/
* Print the data set created in #2;
title1 'Summary Data including name, division, population 1960 and 1970, change_1970, and 3 created variables (data=new_us_data)';
proc print data=new_us_data (obs=15) noobs;
	var statename division population_1960 population_1970 change_1970 pop_per_change abs_difference total_num_seat_changes;
run;

/* ------------------------Question 4------------------------*/
* Create a temporary version of the budget data set in the course folder. Make the following changes;
data new_budget;
	set classDat.budget;
	average_budget = mean(yr2016, yr2017, yr2018, yr2019, yr2020);
	min_budget = min(yr2016, yr2017, yr2018, yr2019, yr2020);
	max_budget = max(yr2016, yr2017, yr2018, yr2019, yr2020);
	multiplier = 1.12;
	output;
run;

/* ------------------------Question 5------------------------*/
* Using PROC MEANS, summarize the data created in step #4;
title1 'Summary Statistics including average, minimum, maximum, and multiplier (data=new_budget)';
ods noproctitle; * supress the printing of the procedure name;
proc means data=new_budget mean min max nonobs;
	class department;
	var average_budget min_budget max_budget multiplier;	
run;

/* ------------------------CLOSING------------------------*/
ods pdf close;

proc printto; run;