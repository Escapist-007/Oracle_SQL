/*
   Author : Md Moniruzzaman Monir
*/

-- use of CASE expression and DECODE() function
-- The CASE expression complies with the ANSI SQL. The DECODE function is specific to Oracle syntax. 


/*           
           CASE EXPRESSION 
        ======================
        
  CASE expr WHEN comparison_expr1 THEN return_expr1
            [WHEN comparison_expr2 THEN return_expr2
             WHEN comparison_exprn THEN return_exprn
             ELSE else_expr] 
  END
  

  Oracle server searches for the first WHEN ... THEN pair for which expr is equal to comparison_expr and returns return_expr. 
  If none of the WHEN ... THEN pairs meet this condition, and if an ELSE clause exists, then the Oracle server returns 
  else_expr. 
  
  Otherwise, the Oracle server returns a null. You cannot specify the literal NULL for all the return_exprs and the else_expr. 
  All of the expressions ( expr, comparison_expr, and return_expr) must be of the same data type, which can be CHAR, VARCHAR2, 
  NCHAR, or NVARCHAR2.

*/



/*
  Problem Statement :
  ===================
  If JOB_ID is IT_PROG,  the salary increase is 10%; 
  If JOB_ID is ST_CLERK, the salary increase is 15%; 
  If JOB_ID is SA_REP,   the salary increase is 20%. 
  For all other job roles, there is no increase in salary.
  
*/

SELECT 
     LAST_NAME, 
     JOB_ID, 
     SALARY,
     (CASE JOB_ID 
          WHEN 'IT_PROG'  THEN  1.10*SALARY
          WHEN 'ST_CLERK' THEN  1.15*SALARY
          WHEN 'SA_REP'   THEN  1.20*SALARY
          ELSE SALARY 
     END) "REVISED_SALARY",
     (CASE 
          WHEN SALARY<5000 THEN 'Low' 
          WHEN SALARY<10000 THEN 'Medium' 
          WHEN SALARY<20000 THEN 'Good' 
          ELSE 'Excellent' 
      END) QUALIFIED_SALARY
FROM HR.EMPLOYEES;
