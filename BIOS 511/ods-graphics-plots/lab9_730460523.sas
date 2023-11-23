proc printto log='/home/u63543119/BIOS511/Logs/lab9_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 9
*
* Program name : lab9_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-09-27
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) Generating default ODS Graphics outputs
* 2) Selecting the desired plots
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
ods pdf file='/home/u63543119/BIOS511/Output/lab9_730460523.pdf';

/* ------------------------Question 1------------------------*/
* ods trace on;

* create temp data set from sashelp.bweight data set;
data bweight;
	set sashelp.bweight;
run;

* sorts data set by var=married;
proc sort data=bweight;
	by married;
run;

* selects only the plots for the ods;
ods select plots;

* Run a PROC UNIVARIATE on the sashelp.bweight data set;
title1 'PROC UNIVARIATE sorted by married with analysis var weight(data=sashelp.bweight)';
proc univariate data=bweight plots; * request all available plots;
	by married; * use mother's married status as the BY var;
	var weight; * use baby's birth weight as the analysis var;
run;

* ods trace off;

/* ------------------------Question 2------------------------*/
* create temp data set from classDat.dm data set;
data dm;
	set classDat.dm;
run;

* Run a PROC FREQ on the dm data set in the course folder, under the course data folder;
title1 'PROC FREQ crosstabulation of armcd and race, grouped by armcd (data=classDat.dm)';
proc freq data=dm;
	tables armcd*race / plots=(freqplot(groupby=row twoway=cluster)) nopercent nocol norow;
run;

/* ------------------------Question 3------------------------*/
* create temp data set from classDat.depression data set;
data depression;
	set classDat.depression;
run;

* Run a PROC FREQ on the depression data set in the course folder;
title1 'PROC FREQ crosstabulation of bed days and accute illness, (data=classDat.depression)';
proc freq data=depression;
	tables beddays*acuteillness / plots=(agreeplot) agree;
run;

/* ------------------------Question 4------------------------*/
* create temp data set from classDat.dmvs data set;
data dmvs;
	set classDat.dmvs;
run;

* Replicate the PROC GLM code from the lecture notes;
title1 'PROC GLM diagnostic plots with country var (data=classDat.dmvs)';
proc glm data=dmvs plots=(diagnostics);
	class country;
	model cfb = country sysbp0 / solution;
run;
quit;

/* ------------------------CLOSING------------------------*/
* closes ods pdf statement;
ods pdf close;

proc printto; run;