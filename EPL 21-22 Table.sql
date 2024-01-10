--Building ENGLISH PREMIER LEAGUE TABLE 21-22
WITH `EPL 21-22 rank` AS
(
    WITH Home_win AS
    (
        SELECT
            HomeTeam,
            COUNT(FTR) AS Total_home_win
        FROM
            `soccer21-22`
        WHERE FTR = 'H'
        GROUP BY HomeTeam
    )
    , Away_win AS
    (
        SELECT
            AwayTeam,
            COUNT(FTR) AS Total_away_win
        FROM
            `soccer21-22`
        WHERE FTR = 'A'
        GROUP BY AwayTeam
    ), Home_lose AS
    (
        SELECT
            HomeTeam,
            SUM(home_lost_point) AS Total_home_lose
        FROM
        (SELECT
            HomeTeam,
            CASE
                WHEN FTR = 'A' THEN 1
                ELSE 0
            END AS home_lost_point
        FROM
            `soccer21-22`) AS A
        GROUP BY HomeTeam
    
    ), Away_lose AS
    (
        SELECT
            AwayTeam,
            COUNT(FTR) AS Total_away_lose
        FROM
            `soccer21-22`
        WHERE FTR = 'H'
        GROUP BY AwayTeam
    )
    , Home_draw AS
    (
        SELECT 
            HomeTeam,
            COUNT(FTR) AS Total_home_draw
        FROM
            `soccer21-22`
        WHERE FTR = 'D'
        GROUP BY HomeTeam
    )
    , Away_draw AS 
    (
        SELECT
            AwayTeam,
            COUNT(FTR) AS Total_away_draw
        FROM
            `soccer21-22`
        WHERE FTR = 'D'
        GROUP BY AwayTeam
    )
    ,`EPL 21-22 Table` AS
    (    
        SELECT
            h1.HomeTeam AS Team,
            (SUM(Total_home_win) + SUM(Total_away_win)) AS Total_match_win,
            (SUM(Total_home_lose) + SUM(Total_away_lose)) AS Total_match_lose,
            (SUM(Total_home_draw) + SUM(Total_away_draw)) AS Total_match_draw
        FROM
            Home_win h1
                LEFT JOIN
            Away_win a1 ON h1.HomeTeam = a1.AwayTeam
                LEFT JOIN
            Home_lose h2 ON h1.HomeTeam = h2.HomeTeam
                LEFT JOIN
            Away_lose a2 ON h1.HomeTeam = a2.AwayTeam
                LEFT JOIN
            Home_draw h3 ON h1.HomeTeam = h3.HomeTeam
                LEFT JOIN
            Away_draw a3 ON h1.HomeTeam = a3.AwayTeam
        GROUP BY h1.HomeTeam
    )
    SELECT
        Team,
        Total_match_win,
        Total_match_draw,
        Total_match_lose,
        (3*Total_match_win + Total_match_draw) AS `Point`
    FROM `EPL 21-22 Table`
    ORDER BY `Point` DESC
)
,Goal_for_against AS
(
    WITH Home_goal_for_against AS
    (
        SELECT
            HomeTeam,
            SUM(FTHG) AS Total_home_goal_for,
            SUM(FTAG) AS Total_home_goal_against
        FROM
            `soccer21-22`
        GROUP BY HomeTeam
    )
    , Away_goal_for_against AS
    (
        SELECT
            AwayTeam,
            SUM(FTAG) AS Total_away_goal_for,
            SUM(FTHG) AS Total_away_goal_against
        FROM
            `soccer21-22`
        GROUP BY AwayTeam
    )
    SELECT
        h.HomeTeam AS Team,
        (Total_home_goal_for + Total_away_goal_for) AS Total_goal_for,
        (Total_home_goal_against + Total_away_goal_against) AS Total_goal_against
    FROM
        Home_goal_for_against h
            JOIN
        Away_goal_for_against a ON h.HomeTeam = a.AwayTeam
)
SELECT
    ROW_NUMBER() OVER(ORDER BY a.Point DESC) AS `Rank`,
    a.Team,
    (a.Total_match_win + a.Total_match_draw + a.Total_match_lose) AS Games_played,
    a.Total_match_win AS Wins,
    a.Total_match_draw AS Draws,
    a.Total_match_lose AS Losses,
    b.Total_goal_for AS Goal_for,
    b.Total_goal_against AS Goal_against,
    (b.Total_goal_for - b.Total_goal_against) AS Goal_difference,
    a.Point AS `Point`
FROM
    `EPL 21-22 rank` a
        JOIN
    Goal_for_against b ON a.Team = b.Team
ORDER BY a.Point DESC