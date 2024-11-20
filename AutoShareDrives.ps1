function New-DriveDetected {
    param (
        [string]$DriveLetter
    )

    $shareName = $DriveLetter.TrimEnd(':')
    $path = "${DriveLetter}\"

    $netShareCommand = "net share $shareName=$path /GRANT:everyone,FULL"
    
    try {
        Write-Output "New drive detected: $DriveLetter. Shared as $shareName."
    } catch {
        Write-Output "Failed to share drive $DriveLetter. Error: $_"
    }
}

$previousDrives = (Get-PSDrive -PSProvider FileSystem).Root.TrimEnd('\')

while ($true) {
    $currentDrives = (Get-PSDrive -PSProvider FileSystem).Root.TrimEnd('\')
    $newDrives = $currentDrives | Where-Object { $previousDrives -notcontains $_ }
    
    foreach ($drive in $newDrives) {
        New-DriveDetected -DriveLetter $drive
    } 

    $previousDrives = $currentDrives
    Start-Sleep -Seconds 10
}