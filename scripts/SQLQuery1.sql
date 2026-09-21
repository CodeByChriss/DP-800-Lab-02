 -- Verify key tables in AdventureWorksLT
 SELECT TOP (5) CustomerID, FirstName, LastName 
 FROM SalesLT.Customer;
    
 SELECT TOP (5) SalesOrderID, OrderDate, CustomerID 
 FROM SalesLT.SalesOrderHeader;
    
 SELECT TOP (5) ProductID, Name, ListPrice 
 FROM SalesLT.Product;