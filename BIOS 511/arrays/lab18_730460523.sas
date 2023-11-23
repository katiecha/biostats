proc printto log='/home/u63543119/BIOS511/Logs/lab18_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 18
*
* Program name : lab18_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-11-1
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) Using arrays to create new variables or alter values of existing variables
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
ods pdf file='/home/u63543119/BIOS511/Output/lab18_730460523.pdf';

/* ------------------------Question 1------------------------*/
* Create a new temporary data set based on the prices data set in the course folder;
data prices_profit;
	set classDat.prices;
	
	array price_arr{15} price1-price15;
	array profit_arr{15} profit1-profit15;
	
	do i=1 to 15;
		profit_arr{i} = price_arr{i} - discount;
	end;
	
	format profit1-profit15 dollar8.2;
	drop i price1-price15 discount;
run;

/* ------------------------Question 2------------------------*/
* The goal of this task is to determine which of the profit values is the highest among the 15 and to create a variable that contains the variable name of that particular profit;
data prices_profit_max;
	set prices_profit;
	length max_profit $10;
	
	array profit_arr{15} profit1-profit15;
	hold = 0; * holding variable;
	
	do i=1 to 15;
		if profit_arr{i} > hold then do;
			hold = profit_arr{i};
			max_profit = vname(profit_arr{i});
		end;
	end;
	drop i;
run;

/* ------------------------Question 3------------------------*/
* Run a PROC FREQ against the character variable created in #2 to see the distribution of highest price point;
title1 'PROC FREQ (data=prices_profit_max)';
title2 'Shows the distribution of highest price point';
proc freq data=prices_profit_max;
	tables max_profit;
run;

/* ------------------------Question 4------------------------*/
* In a temporary data set, using arrays, create numeric 1/0 variables for each one, where 1 represents Yes and 0 represents all other values;
data birthwgt_temp;
	set sashelp.birthwgt;
	array yes_no{6} lowbirthwgt married drinking death smoking somecollege;
	array new_variables{6} new_lowbirthwgt new_married new_drinking new_death new_smoking new_somecollege;
	
	do i=1 to 6;
		if yes_no{i} = 'Yes' then new_variables{i} = 1;
		else new_variables{i} = 0;
	end;
	drop i;
run;

/* ------------------------Question 5------------------------*/
* Generate Chi-square statics for the numeric versions of the low birth weight and drinking variables created in #4. HINT: PROC FREQ;
* Run a PROC FREQ against the character variable created in #2 to see the distribution of highest price point;

* first sorting for by statement in proc freq;
proc sort data=birthwgt_temp;
	by race;
run;

title1 'PROC FREQ (data=birthwgt_temp)';
title2 'Chi-square statics for the numeric versions of the low birth weight and drinking variables';
ods select chisq;
proc freq data=birthwgt_temp notitle;
	tables new_lowbirthwgt*new_drinking / chisq;
	by race;
run;
ods select all;

/* ------------------------Question 6------------------------*/
* Create a new data set based on the sashelp.heart data set;
data heart_temp;
	set sashelp.heart;
	array uppercase_vars{*} _character_;
	array eight_vars{*} _numeric_;
	
	do i=1 to dim(uppercase_vars);
		uppercase_vars{i} = upcase(uppercase_vars{i});
	end;
	
	do j=1 to dim(eight_vars);
		if not missing(eight_vars{j}) then eight_vars{j} = eight_vars{j} * 1.08;
	end;
	
	if sex='MALE' and status='ALIVE' and weight > 180;
	
	drop i j;
run;


/* ------------------------Question 7------------------------*/
* Print the first ten observations of data set created in #6;
title1 'PROC PRINT (data=heart_temp)';
title2 'First 10 observations from data set';
proc print data=heart_temp (obs=10);
	var weight bp_status;
run;

/* ------------------------CLOSING------------------------*/
ods pdf close;

proc printto; run;