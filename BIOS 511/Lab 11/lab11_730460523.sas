proc printto log='/home/u63543119/BIOS511/Logs/lab11_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 11
*
* Program name : lab11_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-10-07
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) Generating multiple plot types using PROC SGPANEL
* 2) Creating similar graphs using both PROC SGPLOT and PROC SGPANEL
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
ods pdf file='/home/u63543119/BIOS511/Output/lab11_730460523.pdf';

/* ------------------------Question 1------------------------*/
* create temp data set prostate from classDat.prostate;
data prostate;
	set classDat.prostate;
run;

* With PROC SGPANEL, create a panel of horizontal box plots;
title1 'Tumor size paneled by treatment and stage';
title2 '(Panel of horizontal box plots [data=classDat.prostate])';
proc sgpanel data=prostate;
	where tumorsize ne -9999; * Subset to a tumor size that is not -9999;
	panelby treatment stage / columns=4; * Panel by the treatment and stage variables && Force the graphs to be in four columns;
	hbox tumorsize / displaystats=(mean) outlierattrs=(color=red); 	* Use tumor size as the analysis variable && Use the DISPLAYSTATS option to display the mean value within each graph && Make the outlier marker color red;
run;

/* ------------------------Question 2------------------------*/
* create temp data set preemies from classDat.preemies;
data preemies;
	set classDat.preemies;
	label bw = 'Birth Weight';
run;

* With PROC SGPANEL, create panel of histograms with density curves;
title1 'Histograms and density curves paneled by sex=0 or 1';
title2 '(Panel of histograms with density curves [data=classDat.preemies])';
proc sgpanel data=preemies noautolegend; * Suppress the creation of a legend, using the NOAUTOLEGEND option;
	panelby sex / novarname; * Panel by the sex variable && Remove the variable names from the cell headings of the panel layout;
	histogram bw;
	density bw / lineattrs=(color=red);
	rowaxis label='Percent (%)' values=(0 to 50 by 10);
run;

/* ------------------------Question 3------------------------*/
* create SORTED temp data set preemies from classDat.preemies;
proc sort data=preemies out=preemies_sorted;
	by sex; * Use a BY statement to create one graph for each visit;	
run;

* Generate the same histograms and density curves as you did in #2, using PROC SGPLOT;
title 'Histogram and density curve paneled by sex=0 or 1';
title1 '(Histogram with density curve [data=classDat.preemies])';
title2 '#byvar1 = #byval1';
options nobyline;
proc sgplot data=preemies_sorted;
	by sex;
	histogram bw;
	density bw / lineattrs=(color=red);
	yaxis values=(0 to 50 by 10) label='Percent (%)';
run;

/* ------------------------CLOSING------------------------*/
ods pdf close;

proc printto; run;