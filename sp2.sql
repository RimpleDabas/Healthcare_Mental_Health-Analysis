CREATE PROCEDURE SelectYearwise @Country nvarchar(30), @for_year varchar(10)
AS
SELECT * FROM Dataset WHERE Entity = @Country AND Year = @for_year;