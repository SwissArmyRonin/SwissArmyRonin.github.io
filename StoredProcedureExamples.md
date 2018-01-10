# Examples of stored procedures/functions

These are based on scanning some tables and aggreagating data. The details are unimportant, but both methods achieve roughly the same result.

## Stored procedure with shared temp table

Creates two procedures (dropping existing variants). The second procedure uses the output from the first.

```sql
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'GetSlowExecutions') AND type IN ( N'P', N'PC' ))
DROP PROCEDURE GetSlowExecutions
GO

CREATE PROCEDURE GetSlowExecutions
	@ThresholdSeconds BIGINT   
AS   
    SET NOCOUNT ON;  
	SELECT ExecutionId, (ExecutionDurationSec * 1000) / NumberOfRowsInserted AS MsPerRow, ExecutionDurationSec / 60 AS Minutes, PackageName, 
		Status, Destination, NumberOfRowsInserted	
	FROM (
		SELECT xd.ExecutionDurationSec, x.PackageName, xd.ExecutionId, xd.Status, xd.Destination, xd.NumberOfRowsInserted, 
			xd.NumberOfRowsSelected, xd.StartTime, xd.EndTime
		FROM Audit.ExecutionDetail AS xd 
		INNER JOIN Audit.Execution AS x ON xd.ExecutionId = x.ExecutionId
		WHERE xd.ExecutionDurationSec > 0
	) AS x
	WHERE (NumberOfRowsInserted > 0) AND (ExecutionDurationSec > @ThresholdSeconds)
	ORDER BY MsPerRow DESC;
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'GetSlowPackages') AND type IN ( N'P', N'PC' ))
DROP PROCEDURE GetSlowPackages
GO

-- packages that contain executions where every insert takes a long time and the overall 
-- execution time is greater than @ThresholdSeconds
CREATE PROCEDURE GetSlowPackages
	@ThresholdSeconds BIGINT   
AS   
    SET NOCOUNT ON;  
	CREATE TABLE #Result (
		ExecutionId BIGINT, MsPerRow INT, Minutes INT, PackageName VARCHAR(255),
		Status VARCHAR(255), Destination VARCHAR(255), NumberOfRowsInserted INT
	);
	INSERT #Result EXECUTE GetSlowExecutions @ThresholdSeconds;
	SELECT MAX(MsPerRow) AS MsPerRow, PackageName
	FROM #Result AS sq
	GROUP BY PackageName
	ORDER BY MsPerRow DESC;
	DROP TABLE #Result;
GO

DECLARE @Threshold INT = 600;
EXECUTE GetSlowExecutions @Threshold
EXECUTE GetSlowPackages @Threshold
GO
```

## Functions

As before, two functions, where the latter uses the first's output.

```sql
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FGetSlowExecutions') AND type = N'IF')
DROP FUNCTION FGetSlowExecutions
GO

CREATE FUNCTION FGetSlowExecutions (@ThresholdSeconds int)
RETURNS TABLE AS
RETURN (
	SELECT ExecutionId, (ExecutionDurationSec * 1000) / NumberOfRowsInserted AS MsPerRow, ExecutionDurationSec / 60 AS Minutes, PackageName, 
		Status, Destination, NumberOfRowsInserted	
	FROM (
		SELECT xd.ExecutionDurationSec, x.PackageName, xd.ExecutionId, xd.Status, xd.Destination, xd.NumberOfRowsInserted, 
			xd.NumberOfRowsSelected, xd.StartTime, xd.EndTime
		FROM Audit.ExecutionDetail AS xd 
		INNER JOIN Audit.Execution AS x ON xd.ExecutionId = x.ExecutionId
		WHERE xd.ExecutionDurationSec > 0
	) AS x
	WHERE NumberOfRowsInserted > 0 AND ExecutionDurationSec > @ThresholdSeconds
)
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FGetSlowPackages') AND type = N'IF')
DROP FUNCTION FGetSlowPackages
GO

CREATE FUNCTION FGetSlowPackages (@ThresholdSeconds int)
RETURNS TABLE AS
RETURN (
	SELECT MAX(MsPerRow) AS MsPerRow, PackageName
	FROM FGetSlowExecutions(@ThresholdSeconds)
	GROUP BY PackageName
)
GO

DECLARE @Threshold INT = 600;
SELECT * FROM FGetSlowExecutions(@Threshold) ORDER BY MsPerRow DESC
SELECT * FROM FGetSlowPackages(@Threshold) ORDER BY MsPerRow DESC
GO
```