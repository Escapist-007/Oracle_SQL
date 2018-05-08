/*
   Author : Md Moniruzzaman Monir
   Email  : moniruzzaman.023.bd.buet@gmail.com


       Basic Functions for storing Date value
  ===================================================
  
  The Date and Timestamp data types are used for storing and manipulating the "date and time" values. These are quite complicated 
  compared to the other data types as they require a special format for storage and processing.
  
  Oracle allows us to perform arithmetic operations on the Date and Timestamp data types.
*/
    
-- Fetch the current date and time as 'Date' data type but shows only the date portion

  SELECT
    currDate 
  FROM
    DUAL; 
  

-- For showing both the date and time portion

  SELECT
    TO_CHAR (currDate , 'DD-MON-YYY HH24:MI:SS') currDate _TIME
  FROM
    dual;
  
  
-- Extract only date value from date field. Need TRUNC() function

  SELECT
    TO_CHAR ( TRUNC (currDate  ), 'DD-MON-YYY HH24:MI:SS') currDate _TIME
  FROM
    dual;


/*
       ---  Date ---
       
The Date data type can be used for storing fixed length "date-time",  which includes Date, Month, Year, Hours, Minutes and Seconds. 
The Oracle server's date can be retrieved by querying the SYSDATE function. 

The date format is set by the NLS_DATE_FORMAT initialization parameter. The default format of date in Oracle is 
DD-MON-YY HH:MI:SS AM  ( *** )

In 'Date' data type, there are two parts : Date part & Time part. But, oracle doesn't show the 'time' part when we query 
the 'Date' data type column. It only shows the date portion.
  
*/


-- TO_CHAR() function is the most flexible way for converting and extracting different parts from date data type

  SELECT
    TO_CHAR ( currDate , 'YYYY')     AS YEAR,
    TO_CHAR ( currDate , 'MM' )      AS MONTH,
    TO_CHAR ( currDate , 'DD' )      AS DAY,
    TO_CHAR ( currDate , 'HH24' )    AS HOUR,
    TO_CHAR ( currDate , 'MI' )      AS MINUTE,
    TO_CHAR ( currDate , 'YYYYQMM' ) AS TIME_KEY
  FROM
    dual;



/*
     ---  Timestamp  ---

The Timestamp data type is an extension of the Date data type with an additional Fraction for a precise date storage and retrieval. 
The Oracle server's Timestamp can be retrieved by querying the SYSTIMESTAMP function. The Timestamp format is set by the 
NLS_TIMESTAMP_FORMAT initialization parameter. The default format of Timestamp in Oracle is DD-MON-YY HH:MI:SS:FF9 AM ( *** )
       
--  Correctly handle 'DATE' data type in queries for filtering using date type column ***
--  Problem Link : https://stackoverflow.com/questions/4876771/how-to-correctly-handle-dates-in-queries-constraints

 As oracle does not show the 'time part' of DATE data type, so it is not true that two date type columns are equal if they show same 
 value. Because the date portion may be same which is showing but the time portion is different. This creates problems when we filter 
 using date type column.
 
*/

-- Here, we have to put the current date in lieu of '28-mar-18'

  SELECT
  CASE
    WHEN TRUNC ( currDate  ) = TO_DATE ( '28-mar-18', 'DD-MON-YY' )
    THEN '1'
    ELSE '0'
  END FLAG0
  FROM
  dual;
  
  
  SELECT
  CASE
    WHEN currDate  = TO_DATE ( '28-mar-18', 'DD-MON-YY' )
    THEN '1'
    ELSE '0'
  END FLAG1
  FROM
  dual;
  
  
  SELECT
  CASE
    WHEN currDate  = TO_DATE ( '28-mar-18' )
    THEN '1'
    ELSE '0'
  END FLAG2
  FROM
  dual;

-- Showing 4 digit year

  SELECT
    TO_CHAR ( currDate , 'MM/DD/YYYY' ) mydate
  FROM
    dual;
