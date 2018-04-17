  /*    TIME DIMENSION CREATION */

 CREATE
  TABLE DIM_TIME
  (
    ID         NUMBER ( 10 ) PRIMARY KEY,
    BEGIN_DATE DATE,
    END_DATE   DATE,
    MONTH      VARCHAR2 ( 5 ),
    MONTH_INT  NUMBER ( 2 ),
    QUARTER    NUMBER ( 1 ),
    YEAR       VARCHAR2 ( 4 ),
    YEAR_INT   NUMBER ( 4 )
  )

  
  
    /*       INSERT MONTHLY (MONTH - GRANULARITY)    */

 INSERT INTO 
       DIM_TIME (ID, Begin_Date, End_Date, Month, Month_Int, Quarter, Year, Year_Int) 

 WITH TIME_RANGE AS 
 (
  SELECT
     TO_DATE ( '01-Jan-2016', 'DD-MON-YYYY' ) Start_Date, -- 01 JANUARY, 2016
     SYSDATE End_Date
  FROM
     DUAL
 )
 SELECT
       TO_NUMBER (TO_CHAR(ADD_MONTHS(TIME_RANGE.Start_Date,(LEVEL-1)),'YYYYQMM')) ID,

       ADD_MONTHS(TIME_RANGE.Start_Date,(LEVEL-1))             Month_Begin_Date,
       LAST_DAY( ADD_MONTHS(TIME_RANGE.Start_Date,(LEVEL-1)) ) Month_End_Date,

       to_char( ADD_MONTHS(TIME_RANGE.Start_Date,(LEVEL-1)),'MON' )           Month , 
       to_number( to_char(ADD_MONTHS(TIME_RANGE.Start_Date,(LEVEL-1)),'MM'))  Month_Int,

       to_char(ADD_MONTHS(TIME_RANGE.Start_Date,(LEVEL-1)),'q')               Quarter,   
       to_char(ADD_MONTHS(TIME_RANGE.Start_Date,(LEVEL-1)),'YYYY')            Year,
       to_number(to_char(ADD_MONTHS(TIME_RANGE.Start_Date,(LEVEL-1)),'YYYY')) Year_Int

 FROM TIME_RANGE
 CONNECT BY ( LEVEL - 1 ) <= MONTHS_BETWEEN ( SYSDATE, TIME_RANGE.Start_Date);
  
  
  
  
    /*      INSERT QUARTERLY (QUARTER - GRANULARITY)   */


  INSERT INTO 
        DIM_TIME (ID, Begin_Date, End_Date, Month, Month_Int, Quarter, Year, Year_Int) 

  WITH TIME_RANGE AS
  (
   SELECT
      TO_DATE ( '01-Jan-2016', 'DD-MON-YYYY' ) Start_Date, 
      SYSDATE End_Date
   FROM
      DUAL
  )
  SELECT
        TO_NUMBER (TO_CHAR(ADD_MONTHS(TIME_RANGE.Start_Date,(LEVEL-1)*3),'YYYYQ')) ID,

        ADD_MONTHS(TIME_RANGE.Start_Date,(LEVEL-1)*3)   Quarter_Begin_Date,

        CASE 
          WHEN TO_CHAR (SYSDATE, 'YYYYQ') = TO_CHAR ( LAST_DAY ( ADD_MONTHS ( TIME_RANGE.Start_Date,(LEVEL-1)*3 + 2) ), 'YYYYQ') 
            THEN LAST_DAY (SYSDATE)
          ELSE 
             LAST_DAY( ADD_MONTHS ( TIME_RANGE.Start_Date,(LEVEL-1)*3 + 2) )
        END Quarter_END_DATE,

        'N/A' Month , 
         -1   Month_Int,

        to_char(ADD_MONTHS(TIME_RANGE.Start_Date,(LEVEL-1)*3),'q')               Quarter,   
        to_char(ADD_MONTHS(TIME_RANGE.Start_Date,(LEVEL-1)*3),'YYYY')            Year,
        to_number(to_char(ADD_MONTHS(TIME_RANGE.Start_Date,(LEVEL-1)*3),'YYYY')) Year_Int

  FROM TIME_RANGE
  CONNECT BY ( LEVEL - 1 ) <= MONTHS_BETWEEN ( SYSDATE, TIME_RANGE.Start_Date)/3;
 
 
 
 
 
    
      /*      INSERT YEARLY (YEAR - GRANULARITY)      */


  INSERT INTO 
        DIM_TIME (ID, Begin_Date, End_Date, Month, Month_Int, Quarter, Year, Year_Int) 

  WITH TIME_RANGE AS
  (
   SELECT
      TO_DATE ( '01-Jan-2016', 'DD-MON-YYYY' ) Start_Date, 
      SYSDATE End_Date
   FROM
      DUAL
  )
  SELECT
        TO_NUMBER (TO_CHAR(ADD_MONTHS(TIME_RANGE.Start_Date,(LEVEL-1)*12),'YYYY')) ID,

        ADD_MONTHS(TIME_RANGE.Start_Date,(LEVEL-1)*12)   Year_Begin_Date,

        CASE 
          WHEN EXTRACT (YEAR FROM SYSDATE) = EXTRACT ( YEAR FROM LAST_DAY(ADD_MONTHS(TIME_RANGE.Start_Date,(LEVEL-1)*12 + 11) )) 
           THEN LAST_DAY ( SYSDATE )
          ELSE 
             LAST_DAY( ADD_MONTHS(TIME_RANGE.Start_Date,(LEVEL-1)*12 + 11) )
        END Quarter_END_DATE,

        'N/A' Month , 
         -1   Month_Int,
         -1   Quarter,   

        to_char(ADD_MONTHS(TIME_RANGE.Start_Date,(LEVEL-1)*12),'YYYY')            Year,
        to_number(to_char(ADD_MONTHS(TIME_RANGE.Start_Date,(LEVEL-1)*12),'YYYY')) Year_Int

  FROM TIME_RANGE
  CONNECT BY ( LEVEL - 1 ) <= MONTHS_BETWEEN ( SYSDATE, TIME_RANGE.Start_Date)/12;
 
 
  COMMIT;
  SELECT * FROM DIM_TIME;
