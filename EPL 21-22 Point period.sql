WITH Home_point AS
(    
    WITH Home_point AS
    (    
        SELECT
            SUBSTRING_INDEX(SUBSTRING_INDEX(Date,'/',-2),'/',1) AS Month,
            SUBSTRING_INDEX(Date,'/',-1) AS Year,
            HomeTeam,
            CASE
                WHEN FTR = 'H' THEN 3
                WHEN FTR = 'D' THEN 1
                ELSE 0
            END AS Home_point
        FROM
            `soccer21-22`
        WHERE FTR = 'H'
    )
    SELECT
        Month,
        Year,
        HomeTeam,
        SUM(Home_point) AS Total_home_point
    FROM
        Home_point
    GROUP BY Month,Year, HomeTeam
)
,Away_point AS
(
    WITH Away_point AS
    (
        SELECT
            SUBSTRING_INDEX(SUBSTRING_INDEX(Date,'/',-2),'/',1) AS Month,
            SUBSTRING_INDEX(Date,'/',-1) AS Year,
            AwayTeam,
            CASE
                WHEN FTR = 'A' THEN 3
                WHEN FTR = 'D' THEN 1
                ELSE 0
            END AS Away_point
        FROM
            `soccer21-22`
    )
    SELECT
        Month,
        Year,
        AwayTeam,
        SUM(Away_point) AS Total_away_point
    FROM
        Away_point
    GROUP BY Month, Year, AwayTeam
)
SELECT
    h.Month,
    h.Year,
    h.HomeTeam AS Team,
    (h.Total_home_point + a.Total_away_point) AS Total_point
FROM
    Home_point h
        JOIN
    Away_point a ON h.Month = a.Month AND h.HomeTeam = a.AwayTeam