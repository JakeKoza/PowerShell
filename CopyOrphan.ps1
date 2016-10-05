$path = "C:\inetpub\wwwroot\unfwebsite"
$orphans = Get-Content -Path "C:\Users\n00974115\Documents\OrphanedFilestest.csv"

foreach ($orphan in $orphans){
    $orphan = ($orphan).replace("`"","")
    $filename = $path + ($orphan).replace("/","\")
    Copy-item -literalpath $filename -destination C:\temp\Uploaded\$orphan
    #Remove-item -Path $filename
}