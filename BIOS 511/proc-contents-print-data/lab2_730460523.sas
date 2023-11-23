proc printto log='/home/u63543119/BIOS511/Logs/lab2_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 2
*
* Program name : lab2_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-08-23
*
* Purpose : This program is designed to be a template that can be
* reused throughout the BIOS 511 course. It uses PROC CONTENTS,
* PROC PRINT, and DATA.
*
* 
* 
* Revision History :
* 
* Date Author Ref (#) Revision
* N/A
*
* searchable reference phrase: *** [#] ***;
*
* Note: Standard header taken from :
* https://www.phusewiki.org/wiki/index.php?title=Program_Header
****************************************************************************/

%put %upcase(no)TE: Program being run by 730460523;
options nofullstimer;

/* determines the names of variables in sashelp.orsales */
proc contents data=sashelp.orsales;
run;

/* prints portion of data (first 8 observations) */
proc print data=sashelp.orsales (obs=8);
run;

/* creates a new dataset */
data students;
/* creates character and numeric variables */
first_name = "Katie";
last_name = "Chai";
age = 20;
run;
proc contents data=students;
run;

proc printto; run;

