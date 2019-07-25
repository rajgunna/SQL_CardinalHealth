/*
	Scenario 3:
	Steve is a warehouse supervisor with a staff of four to pick the orders. 
	Before the beginning of each shift, Steve splits all of the orders for the day into four lists, one for each of his staff.  
	Tonight (2008-05-01), Bob called in sick. Write a query to split the orders into three equal lists.
*/
USE Kata;
GO

/* Solution: As per the above problem the order details for the next shift should be split into 3 equal lists. 
	So, the condition for where clause is with the 'ModifiedDate'; SalesOrderDetails with modified date as '2008-05-01' has 6130 rows 
		When split into 3 lists, each list contains 2043 rows */   
		
select * from (
  select *, ntile(3) over(order by SalesOrderDetailID) as tile_nr from Sales.SalesOrderDetail WHERE ModifiedDate = '2008-05-01'
) x
where x.tile_nr = 1 

select * from (
  select *, ntile(3) over(order by SalesOrderDetailID) as tile_nr from Sales.SalesOrderDetail WHERE ModifiedDate = '2008-05-01'
) x
where x.tile_nr = 2 

select * from (
  select *, ntile(3) over(order by SalesOrderDetailID) as tile_nr from Sales.SalesOrderDetail WHERE ModifiedDate = '2008-05-01'
) x
where x.tile_nr = 3 
