/*
   Author  : Md Moniruzzaman Monir
*/




/*                                   ~~~~~~~~~~~~~~~ CORR() ~~~~~~~~~~~~~
 
 * The Oracle CORR() function calculates the Pearson's correlation coefficient (r), which is the coefficient of correlation of a set of number pairs. 
   It can be used as an aggregate or analytic function.
   
 * Pearson's correlation coefficient reflects the degree of linear relationship between two variables. It ranges from +1 to -1.
 
 * A correlation of +1 means that there is a perfect positive "linear" relationship between variables. 
 
 * r is between 0.75 to 1 then perfect positive correlation.
   r is between -0.75 to -1 then perfect negative correlation.
 
 * r is between -0.25 to -0.75 or 0.25 to 0.75 then moderate correlation. 
   r is 0 then NO Correlation. 
   r is between 0 to 0.25 or 0 to -0.25 then very low correlation.

 * Requires atleast two rows and ignore NULL values

   https://en.wikipedia.org/wiki/Pearson_correlation_coefficient   [Very Good to understand what the value of r means]

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
    

  -- ASSOCIATION BETWEEN SALARY & COMMISSION IN EACH DEPARTMENT
  
    SELECT
      E.DEPARTMENT_ID DEPT_ID,
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
   
-- SH schema is used in this example. "SH Schema" is a Data Warehouse Schema from Oracle Sample Database Schema.

   -- Association Between Sale and Quantity
    
    SELECT
      T.CALENDAR_MONTH_NUMBER MONTH_NO,
      ROUND(CORR (SUM (S.AMOUNT_SOLD), 
      SUM (S.QUANTITY_SOLD)) OVER (ORDER BY T.CALENDAR_MONTH_NUMBER),2) AS "Sale and Quantity association" 
                          -- OVER() clause is explained below
    FROM
      SH.SALES S,
      SH.TIMES T
    WHERE
      S.TIME_ID  = T.TIME_ID AND CALENDAR_YEAR = 1998
    GROUP BY
      T.CALENDAR_MONTH_NUMBER;
  
--                                  ########     Window Functions   ########

/*
 Analytic functions compute an aggregate value based on a group of rows. 
 They differ from aggregate functions in that they return multiple rows for each group.
 
 Analytic functions also operate on subsets of rows, similar to aggregate functions in GROUP BY queries, 
 but they do not reduce the number of rows returned by the query.
 
 The group of rows is called a "WINDOW", and is defined by the analytic clause. For each row, a "sliding" window of rows is defined. 
 The window determines the range of rows used to perform the calculations for the "current row". 
 Window sizes can be based on either a physical number of rows or a logical interval such as time.

 Select MAX() OVER ()
 ~~~~~~~~~~~~~~~~~~~~~
    Here, The OVER() statement signals a start of an Analytic function. 
    That is what differentiates an Analytical Function from a regular Oracle SQL function.

 Select MAX() OVER (Partition by column)
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    The partioning clause is used to setup the group of data (window) upon which the Analytic function would work.

 Select MAX() OVER (Partition by 'column' order by 'column')
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     Order by clause specify the order of the rows in a window. 
     The Order by clause is a keyword in the Oracle Analytic syntax that is a requirement for using some Analytic functions

 Analytic Functions are the "last set of operations" performed in a query except for the final "ORDER BY" clause.

 All joins & all WHERE, GROUP BY, HAVING clauses are completed before the analytic functions are processed. 
 Therefore, analytic functions can appear only in the 'SELECT' list or 'ORDER BY' clause.

*/


    ----    RANK(), DENSE_RANK() and ROW_NUMBER()    -----
    
    CREATE TABLE TEMP (
      ID NUMBER,
      NAME VARCHAR2(20)
    );
    
    INSERT INTO TEMP VALUES (5, '*');
    INSERT INTO TEMP VALUES (2, '*');
    INSERT INTO TEMP VALUES (5, '*');
    INSERT INTO TEMP VALUES (3, '*');
    INSERT INTO TEMP VALUES (5, '*');
    INSERT INTO TEMP VALUES (3, '*');
    INSERT INTO TEMP VALUES (2, '*');
    INSERT INTO TEMP VALUES (4, '#');
    INSERT INTO TEMP VALUES (8, '#');
    INSERT INTO TEMP VALUES (4, '#');
    INSERT INTO TEMP VALUES (8, '#');
    INSERT INTO TEMP VALUES (4, '#');
    
    SELECT * FROM TEMP;
    
    SELECT
      ID, 
      NAME,
      DENSE_RANK ( ) OVER ( PARTITION BY NAME ORDER BY ID ) AS "DENSE RANKING",
      RANK ( )       OVER ( PARTITION BY NAME ORDER BY ID ) RANKING,
      ROW_NUMBER ( ) OVER ( PARTITION BY NAME ORDER BY ID ) AS "ROW NUMBER"
    FROM
      TEMP;
      

  /*  
    EMP and DEPT tables. Classic Oracle tables with 4 departments and 14 employees.
    The DDL scripts are taken from the Oracle Code Library 
  */

   CREATE
    TABLE DEPT
    (
      DEPTNO NUMBER   ( 2,0),
      DNAME  VARCHAR2 ( 14 ),
      LOC    VARCHAR2 ( 13 ),
      
      CONSTRAINT PK_DEPT PRIMARY KEY (DEPTNO)
    );


   CREATE
    TABLE EMP
    (
      EMPNO    NUMBER ( 4, 0 ),
      ENAME    VARCHAR2 ( 10 ),
      JOB      VARCHAR2 ( 9 ),
      MGR      NUMBER ( 4, 0 ),
      HIREDATE DATE,
      SAL      NUMBER ( 7, 2 ),
      COMM     NUMBER ( 7, 2 ),
      DEPTNO   NUMBER ( 2, 0 ),
      
      CONSTRAINT PK_EMP    PRIMARY KEY ( EMPNO ),
      CONSTRAINT FK_DEPTNO FOREIGN KEY ( DEPTNO ) REFERENCES DEPT ( DEPTNO )
    );

  -- Populate 'Dept' table

     INSERT ALL 
       INTO DEPT (DEPTNO, DNAME, LOC) VALUES(10, 'ACCOUNTING', 'NEW YORK') /* Insert row using named columns. */
       INTO DEPT VALUES(20, 'RESEARCH', 'DALLAS')                          /* Insert row by column position.*/
       INTO DEPT VALUES(30, 'SALES', 'CHICAGO')
       INTO DEPT VALUES(40, 'OPERATIONS', 'BOSTON')
     SELECT * FROM DUAL;

  -- Populate 'EMP' table
  
    INSERT ALL
       INTO EMP  VALUES( 7839, 'KING', 'PRESIDENT', NULL,  TO_DATE('17-11-1981','dd-mm-yyyy'),  5000, NULL, 10  )
       INTO EMP  VALUES( 7698, 'BLAKE', 'MANAGER', 7839,   TO_DATE('01-05-1981','dd-mm-yyyy'),  2850, NULL, 30  )
       INTO EMP  VALUES( 7782, 'CLARK', 'MANAGER', 7839,   TO_DATE('09-06-1981','dd-mm-yyyy'),  2450, NULL, 10  )
       INTO EMP  VALUES( 7566, 'JONES', 'MANAGER', 7839,   TO_DATE('02-04-1981','dd-mm-yyyy'),  2975, NULL, 20  )
       INTO EMP  VALUES( 7788, 'SCOTT', 'ANALYST', 7566,   TO_DATE('13-JUL-87','dd-mm-rr')-85,  3000, NULL, 20  )
       INTO EMP  VALUES( 7902, 'FORD',  'ANALYST', 7566,   TO_DATE('03-12-1981','dd-mm-yyyy'),  3000, NULL, 20  )
       INTO EMP  VALUES( 7369, 'SMITH',   'CLERK', 7902,   TO_DATE('17-12-1980','dd-mm-yyyy'),  0800, NULL, 20  )
       INTO EMP  VALUES( 7499, 'ALLEN','SALESMAN', 7698,   TO_DATE('20-02-1981','dd-mm-yyyy'),  1600, 300,  30  )
       INTO EMP  VALUES( 7521, 'WARD', 'SALESMAN', 7698,   TO_DATE('22-02-1981','dd-mm-yyyy'),  1250, 500,  30  )
       INTO EMP  VALUES( 7654, 'MARTIN','SALESMAN',7698,   TO_DATE('28-09-1981','dd-mm-yyyy'),  1250, 1400, 30  )
       INTO EMP  VALUES( 7844, 'TURNER','SALESMAN',7698,   TO_DATE('08-09-1981','dd-mm-yyyy'),  1500, 0,    30  )
       INTO EMP  VALUES( 7876, 'ADAMS',   'CLERK', 7788,   TO_DATE('13-JUL-87', 'dd-mm-rr')-51, 1100, NULL, 20  )
       INTO EMP  VALUES( 7900, 'JAMES',   'CLERK', 7698,   TO_DATE('03-12-1981','dd-mm-yyyy'),  950,  NULL, 30  )
       INTO EMP  VALUES( 7934, 'MILLER',  'CLERK', 7782,   TO_DATE('23-01-1982','dd-mm-yyyy'),  1300, NULL, 10  )
       INTO EMP  VALUES( 7930, 'MONIR',  'ADE', 7782,   TO_DATE('23-01-2017','dd-mm-yyyy'),  NULL, NULL, 10  )
    SELECT * FROM DUAL;

  --  Example of "Window Functions"

    SELECT 
       EMPNO, DEPTNO, SAL,
       ROUND( AVG(SAL) OVER () ) AS "Avg Sal of all employees",
       ROUND( AVG(SAL) OVER (PARTITION BY DEPTNO), 2) AS "Avg Sal by Department"
    FROM   EMP;
    

                             --    #############       FIRST_VALUE ( )      ###############

  /*
    The 'Order by' clause is used to order rows, or siblings, within a partition. 
    So, if an analytic function is sensitive to the order of the siblings in a partition you should include an 'Order by' clause. 
    The following query uses the FIRST_VALUE () function to return the first salary reported in each department.
    The function returns the first value in an ordered set of values.
    If the first value in the set is NULL, then it returns NULL unless you specify IGNORE NULLS.
    
  */

    
    SELECT EMPNO, 
           DEPTNO, 
           SAL, 
           FIRST_VALUE(SAL IGNORE NULLS) OVER (PARTITION BY DEPTNO) AS "FIRST SAL IN DEPT UNORDER"
    FROM   EMP
    WHERE DEPTNO = 10;
    
    
    SELECT EMPNO, 
           DEPTNO, 
           SAL, 
           FIRST_VALUE(SAL IGNORE NULLS) OVER (PARTITION BY DEPTNO ORDER BY SAL ASC NULLS LAST) AS "FIRST SAL IN DEPT ORDER"
    FROM   EMP
    WHERE DEPTNO = 10;
    
    
    -- SEE THE OUTPUT VERY CAREFULLY 
    
    SELECT 
       EMPNO, 
       DEPTNO, 
       SAL, 
       FIRST_VALUE(SAL IGNORE NULLS) OVER (PARTITION BY DEPTNO)  AS "DEPT FIRST SAL UNORDER",  -- DEFAULT ORDER IS :- ASC NULLS LAST
       
       FIRST_VALUE(SAL IGNORE NULLS) OVER (PARTITION BY DEPTNO ORDER BY SAL ASC  NULLS LAST)  AS "DEPT FIRST SAL ASC1",
       FIRST_VALUE(SAL IGNORE NULLS) OVER (PARTITION BY DEPTNO ORDER BY SAL ASC  NULLS FIRST) AS "DEPT FIRST SAL ASC2", 
       
       FIRST_VALUE(SAL IGNORE NULLS) OVER (PARTITION BY DEPTNO ORDER BY SAL DESC NULLS LAST)  AS "DEPT FIRST SAL DESC1",
       FIRST_VALUE(SAL IGNORE NULLS) OVER (PARTITION BY DEPTNO ORDER BY SAL DESC NULLS FIRST) AS "DEPT FIRST SAL DESC2"         
    FROM   EMP
    WHERE DEPTNO = 10
    ORDER BY 2 DESC;
    
