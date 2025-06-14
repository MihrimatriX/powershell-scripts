$oncekiMetin = ""
$dosyaYolu = "C:\Users\AFU\Desktop\DEV\Down.txt"

while ($true) {
    $clipboardIcerik = Get-Clipboard -Raw

    if ($null -ne $clipboardIcerik -and $dosyaYolu -ne $null) {
        if ($clipboardIcerik -ne $oncekiMetin) {
            Write-Host "$clipboardIcerik"
            $clipboardIcerik | Out-File -FilePath $dosyaYolu -Append
            $oncekiMetin = $clipboardIcerik
        }
    }
    Start-Sleep -Seconds 1
}