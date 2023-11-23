proc printto log='/home/u63543119/BIOS511/Logs/lab17_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 17
*
* Program name : lab17_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-10-30
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) Writing DO loops
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
ods pdf file='/home/u63543119/BIOS511/Output/lab17_730460523.pdf';

/* ------------------------Question 1------------------------*/
* Use an iterative DO loop to create a brand-new, temporary data set with one observation for every day of October 2023 through December of 2023;
data oct_dec;
	do day = '01OCT2023'd to '31DEC2023'd; * October 2023 to December 2023;
		random = rand('GAMMA', 5); * Random number with gamma distribution and numeric constant of 5;
		output;
	end;
	format day date9.;
run;

/* ------------------------Question 2------------------------*/
* Run a PROC MEANS on the data set created in #1;
title1 'PROC MEANS (data=oct_dec)';
title2 'Subset to November Records';
proc means data=oct_dec;
	where '01NOV2023'd <= day <= '30NOV2023'd ;
	var random;
run;

/* ------------------------Question 3------------------------*/
* Create a temporary data set based on the sashelp.stocks data set;
data stocks_temp;
	set sashelp.stocks;
	
	where stock='Intel' and date='02JUN2003'd;
	
	do i=1 to 5;
		adjclose = adjclose * 1.11;
		date = INTNX('year', date, 1, 's');
		output;
	end;
	keep stock date adjclose;
run;

/* ------------------------Question 4------------------------*/
* Print the data set created in #3;
title1 'PROC PRINT (data=stocks_temp)';
title2 'Data set created using DO loop';
proc print data=stocks_temp;
run;

/* ------------------------Question 5------------------------*/
* Copy the DATA step you wrote for #3;
* Using a DO UNTIL loop;
data stocks_temp2;
	set sashelp.stocks;
	
	where stock='Intel' and date='02JUN2003'd;
	
	do until (adjclose > 200);
		adjclose = adjclose * 1.11;
		date = INTNX('year', date, 1, 's');
		output;
	end;
	keep stock date adjclose;
run;

/* ------------------------Question 6------------------------*/
* Print the data set created in #5;
title1 'PROC PRINT (data=stocks_temp2)';
title2 'Data set created using DO UNTIL loop';
proc print data=stocks_temp2;
run;

/* ------------------------Question 7------------------------*/
* Use a DATA _NULL_ and PUTLOG statement to write the patient number of patients who are 55 years old, receiving treatment 2 in the prostate data set in the course folder to the log;
data _null_;
  set classDat.prostate;
  if age=55 and treatment=2 then putlog patientnumber=;
run;

/* ------------------------CLOSING------------------------*/
ods pdf close;

proc printto; run;