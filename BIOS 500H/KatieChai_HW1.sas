/**---------------------------------------------------------------------------**/
/*    Program:  KatieChai_HW1.sas
      Location: /home/u63543119/bios500H/Code_and_more/Homework/KatieChai_HW1.sas

/*     Programmer: Katie Chai
/*     Start Date: Sep 7, 2023

/**-----------------------------------------------------------------------**/

options mergenoby=warn nofmterr;

Title1    "BIOS 500H U1: Sampling - HW1: Low Body Weight";
footnote1 "produced by Katie Chai /home/u63543119/bios500H/Code_and_more/KatieChai_HW1.sas";
footnote2 "&systime, &sysdate";
run;
/*---- EXAMPLE LIBNAME STATEMENT ----------------------------------------------- /
/*    You only need ONE libname statement - edit this one (I'm using SAS OnDemand for Academics)
	   OR 
      You may want to look back the .sas code from previous class work to see 'which libname worked' for you.;
/*-------------------------------------------------------------------------------*/

libname bios500H "/home/u63543119/bios500H/Data";

proc format;     				
    * Create formats for the Sex variable and the Yes/No variables;
    * These variables will be stored as quantitative variables, and formats make the results easier to read;
	value sexf 	  1="Male"		
				  0="Female";
	value yes_nof 1="Yes"
	              0="No";
run;

/*-----------Part A/B: ACCESS THE BODY WEIGHT DATA SET N=100 -----------------------*/
data fullbwt;
	set bios500h.low_b_wt;
	label  sbp 	= "Systolic Blood Pressure"          
			 sex  	= "Gender"
             grmhem ="Germinal Matrix Hemorrhage"
			 tox	= "Tox"
			 gestage="Gestational Age (weeks)"
			 apgar5 = "APGAR Score (5 minutes)";	
	 format sex sexf. grmhem yes_nof. tox yes_nof.;  *the formats sexf. and yes_nof. were created	                                                   in section A above already using Proc Format;
run;

proc contents data=bios500h.low_b_wt;
run;

proc print data=fullbwt;
	* Print out, for fun, the entire body fat data set... 'the population' of 100 obs;
	title3 "Entire Body Weight Data Set, the population of N=100";
run;


proc means data=fullbwt n mean std median maxdec=4;
	*Compute PARAMETERS for full data set (the population);
	*Results are output to the RESULTS tab unless otherwise specified;
	title3 "Descriptive Values for the Entire Data Set (Parameters), the population of N=100";
run;

/*---------------Part C: Select SRS using Proc SURVEYSELECT-----------*/
proc surveyselect data=bios500h.low_b_wt method=SRS sampsize=20 seed=3107 
		out=srs_bwt;
	title3 "Select SRS of 20 observations, Using PROC SURVEYSELECT";
run;


proc print data=srs_bwt;
	title3 "20 Selected Observations, from SRS using PROC SURVEYSELECT Dataset= samp_bwt";
run;


proc means data=srs_bwt n mean std median maxdec=3;
	title3 "Descriptive Statistics for SRS of 20 observations, from Dataset= samp_bwt";
run;

/*----------- Select a STRATIFIED SAMPLE (srs within each of two stratum)----*/
data strat_bwt;
	set bios500h.low_b_wt;
run;

proc sort data=strat_bwt out=strat_bwt;
	*Sort by TOX;
	by TOX;
run;

proc print data=strat_bwt;
	title3 "Print out of entire body weight data set, sorted by TOX";
run;

proc means data=strat_bwt n mean std median;
	*Descriptive Info for Each Age Strata separately for FULL (population) data set;
	title3 "Descriptive Info (Parameters) for FULL data set (Population, N=100) by each Tox";
	by TOX;
run;

proc surveyselect data=strat_bwt out=strat_bwt seed=3107 method=srs 
		n=(10, 10);
	title3 "Select a Stratified Sample, using Proc Surveyselect";
	title4 "Strata: toxemia, 10 observations selected in each age category = 20 total observations";
	title5 "Dataset= strat_bwt";
	strata TOX;
run;

proc print data=strat_bwt;
	title3 "Printout of the n=20 observations in stratified sample";
run;

proc means data=strat_bwt n mean std median;
	*Descriptive Info for Each Age Strata separately for FULL (population) data set;
	title3 "Descriptive Info (Parameters) for Stratified data set (Population, N=100) by each Tox";
	by TOX;
run;

