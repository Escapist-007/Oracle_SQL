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


    ----    RANK(), DENSE_RANK() and ROW_NUMBER()    -----
    
    CREATE TABLE temp (
      ID NUMBER,
      NAME VARCHAR2(20)
    );
    
    INSERT INTO temp VALUES (5, '*');
    INSERT INTO temp VALUES (2, '*');
    INSERT INTO temp VALUES (5, '*');
    INSERT INTO temp VALUES (3, '*');
    INSERT INTO temp VALUES (5, '*');
    INSERT INTO temp VALUES (3, '*');
    INSERT INTO temp VALUES (2, '*');
    INSERT INTO temp VALUES (4, '#');
    INSERT INTO temp VALUES (8, '#');
    INSERT INTO temp VALUES (4, '#');
    INSERT INTO temp VALUES (8, '#');
    INSERT INTO temp VALUES (4, '#');
    
    SELECT * FROM temp;
    
    SELECT
      ID, NAME,
      DENSE_RANK ( ) OVER ( PARTITION BY NAME ORDER BY ID ) dense_ranking,
      RANK ( ) OVER ( PARTITION BY NAME ORDER BY ID ) ranking,
      ROW_NUMBER ( ) OVER ( PARTITION BY NAME ORDER BY ID ) row_number
    FROM
      temp;
      

  /*  
    EMP and DEPT tables.  Classic Oracle tables with 4 departments and 14 employees. 
    The DDL scripts are taken from the Oracle Code Library 
  */

   Create
    Table DEPT
    (
      Deptno Number ( 2, 0 ),
      Dname  Varchar2 ( 14 ),
      Loc    Varchar2 ( 13 ),
      
      Constraint Pk_Dept Primary Key ( Deptno )
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
      
      CONSTRAINT PK_EMP PRIMARY KEY ( EMPNO ),
      CONSTRAINT FK_DEPTNO FOREIGN KEY ( DEPTNO ) REFERENCES DEPT ( DEPTNO )
    );

  -- Populate Dept table

   INSERT ALL 
     INTO dept (deptno, dname, loc) VALUES(10, 'ACCOUNTING', 'NEW YORK')  /* Insert row into DEPT table using named columns. */
     INTO dept VALUES(20, 'RESEARCH', 'DALLAS')                           /* Insert a row into DEPT table by column position.*/
     INTO dept VALUES(30, 'SALES', 'CHICAGO')
     INTO dept VALUES(40, 'OPERATIONS', 'BOSTON')
   SELECT * FROM dual;

  -- Populate EMP table
  
    INSERT ALL
     into emp  values( 7839, 'KING', 'PRESIDENT', null,  to_date('17-11-1981','dd-mm-yyyy'),  5000, null, 10  )
     into emp  values( 7698, 'BLAKE', 'MANAGER', 7839,   to_date('01-05-1981','dd-mm-yyyy'),  2850, null, 30  )
     into emp  values( 7782, 'CLARK', 'MANAGER', 7839,   to_date('09-06-1981','dd-mm-yyyy'),  2450, null, 10  )
     into emp  values( 7566, 'JONES', 'MANAGER', 7839,   to_date('02-04-1981','dd-mm-yyyy'),  2975, null, 20  )
     into emp  values( 7788, 'SCOTT', 'ANALYST', 7566,   to_date('13-JUL-87','dd-mm-rr')-85,  3000, null, 20  )
     into emp  values( 7902, 'FORD',  'ANALYST', 7566,   to_date('03-12-1981','dd-mm-yyyy'),  3000, null, 20  )
     into emp  values( 7369, 'SMITH',   'CLERK', 7902,   to_date('17-12-1980','dd-mm-yyyy'),  0800, null, 20  )
     into emp  values( 7499, 'ALLEN','SALESMAN', 7698,   to_date('20-02-1981','dd-mm-yyyy'),  1600, 300,  30  )
     into emp  values( 7521, 'WARD', 'SALESMAN', 7698,   to_date('22-02-1981','dd-mm-yyyy'),  1250, 500,  30  )
     into emp  values( 7654, 'MARTIN','SALESMAN',7698,   to_date('28-09-1981','dd-mm-yyyy'),  1250, 1400, 30  )
     into emp  values( 7844, 'TURNER','SALESMAN',7698,   to_date('08-09-1981','dd-mm-yyyy'),  1500, 0,    30  )
     into emp  values( 7876, 'ADAMS',   'CLERK', 7788,   to_date('13-JUL-87', 'dd-mm-rr')-51, 1100, null, 20  )
     into emp  values( 7900, 'JAMES',   'CLERK', 7698,   to_date('03-12-1981','dd-mm-yyyy'),  950,  null, 30  )
     into emp  values( 7934, 'MILLER',  'CLERK', 7782,   to_date('23-01-1982','dd-mm-yyyy'),  1300, null, 10  )
     into emp  values( 7930, 'MONIR',  'ADE', 7782,   to_date('23-01-2017','dd-mm-yyyy'),  null, null, 10  )
    SELECT * FROM dual;

  --  Example of Window functions

    SELECT 
       EMPNO, DEPTNO, SAL,
       ROUND( AVG(SAL) OVER () ) AS "Avg Sal of all employees",
       ROUND( AVG(SAL) OVER (PARTITION BY DEPTNO), 2) AS "Avg Sal by Department"
    FROM   EMP;
    

                                --    #############               FIRST_VALUE ( )      ###############

  /*
    The order_by_clause is used to order rows, or siblings, within a partition. 
    So, if an analytic function is sensitive to the order of the siblings in a partition you should include an order_by_clause. 
    The following query uses the FIRST_VALUE function to return the first salary reported in each department.
    
  */
    
    SELECT EMPNO, 
           DEPTNO, 
           SAL, 
           FIRST_VALUE(SAL IGNORE NULLS) OVER (PARTITION BY DEPTNO) AS FIRST_SAL_IN_DEPT_UNORDER
    FROM   EMP
    WHERE DEPTNO = 10;
    
    
    SELECT EMPNO, 
           DEPTNO, 
           SAL, 
           FIRST_VALUE(SAL IGNORE NULLS) OVER (PARTITION BY DEPTNO ORDER BY SAL ASC NULLS LAST) AS FIRST_SAL_IN_DEPT_ORDER
    FROM   EMP
    WHERE DEPTNO = 10;
    
    
    -- SEE THE OUTPUT CAREFULLY :D .  Ordering is same for both first_value() function !  
    
    SELECT EMPNO, 
           DEPTNO, 
           SAL, 
           FIRST_VALUE(SAL IGNORE NULLS) OVER (PARTITION BY DEPTNO) AS FIRST_SAL_IN_DEPT_UNORDER,
           FIRST_VALUE(SAL IGNORE NULLS) OVER (PARTITION BY DEPTNO ORDER BY SAL ASC NULLS LAST) AS FIRST_SAL_IN_DEPT_ORDER
    FROM   EMP
    WHERE DEPTNO = 10;
    






