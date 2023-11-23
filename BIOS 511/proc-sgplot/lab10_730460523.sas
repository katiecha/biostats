proc printto log='/home/u63543119/BIOS511/Logs/lab10_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 10
*
* Program name : lab10_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-10-02
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) Generating multiple plot types using PROC SGPLOT
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
ods pdf file='/home/u63543119/BIOS511/Output/lab10_730460523.pdf';

/* ------------------------Question 1------------------------*/
* create temp data set from sashelp.failure;
data failure;
	set sashelp.failure;
run;

* With PROC SGPLOT, create a horizontal bar chart using the sashelp.failure data set;
title1 'Horizontal Bar Chart (data=sashelp.failure)';
title2 'Category=Cause, Response=Count';
PROC SGPLOT data=failure;
	hbar cause / response=count stat=sum dataskin=CRISP;
run;

/* ------------------------Question 2------------------------*/
* create temp data set from sashelp.cars;
data cars;
	set sashelp.cars;
run;

* With PROC SGPLOT, create overlaid vertical bar graphs using the sashelp.cars data set;
title1 'Overlaid Vertical Bar Graphs (data=sashelp.cars)';
title2 'Category=Type';
PROC SGPLOT data=cars;
	vbar type / response=msrp stat=sum transparency=0.3;
	vbar type / response=invoice stat=sum transparency=0.3 barwidth=0.5;
run;

/* ------------------------Question 3------------------------*/
* create temp data set from classDat.vs;
data vs;
	set classDat.vs;
run;

* Summarize the vs data set and store the results in a temporary data set;
title1 'Summarization / PROC MEANS (data=classDat.vs)';

PROC MEANS data=vs noprint nway;
	 class vstestcd vstest visitnum visit;
	 var vsstresn;
	 output out=vs_sum mean=/autoname;
run;

/* ------------------------Question 4------------------------*/
* Run a PROC SPLOT step on the data set created in #3;
title1 'Overlaid Series and Scatter Plot (data=classDat.vs)';
title2 'Y-Axis=Mean Patient Weight';
PROC SGPLOT data=vs_sum noautolegend;
	where vstestcd = 'WEIGHT';
	series x=visit y=vsstresn_mean;
	scatter x=visit y=vsstresn_mean / markerattrs = (color=blue symbol=diamondFilled size=10);
	yaxis values=(69.8 to 70.7 by 0.1);
	label vsstresn_mean = 'Patient Weight';
run;

/* ------------------------CLOSING------------------------*/
ods pdf close;

proc printto; run;