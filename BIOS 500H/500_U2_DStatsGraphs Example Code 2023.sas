/*---------------------------------------------------------------------------------------------------*/
/* Program:  500_U2_DStatsGraphs Example Code 2023.sas
/* Location: /home/u63543119/bios500H/Code_and_more/Unit 2/500_U2_DStatsGraphs Example Code 2023.sas
/* Purpose: Example code to produce descriptive statistics,
/*          bar graphs, histograms and boxplots using lecture examples
            (Student are not responsible for pie charts)
/*          Students can use this code to copy FROM.

/*---------------------TABLE OF CONTENTS: --------------------------------------------------------------  
/*--PART  A: Nominal or Ordinal DATA - Bar Graphs (Using Mortality Data) and Pie Charts moved to appendix ---
		Example 0:  Frequency Table - a good summary for discrete data
					uses 'proc freq' to display "counts" of levels 
			
		Example 1: UNSUMMARIZED/Raw/Observation Level Data
				1a. BAR CHART: Use 'proc sgplot' which works in any edition for a bar chart. 	               
				1b. PIE CHART: Moved to Appendix 
						So I won't ask you to do a pie chart.
						You can also do a pie chart with point and click >Tasks > Graph > Pie Chart ....

		Example 2: SUMMARIZED Data
				2a. BAR CHART:  uses proc sgplot with either vbar or vbarparm .
				2b. PIE CHART:  Moved to Appendix... you won't need to do one of these
				                Pie chart code provided just for completeness


/*--PART B:  QUANT/CONTINUOUS DATA - Descriptive Statistics, Boxplots and Histograms and Stem/leaf (Using BP Data)---
                Assumes you are given observation-level/unsummarized data
                
		Example 3:    	Descriptive Statistics with Proc Means and Proc Univariate
		                Also includes cryptic code to do a stem-and-leaf in proc univariate
					          Example 3.5: create output datasets with JUST THE SUMMARY STATISTICS and print the stats
		
		Example 4:     	Histogram (Sys BP)
		
		XX Example 5X XX: 		XXX Omitted XXX
		
		Example 6: 		Two Histograms "Side by Side" to compare DBP for two genders
		
		Example 7:       ONE BOXPLOT - Single Category 
		        7a: 	Boxplot of Dias BP (continuous), using proc boxplot, with style=schematicid
				7b:     Boxplot of Dias BP (continuous) using proc sgplot 
		        7c: 	Boxplot of Dias Bp (continuous) using proc boxplot, with style=  skeletal
		
		Example 8: 		SIDE BY SIDE BOXPLOTS - To compare two or more categories
				8a:     Side by side boxplot of Dias BP (continuous) by gender (categorical) Using Proc boxplot
				8b: 	Same thing, side by side boxplots by now using proc sgplot;




/* Start Date: July 9, 2010
/* Last Updated: August 21, 2020 Lots of updates for SAS OnDemand, 
                 Aug 30, 2021 added vbarparm example and sgplot for boxplot, 
                 2023 - small edits for clarity

/* ---------------     ! NOTES !: PLEASE READ  !   -----------------------------------------------
        TRY TO GET COMFORTABLE WITH USING CODE WITH SOME QUIRKS AND INCONSISTENCIES.....
        ON THE POSITIVE SIDE - THAT KEEPS LIFE INTERESTING ?
 

a. If using SAS 9.4 or later, the default output is to html - so (MOST OF ?) the ods (Output Delivery System) statements
   			statement below are largely (?) not needed.  
   			Thus, many of the ods statements have been commented out.
   Here's a typical ods statement:
			*ods rtf file="C:\Users\monaco\Documents\2019BIOS500H\SASFiles\Output\2019_U2 Output.rtf";
			*ods rtf close;
   This output the results to an rtf.
   You sandwich your proc between these two  ods statements to output to an rtf file. 
   Same syntax to output to pdf just change 'rtf' to 'pdf' above.   
   Just uncomment out any ods statements or edit them as needed.
   Bottomline:  I'm trying to minimize ods statements for simplicity - especially in the beginning. 
                I've included a couple below just FYI.... I'll say more as we cover it in class.
                Occasionally you may see them crop up in different ways and I can explain as needed. 
                They are a "tree" - not the "forest" - a detail we will cover as needed. 

b. I recommend NOT changing this file code - keep it for reference.
   I recommend using this file to COPY FROM (from this file)/
   			PASTE (into your own .sas program)/EDIT (your own code).
   

c.  NUMBER FORMATTING :  Code below introduces some numeric formatting.
    For example, the number format (10.0) represents (number of spaces for DIGITS.NUMBER OF DECIMALS)
    So (10.0) formats 10 total digits (includes comma and decimal if applicable) and no decimals.
    The format (5.1) will format the number to 5 digits, one place will the tenths.
    The format (5.2) will still allot 5 places for the number (including
    		the decimal and will print to the hundredths place as designate by the .2.
    This is a way to round numbers in the output, for example;
    
d. USING >TASKS
	Most students use the "COPY from example code/PASTE into student file /EDIT" code method
	I try to give you example code for everything you'll need
	
	However, there are 'point and click' ways to get code started for you...
	You can try it: > Tasks and Utilities (on left hand side)
                       >Tasks > Graph > Bar Chart  (for example)
    Using the drop down options you can get SAS to write some preliminary code for common task.
    Then copy and paste it into you own program - and edit as needed with titles etc.  
    AI will also do this - but I have requested NO AI in the course.  I'm giving you 
    what I think you need and will be most helpful.


/* DATA:  Mortality Data Input in a Data Set (Both raw values and summary data)
/*        Blood Pressure edited from SAS documentation
/*        Input in a data step within program

/*-------------------------------END OF HEADER -----------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------*/


options mergenoby=warn nofmterr;
Title1 "Bios 500- Unit 2: Descriptive Statistics and Graphing";
Title2 "   ";
Title3 "   ";
footnote1 "produced by Jane Monaco /home/jmonaco/bios500h/Code_and_more ";
footnote2 " &systime, &sysdate";



/* ----------------------------------------------------------------------*/
*************************************************************************
   PART A:  NOMINAL/ORDINAL DATA - Bar charts and  Pie Charts 
**************************************************************************
/*------------------------------------------------------------------------*;

title2 "PART A: NOMINAL/ORDINAL  DATA - Bar charts (and Pie charts moved to appendix)";

	
************************************************************************************;
**  Example 1 (In Part A) shows what to do when data are UNSUMMARIZED;     
*************************************************************************************;

*  This first example is for a small unsummarized - raw data set - 
   The data are 'one observation per row' - in other words, unsummarized.
   The observations are entered as rows and variables as columns -
   This is the typical raw data set up where the data are **NOT** summarized;

Proc format;
		*A format tells SAS to associate, say,  a number with
     	a label.  So  the value 1 is associated to "Accident"
     	The proc format tells SAS what the formats are -
     	Below in the the data set, the format is associated
	 	with the variable "cause".  Using formats is 2-step process: define the format and then
	 	attach the format to the variable;
		value causef 1="Accident" 
	            2="Homicide" 
	            3="Suicide" 
	            4="Cancer" 
				5="Heart Disease" 
				6="Congenital Defect" 
				7="Other";

title3 "Mortality Data: Cause of Death for n=30 observations ";
Data mortalsmall;
	input id cause;  * Input Raw (Unsummarized)  Mortality Data-  30 observations, 2 variables
					 * Input ID and Cause of Death, both will be numeric (the default);
	format cause causef.;
					 * above stmt ASSOCIATES format causef. with the variable cause - so  in
	  				 * printouts, for example, will list the cause name (accident) rather than the number (1);
	datalines;
1  2
2  1
3  5
4  3
5  6
6  3
7  1
8  2
9  3
10 7
11 2
12 1
13 1
14 1
15 4
16 2
17 1
18 7
19 2
20 7 
21 4
22 3
23 5
24 1
25 7
26 3
27 7
28 1
29 4
30 6
;

proc print data=mortalsmall;
run;

*Produce a frequency table of counts - very helpful for categorical data;
title4 "Example 0: Frequency Table - Cause of Death ";
proc freq;
	tables cause;
	*Very versatile procedure! We will see much more of this procedure;		
	*Some options to be aware of to order the rows: ORDER=DATA | FORMATTED | FREQ | INTERNAL ;    
	*To do a cross tabulation use: tables Cause*var2;
run;

	
**EXAMPLE 1a BAR CHART CODE..... works in SAS OnDemand! Yeah! ;
title4 "Example 1a: Bar Graph - Frequency (Count) by Cause of Death";
title5 "(Unsummarized Data)  Uses Proc Sgplot, which works in any SAS install";
proc sgplot data=mortalsmall;
	*Bar Chart Example:  Proc Sgplot works in University Edition!  Yeah!;
	yaxis label="Number of Deaths";
	xaxis label="Cause of Death" discreteorder=unformatted;
	*order of the bars is important !
	 if you don't put in the discreteorder=, it will order bars alphabetically (usually
	 not recommended)  ... other choices discreteorder = formatted, unformatted or data...;
	vbar cause;
run;

	
************************************************************************************;
**  Example 2 (Still in Part A) shows what to do when data are ALREADY SUMMARIZED;
*************************************************************************************;
title3 "Example 2: Numbers of Deaths Among Citizens Ages 15-24 Years in the US in 2000";
title4 "Entered as SUMMARY Data";
footnote3 "26,694 Total Deaths, Data: www.census.gov";
run;

Data mortality;
	*Iinput SUMMARY Data Given by each Death Type;
	input type death;          *input 'type of death' and 'number of deaths' as variable/columns
	                            there is no $ so SAS assumes the data are numeric not character;
	format death comma10.0;    *format 10 places with comma and no decimals (number includes comma and 
	                            decimal if applicable);
	format type causef.;
	datalines;
1  13616
2  4796
3  3877
4  1668
5  931
6  425
7  1381
;

Proc print data=mortality;
	*Print out this data set to check for problem;
run;

	
************************************************************************************;
**  Example 2a Bar Graph for SUMMARIZED Data;
**              I show two ways.... they are both good -either should work
                One uses vbar command the other uses vbarparm command;
*************************************************************************************;

**Bar Chart Code .. works in SAS OnDemand or local install!;
* If the data are not summarized, just leave out "response=" statement.
  The default is to count # of observations in the levels.;
* This is the Bar Graph from the lectures with summary data;
title5 "Example 2a: Bar Graph- Frequency by Cause of Death";
title6 "(Summarized Data)";
title7 " 2a)i) uses vbar command";
proc sgplot data=mortality;
	*Bar Chart Example:  Proc Sgplot works in SAS OnDemand;
	yaxis label="Number of Deaths";
	xaxis label="Cause of Death" discreteorder=unformatted;
	*if you don't put in the discreteorder=, it will order bars alphabetically
		   ... other choices discreteorder = formatted, unformatted or data...;
	vbar type / freq=death  datalabel=death ;
	*Used freq=death since the data are summarized;
run;

    *This is exactly the same as bar graph above... just uses vbarparm rather than vbar in the sgplot;
title7 " 2a)ii) uses vbarparm command";
proc sgplot data=mortality;
	*Bar Chart Example - uses vbarparm;
	yaxis label="Number of Deaths";
	xaxis label="Cause of Death" discreteorder=unformatted;
	vbarparm category= type response=death ;
run;
/*--------------END OF PART A: Nominal/ordinal Data - Bar charts (Pie Charts were moved to Appendix) ------*/
	


	
/* ------------------------------------------------------------------------------------------*/
**********************************************************************************************
   PART B:  Continuous Data:
   Descriptive Statistics, Histograms and Boxplots and Stem and Leaf
***********************************************************************************************
*---------------------------------------------------------------------------------------------*;

* First, Read in BP Data;
title2 "PART B:  Blood Pressure Data (Continuous)";
footnote3 " ";

Proc format;    *Recall formatting has two steps... 1. create format 2. associate format with variable;
	value genderf 1="Female" 
	              2="Male";

data BP;
	*Input Data used in Class examples... it is 23 patients Systolic and Diastolic BP;
	input PatientID Gender Systolic Diastolic;      *Input the variable names.  All vars are NUMERIC, the default;
		 Group="All Observations";                   *Create a new variable, every observation will have same value;
	     label Systolic="Systolic BP mmHg" Diastolic="Diastolic BP mmHg";
	     format gender genderf.;        *Associates format genderf. with the variable gender, must have created genderf. first;
	datalines;
1 1 115 55	
2 2 130 80  	
3 1 120 65	
4 2 134 72	
5 2 118 76	
6 2 122 78
7 1 122 78
8 1 122 78
9 1 112 62
10 2 122 82
11 2 135 85
12 1 120 50
13 1 90 65
14 2 105 70
15 1 120 80
16 2 140 90
17 2 120 70
18 1 165 110
19 1 110 40
20 2 119 66
21 2 125 76
22 1 133 60
23 2 104 54
;
run;

proc print;
run;

******** End of reading in data *********************************;



*********Sort data and output for use later *********************;

proc sort data=bp out=sortbp;
	*sort by gender then SBP output to new dataset ->sortbp;
	by gender systolic;

proc sort data=bp out=sortsys;
	* Sort by SBP only output to new dataset ->sortsys;
	by systolic;

proc print data=sortsys;
	title4 "Print Out of All Observations Sorted by Systolic BP";
run;


************************************************************************************;
**  Example 3 Descriptive  Stats for all observations AND Stem and Leaf	     		;
*************************************************************************************;
Proc Means Data=bp maxdec=1 n mean std median q1 q3;
	*Example 3: Descriptive Statistics using proc means (gives less output than univariate);
	title4 "Example 3: Proc Means Output of all Observations";
	var diastolic;
	id patientid;
	*by gender;
		*must be SORTED first by this variable if you want results, say, by gender;
	    *can use output out=myoutput if you need the statistics later; 
Run;

ods graphics off;     * I like putting in this ODS statement because it will give you a stem and leaf plot; 
Proc univariate data=bp plot;
	*Proc univariate gives more output than proc means;
	* Compute Descriptive statistics all observations in BP data set ;
	title4 "Example 3:  Proc Univariate Output Statistics of All Observations";
	var systolic diastolic;
	id patientid;
run;
ods graphics on;


/* Example 3.5: Code To output the STATISTICS to a different Data set  (Not Used often)  
                You can largely ignore unless you need to USE the summary stats later  */
Proc univariate data=bp noprint;
	title4 "Example 3.5.  Created output data sets with summary stats";
	*This is if you need the statistics values, later, for more calculations.
      		*(notice the 'noprint' option- so there is NO OUTPUT to the output window,
      		*The following code just creates some data sets in case you want to use them later;
			*Output Descriptive Stats to separate data sets called Means and Sysstats;
	var systolic diastolic;
	output out=Means mean=SysMean DiasMean;
	output out=SysStats mean=SysMean std=SysSD min=SysMin max=SysMax p5=p5sys 
		p95=p95sys n=Sysn;
	output out=Oddpctl pctlpts=30 60 pctlpre=systolic diastolic pctlname=pct30 
		pct60;
run;


proc print data=means;
	title5 "Example 3.5: Now Output Data Set of Means of Systolic and Diastolic BP";
	*This data set, 'means', was created above in the  proc univariate above ;
	*We are printing out the means for systolic and diastolic bp computed in the univariate above;
	
run;

proc print data=sysstats;
	*This data set, 'sysstats', was created above in the proc univariate above;
	*Print out more summary statistics (mean, sd. percentiles, etc)  for systolic only;
	title5 "Example 3.5: Now Output Data Set of Descriptive Statistics for Systolic";
run;

proc print data=oddpctl;
	*This data set, 'oddpctl', was created above in the proc univariate;
	* Print out Odd percentiles for systolic and diastolic;
	title5 "Example 3.5: Now Output Data Set of Odd Percentiles";
run;
/* End of Example 3.5 */


************************************************************************************;
**  Example 4: Histogram of DBP                                                    ''    								;
*************************************************************************************;
*Demonstrates how to do ENDPOINT DESIGNATION
*The 'noprint' option suppresses the statistics  but DOES NOT suppress the histogram in this example;


proc univariate data=bp noprint;
	title4 "Example 4: Distribution of Diastolic BP Values for 23 Patients";
	title5 "demonstrating SAS code for histogram with endpoint designation";
	*ods html file="C:\Users\monaco\Documents\2016BIOS500H\SASFiles\Output\bp_hist_bins.html";
	histogram diastolic /endpoints=30 to 130 by 10 odstitle=" " vaxislabel='Percent of Patients';
	*left endpoint included by default for right endpoint keyword= rtinclude;
	*percent is default, keyword vscale=percent count or proportion;
	inset n='No. Obs.' mean='Mean Diastolic' (5.1) 
		std='S.D. Diastolic' (5.1)/header="Summary Stats Diastolic";
run;
	*ods html close;
	* See note in header about the formatting (5.1) - it basically rounds to five
		  	places, including the decimal. The .1 means to include the tenths place.
			Thus, (5.2) would include the hundredths place.;
			  

************************************************************************************;
**  Example 5 DELETED                           ;    								;
*************************************************************************************;

************************************************************************************;
**  Example 6 Create TWO Histograms - BY GENDER (to compare DBP for the two genders )            ;    								;
*************************************************************************************;

proc univariate data=bp noprint;
	*Two histograms comparing genders distribution for diastolic;
	title4 "Example 6: TWO STACKED HISTOGRAMS";
	title5 "Comparison of Diastolic Blood Pressure for two Genders";
	class gender;
	     * like 'by' statement but doesn't need sort first;
	histogram diastolic /vscale=count vaxis=0 to 10 by 2 vminor=1 
		vaxislabel='Count of Patients' endpoints=30 to 130 by 10 
		odstitle=" ";
	inset n='No.Obs.' mean="Mean Diastolic" (5.1) std='S.D. Diastolic' (5.1);
run;


************************************************************************************;
**  Example 7    BOXPLOT OF DBP	: ONE GROUP... SINGLE CATEGORY
**           7a uses proc boxplot with schematicid option
**			 7b uses proc sgplot  
**			     either way is good... your choice.	
**			 7c uses proc boxplot with skeletal option				                 ;
*************************************************************************************;


************************************************************************************;
**  Example 7a SINGLE BOXPLOT uses proc boxplot with schematicid option		;
*************************************************************************************;

*ods graphics on /width=3in height=4in;
*To make the boxplot smaller;
	
title4 "Example 7a: SINGLE Diastolic BP Boxplot ";
title5 "Uses proc boxplot boxstyle=schematicid";
proc boxplot data=sortbp;
	
	*SAS is a little odd about doing a single boxplot -  it wants to do side-by-side boxplots
         by group ("plot diastolic *group") - my "work around" was to put everyone in the same group
		 called "All Observations" to make a single boxplot. ;

	plot diastolic*group /boxstyle=schematicid nohlabel odstitle=" ";    *other boxstyles = schematicid skeletal;
	*different styles you may want to try: style= analysis or journal or statistical;
	inset min mean (5.1) max stddev (5.1)/ header='Overall Statistics' position=tm;        *tm is top margin;
	id patientid;
run;
*ods graphics off;

************************************************************************************;
**  Example 7b SINGLE BOXPLOT OF DBP	showing proc sgplot with VBOX statement		;
*************************************************************************************;

title4 "Example 7b: SINGLE Diastolic BP Boxplots";
title5 "USING PROC SGPLOT with VBOX STATEMENT";
 proc sgplot data=sortbp;     
	vbox  diastolic ; 

run;
************************************************************************************;
**  Example 7c SINGLE BOXPLOT OF DBP	showing boxstyle =skeletal							;
*************************************************************************************;

title4 "Example 7c: SINGLE Diastolic BP Boxplot";
title5 "Uses proc boxplot showing boxstyle=skeletal ";
proc boxplot data=sortbp;
	*Diastolic Boxplot- Single Boxplot;	
	plot diastolic*group /boxstyle=skeletal  nohlabel odstitle=" ";  *other boxstyles = schematicid skeletal;
	inset min mean (5.1) max stddev (5.1)/ header='Overall Statistics' position=tm;
	*tm is top margin;
	id patientid;
run;



************************************************************************************;
**  Example 8a and b    SIDE-BY-SIDE BOXPLOTS for the two genders, var= DBP (cont) category= GENDER (two levels);
**          8a: uses proc boxplot
			8b: uses proc sgplot
				Either way is good; 					
*************************************************************************************; 
ods graphics off; * I  like the default boxplots with ods graphics off;
                  * I've tried to minimize ods statements because we don't cover 
                    them in class but this one just makes it look better;
title4 "Example 8a: Diastolic BP Boxplots by Gender (Side by Side)";
title5 "USING PROC BOXPLOT";
proc boxplot data=sortbp;     *Side-by-side boxplot for diastolic for two genders;	
	plot diastolic*gender /boxstyle=schematicid odstitle=" ";
			*other boxstyles include = skeletal ;
	inset min mean (5.1) max stddev (5.1)/ header='Overall Statistics' position=tm;
			*tm is top margin;
	insetgroup n mean (5.1) min max /header='Descriptive Statistics by Gender' 
		position=top;
	id patientid;
run;
ods graphics on;
*quit;

title4 "Example 8b: Diastolic BP Boxplots by Gender (Side by Side)";
title5 "USING PROC SGPLOT with VBOX STATEMENT";
proc sgplot data=sortbp;     *Side-by-side boxplot for diastolic for two genders;
	vbox  diastolic /category=gender; 
run;

/*----END OF PART B: For Continuous or Discrete (Quantitative) Data ------------*/
/*-----                Descriptive Statistics, Histograms and Boxplots Stem and Leaf -----------*/






/*-----------------------------------------------------------*/
/*-----APPENDIX--APPENDIX  APPENDIX  APPENDIX  --------------*/
/*-----APPENDIX--APPENDIX  APPENDIX  APPENDIX  --------------*/
/*-----APPENDIX--APPENDIX  APPENDIX  APPENDIX  --------------*/
/*-----APPENDIX--APPENDIX  APPENDIX  APPENDIX  --------------*/

/*-----Probably wont need this - I wont ask you for a pie chart These are FYI.. -------*/
	
****** Example 1b: PIE CHART FOR 'OBSERVATION LEVEL' (Not Summarized) DATASET *******;
****** seems to work in Sas OnDemand- but again I won't ask you for a piechart;

Proc gchart data=mortalsmall;
	*Pie chart of frequency of each cause of death;
	title4 "Example 1b:  Pie Chart - Number of Deaths by Cause of Death";
	title5 "[Cause of Death, Number of Deaths]";
	pie cause /type=freq discrete noheading;
	run;
	*quit;
	
axis1 label=("Cause of Death");
	*x axis label;
axis2 label=("Number of Deaths");
	*y axis label;
	*axis2 label=(angle=90 "Number of Deaths");
	*if you need to rotate axis label;	
Proc gchart data=mortality;
	*Bar graph of Death Frequency by Death Type using summary data;
	title5 "Example 2a: Bar Graph- Frequency by Cause of Death";
	vbar type/ sumvar=death outside=sum discrete axis=0 2000 4000 6000 8000 10000 
		12000 14000 maxis=axis1 raxis=axis2;
	* since summary data, we can sum the deaths to produce desired result;
	* there is only one value per death type so it IS the sum;
	* if the x categories are character and you want to order them
						  differently, use the =midpoints statement;
	run;
	*quit;
	


	
	
	********EXAMPLE 2b: Pie Chart for SUMMARIZED Data **************;
* I give two ways.... neither is great...
* The first way is using a proc template and grender.... too complicated to be meaningful
* The second way is using proc gchart which unfortunately doesn't work in university edition;
* So, basically pie chart I'm showing you, but won't ask you to do on a test.; 

* Pie Chart with proc template and proc grender; 
* Define Pie template; 
proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		layout region;
		piechart
		category=type response=death / start=0 datalabellocation=outside  otherslice=false ;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;
proc sgrender template=SASStudio.Pie data=MORTALITY;
run;
ods graphics / reset;


* Pie Chart with proc gchart... won't work in university edition;
Proc gchart data=mortality;
	*Pie Chart of Number of Deaths by Death Type using summary data;
	title4 "Example 2b: Pie Chart - Frequency by Cause of Death";
	title5 "[Cause of Death, Number of Deaths]";
	pie type /sumvar=death discrete slice=arrow noheading 
		otherlabel="Congenital Defect" other=2;
	*The default is if the pie piece is < 4%, it is labelled "OTHER". Since
			I already have an "Other" Category, I want to label the piece that 
			is less than (changing that default) 2% as "Congenital Defect";
	*other options: value=none percent=outside;
	run;




	