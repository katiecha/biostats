proc printto log='/home/u63543119/BIOS511/Logs/lab5_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 5
*
* Program name : lab5_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-09-11
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) Using PROC PRINT to view data
* 2) Using PROC FREQ to obtain counts, frequencies, and statistics
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

/* ------------------------DATA------------------------*/
* creates temp data set fails from sashelp.failure data set;
data fails;
	set sashelp.failure;
run;

* creates temp data set employee_donate from employee_donations data set;
data employee_donate;
	set classDat.employee_donations;
run;

* creates temp data set custo_dim from customer_dim data set;
data custo_dim;
	set classDat.customer_dim;
run;

* creates temp data set mig from migraine data set;
data mig;
	set classDat.migraine;
run;

/* ------------------------SORT------------------------*/
* sorts fails data set by cause;
proc sort data=fails out=fails;
	by cause;
run;

* sorts custo_dim data set by customer_name;
proc sort data=custo_dim out=custo_dim nodupkey;
	by customer_name;
run;

/* ------------------------PRINT------------------------*/
* prints data set sas.failure based on criteria;
title 'sas.failure data set by cause for day and count variables.';
proc print data=fails;
	by cause;
	var day count;
run;

* prints data set employee_donations based on criteria;
options missing = '0';
title 'employee_donations data set w missing data=0, no obs, dollar8.2 format, labels, and Qtr sums';
proc print data=employee_donate noobs label;
	format Qtr1--Qtr4 dollar8.2;
	label paid_by = 'Type of Payment';
	var paid_by recipients Qtr1--Qtr4;
	sum Qtr:;
run;

/* ------------------------FREQ------------------------*/
* prints customer country distribution for customer_dim data set;
title 'Customer country distribution for customer_dim data set';
proc freq data=custo_dim;
	tables customer_country;
run;

* prints crosstabulation of customer country and age group for customer_dim data set;
title 'Crosstabulation of customer country and age group for customer_dim data set';
proc freq data=custo_dim;
	tables customer_country*customer_age_group;
run;

* prints crosstabulation of customer type and group for customers over the age of 40 with percent and cumulative percent for customer_dim data set;
title 'Crosstabulation of customer type and group for customers over the age of 40 with percent and cumulative percent values for customer_dim data set';
proc freq data=custo_dim;
	where customer_age > 40;
	tables customer_type*customer_group / list;
	tables customer_group*customer_type / list; 
run;

* prints crosstabulation of treatment and response as well as sensitivity and specificity estimates for migraine data set;
title 'Crosstabulation of treatment and response as well as sensitivity and specificity estimates for migraine data set';
proc freq data=mig;
	tables treatment*response / senspec;
run;

proc printto; run;


