Write-Host "
Remember to: set cli config-output-format set
and...
Commit! " -ForegroundColor Green

Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('Desktop') 
    Filter = 'CSV (*.csv)|*.csv'
}
$null = $FileBrowser.ShowDialog()

$Data = Import-Csv -Path $FileBrowser.FileName 

Out-File -FilePath .\Output.txt

$AddressGroup = @{}

foreach( $AddressObject in $Data ) {
    if ($AddressObject.Tags) {
        $Output = "set address " + '"' + $AddressObject.Name + '" ' + $AddressObject.Type + " " + $AddressObject.Address + " tag " +  $AddressObject.Tags
        $Output | Out-File -FilePath .\Output.txt -Append
    }
    else {
        $Output = "set address " + '"' + $AddressObject.Name + '" ' + $AddressObject.Type + " " + $AddressObject.Address 
        $Output | Out-File -FilePath .\Output.txt -Append  
    }

}

$GroupArray = @()
foreach($GroupName in $AddressObject.Group ){
    $GroupArray += $GroupName
}
$GroupArray = $GroupArray | Get-Unique

foreach ($G in $GroupArray) {
    $AddressGroup.add($G)
}

foreach ($i in $AddressGroup) { Write-Host $i } 