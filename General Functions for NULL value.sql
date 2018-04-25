
/*
   Author : Md Moniruzzaman Monir

*/

/*
   The following functions work with any data type and pertain to using nulls:
    • NVL(expr1, expr2)
    • NVL2(expr1, expr2, expr3)
    • NULLIF(expr1, expr2)
    • COALESCE(expr1, expr2, ..., exprn)
*/

/*
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