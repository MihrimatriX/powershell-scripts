param (
    [string]$Directory = 'D:',
    [string]$Name = "Name",
    [string]$OutputFile = 'C:\Users\AFU\Desktop\DEV\DEV\ExcelOutput.xlsx'
)

$Excel = New-Object -ComObject Excel.Application
$Workbook = $Excel.Workbooks.Add()
$Worksheet = $Workbook.Worksheets.Item(1)
$Worksheet.Name = "Files And Folders Size"

$Header = $Worksheet.Rows.Item(1)
$Header.Cells.Item(1).Value = $Name
$Header.Cells.Item(2).Value = "Type"
$Header.Cells.Item(3).Value = "Size (GB)"

$row = 2
$FilesAndFolders = Get-ChildItem -Path $Directory -Recurse -Depth 0
foreach ($FileOrFolder in $FilesAndFolders) {
    if ($FileOrFolder.Attributes -contains "Directory") {
        $Length = (Get-ChildItem $FileOrFolder.FullName -Recurse | Where-Object {!$_.PSIsContainer} | Measure-Object -Sum -Property Length).Sum / 1GB
        
        $Worksheet.Cells.Item($row, 1).Value = $FileOrFolder.Name
        $Worksheet.Cells.Item($row, 2).Value = "Folder"
        $Worksheet.Cells.Item($row, 3).Value = "{0:N2}" -f $Length
    } else {
        $Length = $FileOrFolder.Length / 1GB
        
        $Worksheet.Cells.Item($row, 1).Value = $FileOrFolder.Name
        $Worksheet.Cells.Item($row, 2).Value = "File"
        $Worksheet.Cells.Item($row, 3).Value = "{0:N2}" -f $Length
    }
    $row++
}

$grayColor = 14474460
$HeaderRange = $Worksheet.Range("A1:C1")
$HeaderRange.Interior.Color = $grayColor
$Worksheet.Columns.Item(1).ColumnWidth = 50

$range = $Worksheet.Range("A1:C$row")
$range.Borders.Item(1).LineStyle = 1
$range.Borders.Item(2).LineStyle = 1
$range.Borders.Item(3).LineStyle = 1
$range.Borders.Item(4).LineStyle = 1

$Workbook.SaveAs($OutputFile)
$Excel.Quit()