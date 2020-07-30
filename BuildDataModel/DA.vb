Imports System.Data.SqlClient
Imports System.IO
Imports System.Text
Imports System.Xml.Xsl

Public Class DA
    Public Enum DataAdapterType
        Table
        Custom
    End Enum
    Public Property Server() As String
    Public Property Database() As String
    Public Property UserID() As String
    Public Property Password() As String
    Public Property OutputFolder() As String
    Public Property AppName As String

    Private ReadOnly listToContext As New List(Of String)
    Public Function GetTables() As DataTable
        Dim Query As String
        Query = "select name from sysobjects where xtype in ('u','v') "
        Query += " ORDER BY name"
        Return GetData(Query).Tables(0)
    End Function
    Public Function GetTableSchemaDataset(ByVal tableName As String) As DataSet
        Dim ds As DataSet '("ParentData")
        Dim query As String = QueryForTableStructureNoFkeys() & " AND INFORMATION_SCHEMA.COLUMNS.TABLE_NAME ='" & tableName & "'"
        ds = GetData(query)
        'UpcaseTable(ds.Tables(0))
        ds.Tables(0).TableName = "ChildData"

        Dim dtPar As DataTable = MakeParentDatatable(AppName, CapText(tableName), Database)
        dtPar.TableName = "ParentData"
        ds.Tables.Add(dtPar)
        'FKeyEntityName
        'Dim fkText = "select EntityClassName, UPPER(LEFT(FKeyEntityName,1))+LOWER(SUBSTRING(FKeyEntityName,2,LEN(FKeyEntityName))) AS FKeyEntityName from ("
        Dim fkText = "select EntityClassName, UPPER(LEFT(FKeyEntityName,1))+(SUBSTRING(FKeyEntityName,2,LEN(FKeyEntityName))) AS FKeyEntityName from ("
        'Dim fkText = "select EntityClassName, FKeyEntityName from ("
        Dim FKquery = fkText + query.Replace("DISTINCT", "DISTINCT KEYTABLE.TableName As FKeyEntityName, ") + ") As FKeysTable where FKeyEntityName is not null"
        Dim dtFKeys As DataTable = GetData(FKquery).Tables(0).Copy
        dtFKeys.TableName = "FKeys"
        ds.Tables.Add(dtFKeys)

        ds.Tables(0).ParentRelations.Add(ds.Tables(1).Columns(1), ds.Tables(0).Columns(0)).Nested = True
        ds.Tables(2).ParentRelations.Add(ds.Tables(1).Columns(1), ds.Tables(2).Columns(0)).Nested = True

        ds.DataSetName = "Entitybase"

        Return ds
    End Function
    Public Sub UpcaseTable(ByRef dt As DataTable)
        For Each row In dt.Rows
            row(0) = ToDBNull(CapText(row(0).ToString))
            row(1) = ToDBNull(CapText(row(1).ToString))
            row(7) = ToDBNull(CapText(row(7).ToString))
            row(8) = ToDBNull(CapText(row(8).ToString))
        Next
    End Sub
    Private Function ToDBNull(Value As String) As Object
        If Value Is Nothing Then
            Return DBNull.Value
        Else
            Return Value
        End If
    End Function
    Private Sub ConvertDataType(ByRef dt As DataTable)
        For Each row In dt.Rows
            Dim dataType As String = row(7).ToString().ToLower
            'If dataType.Contains("char") Then
            '    dataType = "String"
            'End If
            Select Case dataType
                Case "bigint", "int", "smallint", "tinyint"
                    dataType = "int"
                Case "Decimal", "float", "money", "numeric", "real", "smallmoney"
                    dataType = "decimal"
                Case "binary", "image", "varbinary", "timestamp"
                    dataType = "byte[]"
                Case "char", "nchar", "ntext", "nvarchar", "text", "varchar"
                    dataType = "string"
                Case "Date", "datetime", "datetime2", "datetimeoffset", "smalldatetime", "time"
                    dataType = "DateTime"
                Case "bit"
                    dataType = "bool"
            End Select
            row(7) = dataType
        Next
    End Sub
    Public Function GetTableSchema(ByVal tableName As String) As DataTable
        Dim dt As DataTable
        Dim query As String = QueryForTableStructure() & " And INFORMATION_SCHEMA.COLUMNS.TABLE_NAME ='" & tableName & "'"
        dt = GetData(query).Tables(0)
        'UpcaseTable(dt)
        ConvertDataType(dt)
        Return dt
    End Function
    Private Function CapText(word As String) As String
        If word IsNot Nothing AndAlso word.Length > 0 Then
            Return word(0).ToString.ToUpper() + word.Substring(1)
        End If
        Return Nothing
    End Function
    Private Function MakeParentDatatable(DbAppName As String, DbBaseTableName As String, DbName As String) As DataTable
        Dim dt As New DataTable
        dt.Columns.Add("AppName")
        dt.Columns.Add("EntityClassName")
        dt.Columns.Add("ContextName")

        Dim row As DataRow = dt.NewRow
        row(0) = DbAppName
        row(1) = DbBaseTableName
        row(2) = DbName
        dt.Rows.Add(row)
        Return dt
    End Function
    Private Function GetConnString() As String
        Dim conn As String
        conn = "Data Source=" & _Server & ";Initial Catalog=" & _Database & ";Persist Security Info=True;User ID=" & _UserID & ";Password=" & _Password & ";" 'Max Pool Size=100;"
        Return conn
    End Function
    Private Function GetData(ByVal Query As String) As DataSet
        Dim conn As New SqlConnection(GetConnString)
        Dim sda As New SqlDataAdapter(Query, conn)
        Dim ds As New DataSet
        sda.Fill(ds)
        conn.Dispose()
        Return ds
    End Function
    Private Function QueryForTableStructure() As String

        Dim queryStruct As String = ""
        queryStruct += "SELECT DISTINCT " 'INFORMATION_SCHEMA.COLUMNS.TABLE_NAME AS EntityClassName, INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME AS EntityPropertyName, "
        queryStruct += "UPPER(LEFT(INFORMATION_SCHEMA.COLUMNS.TABLE_NAME,1))+LOWER(SUBSTRING(INFORMATION_SCHEMA.COLUMNS.TABLE_NAME,2,LEN(INFORMATION_SCHEMA.COLUMNS.TABLE_NAME))) AS EntityClassName, "
        queryStruct += "LOWER(INFORMATION_SCHEMA.COLUMNS.TABLE_NAME) AS EntityClassLower, "
        queryStruct += "UPPER(LEFT(INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME,1))+LOWER(SUBSTRING(INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME,2,LEN(INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME))) AS EntityPropertyName, "
        queryStruct += "LOWER(INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME) AS EntityPropertyLower, "
        queryStruct += "INFORMATION_SCHEMA.COLUMNS.ORDINAL_POSITION As OrdinalPosition, "
        queryStruct += "INFORMATION_SCHEMA.COLUMNS.COLUMN_DEFAULT As ColumnDefault, CASE WHEN INFORMATION_SCHEMA.COLUMNS.IS_NULLABLE = 'YES' THEN 1 ELSE 0 END AS AllowNull, INFORMATION_SCHEMA.COLUMNS.DATA_TYPE AS DataType, "
        queryStruct += "INFORMATION_SCHEMA.COLUMNS.CHARACTER_MAXIMUM_LENGTH AS ColumnSize, FKEYTABLE.ReferenceTableName As KeyEntityName, FKEYTABLE.ReferenceColumnName As KeyPropertyName, "
        queryStruct += "KEYTABLE.TableName As FKeyEntityName, KEYTABLE.ColumnName As FKeyPropertyName, "
        queryStruct += "CASE WHEN IsKeyCol.COLUMN_NAME IS NULL THEN 0 ELSE 1 END AS IsKey, CASE WHEN FKEYTABLE.ReferenceColumnName IS NULL THEN 0 ELSE 1 END AS IsFKey, "
        queryStruct += "CASE WHEN KEYTABLE.ReferenceColumnName IS NULL THEN 0 ELSE 1 END AS HasFKey "
        queryStruct += ", UPPER(LEFT(FKEYTABLE.ReferenceColumnName,1))+LOWER(SUBSTRING(FKEYTABLE.ReferenceColumnName,2,LEN(FKEYTABLE.ReferenceColumnName))) AS ReferenceColumnName "
        queryStruct += ", UPPER(LEFT(FKEYTABLE.ReferenceTableName,1))+LOWER(SUBSTRING(FKEYTABLE.ReferenceTableName,2,LEN(FKEYTABLE.ReferenceTableName))) AS ReferenceTableName "
        'queryStruct += ", FKEYTABLE.ReferenceColumnName, FKEYTABLE.ReferenceTableName "
        queryStruct += "FROM INFORMATION_SCHEMA.TABLES INNER JOIN "
        queryStruct += "INFORMATION_SCHEMA.COLUMNS ON INFORMATION_SCHEMA.TABLES.TABLE_NAME = INFORMATION_SCHEMA.COLUMNS.TABLE_NAME AND "
        queryStruct += "INFORMATION_SCHEMA.TABLES.TABLE_CATALOG = INFORMATION_SCHEMA.COLUMNS.TABLE_CATALOG AND "
        queryStruct += "INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA = INFORMATION_SCHEMA.COLUMNS.TABLE_SCHEMA LEFT OUTER JOIN "
        queryStruct += "(SELECT OBJECT_NAME(f.parent_object_id) AS TableName, COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ColumnName, OBJECT_NAME(f.referenced_object_id) AS ReferenceTableName, "
        queryStruct += "COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS ReferenceColumnName, f.name AS ForeignKey "
        queryStruct += "FROM sys.foreign_keys AS f INNER JOIN "
        queryStruct += "sys.foreign_key_columns AS fc ON f.object_id = fc.constraint_object_id INNER JOIN "
        queryStruct += "sys.objects AS o ON o.object_id = fc.referenced_object_id) AS KEYTABLE ON INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = KEYTABLE.ReferenceTableName AND "
        queryStruct += "INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME = KEYTABLE.ReferenceColumnName LEFT OUTER JOIN "
        queryStruct += "(SELECT OBJECT_NAME(f.parent_object_id) AS TableName, COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ColumnName, OBJECT_NAME(f.referenced_object_id) AS ReferenceTableName, "
        queryStruct += "COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS ReferenceColumnName, f.name AS ForeignKey "
        queryStruct += "FROM sys.foreign_keys AS f INNER JOIN "
        queryStruct += "sys.foreign_key_columns AS fc ON f.object_id = fc.constraint_object_id INNER JOIN "
        queryStruct += "sys.objects AS o ON o.object_id = fc.referenced_object_id) AS FKEYTABLE ON INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = FKEYTABLE.TableName AND "
        queryStruct += "INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME = FKEYTABLE.ColumnName LEFT OUTER JOIN "
        queryStruct += "(SELECT i1.TABLE_NAME, i2.COLUMN_NAME "
        queryStruct += "FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS i1 INNER JOIN "
        queryStruct += "INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS i2 ON i1.CONSTRAINT_NAME = i2.CONSTRAINT_NAME "
        queryStruct += "WHERE (i1.CONSTRAINT_TYPE = 'PRIMARY KEY')) AS IsKeyCol ON INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = IsKeyCol.TABLE_NAME AND "
        queryStruct += "INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME = IsKeyCol.COLUMN_NAME "
        queryStruct += "WHERE " '(INFORMATION_SCHEMA.TABLES.TABLE_TYPE = 'BASE TABLE') AND 
        queryStruct += "INFORMATION_SCHEMA.COLUMNS.DATA_TYPE in "
        queryStruct += "('bigint','binary','bit','char','date','datetime','datetime2','datetimeoffset','decimal',"
        queryStruct += "'float','image','int','money','nchar','ntext','numeric','nvarchar','real','smalldatetime',"
        queryStruct += "'smallint','smallmoney','text','time','timestamp','tinyint','varbinary','varchar')"

        'query.AppendLine("ORDER BY INFORMATION_SCHEMA.TABLES.TABLE_NAME")
        Return queryStruct

    End Function
    Private Function QueryForTableStructureNoFkeys() As String
        Dim Query As New StringBuilder
        Query.AppendLine("SELECT DISTINCT ")
        Query.AppendLine("UPPER(LEFT(INFORMATION_SCHEMA.COLUMNS.TABLE_NAME,1))+(SUBSTRING(INFORMATION_SCHEMA.COLUMNS.TABLE_NAME,2,LEN(INFORMATION_SCHEMA.COLUMNS.TABLE_NAME))) AS EntityClassName, ")
        'Query.AppendLine("INFORMATION_SCHEMA.COLUMNS.TABLE_NAME AS EntityClassName, ")
        Query.AppendLine("LOWER(INFORMATION_SCHEMA.COLUMNS.TABLE_NAME) AS EntityClassLower, ")
        Query.AppendLine("UPPER(LEFT(INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME,1))+(SUBSTRING(INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME,2,LEN(INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME))) AS EntityPropertyName, ")
        'Query.AppendLine("INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME AS EntityPropertyName, ")
        Query.AppendLine("LOWER(INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME) AS EntityPropertyLower, ")
        Query.AppendLine("INFORMATION_SCHEMA.COLUMNS.ORDINAL_POSITION AS OrdinalPosition, ")
        Query.AppendLine("INFORMATION_SCHEMA.COLUMNS.COLUMN_DEFAULT AS ColumnDefault, ")
        Query.AppendLine("CASE WHEN INFORMATION_SCHEMA.COLUMNS.IS_NULLABLE = 'YES' THEN 1 ELSE 0 END AS AllowNull, ")
        Query.AppendLine("INFORMATION_SCHEMA.COLUMNS.DATA_TYPE AS DataType, ")
        Query.AppendLine("INFORMATION_SCHEMA.COLUMNS.CHARACTER_MAXIMUM_LENGTH AS ColumnSize, ")
        Query.AppendLine("CASE WHEN IsKeyCol.COLUMN_NAME IS NULL THEN 0 ELSE 1 END AS IsKey, ")
        Query.AppendLine("CASE WHEN FKEYTABLE.ReferenceColumnName IS NULL THEN 0 ELSE 1 END AS IsFKey, ")
        Query.AppendLine("CASE WHEN KEYTABLE.ReferenceColumnName IS NULL THEN 0 ELSE 1 END AS HasFKey,")
        Query.AppendLine("UPPER(LEFT(FKEYTABLE.ReferenceColumnName,1))+(SUBSTRING(FKEYTABLE.ReferenceColumnName,2,LEN(FKEYTABLE.ReferenceColumnName))) AS ReferenceColumnName, ")
        Query.AppendLine("UPPER(LEFT(FKEYTABLE.ReferenceTableName,1))+(SUBSTRING(FKEYTABLE.ReferenceTableName,2,LEN(FKEYTABLE.ReferenceTableName))) AS ReferenceTableName ")
        'Query.AppendLine("FKEYTABLE.ReferenceColumnName AS ReferenceColumnName,")
        'Query.AppendLine("FKEYTABLE.ReferenceTableName AS ReferenceTableName")
        Query.AppendLine("FROM INFORMATION_SCHEMA.TABLES INNER JOIN")
        Query.AppendLine("INFORMATION_SCHEMA.COLUMNS ON INFORMATION_SCHEMA.TABLES.TABLE_NAME = INFORMATION_SCHEMA.COLUMNS.TABLE_NAME AND ")
        Query.AppendLine("INFORMATION_SCHEMA.TABLES.TABLE_CATALOG = INFORMATION_SCHEMA.COLUMNS.TABLE_CATALOG AND ")
        Query.AppendLine("INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA = INFORMATION_SCHEMA.COLUMNS.TABLE_SCHEMA LEFT OUTER JOIN")
        Query.AppendLine("(SELECT OBJECT_NAME(f.parent_object_id) AS TableName, ")
        Query.AppendLine("COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ColumnName, ")
        Query.AppendLine("OBJECT_NAME(f.referenced_object_id) AS ReferenceTableName, ")
        Query.AppendLine("COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS ReferenceColumnName, ")
        Query.AppendLine("f.name AS ForeignKey")
        Query.AppendLine("FROM sys.foreign_keys AS f INNER JOIN")
        Query.AppendLine("sys.foreign_key_columns AS fc ON f.object_id = fc.constraint_object_id INNER JOIN")
        Query.AppendLine("sys.objects AS o ON o.object_id = fc.referenced_object_id) AS KEYTABLE ON INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = KEYTABLE.ReferenceTableName AND ")
        Query.AppendLine("INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME = KEYTABLE.ReferenceColumnName LEFT OUTER JOIN")
        Query.AppendLine("(SELECT OBJECT_NAME(f.parent_object_id) AS TableName, ")
        Query.AppendLine("COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ColumnName, ")
        Query.AppendLine("OBJECT_NAME(f.referenced_object_id) AS ReferenceTableName, ")
        Query.AppendLine("COL_NAME(fc.referenced_object_id, ")
        Query.AppendLine("fc.referenced_column_id) AS ReferenceColumnName, ")
        Query.AppendLine("f.name AS ForeignKey")
        Query.AppendLine("FROM sys.foreign_keys AS f INNER JOIN")
        Query.AppendLine("sys.foreign_key_columns AS fc ON f.object_id = fc.constraint_object_id INNER JOIN")
        Query.AppendLine("sys.objects AS o ON o.object_id = fc.referenced_object_id) AS FKEYTABLE ON INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = FKEYTABLE.TableName AND ")
        Query.AppendLine("INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME = FKEYTABLE.ColumnName LEFT OUTER JOIN")
        Query.AppendLine("(SELECT i1.TABLE_NAME, i2.COLUMN_NAME")
        Query.AppendLine("FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS i1 INNER JOIN")
        Query.AppendLine("INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS i2 ON i1.CONSTRAINT_NAME = i2.CONSTRAINT_NAME")
        Query.AppendLine("WHERE (i1.CONSTRAINT_TYPE = 'PRIMARY KEY')) AS IsKeyCol ON INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = IsKeyCol.TABLE_NAME AND ")
        Query.AppendLine("INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME = IsKeyCol.COLUMN_NAME")
        Query.AppendLine("WHERE (INFORMATION_SCHEMA.COLUMNS.DATA_TYPE IN ('bigint', 'binary', 'bit', 'char', 'date', 'datetime', 'datetime2', ")
        Query.AppendLine("'datetimeoffset', 'decimal', 'float', 'image', 'int', 'money', 'nchar', 'ntext', 'numeric', 'nvarchar', 'real', ")
        Query.AppendLine("'smalldatetime', 'smallint', 'smallmoney', 'text', 'time', 'timestamp', 'tinyint', 'varbinary', 'varchar'))")

        Return Query.ToString
    End Function
    Private Function QueryForTableStructureNoFkeys2() As String
        Dim Query As New StringBuilder
        Query.AppendLine("SELECT DISTINCT ")
        Query.AppendLine("UPPER(LEFT(INFORMATION_SCHEMA.COLUMNS.TABLE_NAME, 1)) + LOWER(SUBSTRING(INFORMATION_SCHEMA.COLUMNS.TABLE_NAME, 2, LEN(INFORMATION_SCHEMA.COLUMNS.TABLE_NAME))) AS EntityClassName, ")
        Query.AppendLine("LOWER(INFORMATION_SCHEMA.COLUMNS.TABLE_NAME) AS EntityClassLower, UPPER(LEFT(INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME, 1)) ")
        Query.AppendLine("+ LOWER(SUBSTRING(INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME, 2, LEN(INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME))) AS EntityPropertyName, LOWER(INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME) ")
        Query.AppendLine("AS EntityPropertyLower, INFORMATION_SCHEMA.COLUMNS.ORDINAL_POSITION AS OrdinalPosition, INFORMATION_SCHEMA.COLUMNS.COLUMN_DEFAULT AS ColumnDefault, ")
        Query.AppendLine("CASE WHEN INFORMATION_SCHEMA.COLUMNS.IS_NULLABLE = 'YES' THEN 1 ELSE 0 END AS AllowNull, INFORMATION_SCHEMA.COLUMNS.DATA_TYPE AS DataType, ")
        Query.AppendLine("INFORMATION_SCHEMA.COLUMNS.CHARACTER_MAXIMUM_LENGTH AS ColumnSize, CASE WHEN IsKeyCol.COLUMN_NAME IS NULL THEN 0 ELSE 1 END AS IsKey, CASE WHEN FKEYTABLE.ReferenceColumnName IS NULL ")
        Query.AppendLine("THEN 0 ELSE 1 END AS IsFKey, CASE WHEN KEYTABLE.ReferenceColumnName IS NULL THEN 0 ELSE 1 END AS HasFKey")
        Query.AppendLine(", UPPER(LEFT(FKEYTABLE.ReferenceColumnName,1))+LOWER(SUBSTRING(FKEYTABLE.ReferenceColumnName,2,LEN(FKEYTABLE.ReferenceColumnName))) AS ReferenceColumnName")
        Query.AppendLine(", UPPER(LEFT(FKEYTABLE.ReferenceTableName,1))+LOWER(SUBSTRING(FKEYTABLE.ReferenceTableName,2,LEN(FKEYTABLE.ReferenceTableName))) AS ReferenceTableName")
        'Query.AppendLine(", FKEYTABLE.ReferenceColumnName, FKEYTABLE.ReferenceTableName")
        Query.AppendLine("FROM INFORMATION_SCHEMA.TABLES INNER JOIN")
        Query.AppendLine("INFORMATION_SCHEMA.COLUMNS ON INFORMATION_SCHEMA.TABLES.TABLE_NAME = INFORMATION_SCHEMA.COLUMNS.TABLE_NAME AND ")
        Query.AppendLine("INFORMATION_SCHEMA.TABLES.TABLE_CATALOG = INFORMATION_SCHEMA.COLUMNS.TABLE_CATALOG AND ")
        Query.AppendLine("INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA = INFORMATION_SCHEMA.COLUMNS.TABLE_SCHEMA LEFT OUTER JOIN")
        Query.AppendLine("(SELECT OBJECT_NAME(f.parent_object_id) AS TableName, COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ColumnName, OBJECT_NAME(f.referenced_object_id) AS ReferenceTableName, ")
        Query.AppendLine("COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS ReferenceColumnName, f.name AS ForeignKey")
        Query.AppendLine("FROM sys.foreign_keys AS f INNER JOIN")
        Query.AppendLine("sys.foreign_key_columns AS fc ON f.object_id = fc.constraint_object_id INNER JOIN")
        Query.AppendLine("sys.objects AS o ON o.object_id = fc.referenced_object_id) AS KEYTABLE ON INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = KEYTABLE.ReferenceTableName AND ")
        Query.AppendLine("INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME = KEYTABLE.ReferenceColumnName LEFT OUTER JOIN")
        Query.AppendLine("(SELECT OBJECT_NAME(f.parent_object_id) AS TableName, COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ColumnName, OBJECT_NAME(f.referenced_object_id) AS ReferenceTableName, ")
        Query.AppendLine("COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS ReferenceColumnName, f.name AS ForeignKey")
        Query.AppendLine("FROM sys.foreign_keys AS f INNER JOIN")
        Query.AppendLine("sys.foreign_key_columns AS fc ON f.object_id = fc.constraint_object_id INNER JOIN")
        Query.AppendLine("sys.objects AS o ON o.object_id = fc.referenced_object_id) AS FKEYTABLE ON INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = FKEYTABLE.TableName AND ")
        Query.AppendLine("INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME = FKEYTABLE.ColumnName LEFT OUTER JOIN")
        Query.AppendLine("(SELECT i1.TABLE_NAME, i2.COLUMN_NAME")
        Query.AppendLine("FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS i1 INNER JOIN")
        Query.AppendLine("INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS i2 ON i1.CONSTRAINT_NAME = i2.CONSTRAINT_NAME")
        Query.AppendLine("WHERE (i1.CONSTRAINT_TYPE = 'PRIMARY KEY')) AS IsKeyCol ON INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = IsKeyCol.TABLE_NAME AND ")
        Query.AppendLine("INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME = IsKeyCol.COLUMN_NAME")
        Query.AppendLine("WHERE (INFORMATION_SCHEMA.COLUMNS.DATA_TYPE IN ('bigint', 'binary', 'bit', 'char', 'date', 'datetime', 'datetime2', 'datetimeoffset', 'decimal', 'float', 'image', 'int', 'money', 'nchar', 'ntext', 'numeric', 'nvarchar', 'real', ")
        Query.AppendLine("'smalldatetime', 'smallint', 'smallmoney', 'text', 'time', 'timestamp', 'tinyint', 'varbinary', 'varchar'))")

        Return Query.ToString
    End Function
    Private Function CamelBack(stringToConvert As String) As String
        Dim output As String = ""
        Dim shouldCap As Boolean = True

        If stringToConvert.Contains("_") Or stringToConvert = stringToConvert.ToLower Then
            For Each s As String In stringToConvert.ToLower
                If shouldCap Then
                    output += s.ToUpper
                    shouldCap = False
                Else
                    output += s
                End If
                If s = "_" Then shouldCap = True
            Next
            output = output.Replace("_", "")
        Else
            output = stringToConvert
        End If

        Return output
    End Function

    Public Sub ProcessXsl(DbTable As String)
        Dim Folder As String = Application.StartupPath + "\Templates"

        ProcessXsl(DbTable, Folder)
    End Sub
    Public Sub ProcessXsl(DbTable As String, Folder As String)
        Application.DoEvents()
        Dim DataSchema As DataSet
        DataSchema = GetTableSchemaDataset(DbTable)
        ConvertDataType(DataSchema.Tables(0))
        Dim TempPath As String = System.IO.Path.GetTempFileName
        File.Delete(TempPath)
        TempPath = TempPath.Replace(".tmp", ".xml")
        DataSchema.WriteXml(TempPath, XmlWriteMode.IgnoreSchema)
        DbTable = CamelBack(DbTable)
        Dim xslt As New XslCompiledTransform()
        'Process Base Template Files
        ProcessFiles($"{Folder}\Base", Folder, TempPath)

        'For Each baseDir As String In Directory.GetDirectories($"{Folder}\Base")
        '    For Each xfile As String In Directory.GetFiles(baseDir)
        '        Application.DoEvents()
        '        Dim cpy As Boolean = True
        '        If xfile.Contains(".xsl") Then
        '            cpy = False
        '            xslt.Load(xfile)
        '        End If
        '        Dim fileout = xfile.Replace(baseDir, "").Replace(".xsl", "")
        '        Dim folderOut = OutputFolder + baseDir.Replace($"{Folder}\Base", "")

        '        If Not IO.Directory.Exists($"{folderOut}\{DbTable}") Then
        '            Directory.CreateDirectory($"{folderOut}\{DbTable}")
        '        End If
        '        If Not cpy Then
        '            xslt.Transform(TempPath, $"{folderOut}\{fileout}")
        '        Else
        '            IO.File.Copy(xfile, $"{folderOut}\{DbTable}\{fileout}")
        '        End If
        '    Next
        'Next
        For Each tableDir As String In Directory.GetDirectories($"{Folder}\Table")
            For Each xfile As String In Directory.GetFiles(tableDir)
                Application.DoEvents()
                Dim cpy As Boolean = True
                If xfile.Contains(".xsl") Then
                    cpy = False
                    xslt.Load(xfile)
                End If
                Dim fileout = xfile.Replace(tableDir, "").Replace(".xsl", "").Replace("Table", CamelBack(DbTable))
                Dim folderOut = OutputFolder + tableDir.Replace($"{Folder}\Table", "")
                If Not IO.Directory.Exists($"{folderOut}\{DbTable}") Then
                    Directory.CreateDirectory($"{folderOut}\{DbTable}")
                End If
                If Not cpy Then
                    xslt.Transform(TempPath, $"{folderOut}\{DbTable}\{fileout}")
                Else
                    IO.File.Copy(xfile, $"{folderOut}\{DbTable}\{fileout}")
                End If
            Next
        Next
        System.IO.File.Delete(TempPath)
    End Sub

    Private Sub ProcessFolder(FolderName As String, Folder As String, TempPath As String)

    End Sub
    Private Sub ProcessFiles(FolderName As String, Folder As String, TempPath As String)
        Dim xslt As New XslCompiledTransform()
        For Each xfile As String In Directory.GetFiles(FolderName)
            Application.DoEvents()
            Dim cpy As Boolean = True
            If xfile.Contains(".xsl") Then
                cpy = False
                xslt.Load(xfile)
            End If
            Dim fileout = xfile.Replace(FolderName, "").Replace(".xsl", "")
            Dim folderOut = OutputFolder + FolderName.Replace($"{Folder}\Base", "")

            If Not IO.Directory.Exists($"{folderOut}") Then
                Directory.CreateDirectory($"{folderOut}")
            End If
            If Not cpy Then
                xslt.Transform(TempPath, $"{folderOut}\{fileout}")
            Else
                IO.File.Copy(xfile, $"{folderOut}\{fileout}", True)
            End If
        Next
        If Directory.GetDirectories(FolderName).Any Then
            For Each xfolder As String In Directory.GetDirectories(FolderName)
                ProcessFiles(xfolder, Folder, TempPath)
            Next
        End If
    End Sub
End Class
