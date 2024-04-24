

Create procedure selectcountry @country nvarchar(50)
AS 
Select * from Dataset Where Entity = @country
GO

