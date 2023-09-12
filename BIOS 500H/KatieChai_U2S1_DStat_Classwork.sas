****PROGRAM:  KatieChai_U2S1_Dstat_classwork.sas
****DATE:     Sept 7, 2023
****PURPOSE:  Unit 2 Session 1. 
             Work classwork problems about Descriptive statistics and Histogram
             using "Health Care Expenditure" Data.
             
             
**** TO DO:  Students will need to copy example code from 
  		500_U2_DStatsGraphs Example Code.sas into this program.
  		We will just call that file "Example SAS Code"
  		Change that code, as appropriate, to answer the class work questions
  		regarding the Expenditure data set.
  		Here's enough to get you started! ;
  
         
** NOTE 1: 
         Recall you may want to put SAS into interactive mode (arrow type symbol)
	     to get the titles to 'carry over' and keep the log and results from resetting;
	     
** NOTE 2:  
		You got this!   It just takes some practice!  
		Programming can be frustrating.... approach it knowing that debugging
		takes time - and it is good to ask for help! 
		;
 
 title1 "Unit 2 Session 1:  Descriptive Stats and Graphs (Specifically making a histogram)"; 
 title2 "I am not getting frustrated with SAS.  It is making me stronger. ";
 


*****PROBLEM 1 CREATE THE EXPENDITURE DATA SET ********;
data expend; 	   *Create a temporary SAS data set called "expend" with health care 
               		expenditure per capita by country;
	input nation $12. expendpercap;  
	               *the default variable type is numeric...
	              'expendpercap' will be numeric because it has no info after the variable name
	              'nation' will be defined as character (denoted $) and allotted given 12 spaces;
	label expendpercap ="Expenditures Per Capita (US$)";  *label variable within a data step;
	datalines;
Australia	   1032
Austria	       1093
Belgium	       980
Britain	       836
Canada	       1683
Denmark	        912
Finland	       1067
France	       1274
Germany	       1232
Greece	       371
Iceland	       1353
Ireland	       658
Italy	       1050
Japan	       1035
Luxemburg      1193
Netherlands    1135
New_Zealand     820
Norway	       1234
Portugal       464
Spain	       644
Sweden	       1361
Switzerland    1376
US	           2354
;
run;


******CLASSWORK PROBLEM 2a; 
title3 "Health care expenditure per capita by country";
proc print;    * For Problem 2a of the classwork;
	run;

******CLASSWORK PROBLEM 2b; 	
title4 "Health care expenditure per capita by country sorted by expenditure";
proc sort;     *For Problem 2b of the classwork;
   by expendpercap;
  run;
   
proc print;    *For problem 2b of the classwork;
run;    
     
****CLASSWORK PROBLEM 2c:
         You'll find that Example code around "Example 3." 
		 After pasting the example code below, edit it to find the average expenditure for the 23 countries.;  
proc means data=expend maxdec=1 n mean std median q1 q3;
	*Example 3: Descriptive Statistics using proc means (gives less output than univariate);
	title4 "Example 3: Proc Means Output of all Observations";
	title5 "Analysis Variable: Expenditures Per Capita (US$)";
	title6 "N, Mean, Std Dev, Median, Lower Quartile, Upper Quartile";
	var expendpercap;
run;

ods graphics off;     * I like putting in this ODS statement because it will give you a stem and leaf plot; 
proc univariate data=expend plot;
	*Proc univariate gives more output than proc means;
	* Compute Descriptive statistics all observations in BP data set ;
	title4 "Example 3:  Proc Univariate Output Statistics of All Observations";
	var expendpercap;
run;
ods graphics on;
 
****CLASSWORK PROBLEM 3: COPY AND PASTE CODE HERE TO DO A HISTOGRAM HERE 
                        You will find it in Example 4: Histogram of DBP                                                    ''    								;
	*Demonstrates how to do ENDPOINT DESIGNATION
	*The 'noprint' option suppresses the statistics  but DOES NOT suppress the histogram in this example;


proc univariate data=expend noprint;
	title3 "Classwork Problem 3: Histogram of Expenditure per Capita";
	title4 "demonstrating SAS code for histogram with endpoint designation - similar to example 4";
	histogram expendpercap /endpoints=300 to 2400 by 100 odstitle=" " vaxislabel='Number of Countries' vscale=count;
	*left endpoint included by default for right endpoint keyword=rtinclude;
	*percent is default, keyword vscale=percent count or proportion;
	inset n='No. Obs.' mean='Mean Expenditure ($)' (7.0) 
		std='S.D. Expenditure ($)' (7.1)/header="Summary Stats" position=ne;
run;
	*ods html close;
	* See note in header about the formatting (5.1) - it basically rounds to five
		  	places, including the decimal. The .1 means to include the tenths place.
			Thus, (5.2) would include the hundredths place.;






  
      

