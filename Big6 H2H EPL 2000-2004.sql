WITH Big6_home_win AS 
(
    SELECT
        HomeTeam,
        COUNT(FTR) AS Win
    FROM
        epl_results
    WHERE HomeTeam IN ('Man United','Chelsea','Tottenham','Liverpool','Man City','Arsenal')
        AND AwayTeam IN ('Man United','Chelsea','Tottenham','Liverpool','Man City','Arsenal')
        AND FTR = 'H'
        AND YEAR(DateTime) BETWEEN 2000 AND 2004
    GROUP BY HomeTeam
)
, Big6_home_draw AS 
(
    SELECT
        HomeTeam,
        COUNT(FTR) AS Draw
    FROM
        epl_results
    WHERE HomeTeam IN ('Man United','Chelsea','Tottenham','Liverpool','Man City','Arsenal')
        AND AwayTeam IN ('Man United','Chelsea','Tottenham','Liverpool','Man City','Arsenal')
        AND FTR = 'D'
        AND YEAR(DateTime) BETWEEN 2000 AND 2004
    GROUP BY HomeTeam
)
, Big6_home_lose AS 
(
    SELECT
        HomeTeam,
        SUM(Lose) AS Lose
    FROM
        (SELECT
            HomeTeam,
            CASE
                wHEN FTR = 'A' THEN 1
                ELSE 0
            END Lose
        FROM
            epl_results
        WHERE HomeTeam IN ('Man United','Chelsea','Tottenham','Liverpool','Man City','Arsenal')
            AND AwayTeam IN ('Man United','Chelsea','Tottenham','Liverpool','Man City','Arsenal')
            AND YEAR(DateTime) BETWEEN 2000 AND 2004) AS A
    GROUP BY HomeTeam
)
, Big6_away_win AS 
(
    SELECT
        AwayTeam,
        COUNT(FTR) AS Win
    FROM
        epl_results
    WHERE HomeTeam IN ('Man United','Chelsea','Tottenham','Liverpool','Man City','Arsenal')
        AND AwayTeam IN ('Man United','Chelsea','Tottenham','Liverpool','Man City','Arsenal')
        AND FTR = 'A'
        AND YEAR(DateTime) BETWEEN 2000 AND 2004
    GROUP BY AwayTeam
)
, Big6_away_draw AS 
(
    SELECT
        AwayTeam,
        COUNT(FTR) AS Draw
    FROM
        epl_results
    WHERE HomeTeam IN ('Man United','Chelsea','Tottenham','Liverpool','Man City','Arsenal')
        AND AwayTeam IN ('Man United','Chelsea','Tottenham','Liverpool','Man City','Arsenal')
        AND FTR = 'D'
        AND YEAR(DateTime) BETWEEN 2000 AND 2004
    GROUP BY AwayTeam
)
, Big6_away_lose AS 
(
    SELECT
        AwayTeam,
        COUNT(FTR) AS Lose
    FROM
        epl_results
    WHERE HomeTeam IN ('Man United','Chelsea','Tottenham','Liverpool','Man City','Arsenal')
        AND AwayTeam IN ('Man United','Chelsea','Tottenham','Liverpool','Man City','Arsenal')
        AND FTR = 'H'
        AND YEAR(DateTime) BETWEEN 2000 AND 2004
    GROUP BY AwayTeam
)
SELECT
    h1.HomeTeam AS Team,
    h1.Win + a1.Win AS Win,
    h2.draw + a2.draw AS Draw,
    h3.Lose + a3.Lose AS Lose
FROM
    Big6_home_win h1
        JOIN
    Big6_home_draw h2 ON h1.HomeTeam = h2.HomeTeam
        JOIN
    Big6_home_lose h3 ON h1.HomeTeam = h3.HomeTeam
        JOIN
    Big6_away_win a1 ON h1.HomeTeam = a1.AwayTeam
        JOIN
    Big6_away_draw a2 ON h1.HomeTeam = a2.AwayTeam
        JOIN
    Big6_away_lose a3 ON h1.HomeTeam = a3.AwayTeam