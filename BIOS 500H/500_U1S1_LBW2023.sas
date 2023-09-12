
/*-------------------------------------------------------------------------------------------*/
/* Program:    500_U1S1_LBW2023.sas            
/* Location:   Students will see it in SAS OnDemand under: 
                             /home/jmonaco/my_shared_file_links/jmonaco/Programs			
               It is also on my personal directory of:             
                            /home/jmonaco/bios500h/code_and_more )
               
/* PURPOSE/ GOALS:  	(Section A)
		1.	Set up some folders within your personal SAS workspace – copy files from common workspace to personal workspace
		2.	Create a temporary SAS data set from data “typed” or pasted  into a  .sas file that is provided-
		           using "datalines" statement. Also introduce creating and attaching formats!
		3.	“Explore” the data set /get some descriptive statistics with a “proc freq” and a “proc means” 
				(Section B)
		4.	Access data that are saved in a provided SAS dataset file (*.sas7bdat)  and save it to a new permanent sas data set that you could use later.  
				a.	Note that in this classwork we are accessing the same data in two ways: typed in a .sas program and saved as permanent data file
		5.	Not get too frustrated.         			 
/*

/* Programmer: Jane Monaco
/* Start Date:  August 23, 2010
/* Updated:  August 19, 2019 , minor tweeks.
             August 9, 2020 Lots of updates for Sas OnDemand.... til 2023 more updates

NOTE!: Path names are case sensitive and sometimes SAS uses "/" rather than "\" ...
to keep in things interesting.

(* Data originally from Leviton, "Labor and Delivery Characteristics 
and the Risk of Germinal Matrix Hemorrhage in Low Birth Weight Infants", 
Journal of Child Neurology, Vol 6, October 1991, 35-45. 
Table B-7 in Appendix of Pagano and Gauvreau.);
/*----------------------------------------------------------------------------------------*/

* This is a comment. It is green. It starts with a star and ends with semicolon;
/* This is also a comment.  Text in between backslashes and stars. */
options nofmterr;

Title1  "Bios 500- ClassWork.  Unit 1 Session 1";
Title2  "Getting Started in SAS";
Title3 	"Low Birth Weight Data - from Pagano/Gauvreau";


*here's a footnote ;
*you can change this footnote purple text inside the quotes with your own info -
*it is just text that is printed on the output and doesn't impact anything important :-);

footnote1 "produced by Katie Chai /home/u63543119/BIOS500H/Code_and_more/500_U1S1_LBW.sas"; 


*this footnote works in any installation;
footnote2 "&systime, &sysdate";
run;


/***********************************************************************************************/
/*------------------------------ SECTION A ----------------------------------------------------*/
/*         * Create a temporary set with low birth weight data call lbw_pt_A 
           using listing in this file ("datalines" statement) 
		   * Create formats and then attach formats to variables
		   * Create labels
           * Explore data using  PROC PRINT, PROC CONTENTS, PROC MEANS and PROC FREQ                                                             */   
/************************************************************************************************/

Proc format;     				
    * Create formats for the Sex variable and the Yes/No variables;
    * These variables will be stored as quantitative variables, and formats make the results easier to read;
	value sexf 	  1="Male"		
				  0="Female";
	value yes_nof 1="Yes"
	              0="No";
run;

data lbw_pt_A;     *Create a temporary SAS data set (called lbw_pt_A) with low birth weight data;
	input ID sbp sex  tox  grmhem   gestage apgar5; *Input seven variable names. All vars below are numeric.  
	                                                 If we had any character variables, 
	                                                 we would need to use $ symbol. 
	                                                 Example: "input fname $ lname $"; 
	format sex sexf. tox yes_nof. grmhem yes_nof.; *ATTACH the format (say sexf.) with the variable (like sex);
	                                               *For example, Patient 1 has sbp=43, sex=1, tox=0, gestage=29... 
	                                                and listing of data will report their
	                                                sex as "Male" and tox as "Yes" because these variables are formatted;
	label    sbp 	= "Systolic Blood Pressure"          
			 sex  	= "Gender"
             grmhem ="Germinal Matrix Hemorrhage"
			 tox	= "Tox"
			 gestage="Gestational Age (weeks)"
			 apgar5 = "APGAR Score (5 minutes)";  *Attach labels to the variables for readability :-);
	datalines;
1 	43 	1 	0 	0 	29 	7 	
2 	51 	1 	0 	0 	31 	8 	
3 	42 	0 	0 	0 	33 	0 	
4 	39 	0 	0 	0 	31 	8 	
5 	48 	0 	1 	0 	30 	7 	
6 	31 	1 	0 	1 	25 	0 	
7 	31 	1 	1 	0 	27 	7 	
8 	40 	0 	0 	0 	29 	9 	
9 	57 	0 	0 	0 	28 	6 	
10 	64 	0 	1 	0 	29 	9 	
11 	46 	0 	0 	0 	26 	7 	
12 	47 	0 	0 	1 	30 	6 	
13 	63 	0 	0 	0 	29 	8 	
14 	56 	0 	0 	0 	29 	1 	
15 	49 	1 	0 	0 	29 	8 	
16 	87 	1 	0 	0 	29 	7 	
17 	46 	0 	0 	0 	29 	8 	
18 	66 	0 	0 	0 	33 	8 	
19 	42 	0 	1 	0 	33 	8 	
20 	52 	0 	0 	0 	29 	7 	
21 	51 	1 	0 	0 	28 	7 	
22 	47 	0 	0 	0 	30 	9 	
23 	54 	1 	0 	0 	27 	4 	
24 	64 	1 	0 	0 	33 	9 	
25 	37 	0 	0 	0 	32 	7 	
26 	36 	1 	1 	0 	28 	3 	
27 	45 	0 	0 	1 	29 	7 	
28 	39 	1 	0 	0 	28 	7 	
29 	29 	0 	0 	0 	29 	4 	
30 	61 	0 	0 	0 	30 	3 	
31 	53 	1 	0 	0 	31 	7 	
32 	64 	0 	0 	0 	30 	7 	
33 	35 	0 	0 	0 	31 	6 	
34 	34 	1 	0 	0 	29 	9 	
35 	62 	0 	0 	0 	27 	7 	
36 	59 	0 	0 	0 	27 	8 	
37 	36 	1 	0 	0 	27 	9 	
38 	47 	0 	0 	0 	32 	8 	
39 	45 	1 	0 	1 	31 	2 	
40 	62 	0 	0 	1 	28 	5 	
41 	75 	1 	1 	0 	30 	7 	
42 	44 	1 	0 	0 	29 	0 	
43 	39 	1 	0 	0 	28 	8 	
44 	48 	0 	0 	1 	31 	7 	
45 	43 	0 	1 	0 	27 	6 	
46 	19 	0 	0 	1 	25 	4 	
47 	63 	1 	0 	0 	30 	7 	
48 	42 	1 	0 	0 	28 	6 	
49 	44 	0 	0 	0 	28 	9 	
50 	25 	0 	0 	0 	25 	8 	
51 	26 	0 	0 	0 	23 	8 	
52 	27 	1 	0 	0 	27 	9 	
53 	35 	1 	0 	0 	28 	8 	
54 	40 	1 	0 	0 	27 	7 	
55 	44 	0 	0 	0 	27 	6 	
56 	66 	1 	0 	0 	26 	8 	
57 	59 	0 	0 	0 	25 	3 	
58 	24 	0 	0 	0 	23 	7 	
59 	40 	0 	0 	1 	26 	3 	
60 	49 	0 	0 	0 	24 	5 	
61 	53 	1 	1 	0 	29 	9 	
62 	45 	0 	0 	0 	29 	9 	
63 	50 	1 	0 	1 	27 	8 	
64 	64 	1 	0 	0 	30 	7 	
65 	48 	0 	0 	0 	30 	6 	
66 	48 	0 	0 	1 	32 	4 	
67 	58 	0 	1 	0 	33 	7 	
68 	67 	0 	0 	0 	27 	8 	
69 	40 	0 	0 	1 	31 	8 	
70 	48 	0 	0 	0 	26 	8 	
71 	36 	1 	0 	0 	27 	5 	
72 	44 	1 	0 	0 	27 	6 	
73 	53 	0 	1 	0 	35 	9 	
74 	45 	0 	1 	0 	28 	6 	
75 	54 	1 	0 	0 	30 	8 	
76 	44 	1 	1 	0 	31 	2 	
77 	42 	1 	0 	0 	30 	5 	
78 	50 	0 	0 	0 	27 	0 	
79 	48 	0 	0 	0 	25 	5 	
80 	29 	0 	0 	1 	25 	5 	
81 	30 	0 	0 	1 	26 	2 	
82 	36 	0 	0 	0 	29 	0 	
83 	44 	0 	0 	0 	29 	0 	
84 	46 	0 	1 	0 	34 	9 	
85 	51 	1 	1 	0 	30 	4 	
86 	51 	1 	0 	0 	29 	5 	
87 	43 	1 	1 	0 	33 	7 	
88 	48 	1 	0 	0 	30 	5 	
89 	52 	1 	0 	0 	29 	8 	
90 	43 	1 	0 	0 	24 	6 	
91 	42 	1 	1 	0 	33 	8 	
92 	48 	1 	0 	1 	25 	5 	
93 	49 	0 	1 	0 	32 	8 	
94 	62 	1 	1 	0 	31 	7 	
95 	45 	1 	0 	0 	31 	9 	
96 	51 	0 	1 	1 	31 	6 	
97 	52 	1 	0 	0 	29 	8 	
98 	47 	1 	1 	0 	32 	5 	
99 	40 	0 	1 	0 	33 	8 	
100 50 	0 	0 	0 	28 	7 	
;
run;



proc print data=lbw_pt_A;       *Print out all observations and variables from the dataset lbw_pt_A;  
	title4 "This is a PROC PRINT of LBW Data (N=100 Observations)";
	run;
    

proc contents data=lbw_pt_A;  *Prints some summary items about the data set - 
                              For example, you can find number of observations and variables 
                              with a proc contents;
	 title4 "This is a PROC CONTENTS of LBW Data";
	 run;
	

proc freq data=lbw_pt_A;      *Calculate the frequency of each gender and each gestational age; 
	title4 "This is a PROC FREQ of LBW Data"; *Proc freq is great to summarize discrete or nominal data;
	tables sex gestage;
	run;

proc means data=lbw_pt_A maxdec=1 n mean std median;     *Compute the average of the "Gestage" variable;
 	title4 "This is a PROC MEANS of LBW Data";
 	var gestage;
 	run;   

	*Congrats!  You have run some SAS code! ;
	*------------------End of Section A-------------------------------------------- ;
	
*So lbw_pt_A dataset above was "typed into the code" and used a "datalines" statement; 
*Now, we will practice another way to get the same data into SAS... 
	  reading data for a sas data set stored in an external file ; 



/****************************************************************************************/
/*--------------------------------SECTION B --------------------------------------------*/
*         * Now practice reading data from a permanent data set called low_b_wt.sas7bdata 
          * "Subset" the data - meaning just keep the boy observations
          * Then write a smaller (permanent) file (called new_boy) back out to your personal space
          * Thus you will now have two permanent dataset files:  low_b_wt and new_boy
/*****************************************************************************************/ 
/****************************************************************************************/

*MORE EXPLANATION:
In Section A, we read in data using a "datalines" statement within the sas program.
   Below we will experiment with reading in a sas data set (low_b_wt.sas7bdat) that is stored as data 
   file in your personal space

This data set/data file has the SAME data values (100 low birth weight babies) that you've been working 
   with above.  

To access dataset location, we use a "libname" statement to associate a particular path 
    ( a location on the left) to a shorthand label (like "bios500H").  
    "Libname" is short for library name. 
       
Two libname examples are given in Instruction #1, if you are using the SAS OnDemand Install. 
     (Other examples for different "installs" are at the bottom of this file)      
     You will need to EDIT one to match YOUR directory structure where you copied the sas data set. 
     For this program you'll only need ONE libname statement.  
     (You can comment out the one you don't need or  just ignore/don't run the libname 
     statements you don't need)
      ;

/**************************/
/***** Instruction #1 *****/
/**************************/
* EXAMPLE LIBNAME STATEMENTS for SAS OnDemand;
 
Title4 "SECTION B: Read in the LBW Data which was Stored in Permanent File";  

*OPTION 1 PREFERRED... this links the name "bios500H" to my personal path where I have the dataset;	
libname bios500H "/home/jmonaco/bios500h/Data"; *the path is case sensitive;
              *More info on the classwork handout... basically change this statement to your
              directory structure like : libname bios500H "/home/yourname/bios500h/Data"
	run;                                        

*OR
*OPTION 2 access data set from shared drive;
*libname shared "/home/jmonaco/my_shared_file_links/jmonaco/Data"; 


/**************************/
/***** Instruction #2 *****/
/**************************/
Title5 "Yeah!  I've accessed these data from the permanent sas file in my directory";
title6 "100 observations stored as low_b_wt.sas7bdat";
proc print data=bios500h.low_b_wt;  *Use this one if you are using Option 1 - data is in your personal space;  
	run;  
	
*OR ; 
*proc print data=shared.low_b_wt; *Use this one if you using Option 2 - accessing data from shared drive;
	*run;

*!!You will need to change just ONE libname statement to YOUR directory structure!!;
                
* You may need to rerun the proc format above if you get a format error;

/**************************/
/***** Instruction #3 *****/
/**************************/
*Now, "subset" the dataset. Keep only the boys ****;
data temp_boy;              *CREATE temporary data set: temp_boy;
	set bios500h.low_b_wt;  *READ IN the data from this path  (libname=bios500h) named low_b_wt;  	
    *The set statement answers “from where” – the data statement answers “to where”;
	where sex=1;            *KEEPs only the boys observations;    
	label  sbp 	= "Systolic Blood Pressure"          
			 sex  	= "Gender"
             grmhem ="Germinal Matrix Hemorrhage"
			 tox	= "Tox"
			 gestage="Gestational Age (weeks)"
			 apgar5 = "APGAR Score (5 minutes)";	
	 format sex sexf. grmhem yes_nof. tox yes_nof.;  *the formats sexf. and yes_nof. were created
	                                                   in section A above already using Proc Format;
run;
	

proc print data=temp_boy;       *Print out all 44 observations of boys only;
								* See how temp_boy is a one level name? 
								It is temporary, stored in Webwork library and will disappear
								  when this SAS session ends;
	title5 "I got this data set from the perm sas file in my directory! Yeah!" ;
	title6 "I'm printing the TEMPORARY JUST BOYS n=44:  temp_boy";
	run;	
	
Proc univariate data=temp_boy;
	title6 "Here are some descriptive stats for GESTATIONAL AGE for the n=44 boys in lbw dataset ";
		var gestage;
	run;


/**************************/
/***** Instruction #4 *****/
/**************************/
* HERE'S HOW TO SAVE A TEMPORARY DATA SET TO A PERMANENT ONE! ; 

data bios500h.perm_boy; set temp_boy; 
	run;
*Creates a permanent data set (perm_boy)  using temp_boy. 
	*The DATA statement says to create a data set called "perm_boy" - it will 
	*be a permanent data set in the path that is referenced by  the libname "Bios500h."
	*The SET statement answers “from where” – the DATA statement answers “to where”;
	*This code is sort of like "Save As"-- take temp_boy and save it as perm_boy in the path bios500h. 


*After you run these statements, you can look in the folders on the left (>Server files and folder)
       to see if "perm_boy" has been created in 
       the path you specified by the libname "bios500h".;


/**************************/
/***** Instruction #5 *****/
/**************************/
*Using the code above as an example- now repeat to just 'keep the girl observations' 

*Edit the code (replace the ??? with the right thing) to save only the girl observations 
*and compute descriptive stats on n=54 girls; 
 data temp_girl;            *CREATE temporary data set: temp_girl;
	set bios500h.low_b_wt;  *READ IN the data from this path  (libname=bios500h) named low_b_wt;  
	where sex=0;            *KEEP only the girl observations;    
	label  sbp 	= "Systolic Blood Pressure"          
			 sex  	= "Gender"
             grmhem ="Germinal Matrix Hemorrhage"
			 tox	= "Tox"
			 gestage="Gestational Age (weeks)"
			 apgar5 = "APGAR Score (5 minutes)";
	
	 format sex sexf. grmhem yes_nof. tox yes_nof.;  *the formats sexf. and yes_nof. were created
	                                                   in section A above already using Proc Format;
run;     
   
 	
Proc univariate data=temp_????;
	title6 "Here are some descriptive stats for GESTATIONAL AGE for the n=?? ???? in lbw dataset ";
		var gestage;
	run;  
	
	
* You are done!  Great job!  
* You have read data from an external file, "subsetted" the data to just the boys (or girls),
and saved that smaller data set to a permanent SAS data set you could use later.; 




/*******************************************************************
NOTE ABOUT FORMAT ERRORS:   Sometimes you may need this statement: 
             options nofmterr; run; 

If the dataset on the hard drive has formats already associated with it, but you don't know what the
the formats are, then just keep this statement in mind; 
We don't need it today becaure we ran a formatting statement in Section A, 
but if you get "a format error" in your log, try the
"options nofmterr;" statement  
*******************************************************************/
 


*******************-----APPENDIX------ *******************;
*You'll only need these if you are using an Install different from SAS OnDemand;

*Examples FOR SAS FULL INSTALL: Use one of these (or similar) if SAS installed locally;
       *libname bios500h "C:\Users\monaco\Documents\2019BIOS500H\SASFiles"; 
       

