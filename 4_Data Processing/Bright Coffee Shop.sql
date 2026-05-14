BRIGHT COFFEE  SHOP CODING
--=================================================
---1.Checking structure of the data set
--=================================================
SELECT * 
FROM `workspace`.`default`.`Bright_coffee_shop`;

--======================================================
---2.Checking the date range - 2023-01-01 - 2023-06-30
--======================================================
SELECT
       MIN(transaction_date) AS minimum_date,
       MAX(transaction_date) AS maximum_date
FROM `workspace`.`default`.`Bright_coffee_shop`;

--=================================================
---3.Checking operating time - 06:00:00 - 20:59:32
--=================================================
SELECT MIN(transaction_time) AS minimum_time,
       MAX(transaction_time) AS maximum_time
FROM `workspace`.`default`.`Bright_coffee_shop`;

--================================================    
---4.Checking Different store location
--================================================
SELECT
     DISTINCT store_location
     FROM `workspace`.`default`.`Bright_coffee_shop`;

--==================================================================================
---5.Checking different products sold at our stores - 9 different product categories
--==================================================================================
SELECT
      DISTINCT product_category
FROM `workspace`.`default`.`Bright_coffee_shop`; 

--===================================================================================
---6.Checking different product types sold at our store - 29 different product types
--===================================================================================
SELECT
      DISTINCT product_type
      FROM `workspace`.`default`.`Bright_coffee_shop`;

--=============================================================================
---7.Checking product details sold at our stores - 80 different product details
--=============================================================================
SELECT 
      DISTINCT product_detail
      FROM `workspace`.`default`.`Bright_coffee_shop`;

--===========================================
---8.Checking for NULLS in various columns
--===========================================
SELECT*
FROM `workspace`.`default`.`Bright_coffee_shop`
WHERE  unit_price = NULL
OR transaction_qty = NULL
OR transaction_date = NULL;

--============================================
---9. Checking Cheap and Expensive products
--===========================================
SELECT 
      Min(unit_price) AS cheap_product,
      Max(unit_price) AS expensive_product
FROM `workspace`.`default`.`Bright_coffee_shop`;

--===========================================
---10. Extracting day and month names
--===========================================
SELECT
     transaction_date,
     Dayname(transaction_date) AS day_name,
     Monthname(transaction_date) AS month_name
FROM `workspace`.`default`.`Bright_coffee_shop`;

--==========================================
---11.Calculating the revenue
--==========================================
SELECT
      unit_price,
      transaction_qty,
      unit_price*transaction_qty AS revenue
FROM `workspace`.`default`.`Bright_coffee_shop`;

--==========================================================
---12. Combining functions to get a clean enhanced data set
--==========================================================
SELECT
---Dates
     transaction_date AS purchase_date,
     DAYNAME(transaction_date) AS day_name,
     MONTHNAME(transaction_date) AS month_name,
     DAYOFMONTH(transaction_date) AS day_of_month,
    CASE 
      WHEN Dayname(transaction_date) IN('Sun','Sat') THEN 'Weekend'
      ELSE 'Weekday'
    END AS day_classification,
---date_format(transaction_date,'HH:mm:ss') AS purchase_time,
    CASE 
      WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '06:00:00' AND '11:59:59' THEN '01.Morning'
      WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '12:00:00' AND '17:59:59' THEN '02.Afternoon'
      WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '18:00:00' AND '23:59:59' THEN '03.Evening'
    END AS time_buckets,
---Spend Buckets
---Counts of IDs
    COUNT(DISTINCT transaction_id) AS number_of_sales,
    COUNT(DISTINCT product_id) AS number_of_products,
    COUNT(DISTINCT store_id) AS number_of_stores,
---Revenue
    SUM(transaction_qty*unit_price) AS revenue_per_day,
   
    CASE 
      WHEN revenue_per_day <= 50 THEN '01.low spend'
      WHEN revenue_per_day BETWEEN 51 AND 200 THEN '02.medium spend'
      ELSE '03.High spend'
    END AS spend_buckets,

---Categorical columns
      store_location,
      product_category,
      product_detail
    FROM `workspace`.`default`.`Bright_coffee_shop`
    GROUP BY
      purchase_date,
      day_name,
      month_name,
      store_location,
      day_classification,
      time_buckets,
      product_category,
      transaction_qty,
      product_detail,
      unit_price;

