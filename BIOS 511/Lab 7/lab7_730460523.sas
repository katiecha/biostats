proc printto log='/home/u63543119/BIOS511/Logs/lab7_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 7
*
* Program name : lab7_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-09-18
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) Generating reports with PROC REPORT
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

/* ------------------------Question 1------------------------*/
* create temp data set from learn_modalities;
data learnModalities;
	set classDat.learn_modalities;
run;

* proc report with specific conditions (where, col); 
title1 'PROC REPORT on Learn Modalities data set';
title2 'displays only the first 25 observations,';
title3 'subset to obs from South Dakota,';
title4 'with cols for district name, learning modality, and num of student,';
title5 'and spanning header';
proc report data=learnModalities (obs=25);
	where state='SD';	
	column district_name ('Learning and Student Information' learning_modality student_count);
run;

/* ------------------------Question 2------------------------*/
* create temp data set from shoes;
data shoes;
	set sashelp.shoes;
run;

* proc report with specific conditions (col, define...group/max/min); 
title1 'PROC REPORT on Shoes data set';
title2 'with cols for region, product, *returns, and inventory,';
title3 'grouping region and product,';
title4 'with max stat for returns,';
title5 'and min stat for inventory';
proc report data=shoes;	
	column region product returns inventory;
	define region / group;
	define product / group;
	define returns / 'Max Returns' max;
	define inventory / 'Min Inventory' min;
run;


/* ------------------------Question 3------------------------*/
* create temp data set from budget;
data budget;
	set classDat.budget;
run;

* proc report with specific conditions (col, define...across); 
title1 'PROC REPORT on Budget data set';
title2 'including department and years 2017-2019,';
title3 'using department vars as headers';
proc report data=budget;
	column department, (yr2017 yr2018 yr2019);
	define department / '' across;
run;

/* ------------------------Question 4------------------------*/
* create temp data set from employee_donations;
data employeeDonations;
	set classDat.employee_donations;
run;

* proc report with specific conditions (col, define...group/format/style); 
title1 'PROC REPORT on Employee Donations data set';
title2 'cols for paid by, quarter 1, quarter 2, quarter 3, and quarter 4,';
title3 'with dollar8. format for quarter vars';
title4 'and light green background for quarter 3 column';
proc report data=employeeDonations;
	column paid_by qtr1 qtr2 qtr3 qtr4;
	define paid_by / group;
	define qtr: / format=dollar8.;
	define qtr3 / style(column)=[background=lightgreen];
run;

/* ------------------------Question 5------------------------*/
* create temp data set from cars;
data cars;
	set sashelp.cars;
run;

* proc report with specific conditions (col, define...group/across); 
title1 'PROC REPORT on Cars data set';
title2 'using origin as a grouping var,';
title3 'using type as col headers,';
title4 'requesting n stat under type,';
title5 'supressing label printing for all three report items,';
title6 'and no dots for missing values';
options missing = '0';
proc report data=cars;
	column origin type, n;
	define origin / '' group;
	define type / '' across;
	define n / '';
run;

proc printto; run;