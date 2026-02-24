CREATE DATABASE retail_project;
USE retail_project;

SELECT * 
FROM online_retail
LIMIT 10;

ALTER TABLE online_retail
MODIFY InvoiceDate DATETIME;
DESCRIBE online_retail;

SELECT COUNT(*) AS null_count
FROM online_retail
WHERE CustomerID IS NULL;

SELECT COUNT(*) AS negative_qty
FROM online_retail
WHERE Quantity < 0;

SELECT COUNT(*) AS invalid_price
FROM online_retail
WHERE UnitPrice <= 0;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM online_retail
WHERE Quantity < 0;

DELETE FROM online_retail
WHERE UnitPrice <= 0;

ALTER TABLE online_retail
ADD COLUMN TotalPrice DECIMAL(10,2);

UPDATE online_retail
SET TotalPrice = Quantity * UnitPrice;

SELECT Quantity, UnitPrice, TotalPrice
FROM online_retail
LIMIT 10;

SELECT SUM(TotalPrice) AS total_revenue
FROM online_retail;

SELECT 
    Country,
    SUM(TotalPrice) AS revenue
FROM online_retail
GROUP BY Country
ORDER BY revenue DESC;

SELECT 
    Description,
    SUM(Quantity) AS total_sold
FROM online_retail
GROUP BY Description
ORDER BY total_sold DESC
LIMIT 10;

SELECT 
    CustomerID,
    SUM(TotalPrice) AS total_spent
FROM online_retail
GROUP BY CustomerID
ORDER BY total_spent DESC
LIMIT 10;

SELECT 
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS month,
    SUM(TotalPrice) AS revenue
FROM online_retail
GROUP BY month
ORDER BY month;

SELECT 
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS orders
FROM online_retail
GROUP BY CustomerID
HAVING orders > 1;

SELECT 
    CustomerID,
    MAX(InvoiceDate) AS last_purchase,
    COUNT(DISTINCT InvoiceNo) AS frequency,
    SUM(TotalPrice) AS monetary
FROM online_retail
GROUP BY CustomerID;

SELECT 
    CustomerID,
    DATEDIFF(
        (SELECT MAX(InvoiceDate) FROM online_retail),
        MAX(InvoiceDate)
    ) AS recency,
    COUNT(DISTINCT InvoiceNo) AS frequency,
    SUM(TotalPrice) AS monetary
FROM online_retail
GROUP BY CustomerID;

SELECT 
    CustomerID,
    
    NTILE(5) OVER (ORDER BY 
        DATEDIFF((SELECT MAX(InvoiceDate) FROM online_retail), MAX(InvoiceDate)) DESC
    ) AS R_score,

    NTILE(5) OVER (ORDER BY COUNT(DISTINCT InvoiceNo)) AS F_score,

    NTILE(5) OVER (ORDER BY SUM(TotalPrice)) AS M_score

FROM online_retail
GROUP BY CustomerID;

SELECT 
    CustomerID,
    
    NTILE(5) OVER (ORDER BY 
        DATEDIFF((SELECT MAX(InvoiceDate) FROM online_retail), MAX(InvoiceDate)) DESC
    ) AS R_score,

    NTILE(5) OVER (ORDER BY COUNT(DISTINCT InvoiceNo)) AS F_score,

    NTILE(5) OVER (ORDER BY SUM(TotalPrice)) AS M_score,

    CASE 
        WHEN 
            NTILE(5) OVER (ORDER BY DATEDIFF((SELECT MAX(InvoiceDate) FROM online_retail), MAX(InvoiceDate)) DESC) >= 4
            AND NTILE(5) OVER (ORDER BY COUNT(DISTINCT InvoiceNo)) >= 4
            AND NTILE(5) OVER (ORDER BY SUM(TotalPrice)) >= 4
        THEN 'VIP Customer'

        WHEN NTILE(5) OVER (ORDER BY COUNT(DISTINCT InvoiceNo)) >= 4
        THEN 'Loyal Customer'

        WHEN NTILE(5) OVER (ORDER BY DATEDIFF((SELECT MAX(InvoiceDate) FROM online_retail), MAX(InvoiceDate)) DESC) <= 2
        THEN 'At Risk'

        ELSE 'Lost Customer'
    END AS segment

FROM online_retail
GROUP BY CustomerID;

SELECT * FROM online_retail;

SELECT * 
FROM online_retail
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/online_retail_cleaned.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';