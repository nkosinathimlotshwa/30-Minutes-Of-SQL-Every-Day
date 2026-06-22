/***
	From the following table write a query in SQL to retrieve 
	all rows and columns from the employee table in the Adventureworks  database. 
	Sort the result set in ascending order on jobtitle.
***/
USE AdventureWorks2022;
GO

SELECT * 
FROM dbo.DimEmployee
ORDER BY Title;

/***
	From the following table write a query in SQL to retrieve all rows and 
	columns from the employee table using table aliasing in the Adventureworks database. 
	Sort the output in ascending order on lastname
***/
SELECT c.* 
FROM dbo.DimCustomer AS c
ORDER BY CustomerKey;


/***
	 write a query in SQL to return all rows and a subset of the columns (FirstName, LastName, businessentityid) 
	 from the person table in the AdventureWorks database. The third column heading is renamed to Employee_id. 
	 Arranged the output in ascending order by lastname
***/
SELECT FirstName, LastName, EmployeeKey AS Employee_id
FROM dbo.DimEmployee AS e
ORDER BY LastName ASC;

/***
	Write a query in SQL to return only the rows for product that have a sellstartdate that is not NULL and a productline of 'T'. 
	Return productid, productnumber, and name. Arranged the output in ascending order on name.
***/
SELECT ProductKey AS ProductId, ProductAlternateKey AS ProductNumber, EnglishProductName AS ProductName
FROM dbo.dimProduct
WHERE EndDate IS NOT NULL 
	AND ProductLine IN ('T')
ORDER BY EnglishProductName ASC;


SELECT ProductKey AS ProductId, ProductAlternateKey AS ProductNumber, EnglishProductName AS ProductName
FROM dbo.dimProduct
WHERE EndDate IS NOT NULL
	AND dbo.dimProduct.ProductLine = 'T'
ORDER BY EnglishProductName;


/***
	6. Write a query in SQL to create a list of unique jobtitles in the employee table in Adventureworks database. 
	Return jobtitle column and arranged the resultset in ascending order.
***/
SELECT DISTINCT Title AS JobTitle
FROM dbo.DimEmployee
ORDER BY JobTitle ASC;

/***
	7. Write a query in SQL to calculate the total freight paid by each customer. 
	   Return customerid and total freight. Sort the output in ascending order on customerid.
***/
SELECT CustomerKey AS CustomerId, SUM(Freight) AS TotalFreight
FROM dbo.FactInternetSales
GROUP BY CustomerKey
ORDER BY CustomerKey;

/*
	8. write a query in SQL to find the average and the sum of the subtotal for every customer. 
	Return customerid, average and sum of the subtotal. 
	Grouped the result on customerid and salespersonid. Sort the result on customerid column in descending order.
	SELECT	CustomerId, AVG(subtotal), SUM(subtotal)
FROM dbo.FactInternetSales
GROUP BY CustomerId, SalesPersonId
ORDER BY CustomerId DESC;
*/

/*
	9. Write a query in SQL to retrieve total quantity of each productid which are in shelf of 'A' or 'C' or 'H'. 
	Filter the results for sum quantity is more than 500. 
	Return productid and sum of the quantity. Sort the results according to the productid in ascending order.
*/
	SELECT ProductId, SUM(Quantity) AS TotalQuantity
	FROM Production.ProductionInventory
	WHERE ProductId IN ('A', 'C', 'H')
	ORDER BY ProductID ASC;

	/* Corrections */ 

	SELECT ProductId, SUM(Quantity) AS TotalQuantity
	FROM Production.ProductionInventory
	WHERE Shelf IN ('A', 'C', 'H')
	GROUP BY ProductId 
	HAVING TotalQuantity > 500
	ORDER BY ProductID ASC;


/*
	10.  From the following table write a query in SQL to find the total quantity for a group of locationid multiplied by 10.
*/
	SELECT SUM(LocationId) * 10 AS TotalQuantity
	FROM Production.ProductInventory

	/* Corrections */
	SELECT SUM(Quantity) AS TotalQuantity
	FROM Production.ProductInventory
	GROUP BY (LocationId * 10);

/*
	11. From the following tables write a query in SQL to find the persons whose last name starts with letter 'L'. 
		Return BusinessEntityID, FirstName, LastName, and PhoneNumber. 
		Sort the result on lastname and firstname.
*/
	SELECT BusinessEntityID, FirstName, LastName, PhoneNumber AS PersonPhone
	FROM Person.PersonPhone ph
	WHERE LastName LIKE 'L%'
	INNER JOIN Person.Person pp
		ON BusinessEntityID ph = BusinessEntityID pp
	ORDER BY LastName, FirstName

	/* Corrections */
	SELECT p.BusinessEntityID, FirstName, LastName, PhoneNumber AS PersonPhone
	FROM Person.Person p
	INNER JOIN Person.PersonPhone ph
		ON p.BusinessEntityID = ph.BusinessEntityID
	WHERE LIKE 'L%'
	ORDER BY LastName, FirstName;


/*
	From the following table write a query in SQL to find the sum of subtotal column. 
	Group the sum on distinct salespersonid and customerid. 
	Roll up the results into subtotal and running total. 
	Return salespersonid, customerid and sum of subtotal column i.e. sum_subtotal.
	Sales.SalesOrderHeader
*/
	SELECT DISTINCT SalesPersonID, DISTINCT CustomerID, SUM(SubTotal) AS SumSubTotal
	FROM Sales.SalesOrderHeader
	GROUP BY SalesPersonID, CustomerID;

	/* Corrections */
	SELECT SalesPersonID, CustomerID, SUM(SubTotal) AS SumSubTotal
	FROM Sales.SalesOrderHeader s
	GROUP BY ROLLUP (SalesPersonID, CustomerID)


/*
	13. From the following table write a query in SQL to find 
		the sum of the quantity of all combination of group of distinct locationid and shelf column. 
		Return locationid, shelf and sum of quantity as TotalQuantity.
*/
		SELECT LocationID, Shelf, SUM(Quantity) AS TotalQuantity
		FROM Production.ProductionInventory pi
		GROUP BY CUBE (LocationID, Shelf)

/*
	14. From the following table write a query in SQL to find the sum of the quantity with subtotal for each locationid. 
		Group the results for all combination of distinct locationid and shelf column. 
		Rolls up the results into subtotal and running total. Return locationid, shelf and sum of quantity as TotalQuantity.
*/
		SELECT LocationID, Shelf, SUM(Quantity) AS TotalQuantity
		FROM Production.ProductionInventory
		GROUP BY CUBE (LocationID, Shelf)
		ROLLUP(LocationID, Shelf)

		/* Corrections */
		SELECT LocationID, Shelf, SUM(Quantity) AS TotalaQuantity
		FROM Production.ProductionInventory
		GROUP BY GROUPING SETS (ROLLUP(LocationID, Shelf), CUBE(LocationID, Shelf));

/*
	15. From the following table write a query in SQL to 
		find the total quantity for each locationid and calculate the grand-total for all locations. 
		Return locationid and total quantity. Group the results on locationid.

		SELECT LocationID, SUM(Quantity) AS TotalQuantity
		FROM Production.ProductionInventory
		GROUP BY GROUPING SETS (LocationID, ());
*/

/*
	16.  From the following table write a query in SQL to retrieve the number of employees for each City. 
	Return city and number of employees. Sort the result in ascending order on city.
	
	SELECT City, COUNT(Employees) AS NumberOfEmployees 
	FROM Person.BusinessEntityAddress
	ORDER BY City ASC;

	Corrections
	SELECT a.City, COUNT(Employees) AS NoOfEmployees
	FROM Person.BusinessEntity AS b
		INNER JOIN Person.Address AS a
			ON b.AddressID = a.AddressID
	GROUP BY a.City
	ORDER BY a.City;
*/

/*

	17.  Write a query in SQL to retrieve the total sales for each year. 
	Return the year part of order date and total due amount. 
	Sort the result in ascending order on year part of order date.

	PostgreSQL
	SELECT DATE_PART('year',OrderDate) AS "Year", SUM(TotalDue) AS "Order Amount"  
	FROM Sales.SalesOrderHeader  
	GROUP BY DATE_PART('year',OrderDate)  
	ORDER BY DATE_PART('year',OrderDate);
*/
	SELECT YEAR(OrderDate) AS OrderYear, SUM(TotalDue) AS TotalSales
	FROM Sales.SalesOrderHeader s
	GROUP BY YEAR(OrderDate)
	ORDER BY YEAR(OrderDate) ASC;
	GO

	SELECT DATEPART(YEAR, OrderDate) AS OrderYear, SUM(TotalDue) AS AmountDue
	FROM Sales.SalesOrderHeader
	GROUP BY DATEPART(YEAR, OrderDate)
	ORDER BY DATEPART(YEAR, OrderDate) ASC;
	GO
/**
	18. Write a query in SQL to retrieve the total sales for each year. 
	Filter the result set for those orders where order year is on or before 2016. 
	Return the year part of orderdate and total due amount. 
	Sort the result in ascending order on year part of order date.

**/

	SELECT YEAR(OrderDate) AS OrderYear, SUM(TotalDue) AS TotalAmountDue
	FROM Sales.SalesOrderHeader
	GROUP BY YEAR(OrderDate)
	HAVING YEAR(OrderDate) <= '2016'
	ORDER BY YEAR(OrderDate);
	GO

	SELECT DATEPART(YEAR, OrderDate) AS OrderYear, SUM(TotalDue) AS TotalAmountDue
	FROM Sales.SalesOrderHeader
	GROUP BY DATEPART(YEAR, OrderDate)
	HAVING DATEPART(YEAR, OrderDate) <= '2016'
	ORDER BY DATEPART(YEAR, OrderDate);
	GO

/*
	19. Write a query in SQL to find the contacts who are designated as a manager in various departments. 
	Returns ContactTypeID, name. 
	Sort the result set in descending order.
*/
	SELECT ContactTypeID, Name
	FROM Person.ContactType
	WHERE Name LIKE '%Manager%'
	ORDER BY Name DESC;

/*
	20. Write a query in SQL to make a list of contacts who are designated as 'Purchasing Manager'. 
	Return BusinessEntityID, LastName, and FirstName columns. 
	Sort the result set in ascending order of LastName, and FirstName.
*/
	SELECT p.BusinessEntityID, LastName, FirstName
	FROM Person.BusinessEntityContact b
	INNER JOIN Person.ContactType c
		ON c.ContactTypeID = b.ContactTypeID
	INNER JOIN Person.Person p
		ON p.BusinessEntityID = b.PersonID
	WHERE Name = 'Purchasing Manager'
	ORDER BY LastName, FirstName;

/*
	21. Write a query in SQL to retrieve the salesperson for each PostalCode who belongs to a territory and SalesYTD is not zero. 
	Return row numbers of each group of PostalCode, last name, salesytd, postalcode column. 
	Sort the salesytd of each postalcode group in descending order. 
	Shorts the postalcode in ascending order.
*/
	
	SELECT 
		ROW_NUMBER() OVER (PARTITION BY pa.PostalCode ORDER BY sp.SalesYTD DESC) AS RowNumber,
		pp.LastName,
		sp.SalesYTD,
		pa.PostalCode
	FROM Sales.SalesPerson sp
		INNER JOIN Person.Person pp
			ON sp.BusinessEntityID = pp.BusinessEntityID
		INNER JOIN Person.BusinessEntityAddress pba
			ON sp.BusinessEntityID = pba.BusinessEntityID
		INNER JOIN Person.Address pa
			ON pba.AddressID = pa.AddressID
	WHERE sp.TerritoryID IS NOT NULL
		AND SalesYTD <> 0
	ORDER BY pa.PostalCode;

/* 22. Write a query in SQL to count the number of contacts for combination of each type and name. 
	   Filter the output for those who have 100 or more contacts. 
	   Return ContactTypeID and ContactTypeName and BusinessEntityContact. 
	   Sort the result set in descending order on number of contacts.
	   Person.BusinessEntityContact pbec
	   Person.ContactType pct
*/ 
	SELECT pc.ContactTypeID, pc.Name, COUNT(*) AS NumberOfContacts
	FROM Person.BusinessEntityContact pb
	INNER JOIN Person.ContactType pc
		ON pb.ContactTypeID = pc.ContactTypeID
	GROUP BY pc.ContactTypeID, pc.Name
	HAVING COUNT(*) >= 100
	ORDER BY COUNT(*) DESC;

/* 23. Write a query in SQL to retrieve the RateChangeDate, 
	   full name (first name, middle name and last name) and weekly salary (40 hours in a week) of employees. 
	   In the output the RateChangeDate should appears in date format. 
	   Sort the output in ascending order on NameInFull.
	   
	   HumanResources.EmployeePayHistory hre
	   Person.Person pp

	   SELECT CAST(hre.RateChangeDate AS DATE) RateChangeDate, 
			  CONCAT_WS(' ', pp.FirstName, pp.MiddleName, pp.LastName) AS FullName, 
			  CAST(hre.Rate * 40 AS DECIMAL(10, 2)) as WeeklySalary
	   FROM HumanResources.EmployeePayHistory hre
	   INNER JOIN Person.Person pp
		ON hre.BusinessEntityID = pp.BusinessEntityID
	   ORDER BY FullName ASC;
*/

/* 24. Write a query in SQL to calculate and display the latest weekly salary of each employee. 
	   Return RateChangeDate, full name (first name, middle name and last name) and weekly salary (40 hours in a week) of employees 
	   Sort the output in ascending order on NameInFull.
	   HumanResources.EmployeePayHistory hre
	   Person.Person pp

	   SELECT CAST(hre.Rate)

*/
/* 24. Write a query in SQL to calculate and display the latest weekly salary of each employee. 
	   Return RateChangeDate, full name (first name, middle name and last name) and weekly salary (40 hours in a week) of employees 
	   Sort the output in ascending order on NameInFull.
	   HumanResources.EmployeePayHistory hre
	   Person.Person pp

	   WITH LatestPay AS
		(
			SELECT 
				BusinessEntityID,
				RateChangeDate,
				Rate,
				ROW_NUMBER () OVER
				(
					PARTITION BY BusinessEntityID
					ORDER BY RateChangeDate DESC
				) AS rn
			FROM HumanResources.EmployeePayHistory
		)
	   
	   SELECT 
			  CAST(lp.RateChangeDate AS DATE) AS RateChangeDate, 
			  CONCAT_WS(' ', pp.FirstName, pp.MiddleName, pp.LastName) AS FullName,
			  CAST(lp.Rate * 40 AS DECIMAL(10, 2)) AS WeeklySalary
	  FROM LatestPay lp
	  INNER JOIN Person.Person pp
		ON lp.BusinessEntityID = pp.BusinessEntityID
	  WHERE lp.rn = 1
	  ORDER BY FullName;

	 WITH LatestPay AS
	(
		SELECT
			BusinessEntityID,
			RateChangeDate,
			Rate,
			ROW_NUMBER() OVER (
				PARTITION BY BusinessEntityID
				ORDER BY RateChangeDate DESC
				) AS RowNumber
		FROM HumanResources.EmployeePayHistory
	)
	 SELECT
		CAST(lp.RateChangeDate AS DATE) AS RateChangeDate,
		CONCAT_WS(' ', pp.FirstName, pp.MiddleName, pp.LastName) AS FullName,
		CAST(lp.Rate * 40 AS DECIMAL(10,2)) AS WeeklySalary,
	FROM LatestPay lp
	INNER JOIN Person.Person pp
		ON lp.BusinessEntityID = pp.BusinessEntityID
	ORDER BY lp.RateChangeDate DESC;
*/

/*
	25. Write a query in SQL to find 
	the sum, average, count, minimum, and maximum order quentity for those orders whose id are 43659 and 43664. 
	Return SalesOrderID, ProductID, OrderQty, sum, average, count, max, and min order quantity.

*/
SELECT 
		SalesOrderID,
		ProductID,
		OrderQty,
		SUM(OrderQty) OVER (PARTITION BY SalesOrderID) AS TotalOrders,
		AVG(OrderQty) OVER (PARTITION BY SalesOrderID) AS AverageOrders,
		COUNT(OrderQty) OVER (PARTITION BY SalesOrderID) AS NumberOfOrders,
		MAX(OrderQty) OVER (PARTITION BY SalesOrderID) AS HighestOrders,
		MIN(OrderQty) OVER (PARTITION BY SalesOrderID) AS LowestOrders
	FROM Sales.SalesOrderDetail
	WHERE SalesOrderID IN (43659, 43664);

/*
	26. Write a query in SQL to find the sum, average, 
	    and number of order quantity for those orders whose ids are 43659 and 43664 and product id starting with '71'. 
	    Return SalesOrderID, OrderNumber,ProductID, OrderQty, sum, average, and number of order quantity.
*/	
	SELECT 
		SalesOrderID,
		CarrierTrackingNumber,
		ProductID,
		OrderQty,
		SUM(OrderQty) OVER (PARTITION BY SalesOrderID) AS TotalOrders,
		AVG(OrderQty) OVER (PARTITION BY SalesOrderID) AS AverageOrders,
		COUNT(OrderQty) OVER (PARTITION BY SalesOrderID) AS NumberOfOrders
	FROM Sales.SalesOrderDetail
	WHERE SalesOrderID IN (43659, 43664)
		AND CAST(ProductID AS VARCHAR(10)) LIKE '71%';

/*
	27. Write a query in SQL to retrieve the total cost of each salesorderID that exceeds 100000. 
	Return SalesOrderID, total cost.
*/
	SELECT 
		SalesOrderID,
		SUM(OrderQty * UnitPrice) AS TotalCost
	FROM Sales.SalesOrderDetail
	GROUP BY SalesOrderID
	HAVING SUM(OrderQty * UnitPrice) > 100000
	ORDER BY SalesOrderID;

/*
	28. Write a query in SQL to retrieve products whose names start with 'Lock Washer'. 
	Return product ID, and name and 
	order the result set in ascending order on product ID column.
	Production.Production
*/
	SELECT 
		ProductID,
		Name
	FROM [Production].[Product]
	WHERE Name LIKE 'Lock Washer%'
	ORDER BY ProductID ASC;
	GO

/*
	29. Write a query in SQL to fetch rows from product table and order the result set on an unspecified column listprice. 
		Return product ID, name, and color of the product.
*/
	SELECT
		ProductID,
		Name,
		Color
	FROM [Production].[Product]
	ORDER BY ListPrice;

/*
	30. Write a query in SQL to retrieve records of employees. 
	Order the output on year (default ascending order) of hiredate. 
	Return BusinessEntityID, JobTitle, and HireDate.
*/
	SELECT
		BusinessEntityID,
		JobTitle,
		HireDate
	FROM HumanResources.Employee
	ORDER BY DATEPART(YEAR, HireDate) ASC;

/*
	31. Write a query in SQL to retrieve those persons whose last name begins with letter 'R'. 
		Return lastname, and firstname and display the result in ascending order on firstname and 
		descending order on lastname columns.
*/
	SELECT
		LastName,
		FirstName
	FROM Person.Person
	WHERE LastName LIKE 'R%'
	ORDER BY FirstName ASC, LastName DESC;

/*
	32. Write a query in SQL to ordered the BusinessEntityID column descendingly when SalariedFlag set to 'true' and 
		BusinessEntityID in ascending order when SalariedFlag set to 'false'. 
		Return BusinessEntityID, SalariedFlag columns.
*/
	SELECT
    BusinessEntityID,
    CASE SalariedFlag
		WHEN 1 THEN 'True'
		WHEN 0 THEN 'False'
	END AS SalariedFlag
FROM HumanResources.Employee
ORDER BY CASE SalariedFlag WHEN 1 THEN BusinessEntityID END DESC,
         CASE SalariedFlag WHEN 0 THEN BusinessEntityID END ASC;
