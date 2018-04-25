
/*
   Author : Md Moniruzzaman Monir

*/

/*
   The following functions work with any data type and pertain to using nulls:
    • NVL(expr1, expr2)
    • NVL2(expr1, expr2, expr3)
    • NULLIF(expr1, expr2)
    • COALESCE(expr1, expr2, ..., exprn)

        NVL (expr1, expr2)
        
In the syntax:
  • expr1 is the source value or expression that may contain a null
  • expr2 is the target value for converting the null
  
We can use the NVL function to convert any data type, but the return value is always the same as the data type of expr1.
*/


SELECT
  LAST_NAME,
  SALARY,
  NVL ( HIRE_DATE, '01-JAN-97' ) HIRE_DATE,
  NVL ( JOB_ID, 'No Job Yet' )   JOB_ID,
  NVL ( COMMISSION_PCT, 0 ),
  ( SALARY * 12 ) + ( SALARY * 12 * NVL ( COMMISSION_PCT, 0 ) ) ANN_SAL
FROM
  HR.EMPLOYEES;
  
  
/*
  The NVL2 function examines the first expression. If the first expression is not null, the NVL2 function returns the second expression. 
  If the first expression is null, the third expression is returned. 

  Syntax: NVL2 (expr1, expr2, expr3)

  In the syntax:
    • expr1 is the source value or expression that may contain a null
    • expr2 is the value that is returned if expr1 is not null
    • expr3 is the value that is returned if expr1 is null
  
  The argument expr1 can have any data type. The arguments expr2 and expr3 can have any data types except LONG. 
*/

SELECT
  DEPARTMENT_ID,
  LAST_NAME,
  SALARY,
  COMMISSION_PCT,
  NVL2 ( COMMISSION_PCT, 'SAL+COMM', 'SAL' ) INCOME
FROM
  HR.EMPLOYEES
WHERE
  DEPARTMENT_ID IN ( 50, 80 ) ;
  
/*
  Syntax: NULLIF (expr1, expr2)

  The NULLIF ( ) function is logically equivalent to the following CASE expression. 
        
        CASE 
           WHEN expr1 = expr2 THEN NULL 
           ELSE expr1 
        END
  
   Here, If expr1 is NULL then the function will return NULL
*/

SELECT
  FIRST_NAME,
  LENGTH ( FIRST_NAME ) "expr1",
  LAST_NAME,
  LENGTH ( LAST_NAME ) "expr2",
  NULLIF ( LENGTH ( FIRST_NAME ), LENGTH ( LAST_NAME ) ) RESULT
FROM
  HR.EMPLOYEES;

SELECT
  FIRST_NAME
  ||' '
  || LAST_NAME ENAME,
  COMMISSION_PCT,
  NULLIF ( COMMISSION_PCT, 0 )
FROM
  HR.EMPLOYEES;
  
  
/*
  The COALESCE function returns the first non-null expression in the list.
  
  Syntax : COALESCE (expr1, expr2, ... exprn)
  
  In the syntax:
    • expr1 returns this expression if it is not null
    • expr2 returns this expression if the first expression is null and this expression is not null
    • exprn returns this expression if the preceding expressions are null
  
  Note that all expressions must be of the same data type.

*/


    /* TO_CHAR function is applied so that all expressions are of the same data type. */

SELECT
  LAST_NAME,
  EMPLOYEE_ID,
  COMMISSION_PCT,
  MANAGER_ID,
  COALESCE ( TO_CHAR ( COMMISSION_PCT ), TO_CHAR ( MANAGER_ID ),'No commission and no manager' ) COALESCE_OUPUT
FROM
  HR.EMPLOYEES;

/* 
  For the employees who do not get any commission, your organization wants to give a salary increment of $2,000 and for employees who get commission, 
  the query should compute the new salary that is equal to the existing salary added to the commission amount.
*/


SELECT
  LAST_NAME,
  SALARY,
  COMMISSION_PCT,
  COALESCE ( ( SALARY + ( COMMISSION_PCT * SALARY ) ), SALARY + 2000, SALARY ) "New Salary"
FROM
  HR.EMPLOYEES;
  

  /*
     Predefined collections :
    ---------------------------
    If I need to generate 3 rows called AAA, BBB, CCC, I could use dual and union all. 
    Another method is to use "Extensibility Types" (e.g. ODCIVarchar2List [Stores varrays of VARCHAR2s], ODCINumberList [Stores varrays of NUMBERs] etc )
  
  */

SELECT 'AAA' FROM dual
  UNION ALL
SELECT 'BBB'FROM dual
  UNION ALL
SELECT 'CCC' FROM dual;


SELECT * 
FROM 
TABLE(SYS.ODCIVARCHAR2LIST('AAA','BBB','CCC'));

/* Another Example */
SELECT 
  COLUMN_VALUE X 
FROM  
  TABLE(SYS.ODCIVARCHAR2LIST('X',NULL,'Y',-1));
  
  
  /* At a glance */

WITH
  X AS
  (
    SELECT
      COLUMN_VALUE X
    FROM
      TABLE ( SYS.ODCIVARCHAR2LIST ( 'X', NULL ) )
  )
  ,
  Y AS
  (
    SELECT
      COLUMN_VALUE Y
    FROM
      TABLE ( SYS.ODCIVARCHAR2LIST ( 'Y', NULL ) )
  )
  ,
  Z AS
  (
    SELECT
      COLUMN_VALUE Z
    FROM
      TABLE ( SYS.ODCIVARCHAR2LIST ( 'Z', NULL ) )
  )
SELECT
  X,
  Y,
  Z,
  NVL ( X, Y ),
  NVL2 ( X, Y, Z ),
  COALESCE ( X, Y, Z )
FROM
  X, Y, Z;
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
