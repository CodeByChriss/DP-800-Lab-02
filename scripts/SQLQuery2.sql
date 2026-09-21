 CREATE OR ALTER VIEW SalesLT.vCustomerOrders AS
 SELECT 
     c.CustomerID,
     CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
     h.SalesOrderID,
     h.OrderDate
 FROM SalesLT.Customer c
 INNER JOIN SalesLT.SalesOrderHeader h ON c.CustomerID = h.CustomerID;