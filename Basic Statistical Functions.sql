/*
   Author : Md Moniruzzaman Monir
*/

-- Mean:   This is the “average” that you might know. It’s the sum of all of the numbers divided by the count of numbers. 
-- Median: This is the middle value of a list of numbers. 
-- Mode:   This is the value that occurs most often


/*
    Creating a table and inserting some numbers for finding the average, median and mode of those numbers :
    1,1,1,2,2,2,4,5,6,7,8,8 NULL
  
    NULL means unknown, so we can't assume it to be  0.
  
    Here, Mode    is = 1 & 2
          Median  is = 3
          Average is = (1+1+1+2+2+2+4+5+6+7+8+8)/12 = 3.92 (approximately)
*/

CREATE TABLE TEST (my_num  NUMBER);

INSERT INTO TEST VALUES (1);
INSERT INTO TEST VALUES (1);
INSERT INTO TEST VALUES (1);
INSERT INTO TEST VALUES (2);
INSERT INTO TEST VALUES (2);
INSERT INTO TEST VALUES (2);
INSERT INTO TEST VALUES (4);
INSERT INTO TEST VALUES (5);
INSERT INTO TEST VALUES (6);
INSERT INTO TEST VALUES (7);
INSERT INTO TEST VALUES (8);
INSERT INTO TEST VALUES (8);
INSERT INTO TEST VALUES (NULL);

COMMIT;

SELECT * FROM TEST;


--  AVG(), MEDIAN() and STATS_MODE()

--  NULL values are ignored by AVG(), MEDIAN() and STATS_MODE() functions.
--  Here, STATS_MODE() only returns one mode (lowest one) . So it is not true when we have two or more modes. 
--  In this case, both 1 & 2 are mode .


/*
            ************   AVG()  ********

 Return the avergae of a set of numbers. Exclude the NULL value while calculating avergae.

           ************   MEDIAN()  ********

The MEDIAN function can be used as either an "Analytic Function" or an "Aggregate Function".

The parameters of the MEDIAN function are:

expr (mandatory): The expression to calculate a median for. This can be a set of numbers, or a column.
query_partition_clause (optional): The clause that is used to partition the data when using MEDIAN as an analytic query.

The expr value can be any numeric data type. The MEDIAN function returns the same data type as the expr value.

If you specify the OVER clause, Oracle will work out the data type with the highest precedence and return that type.

Oracle Doc: https://docs.oracle.com/cd/B19306_01/server.102/b14200/functions086.htm

*/


SELECT
  COUNT ( * ) TOTAL_RECORDS,
  COUNT ( MY_NUM ) TOTAL_NON_NULL_RECORDS,
  ROUND ( AVG ( MY_NUM ), 2 ) AVERAGE,
  MEDIAN ( MY_NUM ) MEDIAN,
  STATS_MODE ( MY_NUM ) MODE_OF_NUMBERS
FROM
  TEST;


--   Use of these 3 functions as AGGREGATE FUNCTION in HR schema


SELECT
  NVL ( DEPARTMENT_ID, - 1 ) DEPT_ID,
  COUNT ( EMPLOYEE_ID ) NO_OF_EMPLOYEE,
  ROUND ( AVG ( SALARY ), 2 ) AVG_SAL,
  MEDIAN ( SALARY ) MEDIAN_SAL,
  STATS_MODE ( SALARY ) MODE_OF_SAL,
  MAX ( SALARY ) MAX_SAL,
  MIN ( SALARY ) MIN_SAL
FROM
  HR.EMPLOYEES
GROUP BY
  DEPARTMENT_ID;
  
  
/*
  How to find the mode when there are more than one mode (bi-modal or multi-modal)

  STATS_MODE takes as its argument a set of values and returns the value that occurs with the greatest frequency. If more than one mode exists, Oracle 
  Database chooses one and returns only that one value.

  To obtain multiple modes (if multiple modes exist), you must use a combination of other functions, as shown in the hypothetical query:

  SELECT x FROM (SELECT x, COUNT(x) AS cnt1
   FROM t GROUP BY x)
   WHERE cnt1 =
      (SELECT MAX(cnt2) FROM (SELECT COUNT(x) AS cnt2 FROM t GROUP BY x));
*/


SELECT my_num mode_of_numbers
FROM
 (SELECT my_num, count(my_num) AS cnt1 
  FROM TEST
  GROUP BY my_num
 )
WHERE cnt1 = 
      (SELECT MAX(num_frequency) 
       FROM
         (SELECT count(my_num) AS num_frequency
          FROM TEST
          GROUP BY my_num));



/*
  Use of WITH clause - Sub-query Factoring
*/

WITH TEMP AS (
   SELECT MY_NUM, COUNT(MY_NUM) AS NUM_FREQUENCY 
   FROM TEST 
   GROUP BY MY_NUM
)

SELECT MY_NUM MODE_OF_NUMBERS 
FROM TEMP
WHERE NUM_FREQUENCY =  (SELECT MAX(NUM_FREQUENCY) FROM TEMP );


/*
      Numbers in 'test" table :  1,1,1,2,2,2,4,5,6,7,8,8, NULL
      
      The SD of these numbers:-
      Sample Standard Deviation     = 2.7784342658586
      Population Standard Deviation = 2.6601482832521
     
      Distinct Numbers : 1,2,4,5,6,7,8,NULL
      Sample Standard Deviation     = 2.5634797778466

      The purpose of the STDDEV() function is to find the standard deviation of a set of numbers.
      It is a mathematical concept, which is a number that represents how much the values in a group differ from the mean 
      value in a group.

The syntax for the STDDEV function when it is used as an aggregate function is:

STDDEV ( [DISTINCT | ALL] expression )

Alternatively, the syntax when used as an analytical function is:

STDDEV ( [DISTINCT | ALL] expression ) [OVER (analytical_clause) ]

The parameters of the STDDEV function as an aggregate function are:

DISTINCT|ALL (optional): Using DISTINCT means that the function will only look at unique values. 
Using ALL means that all values will be considered.
expression (mandatory): The expression is the set of data or the column that is used in the STDDEV function.
The parameters of the STDDEV function as an analytical  function are the same, but also include:

Analytical_clause (optional): This is the clause or logic that is used to group the values for the STDDEV function.

*/


SELECT
  STDDEV ( MY_NUM ) STANDARD_DEVIATION
FROM
  TEST;
  
SELECT DISTINCT
  MY_NUM DISTINCT_NUMBERS
FROM
  TEST;
  
SELECT
  STDDEV ( DISTINCT MY_NUM ) DISTINCT_STANDARD_DEVIATION
FROM
  TEST;
