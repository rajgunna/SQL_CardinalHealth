/*
	Scenario 4:
	The team has been sent an extract from the mainframe to perform price updates based on category. Using Update.txt, update the product pricing.

	The file format is:

	ProductCategoryId.ProductSubcategoryId|Margin
	-------------------------------------------------
	000001.000001|1.7950

	The list price should be Standard Cost * Margin
*/
USE Kata;
GO

/* Solution: As per the above problem the list price in Product table should be updated based on the text file data. 
	Step 1: Created a Temp table(#temp) to bulkload the data from the text file into 1 coloumn 
	Step 2:  Created a Temp table(#temp1) to segregate the values in the first temp table
	Step 3: Updated listprice based on the requirement using joins*/   

CREATE TABLE #TEMP (
  [FullValue] nvarchar(100)
)
GO

BULK INSERT #TEMP
FROM 'C:\Users\rgunna\Downloads\sql\rajkiran_sql_audition\Update.txt'
WITH
 (
    rowterminator = '\n',
	ERRORFILE = 'C:\temp\Error.log' 
  )    
GO

CREATE TABLE #TEMP1 (
  ProductCategoryId int,
  ProductSubcategoryId int,
  [Margin] decimal(5,4)
)
GO

INSERT INTO #TEMP1
SELECT   
       CAST(SUBSTRING(FullValue,1,CHARINDEX('.',FullValue)-1) AS int) ProductCategoryId, 
       CAST(SUBSTRING(FullValue, CHARINDEX('.',FullValue)+1, (CHARINDEX('|',FullValue)-1) - (CHARINDEX('.',FullValue))) AS int) ProductSubcategoryId, 
	   CAST(SUBSTRING(FullValue, CHARINDEX('|',FullValue)+1, LEN(FullValue)) AS decimal(5,4)) Margin 
FROM #TEMP 

update Production.Product set ListPrice = StandardCost * #TEMP1.Margin from Production.Product as P 
INNER JOIN #TEMP1 ON #TEMP1.ProductSubcategoryId = P.ProductSubcategoryID
INNER JOIN Production.ProductCategory PC ON PC.ProductCategoryID = #TEMP1.ProductCategoryId

select * from Production.Product

drop table #TEMP
drop table #TEMP1