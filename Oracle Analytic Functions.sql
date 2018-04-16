/*
   Author  : Md Moniruzzaman Monir
   Purpose : To show the use of ANALYTIC FUNCTIONS
*/




/*
 ************************************** CORR() *****************************
 
 * The Oracle CORR() function calculates the Pearson's correlation coefficient (r), which is the coefficient of correlation of a set of number pairs. 
   It can be used as an aggregate or analytic function.
   
 * Pearson's correlation reflects the degree of linear relationship between two variables. It ranges from +1 to -1.
 
 * A correlation of +1 means that there is a perfect positive linear relationship between variables. 
 
 * If r is between 0.75 to 1 then perfect positive correlation. r is between -0.75 to -1 then perfect negative correlation.
 
 * r is between -0.25 to -0.75 or 0.25 to 0.75 then moderate correlation. r is 0 then NO Correlation. r is between 0 to 0.25 or 0 to -0.25 then very low correlation

 * Requires atleast two rows and ignore NULL values

   https://en.wikipedia.org/wiki/Pearson_correlation_coefficient [Very Good to understand what the value of r means]

*/


  --  Use of NVL and FETCH FIRST N ROWS 
  
    SELECT 
      SALARY, 
      NVL (COMMISSION_PCT, 0) COMMISSION_PCT
    FROM 
      HR.EMPLOYEES 
    ORDER BY 1, 2
      FETCH FIRST 5 ROWS ONLY;

  -- CORR() Function
  
    SELECT 
      ROUND ( CORR(SALARY, NVL (COMMISSION_PCT, 0)), 2 ) AS "CORRELATION BETWEEN SAL-COMM" 
    FROM 
      HR.EMPLOYEES;
    
 

  -- SALARY_COMMISSION_ASSOCIATION IN EACH DEPARTMENT
  
    SELECT
      E.DEPARTMENT_ID Dept_ID,
      E.JOB_ID JOB,
      ROUND ( CORR ( E.SALARY, E.COMMISSION_PCT ), 2 ) AS "SALARY_COMMISSION_ASSOCIATION"
    FROM
      HR.EMPLOYEES E
    WHERE
      E.DEPARTMENT_ID      IS NOT NULL
      AND E.COMMISSION_PCT IS NOT NULL
    GROUP BY
      E.DEPARTMENT_ID,
      E.JOB_ID
    ORDER BY
      E.DEPARTMENT_ID ASC,
      E.JOB_ID DESC;
    
    

  --SH schema is used in this example. "SH schema" is a data warehouse schema (star schema model)

    --Sale and Quantity Association
    
    SELECT
      t.calendar_month_number Month_No,
      round(CORR (SUM (s.amount_sold), SUM (s.quantity_sold)) OVER (ORDER BY t.calendar_month_number),2) AS "Sale and Quantity association"
    FROM
      SH.sales s,
      SH.times t
    WHERE
      s.time_id  = t.time_id AND calendar_year = 1998
    GROUP BY
      t.calendar_month_number;
  
--                                               ########       Window Functions   ########

/*
 Analytic functions compute an aggregate value based on a group of rows. They differ from aggregate functions in that they return multiple rows for each group.
 Analytic functions also operate on subsets of rows, similar to aggregate functions in GROUP BY queries, but they do not reduce the number of rows returned by the query.
 
 The group of rows is called a WINDOW and is defined by the analytic clause. For each row, a "sliding" window of rows is defined. 
 The window determines the range of rows used to perform the calculations for the "current row". 
 Window sizes can be based on either a physical number of rows or a logical interval such as time.

 Select MAX() OVER ()
 
   Here, The OVER() statement signals a start of an Analytic function. That is what differentiates an Analytical Function from a regular Oracle SQL function.

 Select MAX() OVER(partition by field1)
 
   The portioning clause is used to setup the group of data that the Analytic function would be applied to.

 Select MAX() OVER(Partition by field order by)
   
   Order by specify the order of the window in the group by statement. The Order by clause is a keyword in the Oracle Analytic syntax that is requirement for using some Analytic functions

 Analytic functions are the last set of operations performed in a query except for the final ORDER BY clause.

 All joins and all WHERE, GROUP BY, and HAVING clauses are completed before the analytic functions are processed. 
 Therefore, analytic functions can appear only in the select list or ORDER BY clause.

*/

