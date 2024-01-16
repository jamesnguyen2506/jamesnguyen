WITH Grab AS
(    
    WITH CTE_1 AS
    (    
        SELECT
            SUBSTRING_INDEX(Time_Order,'/',-1) AS Year,
            Booking_state_simple,
            SUM(GMV) AS Total_GMV
        FROM
            `grab_raw-data`
        WHERE Booking_state_simple = 'COMPLETED'
        GROUP BY SUBSTRING_INDEX(Time_Order,'/',-1), Booking_state_simple
    )
    SELECT
        Year,
        LAG(Year,1,0) OVER(ORDER BY Year) AS Previous_year,
        Booking_state_simple,
        Total_GMV,
        LAG(Total_GMV,1,null) OVER(ORDER BY Year) AS Previous_GMV,
        CONCAT(ROUND((Total_GMV - LAG(Total_GMV,1,0) OVER(ORDER BY Year))*100/(Total_GMV),2),'%') AS growth_rate_GMV
    FROM 
        CTE_1
)
SELECT
    Year,
    Previous_year,
    Booking_state_simple,
    Total_GMV,
    Previous_GMV,
    growth_rate_GMV
FROM
    Grab
WHERE Previous_year <> 0