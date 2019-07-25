/*
	Scenario 1:
	There was an error in the order entry system that caused duplicate order lines to get entered into the database. Remove the duplicate order lines.
	BONUS: Modify the database so that this error cannot happen again.
*/

/* Solution: As per the above problem the duplicates are in SalesOrderDetail table, finding the duplicated values by ROW_NUMBER() and deleting them will
remove the duplicates from the Database*/  

USE Kata;
GO
WITH SalesOrderDetail_Updated AS (
    SELECT 
        SalesOrderID, 
		SalesOrderDetailID,
        CarrierTrackingNumber, 
        OrderQty, 
		ProductID,
		SpecialOfferID,
		UnitPrice,
		UnitPriceDiscount,
		LineTotal,
		rowguid,
		ModifiedDate,
        ROW_NUMBER() OVER (
            PARTITION BY 
                SalesOrderID, 
				CarrierTrackingNumber, 
				OrderQty, 
				ProductID,
				SpecialOfferID,
				UnitPrice,
				UnitPriceDiscount,
				LineTotal,
				ModifiedDate
            ORDER BY 
                SalesOrderID
        ) row_num
     FROM 
        Kata.Sales.SalesOrderDetail
)
DELETE FROM SalesOrderDetail_Updated
WHERE row_num > 1;

