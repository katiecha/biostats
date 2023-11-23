proc printto log='/home/u63543119/BIOS511/Logs/lab4_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 4
*
* Program name : lab4_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-09-06
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) Using PROC SORT to sort data
* 2) Using PROC CONTENTS to obtain variable names
* 
* Revision History :
*
* Note: Standard header taken from :
* https://www.phusewiki.org/wiki/index.php?title=Program_Header
****************************************************************************/

%put %upcase(no)TE: Program being run by 730460523;
options nofullstimer;

* assigns libref for class data;
LIBNAME classDat "/home/u63543119/my_shared_file_links/u49231441/Data" access=readonly;

* assigns libref for my data;
LIBNAME myDat "/home/u63543119/BIOS511/Data";

* creates temp data set from customer_dim data set;
data custodim;
	set classDat.customer_dim;
run;

* sorts custodim data by last name;
proc sort data=custodim out=custodim_1;
	by customer_lastname;
run;

* sorts custodim data by group and type, only keeping these variables;
proc sort data=custodim out=custodim_2 (keep=customer_group customer_type) nodupkey;
	by customer_group customer_type;
run;

* creates temp data set from drivers data set;
data drive;
	set classDat.drivers;
run;

* sorts drive data by cohort;
proc sort data=drive out=drive_1;
	by cohort;
run;

* subsets + sorts drive data into North Carolina drivers and by gender;
proc sort data=drive out=myDat.drive_2;
	where state='North Carolina';
	by gender;
run;

* print variable names according to the order they are found in the data set;
title 'Proc Contents according to order they are found in the data set.';
proc contents data=custodim_1 varnum;
run;

* suppresses the printing of output --> stores in temp data set;
proc contents data=custodim_1 noprint out=custodim_1_contents;
run;

proc printto; run;
