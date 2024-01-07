# MSSQL Cookbooks

Some useful MSSQL queries for daily maintainance.

## Expensive queries

```sql
SELECT TOP 10 SUBSTRING(qt.TEXT, (qs.statement_start_offset/2)+1, ((CASE qs.statement_end_offset
WHEN -1 THEN DATALENGTH(qt.TEXT)
ELSE qs.statement_end_offset
END - qs.statement_start_offset)/2)+1),
qs.execution_count,
qs.total_logical_reads,
qs.last_logical_reads,
qs.total_logical_writes,
qs.last_logical_writes,
qs.total_worker_time,
qs.last_worker_time,
qs.total_elapsed_time/1000000 total_elapsed_time_in_S,
qs.last_elapsed_time/1000000 last_elapsed_time_in_S,
qs.last_execution_time,
qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text
(
   qs.sql_handle
)
qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY qs.total_logical_reads DESC -- logical reads
-- ORDER BY qs.total_logical_writes DESC -- logical writes
-- ORDER BY qs.total_worker_time DESC -- CPU time
```

## Find the most fragmented indexes

```sql
SELECT dbschemas.[name] as 'Schema', dbtables.[name] as 'Table', dbindexes.[name] as 'Index', indexstats.avg_fragmentation_in_percent, indexstats.page_count
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS indexstats
INNER JOIN sys.tables dbtables on dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas on dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id]
AND indexstats.index_id = dbindexes.index_id
WHERE indexstats.database_id = DB_ID() --AND dbtables.[name] like 'WastePickup%'
ORDER BY indexstats.avg_fragmentation_in_percent desc
```

## Large tables

```sql
SELECT
    t.NAME AS TableName,
    i.name as indexName,
    p.[Rows],
    sum(a.total_pages) as TotalPages,
    sum(a.used_pages) as UsedPages,
    sum(a.data_pages) as DataPages,
    (sum(a.total_pages) * 8) / 1024 as TotalSpaceMB,
    (sum(a.used_pages) * 8) / 1024 as UsedSpaceMB,
    (sum(a.data_pages) * 8) / 1024 as DataSpaceMB
FROM
    sys.tables t
INNER JOIN
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN
    sys.allocation_units a ON p.partition_id = a.container_id
WHERE
    t.NAME NOT LIKE 'dt%' AND
    i.OBJECT_ID > 255 AND
    i.index_id <= 1
GROUP BY
    t.NAME, i.object_id, i.index_id, i.name, p.[Rows]
ORDER BY
--    object_name(i.object_id)
  Rows desc
```

## Open connections

```sql
SELECT DB_NAME(dbid) as DBName, COUNT(dbid) as NumberOfConnections, loginame as LoginName
FROM sys.sysprocesses
WHERE dbid > 0
--AND status <> 'sleeping'
GROUP BY dbid, loginame
```

## Statistics

###Info about the last stats update

```sql
SELECT t.name AS Table_Name, i.name AS Index_Name, i.type_desc AS Index_Type ,
STATS_DATE(i.object_id,i.index_id) AS Date_Updated
FROM sys.indexes i
JOIN sys.tables t ON t.object_id = i.object_id
WHERE i.type > 0
ORDER BY Date_Updated ASC
--t.name ASC ,i.type_desc ASC ,i.name ASC
```

### Update the stats for an index on a table

```sql
UPDATE STATISTICS table_name index_name
```

### Update all stats in a schema

NB: This can take a long time (in excess of 20 minutes)

```sql
EXEC sp_updatestats
```

### SPLIT_STRING before SQL Server 2016

```sql
CREATE FUNCTION STRING_SPLIT ( 
    @string NVARCHAR(MAX), 
    @delimiter CHAR(1) 
) 
RETURNS @output TABLE([value] NVARCHAR(MAX)) 
BEGIN 
    DECLARE @start INT, @end INT 
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string) 
    WHILE @start < LEN(@string) + 1 BEGIN 
        IF @end = 0  
            SET @end = LEN(@string) + 1
       
        INSERT INTO @output ([value])  
        VALUES(SUBSTRING(@string, @start, @end - @start)) 
        SET @start = @end + 1 
        SET @end = CHARINDEX(@delimiter, @string, @start)        
    END 
    RETURN 
END
```

Source: http://www.sqlservercentral.com/blogs/querying-microsoft-sql-server/2013/09/19/how-to-split-a-string-by-delimited-char-in-sql-server/

[gimmick:Disqus](swissarmyronin-github-io)