/*1.  In 1896 year which sports played a lot.*/

select sport, count(sport) as Sportsplayed
from olympics.summer
where Year = 1896
group by sport;

/*2.How many men and women played olympics in the summer and winter Olympics.*/

SELECT Gender, COUNT(*) AS Count
FROM (
    SELECT Gender FROM olympics.summer
    UNION ALL
    SELECT Gender FROM olympics.winter
) AS CombinedOlympics
GROUP BY Gender;

select S.Gender, count(W.Gender) as totalgender
from olympics.summer as S inner join olympics.winter as W on S.Country = W.Country
group by Gender
order by totalgender desc;

/*3.In which discipline mens played a lot along with country.*/

SELECT Discipline, COUNT(*) AS MenCount
FROM (
    SELECT Discipline, Gender FROM olympics.summer
    UNION ALL
    SELECT Discipline, Gender FROM olympics.winter
) AS CombinedOlympics
WHERE Gender = 'Men'
GROUP BY Discipline
ORDER BY MenCount DESC;

select S.Discipline, count(W.Discipline) as totalDisc
from olympics.summer as S inner join olympics.winter as W on S.Country = W.Country
group by Discipline
order by totalDisc desc;

/*4.In which country get maximum number of medals.*/

select S.Medal, sum(W.Medal+S.Medal)as totalMedal
from olympics.summer as S inner join olympics.winter as W on S.Country = W.Country
group by Medal
order by totalMedal desc;

SELECT Country, SUM(Medal) AS total_medals
FROM (SELECT Country, Medal FROM olympics.summer UNION SELECT Country, Medal FROM olympics.winter) AS combined
GROUP BY Country
ORDER BY total_medals DESC
LIMIT 1;

SELECT Country, TotalMedals
FROM (
    SELECT Country, SUM(TotalMedals) AS TotalMedals
    FROM (
        SELECT Country, 
               COUNT(CASE WHEN Medal = 'Gold' THEN 1 END) AS GoldCount,
               COUNT(CASE WHEN Medal = 'Silver' THEN 1 END) AS SilverCount,
               COUNT(CASE WHEN Medal = 'Bronze' THEN 1 END) AS BronzeCount,
               COUNT(*) AS TotalMedals
        FROM (
            SELECT Country, Medal FROM olympics.summer
            UNION ALL
            SELECT Country, Medal FROM olympics.winter
        ) AS CombinedMedals
        GROUP BY Country
    ) AS MedalCounts
    GROUP BY Country
) AS FinalMedalCounts
ORDER BY TotalMedals DESC
LIMIT 1;


SELECT Country, COUNT(*) AS TotalMedals
FROM (
    SELECT Country FROM olympics.summer WHERE Medal IN ('Gold', 'Silver', 'Bronze')
    UNION ALL
    SELECT Country FROM olympics.winter WHERE Medal IN ('Gold', 'Silver', 'Bronze')
) AS AllMedals
GROUP BY Country
ORDER BY TotalMedals DESC
LIMIT 1;

/*5.In event which country participated a lot along with men and women category.*/

SELECT Event, Country, 
       SUM(CASE WHEN Gender = 'Men' THEN 1 ELSE 0 END) AS MenCount,
       SUM(CASE WHEN Gender = 'Women' THEN 1 ELSE 0 END) AS WomenCount,
       COUNT(*) AS TotalCount
FROM (
    SELECT Event, Country, Gender FROM olympics.summer
    UNION ALL
    SELECT Event, Country, Gender FROM olympics.winter
) AS CombinedOlympics
GROUP BY Event, Country
ORDER BY Event, TotalCount DESC;

SELECT Event, COUNT(*) AS Count
FROM (
    SELECT Event FROM olympics.summer
    UNION ALL
    SELECT Event FROM olympics.winter
) AS CombinedOlympics
GROUP BY Event;

/* 6.How many mens and women are participated in the Olympics*/

select S.Gender, count(S.Gender) Totalparticipation
from olympics.summer as S inner join olympics.winter as W on S.Country = W.Country
group by Gender;

SELECT Gender, COUNT(*) AS TotalParticipants
FROM (
    SELECT Gender FROM olympics.summer
    UNION ALL
    SELECT Gender FROM olympics.winter
) AS AllParticipants
GROUP BY Gender;


/*7.From 1900-1936 what is the count for the medals.*/

SELECT Medal, COUNT(*) AS MedalCount
FROM (
    SELECT Year, Medal
    FROM olympics.summer
    WHERE Year BETWEEN 1900 AND 1936
    UNION ALL
    SELECT Year, Medal
    FROM olympics.winter
    WHERE Year BETWEEN 1900 AND 1936
) AS FilteredMedals
GROUP BY Medal;


/*8.For Germany country which sport is played a lot (discipline)*/

SELECT S.Sport, COUNT(*) AS ParticipationCount
FROM olympics.summer AS S
INNER JOIN olympics.winter AS W
ON S.Sport = W.Sport AND S.Country = 'GER' AND W.Country = 'GER'
GROUP BY S.Sport
ORDER BY ParticipationCount DESC
LIMIT 1;

SELECT Discipline, COUNT(*) AS ParticipationCount
FROM (
    SELECT Discipline
    FROM olympics.summer
    WHERE Country = 'GER'
    UNION ALL
    SELECT Discipline
    FROM olympics.winter
    WHERE Country = 'GER'
) AS GermanParticipants
GROUP BY Discipline
ORDER BY ParticipationCount DESC
LIMIT 1;

/*9.In which year the discipline is participated a lot.*/

SELECT Year, Discipline, COUNT(*) AS ParticipationCount
FROM (
    SELECT Year, Discipline
    FROM olympics.summer
    UNION ALL
    SELECT Year, Discipline
    FROM olympics.winter
) AS AllParticipants
GROUP BY Year, Discipline
ORDER BY ParticipationCount DESC
LIMIT 1;


/*10.Which city played the sport a lot along with count.*/

SELECT City, COUNT(Sport) AS SportCount
FROM (
    SELECT City, Sport
    FROM olympics.summer
    UNION ALL
    SELECT City, Sport
    FROM olympics.winter
) AS AllSports
GROUP BY City
ORDER BY SportCount DESC
LIMIT 1;

/*11 Find the GDP per capita for the country that won the most gold medals in the Winter Olympics*/
/*12 Find the countries that have never won a gold medal in either the Summer or Winter Olympics.*/
/*13 Find the country with the lowest GDP per capita that has won a medal in the Winter Olympics.*/
/*14 List all athletes who have won medals in both the Summer and Winter Olympics, along with the total number of medals they have won in each.*/
/*15 Retrieve the total number of medals won by each country in both Summer and Winter Olympics, along with the total GDP per capita of those countries.*/
/*16 Get the list of countries that have hosted the Olympics (either Summer or Winter), along with the total number of times they have hosted.*/
/*17 Find the total number of events held in the Summer and Winter Olympics combined, grouped by year.*/
/*18 Retrieve the names of athletes who won medals in the 2000 Summer Olympics and their corresponding disciplines, then find out if they won any medals in the 2002 Winter Olympics.*/
/*19 List the countries and their respective GDP per capita that won the most medals in the Summer Olympics in 2016.*/
/*20 Get the top 5 athletes who have won the most medals across both Summer and Winter Olympics.*/
/*21 Find the countries with the highest medal-to-population ratio in the Summer Olympics.*/
/*22 Retrieve the list of athletes and the number of medals they have won in the Winter Olympics, along with the GDP per capita of their countries.*/
/*23 Get the total number of distinct disciplines in which medals were awarded in both Summer and Winter Olympics, grouped by gender.*/
/*24 Find the athlete who has won the most gold medals in the Summer Olympics, and check if they won any medals in the Winter Olympics.*/

/*11 Find the GDP per capita for the country that won the most gold medals in the Winter Olympics*/

SELECT d.Country, d.GDP
FROM olympics.winter as w
inner JOIN olympics.dictionary as d ON w.Country = d.Country
WHERE w.Medal = 'Gold'
GROUP BY d.Country
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT d.Country, d.GDP
FROM olympics.dictionary d
INNER JOIN (
    SELECT w.Country, COUNT(*) as GoldMedals
    FROM olympics.winter w
    WHERE w.Medal = 'Gold'
    GROUP BY w.Country
    ORDER BY GoldMedals DESC
    LIMIT 1
) as g ON d.Country = g.Country;

/*12 Find the countries that have never won a gold medal in either the Summer or Winter Olympics.*/

SELECT d.Country
FROM olympics.dictionary d
LEFT JOIN olympics.summer s ON d.Country = s.Country AND s.Medal = 'Gold'
LEFT JOIN olympics.winter w ON d.Country = w.Country AND w.Medal = 'Gold'
WHERE s.Country IS NULL AND w.Country IS NULL;

/*13 Find the country with the lowest GDP per capita that has won a medal in the Winter Olympics.*/

SELECT d.Country, d.GDP
FROM olympics.winter as w
inner JOIN olympics.dictionary as d ON w.Country = d.Country
WHERE w.Medal IS NOT NULL
ORDER BY d.GDP ASC
LIMIT 1;

/*14 List all athletes who have won medals in both the Summer and Winter Olympics, along with the total number of medals they have won in each.*/

SELECT s.Athlete, 
       COUNT(DISTINCT s.Medal) as SummerMedals, 
       COUNT(DISTINCT w.Medal) as WinterMedals
FROM olympics.summer s
INNER JOIN olympics.winter w ON s.Athlete = w.Athlete
GROUP BY s.Athlete
HAVING SummerMedals > 0 AND WinterMedals > 0;

/*15 Retrieve the total number of medals won by each country in both Summer and Winter Olympics, along with the total GDP per capita of those countries.*/

SELECT Country, 
       SUM(TotalMedals) as TotalMedals, 
       SUM(GDP) as TotalGDP
FROM (
    SELECT s.Country, 
           COUNT(*) as TotalMedals, 
           d.GDP
    FROM olympics.summer as s
    INNER JOIN olympics.dictionary d ON s.Country = d.Country
    GROUP BY s.Country, d.GDP
    UNION ALL
    SELECT w.Country, 
           COUNT(*) as TotalMedals, 
           d.GDP
    FROM olympics.winter as w
    INNER JOIN olympics.dictionary d ON w.Country = d.Country
    GROUP BY w.Country, d.GDP
) as Combined
GROUP BY Country;

/*16 Get the list of countries that have hosted the Olympics (either Summer or Winter), along with the total number of times they have hosted.*/

SELECT Country, COUNT(*) as HostCount
FROM (
    SELECT DISTINCT City, Country
    FROM Summer
    UNION
    SELECT DISTINCT City, Country
    FROM Winter
) as Hosts
GROUP BY Country;

/*17 Find the total number of events held in the Summer and Winter Olympics combined, grouped by year.*/

SELECT Year, COUNT(DISTINCT Event) as TotalEvents
FROM (
    SELECT Year, Event
    FROM Summer
    UNION
    SELECT Year, Event
    FROM Winter
) as AllEvents
GROUP BY Year;

/*18 Retrieve the names of athletes who won medals in the 2000 Summer Olympics and their corresponding disciplines, then find out if they won any medals in the 2002 Winter Olympics.*/

SELECT s.Athlete, s.Discipline, w.Medal as WinterMedal
FROM Summer s
LEFT JOIN Winter w ON s.Athlete = w.Athlete AND w.Year = 2002
WHERE s.Year = 2000 AND s.Medal IS NOT NULL;

/*19 List the countries and their respective GDP per capita that won the most medals in the Summer Olympics in 2016.*/

SELECT s.Country, d.GDP_per_Capita, COUNT(*) as MedalsWon
FROM Summer s
INNER JOIN Dictionary d ON s.Country = d.Country
WHERE s.Year = 2016
GROUP BY s.Country, d.GDP_per_Capita
ORDER BY MedalsWon DESC
LIMIT 1;

/*20 Get the top 5 athletes who have won the most medals across both Summer and Winter Olympics.*/

SELECT Athlete, COUNT(*) as TotalMedals
FROM (
    SELECT Athlete, Medal
    FROM Summer
    UNION ALL
    SELECT Athlete, Medal
    FROM Winter
) as AllMedals
GROUP BY Athlete
ORDER BY TotalMedals DESC
LIMIT 5;

/*21 Find the countries with the highest medal-to-population ratio in the Summer Olympics.*/

SELECT s.Country, 
       COUNT(s.Medal) / d.Population as MedalToPopulationRatio
FROM Summer s
INNER JOIN Dictionary d ON s.Country = d.Country
WHERE s.Medal IS NOT NULL
GROUP BY s.Country, d.Population
ORDER BY MedalToPopulationRatio DESC
LIMIT 10;

/*22 Retrieve the list of athletes and the number of medals they have won in the Winter Olympics, along with the GDP per capita of their countries.*/

SELECT w.Athlete, COUNT(w.Medal) as TotalMedals, d.GDP_per_Capita
FROM Winter w
INNER JOIN Dictionary d ON w.Country = d.Country
WHERE w.Medal IS NOT NULL
GROUP BY w.Athlete, d.GDP_per_Capita;

/*23 Get the total number of distinct disciplines in which medals were awarded in both Summer and Winter Olympics, grouped by gender.*/

SELECT Gender, COUNT(DISTINCT Discipline) as TotalDisciplines
FROM (
    SELECT Gender, Discipline
    FROM Summer
    WHERE Medal IS NOT NULL
    UNION
    SELECT Gender, Discipline
    FROM Winter
    WHERE Medal IS NOT NULL
) as AllDisciplines
GROUP BY Gender;

/*24 Find the athlete who has won the most gold medals in the Summer Olympics, and check if they won any medals in the Winter Olympics.*/

SELECT s.Athlete, COUNT(s.Medal) as GoldMedals, COUNT(w.Medal) as WinterMedals
FROM Summer s
LEFT JOIN Winter w ON s.Athlete = w.Athlete
WHERE s.Medal = 'Gold'
GROUP BY s.Athlete
ORDER BY GoldMedals DESC
LIMIT 1;
