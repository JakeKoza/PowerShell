$path = "C:\inetpub\wwwroot\unfwebsite"
$orphans = Get-Content -Path "C:\Users\n00974115\Documents\OrphanedFilestest.csv"

foreach ($orphan in $orphans){
    $filename = $path + ($orphan).replace("/","\")
    Remove-item -Path $filename
}