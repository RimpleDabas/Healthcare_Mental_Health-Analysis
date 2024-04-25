

Create procedure Ranks1 @for_year varchar(5), @parameter nvarchar(20), @ranknumber Varchar(100)
AS
(Select * From(
SELECT  Year =  @for_year , parameter =  @parameter,
ROW_NUMBER() OVER(PARTITION BY @for_year  ORDER BY  @parameter DESC) AS Rank_number
FROM Dataset) as subquery
Where Rank_number = @ranknumber );
