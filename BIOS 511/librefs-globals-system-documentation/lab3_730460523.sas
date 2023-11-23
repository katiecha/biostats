proc printto log='/home/u63543119/BIOS511/Logs/lab3_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 3
*
* Program name : lab3_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-08-28
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) librefs (temporary and permanent data sets)
* 2) global statements
* 3) system options
* 4) product documentation
* 
* Revision History :
*
* 
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

* creates temp data set from dmv data set using libref;
data tempDat;
set classDat.dmvs;
run;

* creates + stores perm data set from dmv data set using libref;
data myDat.permDat;
set classDat.dmvs;
run;

* prints first 5 observations from temp data set above with title + footnote;
title1 "DMV Data";
footnote "Practice printing a temporary dataset with a libname.";
proc print data=tempDat(obs=5);
run;

* returns year cutoff option;
proc options option=YEARCUTOFF;
run;

proc printto; run;
