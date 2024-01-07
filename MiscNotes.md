# Misc. Notes

This page contains a collection of unrelated notes pertaining to issues I have Googled more than once.

## Move a feature branch from one product to another

If, by accident, one has created a feature ``foo`` from the wrong product version branch (eg.: ``tmtand-3.1/develop``) and it really should have started from another product version branch (eg.: ``tmtand-3.2/develop``)), then it's easy to rebase the feature on the proper product version with:

    git rebase --onto target-branch source-branch

So in the case above, that would be:

    git checkout tmtand-3.1/feature/foo
    git rebase --onto tmtand-3.2/develop tmtand-3.1/develop

## SecurityException on binaries running from a network share

Let's say I get a SecurityException when running my .NET console application from "\\vmware-host\Shared Folders". In this case, simply open a developer prompt and type:

    CasPol.exe -m -ag 1.2 -url "file://\\vmware-host\Shared Folders/*" FullTrust

From "[Using CasPol to Fully Trust a Share](https://blogs.msdn.microsoft.com/shawnfa/2004/12/30/using-caspol-to-fully-trust-a-share/)".

## Netcopy

Want to copy a file from one *Nix macine to another without the hassle of FTP?


    DestinationShell# nc -l -p 2020 > file.txt
    SourceShell# cat file.txt | nc dest.ip.address 2020

## Working with multiple git repositories

If your product consists of specific versions across multiple repositories, there are multiple options for managing that. I prefer [Gitslave](http://gitslave.sourceforge.net) or ``gits``, but while researching the issue, I came across a number of tools for the same problem:

   * [gr -- A tool for managing multiple git repositories](http://mixu.net/gr/)
   * [Alternatives To Git Submodule: Git Subtree](http://blogs.atlassian.com/2013/05/alternatives-to-git-submodule-git-subtree/)
   * [git-repo](https://code.google.com/p/git-repo/)
   * [giternal](https://github.com/patmaddox/giternal)
   * [braid](https://github.com/cristibalan/braid)

## Temp. Git ignore

So, to temporarily ignore changes in a certain file, run:

    git update-index --assume-unchanged <file>

Then when you want to track changes again:

    git update-index --no-assume-unchanged <file>

## TWiki syntax high-lighting

TWiki sucks. But it sucks harder without syntax higlighting of snipptes. This plugin fixes that: [DpSyntaxHighlighterPlugin](http://twiki.org/cgi-bin/view/Plugins/DpSyntaxHighlighterPlugin)

## Cruft detection

Legacy projects are hoary with cruft. Find it and remove it with ...

   * [Classpath Helper](http://classpathhelper.sourceforge.net)
   * [UCDetector: Unnecessary Code Detector](http://www.ucdetector.org)
   * [Tattletale](http://tattletale.jboss.org)

## Codesigning

Signing a .NET binary post build is easy with a X.509 certificate. Heres how to sign ``MyApp.exe`` with ``mycert.pfx``:

    signtool.exe sign /v /f "mycert.pfx" -t "http://timestamp.verisign.com/scripts/timstamp.dll" "MyApp.exe"

## Custom Security Contexts in Jersey

[Jersey (JAX-RS) SecurityContext in action](https://simplapi.wordpress.com/2015/09/19/jersey-jax-rs-securitycontext-in-action/)

## Linux & PAM

Sometimes you have a Linux server that uses PAM/ActiveDirectory to validate logins. If the connection to the AD lapses for some reason, you can find yourself locked out. These steps fix that.

Boot into singleuser mode, hold shift duirng startup and choose ``advanced options -> recoverymode -> drop to root shell`` from the Grub menu.

Remount harddisk in RW mode: 

    mount -o remount,rw /

Reestablish AD trust with Kerberos:

    kinit xxx@MY-DOM

... hvor ``xxx`` is an AD browser account on the ``MY-DOM`` domain.

## .NET Core notes

* [.NET Core download](https://www.microsoft.com/net/core)
* [Documentation](https://docs.asp.net/en/latest)
* [.NET Compatibility Diagnostic Tools](http://dotnetstatus.azurewebsites.net)
* [How to setup Https on Kestrel](http://dotnetthoughts.net/how-to-setup-https-on-kestrel)
* [Using both xproj and csproj with .NET Core](http://stackify.com/using-both-xproj-and-csproj-with-net-core)

## REST Services 
[Service versioning](http://www.hanselman.com/blog/ASPNETCoreRESTfulWebAPIVersioningMadeEasy.aspx)

## SQL Cookbooks

Some useful MSSQL queries for daily maintainance.

### Expensive queries

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

### Find the most fragmented indexes

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

### Large tables

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

### Open connections

```sql
SELECT DB_NAME(dbid) as DBName, COUNT(dbid) as NumberOfConnections, loginame as LoginName
FROM sys.sysprocesses
WHERE dbid > 0
--AND status <> 'sleeping'
GROUP BY dbid, loginame
```

### Statistics

####Info about the last stats update

```sql
SELECT t.name AS Table_Name, i.name AS Index_Name, i.type_desc AS Index_Type ,
STATS_DATE(i.object_id,i.index_id) AS Date_Updated
FROM sys.indexes i
JOIN sys.tables t ON t.object_id = i.object_id
WHERE i.type > 0
ORDER BY Date_Updated ASC
--t.name ASC ,i.type_desc ASC ,i.name ASC
```

#### Update the stats for an index on a table

```sql
UPDATE STATISTICS table_name index_name
```

#### Update all stats in a schema

NB: This can take a long time (in excess of 20 minutes)

```sql
EXEC sp_updatestats
```

[gimmick:Disqus](swissarmyronin-github-io)