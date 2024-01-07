# SSIS Notes

Some random notes about the challenges of SSIS.

## Calling stored procedures from OLE DB Source

Calling parameterized stored procedures from an OLE DB Source uses a non intuitive interface.

Assuming I want to call an SP called "Foo" with an integer parameter "@Bar" that returns a tuple of "{Int, NVarChar(255)}", I would normally call the SP with

```sql
EXEC Foo ?
```

... where ? is a string.

However, SSIS will fail to map the query parameters and output correctly.

Instead I must set the script to:

```sql
EXEC Foo @Bar = ? WITH RESULT SETS 
(
 ( 
  [Baz] INT,
  [Lur] VARCHAR(255)
 ) 
)
```

In the "Parameters..." section, I also have to name the parameter "@Bar" before mapping it to a suitable input variable.

Source: <http://geekswithblogs.net/stun/archive/2009/03/05/mapping-stored-procedure-parameters-in-ssis-ole-db-source-editor.aspx>
