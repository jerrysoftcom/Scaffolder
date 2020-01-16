Imports Microsoft.SqlServer.Management.Smo
Imports Microsoft.SqlServer.Management.Common
Imports System.IO
Public Class DBViewer
    Private Sub lstServers_TextChanged(sender As Object, e As EventArgs) Handles lstServers.TextChanged
        FillDatabases()
    End Sub

    Private Sub FillDatabases()
        Try
            lstDatabases.Items.Clear()
            Dim serverName As String = ""
            If serverName = "" And lstServers.Text <> "" Then
                serverName = lstServers.Text
            End If

            Dim connection As New ServerConnection(serverName, tbUserID.Text, tbPassword.Text)
            Dim server As Server = New Server(connection)

            Try
                For Each database As Database In server.Databases
                    lstDatabases.Items.Add(database.Name)
                Next
            Catch ex As Exception
                Dim exception As String = ex.Message
            End Try

        Catch ex As Exception

        End Try
        'End If
    End Sub
    Private Function getDa() As DA
        Dim da As New DA
        da.Database = lstDatabases.Text
        da.Server = lstServers.Text
        da.UserID = tbUserID.Text
        da.Password = tbPassword.Text
        da.AppName = tbAppName.Text

        Return da
    End Function
    Private Sub btLoadTables_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btLoadTables.Click
        Try
            tvSchema.Nodes.Clear()
            '_TableData = New List(Of DataTable)
            Dim dt As New Data.DataTable
            Dim da As DA = getDa()

            dt = da.getTables
            Dim refreshCnt As Integer = 0
            Dim dr As DataRow
            For Each dr In dt.Rows
                Dim nd As New TreeNode(dr.Item(0))
                Application.DoEvents()
                tvSchema.Nodes.Add(nd)
            Next
        Catch ex As Exception
            MsgBox(ex.Message)
        End Try
        If Me.tbAppName.Text.Length = 0 Then
            Me.tbAppName.Text = Me.lstDatabases.Text
        End If
    End Sub
    Private Sub tvSchema_AfterSelect(ByVal sender As System.Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles tvSchema.AfterSelect
        Dim da As DA = getDa()
        Dim ddt As DataTable = da.getTableSchema(tvSchema.SelectedNode.Text)

        dgvColumns.DataSource = ddt

    End Sub
    Private Sub lstDatabases_DropDown(ByVal sender As Object, ByVal e As System.EventArgs) Handles lstDatabases.DropDown
        If lstDatabases.Items.Count < 1 Then
            FillDatabases()
        End If
    End Sub
    Private Sub btBuild_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btBuild.Click

        fbdDALSave.SelectedPath = tbPath.Text
        If fbdDALSave.ShowDialog = Windows.Forms.DialogResult.OK Then
            Dim path As String = fbdDALSave.SelectedPath
            'If Microsoft.VisualBasic.Right(path, 1) <> "\" Then
            '    path += "\"
            'End If
            '        _outputFolder = value

            For Each nd As TreeNode In tvSchema.Nodes
                If nd.Checked Then
                    Dim da As DA = getDa()
                    Dim ds As New DataSet()
                    da.OutputFolder = path
                    da.ProcessXsl(nd.Text)
                    'ds = da.getTableSchemaDataset(nd.Text)
                    'ds.WriteXml(fbdDALSave.SelectedPath + "\" + nd.Text + ".xml", XmlWriteMode.IgnoreSchema)
                End If
            Next
            MsgBox("Complete")
            tbPath.Text = fbdDALSave.SelectedPath
        End If
    End Sub
    Private Sub btnSelectAll_Click(sender As Object, e As EventArgs) Handles btnSelectAll.Click
        For Each nd As TreeNode In tvSchema.Nodes
            nd.Checked = True
        Next
    End Sub
    Private Sub SaveXml_Click(sender As Object, e As EventArgs) Handles SaveXml.Click

        fbdDALSave.SelectedPath = "D:\" 'Application.StartupPath
        If fbdDALSave.ShowDialog = Windows.Forms.DialogResult.OK Then

            For Each nd As TreeNode In tvSchema.Nodes
                If nd.Checked Then
                    Dim da As DA = getDa()
                    Dim ds As New DataSet()

                    ds = da.getTableSchemaDataset(nd.Text)
                    ds.WriteXml(fbdDALSave.SelectedPath + "\" + nd.Text + ".xml", XmlWriteMode.IgnoreSchema)
                    MsgBox("Complete", "Build")
                End If
            Next
        End If
    End Sub
    Private Sub OpenToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles OpenToolStripMenuItem.Click
        Dim path = Application.StartupPath + "\appdata.xml"
        Dim dt As New DataTable
        dt.ReadXml(path)
        lstServers.Text = dt.Rows(0)(0).ToString
        tbUserID.Text = dt.Rows(0)(1).ToString
        tbPassword.Text = dt.Rows(0)(2).ToString
        lstDatabases.Text = dt.Rows(0)(3).ToString
        tbAppName.Text = dt.Rows(0)(4).ToString

    End Sub
    Private Sub SaveToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles SaveToolStripMenuItem.Click
        Dim path = Application.StartupPath + "\appdata.xml"
        Dim dt As New DataTable("AppData")
        dt.Columns.Add("Server")
        dt.Columns.Add("User")
        dt.Columns.Add("Password")
        dt.Columns.Add("Database")
        dt.Columns.Add("Appname")

        Dim row As DataRow = dt.NewRow()

        row(0) = lstServers.Text
        row(1) = tbUserID.Text
        row(2) = tbPassword.Text
        row(3) = lstDatabases.Text
        row(4) = tbAppName.Text
        dt.Rows.Add(row)

        dt.WriteXml(path, XmlWriteMode.WriteSchema)
    End Sub
    Private Sub ExitToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles ExitToolStripMenuItem.Click
        End
    End Sub

    Private Sub DBViewer_Load(sender As Object, e As EventArgs) Handles Me.Load
        tbPath.Text = Application.StartupPath
    End Sub

End Class
