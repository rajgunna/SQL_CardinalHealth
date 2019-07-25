/*
	Scenario 2:
	New orders came into the staging area for (2008-05-01). Merge these orders with the existing orders for the same date.
*/

USE Kata;
GO

/* Solution: As per the above problem the new order came into SalesOrderDetailStaging table, I used the below query to merge with SalesOrderDetail table. 
	So, the condition for where clause is with the 'ModifiedDate'; SalesOrderDetails with modified date as '2008-05-01' has 6130 rows 
		SalesOrderDetailStaging has 6130 rows
		SalesOrderDetails has 121729 rows
		SalesOrderDetails with date has 2477 rows
		SalesOrderDetails after senario 2 - 124382
	When we merge both tables, updated rows are 6130 */   

MERGE Kata.Sales.SalesOrderDetail AS TARGET
USING Kata.Sales.SalesOrderDetailStaging AS SOURCE 
ON (TARGET.SalesOrderDetailID = SOURCE.SalesOrderDetailID AND TARGET.ModifiedDate = '2008-05-01') 

WHEN MATCHED AND
TARGET.SalesOrderID = SOURCE.SalesOrderID OR
TARGET.CarrierTrackingNumber <> SOURCE.CarrierTrackingNumber OR 
TARGET.OrderQty <> SOURCE.OrderQty	OR 
TARGET.ProductID <> SOURCE.ProductID  OR 
TARGET.SpecialOfferID <> SOURCE.SpecialOfferID  OR 
TARGET.UnitPrice <> SOURCE.UnitPrice  OR 
TARGET.UnitPriceDiscount <> SOURCE.UnitPriceDiscount  OR 
TARGET.LineTotal <> SOURCE.LineTotal  OR 
TARGET.rowguid <> SOURCE.rowguid 
THEN UPDATE SET 
TARGET.SalesOrderID = SOURCE.SalesOrderID,
TARGET.CarrierTrackingNumber = SOURCE.CarrierTrackingNumber, 
TARGET.OrderQty = SOURCE.OrderQty,
TARGET.ProductID = SOURCE.ProductID,  
TARGET.SpecialOfferID = SOURCE.SpecialOfferID, 
TARGET.UnitPrice = SOURCE.UnitPrice,
TARGET.UnitPriceDiscount = SOURCE.UnitPriceDiscount, 
TARGET.LineTotal = SOURCE.LineTotal, 
TARGET.rowguid = SOURCE.rowguid

WHEN NOT MATCHED BY TARGET
THEN INSERT (SalesOrderId, CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, LineTotal, rowguid, ModifiedDate) 
VALUES (SOURCE.SalesOrderId, SOURCE.CarrierTrackingNumber, SOURCE.OrderQty, SOURCE.ProductID, SOURCE.SpecialOfferID, SOURCE.UnitPrice, SOURCE.UnitPriceDiscount, SOURCE.LineTotal, SOURCE.rowguid, SOURCE.ModifiedDate)

WHEN NOT MATCHED BY SOURCE AND TARGET.ModifiedDate = '2008-05-01'
THEN DELETE; 

