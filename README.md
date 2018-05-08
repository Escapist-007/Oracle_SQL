
This repository contains `SQL scripts` related to some common Oracle SQL functions.

* **Explore Analytic Functions.sql**<br/> 
  > Explore different `Analytic Functions` of Oracle for Data Analysis.

* **Basic Statistical Functions.sql**<br/>
  > How to find the mean/average, median, mode, SD, max, min of a column value in oracle? By knowing the mean, median and mode we can have     an idea about the distribution of the values of a particular column. If `mean = median = mode`, then the distribution is `NORMAL DISTRIBUTION`.

* **Generate Time Dimension.sql** :ok_hand: <br/>
  > How to generate `Time Dimension` in Data Warehouse having month/quarter/year granularity? Here, `currDate` is actually used in lieu of 
    `SYSDATE` and `connBy` is used in lieu of `CONNECT BY`. If I use SYSDATE & CONNECT BY then the syntax highlighting becomes invalid.
  
* **General Functions for NULL value.sql** <br/>
  > How to replace NULL value of a column using oracle functions?
    Functions: NVL, NVL2, NULLIF, COALESCE, LNNVL, NANVL, DECODE 
    
* **Explore DATE Functions.sql** <br/>
  > How to handle date in oracle? This file contains some common functions related to DATE value. Here, `currDate` is actually used in         lieu of `SYSDATE`.
* **Conditional Expression.sql** <br/>
  > Use of `CASE` expression and `DECODE` function for implemeting conditional logic in query.
