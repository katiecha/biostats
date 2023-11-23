proc printto log='/home/u63543119/BIOS511/Logs/lab22_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 22
*
* Program name : lab22_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-11-15
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) Directly inputting data
* 2) Reading raw data files
* 3) Importing data files
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
ods pdf file='/home/u63543119/BIOS511/Output/lab22_730460523.pdf';

/* ------------------------Question 1------------------------*/
/* This goal of this task is to import the country.dat file in the course folder using
PROC IMPORT. */

* Write a FILENAME statement that assigns a fileref with the country.dat file;
filename coun '/home/u63543119/my_shared_file_links/u49231441/Data/country.dat';

proc import datafile=coun out=country dbms=dlm replace;
    delimiter='!';
    getnames=no;
run;

/* ------------------------Question 2------------------------*/
/* With a DATA step, modify the data set created in #1. */
data country_import;
    set country;
    rename var1=countryabbrev var2=countryname;
    label countryabbrev='Country Abbreviation' countryname='Country Name';
run;

/* ------------------------Question 3------------------------*/
/* The goal of this task is to read in the country.dat file in the course data folder using
a DATA step. */
data country_data;
	infile coun dlm='!';
	length countryabbrev $2 countryname $20;
    input countryabbrev countryname;
	label countryabbrev='Country Abbreviation' countryname='Country Name';
run;

/* ------------------------Question 4------------------------*/
/* Run a PROC COMPARE between the data sets created in #2 and #3. It is ok if it shows
difference with informats. */
title1 'Difference between data sets created in #2 and #3';
title2 'PROC COMPARE (base=country_import, compare=country_data)';
proc compare base=country_import compare=country_data;
run;

/* ------------------------Question 5------------------------*/
/* Data like the country information from #1 and #3 are often used to create user-defined
formats. The analysis data sets often contain just a code and a separate file contains the
mappings from code to a useful value. The goal of this task is to create a format from
the variables in the data set. */

* Using the data set from #1: Create a new data set;
data country_format;
    set country_import;
    start = countryabbrev;
    label = countryname;
    retain fmtname "$cnty";
run;

* Use the following PROC FORMAT code to generate a format;
proc format cntlin=country_format lib=work
	fmtlib;
run;

/* ------------------------Question 6------------------------*/
/* Create a data set, using DATALINES, that holds your class schedule. */
data katie_schedule;
    infile datalines dlm=',';
    length ClassName $20 SectionType $10 Building $50 Room $10 DayOfWeek $9 StartTime $5;
    input ClassName SectionType Building Room DayOfWeek StartTime time8.;
    label ClassName = 'Class Name'
          SectionType = 'Section Type'
          Building = 'Building'
          Room = 'Room Number'
          DayOfWeek = 'Day of Week'
          StartTime = 'Class Start Time';
    format StartTime time.;

datalines;
BIOS 511, Lecture, McGavran - Greenberg Hall, 2306, Monday, 09:05
BIOS 511, Lab, McGavran - Greenberg Hall, 2306, Monday, 10:10
SPHG 351, Lecture, Michael Hooker Research Center, 0001, Monday, 12:20
COMP 301, Lecture, Hamilton Hall, 0100, Tuesday, 08:00
COMP 455, Lecture, Sitterson Hall, 0014, Tuesday, 14:00
HBEH 748, Lecture, Remote, Remote, Tuesday, 17:30
BIOS 511, Lecture, McGavran - Greenberg Hall, 2306, Wednesday, 09:05
BIOS 511, Lab, McGavran - Greenberg Hall, 2306, Wednesday, 10:10
SPHG 351, Lecture, Michael Hooker Research Center, 0001, Wednesday, 12:20
COMP 301, Lecture, Hamilton Hall, 0100, Thursday, 08:00
COMP 455, Lecture, Sitterson Hall, 0014, Thursday, 14:00
SPHG 351, Lecture, Michael Hooker Research Center, 0001, Friday, 12:20
;
run;

/* ------------------------Question 7------------------------*/
/* Print the data set created in #6. */

* The order of the observations should be: day of week, start time;
proc sort data=katie_schedule;
    by DayOfWeek StartTime;
run;

title1 'My Class Schedule';
title2 'PROC PRINT (data=katie_schedule)';
proc print data=katie_schedule noobs label;
run;

/* ------------------------CLOSING------------------------*/
ods pdf close;

proc printto; run;