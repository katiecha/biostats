/**---------------------------------------------------------------------------**/
/*    Program:  500_U1_Sampling Example 2023.sas
      Location: /home/u63543119/bios500H/Code_and_more/500_U1S2_Sampling Example  2023.sas

/*     Purpose: PARTS A,B,C: To demonstrate example code for selecting a SRS (several methods)
                             Students are given the POPULATION data set (n=252) and asked to select samples
                PART D: To demonstrate selecting a STRATIFIED SAMPLE and (You may OMIT FOR 2022:unbiased
                        estimate for an average.)
                PART E: Import data from excel (.csv) to a sas data set (temp or permanent)
                        
.

/*     Programmer: Katie Chai
/*     Start Date: August 29, 2023
/*     Updated:    Lots of times for various purposes :-)...August 2020 for SAS On Demand, 
                   misc updates for clarity including in 2023

/*     Data: /home/u63543119/bios500H/Data/body_fat.sas7bdat
			also available /home/u63543119/my_shared_file_links/jmonaco/Data/body_fat.sas7bdat
/*                     252 observations, 16 variables:
/* 			ID,
/* 			Und_dens="Underwater Density"
/*   		Abd2_Cir= "Abdomen 2 Circum (cm)"
/*   		Age="Age (years)"
/*     		Bodyfat="Body Fat (%)"
/*	 		Ank_cir="Ankle Circum (cm) "
/*    		Chestcir="Chest Circum (cm)"
/*   		EBic_cir="Extend Biceps Circum (cm)"
/*   		FArm_Cir="Forearm Circum (cm)"
/*    		Height=  "Height (cm)"
/*     		Hip_cir=  "Hip Circum (cm)"
/*   		Knee_cir="Knee Circum (cm)"
/*   		Neck_cir= "Neck Circum(cm)"
/*    		Thighcir= "Thigh Circum (cm)"
/*    		Weight="Weight (kg)"
/*			Wristcir="Wrist Circum (cm)";
/**-----------------------------------------------------------------------**/
options mergenoby=warn nofmterr;

Title1    "Bios 500H-Unit 1, Sampling:Unit 1 Session 2 - Body Fat Data";
footnote1 "produced by Katie Chai /home/u63543119/bios500H/Code_and_more/500_U1S2_Sampling Example  2023.sas";
footnote2 "&systime, &sysdate";
run;
/*---- EXAMPLE LIBNAME STATEMENT ----------------------------------------------- /
/*    You only need ONE libname statement - edit this one (I'm using SAS OnDemand for Academics)
	   OR 
      You may want to look back the .sas code from previous class work to see 'which libname worked' for you.;
/*-------------------------------------------------------------------------------*/

libname bios500H "/home/u63543119/bios500H/Data";
	*Reminder:  What does a libname statement do? Creates a nickname for a long path
	            If you are in "noninteractive mode"  you can see the libraries in 
	            the left hand window near the bottom; 
libname shared "/home/u63543119/my_shared_file_links/jmonaco/Data"; 


proc format;
	* Formats the age category variable ;
	* Creates label (age_catf) so that 1 is associated with Young, 2 with Old;
	* We will need it later.... when we create a new VARIABLE with two level called age_cat;
	* The code doesn't create a variable... it only creates a LABEL for a variable we will create later;
	value age_catf 1="Young" 
                   2="Old";
run;

/*-----------ACCESS THE BODY FAT (POPULATION) DATA SET N=252 -----------------------*/
data fullbfat;
	set bios500h.body_fat;
	* Remember, the set statement answers “from where” – the data statement answers “to where”;
	* So this code creates a TEMPORARY data set (fullbfat) from the PERMANENT one (bios500h.body_fat);	
    * We can identify permanent data sets by that "two level" name;
    * Why create that temporary dataset?  because we don't want to modify (mess up) the permanent data set
      stored on the hard drive: fullbfat we can play with and it will be gone when we end this sas session;
run;


proc sort data=fullbfat;
	by id;
	* This procedure sorts the dataset =fullbfat.
	* Since no other data set is specified, the new sorted data set will overwrite
      the unsorted one... and still be called fullbfat;
run;


proc print data=fullbfat;
	* Print out, for fun, the entire body fat data set... 'the population' of 252 obs;
	title3 "Print out of entire body fat data set, the population of N=252";
run;


proc means data=fullbfat n mean std median maxdec=4;
	*Compute PARAMETERS for full data set (the population);
	*Results are output to the RESULTS tab unless otherwise specified;
	title3 "Descriptive Values for the Entire Data Set (Parameters), the population of N=252";
run;


*Using the KEEP statement to keep just a few variables;
data fullbfat;
	set fullbfat;
	*This code just pulls data in from the 'set statement'and writes it back out to same name
	 using the 'data statement' -overwriting the original;
	*In other words, since the same data set is in the data statement and the set statement, 
     the dataset will be overwritten;  
     *fullbfat is a temp data set - it has a one level name;
	*Below just KEEPs a few variables (columns) for simplicity and of course keeps all observations (rows);
	keep id age bodyfat weight height;
run;


/*----------------------------------------------------------------------------------*/
/*---------- THREE WAYS TO SELECT A SRS (Parts A, B, C) ----------------------------*/
/*                 These methods were in the lectures... here's the code!           */
/*----------------------------------------------------------------------------------*/

/*----------- PART A. Select SRS of APPROXIMATELY 5% of the population -------------*/
*Most straightforward (unglamorous) way to select SRS, but exact sample size is not specified;
*Called Method 5 in the notes; 
title3 "Different ways to select a SRS";
title4 "PART A. Select Approximately 5% SRS from Full Dataset, Called samp_bf1, using RANUNI() function";

data samp_bf1;
	set fullbfat;
	* Select a SRS of approximately 5% of full dataset;
	* See the "data new set old" syntax? the new dataset is samp_bf1, and the old one is fullbfat;
	rannum=ranuni(3107);

	if rannum <0.05;
	* ranuni(seed) where the seed is arbitrary but allows reproducible results;
	* the seed is just an arbitrary number, I used my office number, some folks use their bday or current date/time;
	* ranuni(seed) generates a random number between 0 and 1;
	* the "if" statement is called a "subsetting if" - it keeps only observations where
      the rannum is less than 0.05 (or about 5%);
run;

/* This code does exactly the same thing as above
and it was presented in the lectures:             
*data samp_bf1; set fullbfat; 	     * Select a SRS of approximately 5% of full dataset;
*where ranuni(2018) <0.05;		     * Uses a 'subsetting where' statement;
*run; */


proc print data=samp_bf1;
	title6 "Printout of Selected Observations in the Sample,  DATASET=samp_bf1";
	var id age bodyfat weight height rannum;
run;


proc means data=samp_bf1 n mean std median maxdec=3;
	*Compute statistics for sample data set of 5% of observations;
	title6 "Calculate Descriptive statistics for SRS stored in DATASET = samp_bf1";
	var age bodyfat weight height;
run;


/*---------------PART B. Select SRS using Proc SURVEYSELECT-----------*/
* Easy way to select a SRS using proc surveyselect;
*  Called METHOD 6? in the notes;

proc surveyselect data=bios500h.body_fat method=SRS sampsize=10 seed=3107 
		out=samp_bf2;
	*Sample size=10, arbitrary seed=my office number, 
	 The new data set will be a temporary data set called samp_bf2;
	title4 "PART B. Select SRS of 10 observations, Using PROC SURVEYSELECT";
run;


proc print data=samp_bf2;
	Title6 "Print the 10 selected observations, from SRS using PROC SURVEYSELECT Dataset= samp_bf2";
	var id age bodyfat weight height;
run;


proc means data=samp_bf2 n mean std median maxdec=3;
	*Compute statistics for sample data set of 10 observations;
	title6 "Calculate Descriptive statistics for SRS of 10 observations, from Dataset= samp_bf2";
	var age bodyfat weight height;
run;


/*---------------- PART C.  Another way to select SRS, using Proc Sort----------*/
* Each observation is assigned a random number, the data set
  is sorted by the random number, then select the first "n";
* This one is called Method 4 in the notes. ;


data wrandom;
	set bios500h.body_fat;
	rannum=ranuni(0123);
	* Assign a random number to each observation;
	* Seed is an arbitrary value I used my birthday, jan 23;
run;


proc sort data=wrandom;
	* Sort the data set by the random number column;
	by rannum;
run;


proc print data=wrandom;
	title4 "Print Out of All Observations Sorted by Random Number";
	run;
	
	
title4 "PART C: Select a SRS, by Sorting by Uniform Random Number, keeping only 10 obs. New Dataset= samp_bf4";
data samp_bf4;	
	set wrandom (obs=10);     * SRS is just the first 10 observations of the sorted dataset;
	* Keep the first 10 observations in the data set and drop the random number;
	* This is helpful code.... how to keep just the first, say, 10 observations;
	keep id age bodyfat weight height;
	*Keep only certain variable;
run;

proc print data=samp_bf4;
	title5 "Print Out of Sample (SRS) of n=10 ";
run;

proc means data=samp_bf4 n mean std median maxdec=4;
	*Compute statistics for sample data set of 10 observations;
	title5 "Descriptive statistics for SRS of 10 observations";
run;



/*--------------PART D:  STRATIFIED SAMPLING--------------------*/
*			 Now, select a stratified random sample
*			 and calculate an unbiased estimate of the 
*			 % body fat two ways (by hand and w proc surveymeans/;
*			 We create a NEW VARIABLE called age_cat where 1 is young and 2 is old;
/*---------------------------------------------------------------*/
title3 "PART D:  STRATIFIED Sampling Examples";
*We start with ALL the observations... the Population;

data fullbfat;
	set fullbfat;
	if age<=45 then
				age_cat=1;	
	else
				age_cat=2;
				*Makes a NEW VARIABLE called age_cat for age category where Young (<=45), Old (>45);
	p_weight=weight;
	*Change the variable name for weight to p_weight for patient weight;
	drop weight;
	*Drop variable WEIGHT so that it isn't confused with sampling weight;
	
	format age_cat age_catf.;   * "Attach" the format to the variable;
	label p_weight="Patient Weight (kg.)";
run;


proc sort data=fullbfat out=fullbfat;
	*Sort by age and id;
	by age_cat id;
run;


proc means data=fullbfat n mean std median;
	*Descriptive Info for Each Age Strata separately for FULL (population) data set;
	title5 "Descriptive Info (Parameters) for FULL data set (Population, N=252) by each Age Category";
	by age_cat;
	*Must have sorted the data first by age_cat to get results 'by age_cat';
	var bodyfat;
	*Want descriptive statistics for the bodyfat variable;
run;


/*----------- Select a STRATIFIED SAMPLE (srs within each of two stratum)----*/
* The procedure will select 12 observations from each strata;

proc surveyselect data=fullbfat out=samp_stratbf seed=500 method=srs 
		n=(12, 12);
	* data is the input dataset called fullbfat, out is the output data set with 24 obs called samp_stratbf,
    * Where did the 500 come from?  an arbitrary number - i used 500 for the 500h class number;
    * Method is srs within each strata and n is number selected in each strata;
	title5 "Select a Stratified Sample, using Proc Surveyselect";
	title6 "Strata: age categories, 12 observations selected in each age category = 24 total observations";
	title7 "Dataset= samp_stratbf";
	strata age_cat;
run;

proc print data=samp_stratbf;
	title8 "Printout of the n=24 observations in stratified sample";
run;



/*----OMIT FOR 2023 for "by hand calculations" with stratified sample for classwork -------*/
proc means data=samp_stratbf n mean;
	*Calculate descriptive statistics separately for EACH AGE CATEGORY;
	title8 "Descriptive Statistics for Each Age Category SEPARATELY from Stratified Sample";
	title9 "for calculating unbiased estimate by hand";
	*This will give values for 'by hand' calculation;
	by age_cat;
	var bodyfat;
run;

/*----OMIT FOR 2023 To calculate an unbiased estimate with SAS for stratified sample -------*/
* This procedure actual "does the weighting for you" :-);

proc surveymeans data=samp_stratbf mean;
	*Calculate an unbiased estimate of bodyfat using stratified sample;
	title8 "Descriptive statistics from Stratified Sample using PROC SURVEYMEANS";
	title9 "Using Sampling weights to compute unbiased estimate";
	var bodyfat;
	strata age_cat;
	weight SamplingWeight;
	*see hand out for examplanation of sampling weight which is computed automatically in above code;
run;



/*--------------PART E: Reading in Data from Excel to SAS data set----------*/
*  				Goals: 	Read in data  from an EXCEL (.csv) file into a SAS data set 
  							either through point-and-click or provided code (which IS what point-and-click is creating)
  				   		And Save a temp data set to a permanent data set.
*------------------------------------------------------------------------*;

*This code takes the Excel file HealthCareExpend.csv (stored in your personal file directory)
	and creates a temporary SAS data set called "HCE_SAS" ; 
	
*	 POINT-AND-CLICK: Right click HealthCareExpend.csv select >Import Data
					The defaults should be fine for now
					Near the bottom of the window, you should see generated code that looks similar to mine below
					You can run that code from that  window or copy and paste it below and run from this program
					The default is to create a sasdataset called WORK.IMPORT... a temp data set in the WORK library called IMPORT
					Interactive made uses WEBWORK rather that WORK;
*    EDIT THE CODE BELOW: My code below is pretty much like the code created from point-and-click;	

FILENAME REFFILE '/home/u63543119/bios500H/Data/HealthCareExpend.csv';
	*The above statement tells sas where to find the csv file and calls it REFFILE for reference file
	 You would need to change the path to your own directory structure;

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=HCE_SAS
	REPLACE;
	GETNAMES=YES;
	
RUN;
*This statement takes the REFFILE, which has type .csv, and creates a temporary sas data set
      called HCE_SAS in the the "WORK" library which is a temporary library;

PROC PRINT DATA=HCE_SAS;
RUN;  * Just check that the HCE_SAS data set look ok... 23 observations and 2 variables.;

Proc means data=hce_sas;
run;

* Want to save HCE_SAS a permanent dataset?  Here's the code: ;
Data bios500H.hce_SAS; set HCE_SAS;  
*Could also use "set WORK.HCE_SAS"....or "set WEBWORK.HCE_SAS" depending on where the temporary data are stored
 ....it is the same thing;
*remember SET asks "from where" and DATA asks "to where";
run; 


	
********Want to save a temp data set to a permanent one? Here's some code general code ************;

data bios500h.newperm;
	          set oldtemp;
*Note two level names are permanent, like bios500h.newperm (except when the libraries are WORK or WEBWORK)
	where bios500H is a libname you've associated with a path/directory
    oldtemp is not surprisingly an existing temporary dataset ; 
	

/*--------------END OF PART E --------------------------*/




	
	
	
	

/*------------------HOMEWORK COMMENT maybe not needed 2022------------*/
*Students may need this code for the U1 homework
to calculate descriptive statistics for a certain subset of observations- specifying certain ids;

proc means data=fullbfat maxdec=3;
	where id in (1, 5, 10);
run;




/*-------WHY DO I USE INTERACTIVE MODE? WHAT THE DIFFERENCE ? ------------*/
* Just personal preference.  
 Interactive mode let's the  LOG and OUTPUT run without
 resetting.  THis has a some good attributes- 
 For example, the 'titles' work correctly (dont reset)and you don't need to
 rerun code - SAS 'remembers' what already been run.


 However, a downside is the output is only html.
 Sometimes, I'll use interative mode while editing and working on a program.
 Then, when everything is working correctly, I run the whole thing a final time
 in non-interactive mode - and I can change the output to, say, rtf or pdf.
 Interactive: uses WEBWORK library as temporary library
 NON Interactive: uses WORK library as temporary library
 ---------------------------------------------------------------------------*/


/*----------------ODS COMMENTS/CODE: ODS = Output Delivery System-----*/
* you may find some of my old slides or old code and lectures include ODS statements...
*Since SAS 9.4, you probably won't need the ods statements much.  
 Just comment them out
 Starting in 9.4 the output goes to an HTML window and can be 
 manipulated there;
*BUT,  if you need to output to, say, a pdf... here's some code: ;
ods html close;
ods pdf file="/home/jmonaco/bios500h/Code_and_more/20200810output.pdf";
		*insert the programming statements that produce the output here;
		* and the ods statements are like a sandwich around the procs;

ods pdf close;




/*--------SOME COMMENTS ABOUT OUTPUT (HTML vs. PDF vs. RTF)---------*/
*In SAS Studio the output (results) is in html if you are
 working in "interactive" mode.   
 There are a couple of work arounds if you don't want output in html.
 You can switch from 'interactive mode' into 'noninteractive mode"
 (interactive icon looks like an "Arrow" near the  XX icon. Hover over it to 
 help find it. )
 
 Or you can copy from the .html  and paste into a 
 blank document (like a .docx) and manipulate from there. 
 
 Or you can change your preferences: >Preferences >Results >....
 
 Or lots of other workarounds.... like using ods.... above.  

*In SAS full install, things are easy.... just  "save as pdf"
 or "save as html" or rtf etc.

-----------------------------------------------------------------------;

