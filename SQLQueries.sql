

-- SELECT to see everything was loaded
Select * from Dataset;


-- Check datatype
SELECT * FROM INFORMATION_SCHEMA.Columns;

--
Select * from Dataset 
where Entity = 'Canada' AND YEAR = 2000;

-- Select distinct country
SELECT DISTINCT Entity FROM Dataset;

-- Count no.of records for each country
;
SELECT Entity, COUNT(*) AS Total_Records
FROM Dataset
GROUP BY Entity


-- TOP and bottom performers
SELECT Entity,ROUND(Depression,0) As Depression FROM Dataset 
WHERE YEAR = '2010'
ORDER BY Depression ASC;       

--Overall Top/Bottom 

SELECT 
    Entity, 
    AVG(Depression) AS avg_depression, 
    AVG(Anxiety) AS avg_anxiety_order, 
    AVG(schizophrenia) AS avg_schizophrenia 
FROM 
    Dataset
GROUP BY 
    ENTITY
ORDER BY AVG(Anxiety);


-- In particular section 

SELECT 
   Top 5 Entity, 
    AVG(Depression) AS avg_depression 
FROM 
    Dataset 
GROUP BY 
    Entity
ORDER BY 
    avg_depression;


-- CTE
WITH average_scores AS (
    SELECT 
        Entity, 
        AVG(Depression) AS avg_depression, 
        AVG(Anxiety) AS avg_anxiety_order, 
        AVG(Schizophrenia) AS avg_schizophrenia 
    FROM 
        Dataset
    GROUP BY Entity
)
SELECT * FROM average_scores;


-- YoY calculations first step is to get the value for the last year
SELECT YEAR, 
	   Entity,
       Anxiety,
       LAG(Anxiety) OVER ( ORDER BY Year ) AS Previous,
	   Anxiety - LAG(Anxiety) OVER ( ORDER BY year )  AS YOY_Difference
FROM  Dataset

-- Percentage difference
SELECT YEAR, 
	   Entity,
       Anxiety,
       LAG(Anxiety) OVER ( ORDER BY Entity, Year ) AS Previous,
	   ROUND(((Anxiety - LAG(Anxiety) OVER ( ORDER BY Entity,year ))/LAG(Anxiety) OVER ( ORDER BY Entity,year))  * 100,2) AS Percent_Change
FROM  Dataset

-- Beacause we cannot use where with window functions use CTE to filter the data for particular country
WITH YOY AS(
SELECT YEAR, 
	   Entity,
	   Anxiety,
       LAG(Anxiety) OVER ( ORDER BY Entity, Year ) AS Previous,
	   ROUND(((Anxiety - LAG(Anxiety) OVER ( ORDER BY Entity,year ))/LAG(Anxiety) OVER ( ORDER BY Entity,year))  * 100,2) AS Percent_Change
FROM  Dataset)

Select Entity, YEAR,Percent_Change
From YOY
Where Entity = 'Canada';

-- window function Rank 
WITH ranked_depression AS (
    SELECT 
        *,
        RANK() OVER (ORDER BY Depression DESC) AS depression_rank
    FROM 
        Dataset
)

SELECT * FROM ranked_depression;



-- Find the countries with 5th laregst cases in Depression

SELECT * FROM (
  SELECT Entity,Depression,Year, DENSE_RANK() OVER (ORDER BY Depression DESC) AS Position
  FROM Dataset
) AS subquery
WHERE Position = 5 ;

  -- Use row number to get ranks based on the years
SELECT Entity AS Country, YEAR, Depression,
ROW_NUMBER() OVER(PARTITION BY Year ORDER BY Depression DESC) AS Rank_number
FROM Dataset

-- Use this to get what was the country that ranked 4 based on the year

Select * From(
SELECT Entity AS Country, YEAR, Schizophrenia,
ROW_NUMBER() OVER(PARTITION BY Year ORDER BY Schizophrenia DESC) AS Rank_number
FROM Dataset) as subquery
Where Rank_number = '4'