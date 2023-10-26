* proc printto log='/home/u63543119/BIOS511/Logs/lab6_730460523.log' new; run;

/****************************************************************************
*
* Project : BIOS 511 Lab 6
*
* Program name : lab6_730460523.sas
*
* Author : Katie Chai
*
* Date created : 2023-09-13
*
* Purpose : This program is designed to apply the key points of the lecture:
* 1) Using PROC MEANS to calculate simple statistics on numeric variables
* 2) Using PROC UNIVARIATE to calculate statistics and generate plots
* 
* Revision History :
*
* Note: Standard header taken from :
* https://www.phusewiki.org/wiki/index.php?title=Program_Header
****************************************************************************/

* %put %upcase(no)TE: Program being run by 730460523;
* options nofullstimer;

/* ------------------------LIBNAME------------------------*/
* assigns libref for class data;
LIBNAME classDat "/home/u63543119/my_shared_file_links/u49231441/Data" access=readonly;

* assigns libref for my data;
LIBNAME myDat "/home/u63543119/BIOS511/Data";

/* ------------------------DATA------------------------*/
* creates temp data set from sashelp.pricedata;
data priceData;
	set sashelp.pricedata;
run;

* creates temp data set from order_fact;
data orderFact;
	set classDat.order_fact;
run;

* creates temp data set from sas.orsales;
data orSales;
	set sashelp.orsales;
run;

* creates temp data set from budget;
data budge;
	set classDat.budget;
run;

/* ------------------------MEANS------------------------*/
* Question 1: Run a PROC MEANS step on the sashelp.pricedata data set;
title1 'PROC MEANS on Price data set';
title2 '(not including n, mean, min, or max)';
proc means data=priceData median mode kurtosis std Q1 Q3;
run;

* Question 2: Run a PROC MEANS step on the order_fact data set in the course data folder;
title1 'PROC MEANS on Order Fact data set';
title2 '(using CLASS statement and calculating count, sum, and mean for quality and cost price per unit variables)';
proc means data=orderFact n sum mean;
	class order_type;
	var quantity costprice_per_unit;
run;

* Question 3: Run a PROC MEANS on the sashelp.orsales data set;
proc means data=orSales noprint nway;
	where year=2000;
	class product_line product_category;
	var quantity profit total_retail_price;
	output sum=/autoname;
run;

* Question 4: Run a PROC PRINT on the data set generated in #3;
title1 'PROC PRINT on Or Sales data set';
title2 '(limited to highest_TYPE_value, subset to year 2000 for product line, category, and profit)';
proc print data=data1 noobs;
	where product_category='Golf' or product_category='Swim Sports';
	format profit_sum dollar12.2;
	var product_line product_category profit_sum;
run;

* Question 5: Modify your code from #3;
proc means data=orSales noprint nway;
	where year=2000;
	class product_line product_category;
	var quantity profit total_retail_price;
	output out=sumMeanData sum(profit total_retail_price)=Profit_Sum_Total Retail_Price_Sum mean(profit total_retail_price)=Profit_Mean Total_Retail_Price_Mean;
run;

/* ------------------------UNIVARIATE------------------------*/
* Question 6: Run a PROC UNIVARIATE on the budget data set in the course data folder;
proc sort data=budge out=budge;
	by department;
run;

title1 'PROC UNIVARIATE on Budget data set';
title2 '(by department for year 2017 with confidence limits information)';
proc univariate data=budge cibasic;
	by department;
	var yr2017;
run;

* Question 7: Create a histogram with PROC UNIVARIATE on the budget data set in the course data
folder;
title1 'PROC UNIVARIATE on Budget data set';
title2 '(histogram with department as classification var and year 2016 as analysis var and insets)';
proc univariate data=budge noprint;
	class department;
	histogram yr2016;
	inset mean std / position=ne;
run;

* proc printto; run;


