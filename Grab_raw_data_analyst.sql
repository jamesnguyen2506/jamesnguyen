WITH CTE_1 AS
(
    SELECT
        SUBSTRING_INDEX(Time_Order,'/',-1) AS Year,
        SUBSTRING_INDEX(Time_Order,'/',1) AS Month,
        Booking_state_simple,
        SUM(GMV) AS Total_GMV,
        SUM(trading_value) AS Total_trading
    FROM
        `grab_raw-data`
    WHERE SUBSTRING_INDEX(Time_Order,'/',-1) BETWEEN 2020 AND 2022
    GROUP BY SUBSTRING_INDEX(Time_Order,'/',1), SUBSTRING_INDEX(Time_Order,'/',-1), Booking_state_simple
    ORDER BY SUBSTRING_INDEX(Time_Order,'/',-1)
)
SELECT
    Year,
    Month,
    Booking_state_simple,
    Total_GMV,
    Total_trading,
    ROW_NUMBER() OVER(PARTITION BY Year, Month ORDER BY Total_GMV DESC) AS `Rank`
FROM    
    CTE_1