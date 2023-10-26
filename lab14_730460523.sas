proc printto log='/home/u63543119/BIOS511/Logs/lab14_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 14
*
* Program name : lab14_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-10-16
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) Combining data sets with a SET statement
* 2) Combining data sets with a MERGE statement
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
ods pdf file='/home/u63543119/BIOS511/Output/lab14_730460523.pdf';

/* ------------------------Question 1------------------------*/
* Create a permanent data set named aedm;

* create temp data set dm;
data dm;
	set classDat.dm;
run;

* create temp data set ae;
data ae;
	set classDat.ae;
run;

* sort temp data sets;
proc sort data=dm; by usubjid;
proc sort data=ae; by usubjid;
run;

* merge temp data sets dm and ae into perm data set aedm;
data myDat.aedm;
	merge dm ae;
	by usubjid;
run;

/* ------------------------Question 2------------------------*/
* Run a PROC CONTENTS step on the data set created in #1;
title1 'PROC CONTENTS on merged dm ae data sorted by subject id (data=myDat.aedm)';
ods exclude enginehost variables; * exclude engine/host information;
proc contents data=myDat.aedm;
run;

/* ------------------------Question 3------------------------*/
* Create a temporary data set;
data subset_aedm;
	merge dm(in=ind) ae(in=int);
	if ind=1 and int=0;
	by usubjid;
	keep usubjid sex age;
run;

/* ------------------------Question 4------------------------*/
* Print the first ten participants of the data set created in #3;
title1 'PROC PRINT on subset dm ae data sorted by subject id (data=subset_aedm)';
proc print data=subset_aedm (obs=10);
run;

/* ------------------------Question 5------------------------*/
* Create a permanent data set named aedm2;
data myDat.aedm2;
	merge dm(in=ind) ae(in=int);
	if ind=1 and int=1;
	by usubjid;
run;

/* ------------------------Question 6------------------------*/
* Using the data set from #5, create a panel graph (PROC SGPANEL) of vertical bars;
title1 'PROC SGPANEL on subset dm ae data sorted by subject id (data=myDat.aedm2)';
title2 'Panel graph of vertical bars';
proc sgpanel data=myDat.aedm2;
	panelby race arm / novarname columns=4 spacing=20;
	vbar aesev / group=sex;
run;

/* ------------------------Question 7------------------------*/
* The objective of this task is to create a temporary data set that contains the variables USUBJID, VISITNUM, VISIT, DIABP, and SYSBP;

* create temp data set vs;
data vs;
	set classDat.vs;
run;

* create temp data set vs with obs for diastolic;
data vs1;
	set classDat.vs;
	where vstestcd = 'DIABP';
	rename vsstresn = DIABP;
run;

* create temp data set vs with obs for systolic;
data vs2;
	set classDat.vs;
	where vstestcd = 'SYSBP';
	rename vsstresn = SYSBP;
run;

proc sort data=vs1; by usubjid visitnum visit;
proc sort data=vs2; by usubjid visitnum visit;
run;

data updated_vs1;
	merge vs1 vs2;
	by usubjid visitnum visit;
	keep usubjid visitnum visit diabp sysbp;
run;

/* ------------------------Question 8------------------------*/
* Print the observations for subject ECHO-012-019 in the data set created in #6b;
title1 'PROC PRINT on merged vs data set (data=updated_vs1)';
title2 'Observation for subject ECHO-012-019';
proc print data=updated_vs1;
	where usubjid = 'ECHO-012-019';
run;

/* ------------------------Question 9------------------------*/
* The goal of this task is to create the same data set as #7b using one DATA step;
proc sort data=vs out=sorted_vs;
	by usubjid visitnum visit;
run;

data updated_vs2;
	merge sorted_vs (where=(vstestcd='DIABP') rename=(vsstresn=DIABP))
		sorted_vs (where=(vstestcd='SYSBP') rename=(vsstresn=SYSBP));
	by usubjid visitnum visit;
	keep usubjid visitnum visit diabp sysbp;
run;

/* ------------------------Question 10------------------------*/
* Run a PROC CONTENTS step on the data set created in #9a;
title1 'PROC CONTENTS on merged vs data set (data=updated_vs2)';
ods exclude enginehost; * exclude engine/host information;
proc contents data=updated_vs2;
run;

/* ------------------------CLOSING------------------------*/
ods pdf close;

proc printto; run;