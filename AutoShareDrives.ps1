function New-DriveDetected {
    param (
        [string]$DriveLetter
    )

    # Yeni sürücüyü ağ üzerinde paylaş
    $shareName = $DriveLetter.TrimEnd(':')
    $path = "${DriveLetter}\"

    # Ağ paylaşımını oluştur
    $netShareCommand = "net share $shareName=$path /GRANT:everyone,FULL"
    
    try {
        Write-Output "New drive detected: $DriveLetter. Shared as $shareName."
    } catch {
        Write-Output "Failed to share drive $DriveLetter. Error: $_"
    }
}

# Önceki sürücüleri takip et
$previousDrives = (Get-PSDrive -PSProvider FileSystem).Root.TrimEnd('\')

# Yeni sürücüler takıldığında kontrol et
while ($true) {
    $currentDrives = (Get-PSDrive -PSProvider FileSystem).Root.TrimEnd('\')
    $newDrives = $currentDrives | Where-Object { $previousDrives -notcontains $_ }
    
    foreach ($drive in $newDrives) {
        New-DriveDetected -DriveLetter $drive
    } 

    # Yeni sürücüleri güncelle
    $previousDrives = $currentDrives
    Start-Sleep -Seconds 10
}