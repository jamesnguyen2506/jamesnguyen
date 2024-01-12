--Ratio goal for and against
WITH Ratio_GF AS
(
    WITH Home_goal_conversion AS
    (
        SELECT
            HomeTeam,
            SUM(HST) AS Total_home_shot_target,
            SUM(FTHG) AS Total_home_goal,
            ROUND((SUM(FTHG)*100/SUM(HST)),0) AS Ratio_home_goal_conversion
        FROM    
            `soccer21-22`
        GROUP BY HomeTeam
        ORDER BY Ratio_home_goal_conversion DESC
    )
    , Away_goal_conversion AS
    (
        SELECT
            AwayTeam,
            SUM(FTAG) AS Total_away_goal,
            SUM(AST) AS Total_away_shot_target,
            ROUND((SUM(FTAG)*100/SUM(AST)),0) AS Ratio_away_goal_conversion
        FROM    
            `soccer21-22`
        GROUP BY AwayTeam
        ORDER BY Ratio_away_goal_conversion DESC
    )
    SELECT
        h.HomeTeam AS Team,
        CONCAT(h.Ratio_home_goal_conversion,'%') AS Ratio_home_GF,
        CONCAT(a.Ratio_away_goal_conversion, '%') AS Ratio_away_GF,
        CONCAT((h.Ratio_home_goal_conversion + a.Ratio_away_goal_conversion),'%') AS Ratio_GF
    FROM
        Home_goal_conversion h
            JOIN
        Away_goal_conversion a ON h.HomeTeam = a.AwayTeam
    ORDER BY (h.Ratio_home_goal_conversion + a.Ratio_away_goal_conversion) DESC
)
,Ratio_GA AS
(    
    WITH Home_goal_against AS
    ( 
        SELECT
            HomeTeam,
            ROUND(SUM(FTAG)*100/SUM(AST),0) AS Ratio_home_goal_against
        FROM
            `soccer21-22`
        GROUP BY HomeTeam
    )
    , Away_goal_against AS
    (
        SELECT
            AwayTeam,
            ROUND(SUM(FTHG)*100/SUM(HST),0) AS Ratio_away_goal_against
        FROM
            `soccer21-22`
        GROUP BY AwayTeam
    )
    SELECT
        h.HomeTeam AS Team,
        CONCAT(h.Ratio_home_goal_against,'%') AS Ratio_home_GA,
        CONCAT(a.Ratio_away_goal_against,'%') AS Ratio_away_GA,
        CONCAT((h.Ratio_home_goal_against + a.Ratio_away_goal_against),'%') AS Ratio_GA
    FROM
        Home_goal_against h
            JOIN
        Away_goal_against a ON h.HomeTeam = a.AwayTeam
    ORDER BY (h.Ratio_home_goal_against + a.Ratio_away_goal_against) DESC
)
SELECT
    gf.Team,
    gf.Ratio_home_GF,
    gf.Ratio_away_GF,
    gf.Ratio_GF,
    ga.Ratio_home_GA,
    ga.Ratio_away_GA,
    ga.Ratio_GA
FROM
    Ratio_GF gf
        JOIN
    Ratio_GA ga ON gf.Team = ga.Team
ORDER BY Ratio_GF DESC, Ratio_GA 