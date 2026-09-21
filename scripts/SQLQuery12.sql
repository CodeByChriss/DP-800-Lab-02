 -- Update an order detail to change the total
 UPDATE d
 SET OrderQty = OrderQty + 1
 FROM SalesLT.SalesOrderDetail d
 WHERE d.SalesOrderID = (SELECT TOP 1 SalesOrderID FROM SalesLT.SalesOrderHeader ORDER BY SalesOrderID DESC);
    
 SELECT TOP (5) * 
 FROM dbo.OrderAudit 
 ORDER BY AuditID DESC;