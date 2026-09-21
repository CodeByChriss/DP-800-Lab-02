 -- Audit table
 IF OBJECT_ID('dbo.OrderAudit') IS NULL
 BEGIN
     CREATE TABLE dbo.OrderAudit (
         AuditID     INT IDENTITY(1,1) PRIMARY KEY,
         OrderID     INT NOT NULL,
         OldTotal    DECIMAL(18,2) NULL,
         NewTotal    DECIMAL(18,2) NULL,
         ChangedAt   DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
     );
 END
 GO

 -- Trigger on order details updates
 CREATE OR ALTER TRIGGER SalesLT.trg_LogOrderTotalChange
 ON SalesLT.SalesOrderDetail
 AFTER INSERT, UPDATE
 AS
 BEGIN
     SET NOCOUNT ON;

     ;WITH AffectedOrders AS (
         SELECT SalesOrderID FROM inserted
         UNION
         SELECT SalesOrderID FROM deleted
     ),
     -- New totals from the base table (already reflects changes)
     NewTotals AS (
         SELECT d.SalesOrderID, SUM(d.OrderQty * d.UnitPrice) AS Total
         FROM SalesLT.SalesOrderDetail d
         INNER JOIN AffectedOrders a ON d.SalesOrderID = a.SalesOrderID
         GROUP BY d.SalesOrderID
     ),
     -- Contribution of the newly inserted/updated rows
     InsertedTotals AS (
         SELECT SalesOrderID, SUM(OrderQty * UnitPrice) AS Total
         FROM inserted
         GROUP BY SalesOrderID
     ),
     -- Contribution of the previous row versions (empty on INSERT)
     DeletedTotals AS (
         SELECT SalesOrderID, SUM(OrderQty * UnitPrice) AS Total
         FROM deleted
         GROUP BY SalesOrderID
     )
     INSERT INTO dbo.OrderAudit (OrderID, OldTotal, NewTotal)
     SELECT
         n.SalesOrderID,
         n.Total - ISNULL(i.Total, 0) + ISNULL(d.Total, 0) AS OldTotal,
         n.Total AS NewTotal
     FROM NewTotals n
     LEFT JOIN InsertedTotals i ON n.SalesOrderID = i.SalesOrderID
     LEFT JOIN DeletedTotals d ON n.SalesOrderID = d.SalesOrderID;
 END;