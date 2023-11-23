proc printto log='/home/u63543119/BIOS511/Logs/lab21_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 21
*
* Program name : lab21_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-11-13
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) Using the DATA step for restructuring data
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
ods pdf file='/home/u63543119/BIOS511/Output/lab21_730460523.pdf';

/* ------------------------Question 1------------------------*/
/* The goal of this task is to create this data set. (NOTE: The picture contains only part of
the data set. The order of your variables does not have to match what is below.) */

proc sort data = classDat.ae out=ae_sorted;
	by AETERM AESOC; 
run;

data ae_edit;
	set ae_sorted;
	by AETERM AESOC; 
	retain mild moderate severe;
	array AESEV_counts{3} mild moderate severe;
		
	* set equal to 0;
	if first.AETERM then do j=1 to 3;
		AESEV_counts{j} = 0;
	end;
		
	if AESEV = 'MILD' then AESEV_counts{1} = AESEV_counts{1} + 1;
	else if AESEV = 'MODERATE' then AESEV_counts{2} = AESEV_counts{2} + 1;
	else if AESEV = 'SEVERE' then AESEV_counts{3} = AESEV_counts{3} + 1;
		
	if last.AETERM;
	keep AETERM AESOC mild moderate severe;
run;

/* ------------------------Question 2------------------------*/
/* Print the observations with an ae term of Thirst from the data set created in #2.
 */
title1 "Observations with an ae term of Thirst";
title2 "PROC Print (data=ae_edit)";
proc print data = ae_edit;
	 where AETERM = 'Thirst';
run;

/* ------------------------Question 3------------------------*/
/* The goal of this task is to restructure the lb data set in the course folder to look like
this: */

proc sort data = classDat.lb out=lb_sorted;
	by USUBJID VISITNUM VISIT LBTESTCD;
run;

data lb_edit;
    set lb_sorted;
    by USUBJID VISITNUM VISIT LBTESTCD;

    retain ALB CA HCT;
    
    if first.USUBJID then do;
		ALB = .;
		CA = .;
	    HCT = .;
	end;
    
    if LBTESTCD = 'ALB' then ALB = LBSTRESN;
    else if LBTESTCD = 'CA' then CA = LBSTRESN;
    else if LBTESTCD = 'HCT' then HCT = LBSTRESN;

    if last.VISITNUM then do;
    	output;
    end;
    keep USUBJID VISITNUM VISIT ALB CA HCT;
run;

/* ------------------------Question 4------------------------*/
/* Print the observations with usubjid of ECHO-040-023 from the data set created in #3. */
title1 "Observations with a usubjid of ECHO-040-023";
title2 "PROC Print (data=lb_edit)";
proc print data = lb_edit;
	 where USUBJID = 'ECHO-040-023';
run;

/* ------------------------Question 5------------------------*/
/* Create a data set based on the tumor2 data set in the course data folder. */
data tumor2_edit;
    set classDat.tumor2;
    output;
    treatment = 'Total';
    output;
run;

/* ------------------------Question 6------------------------*/
proc sort data = tumor2_edit;
	by treatment;
run;

/* Use PROC FREQ to get the number of patients for each treatment. */
title1 "Number of patients for each treatment";
title2 "PROC Freq (data=tumor2_edit)";
proc freq data = tumor2_edit;
	 tables treatment;
run;

/* ------------------------CLOSING------------------------*/
ods pdf close;

proc printto; run;