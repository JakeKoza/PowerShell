
$path = "C:\temp"
$orphans = Get-Content -Path "C:\temp\ImagesToDelete.csv"
$orphans2 = Get-Content -Path "C:\temp\FilesToDelete.csv"

foreach ($orphan in $orphans){
    $filename = $path + (($orphan).replace("/","\")).replace("`"","")
    if (($filename -like "*.jpg") -or ($filename -like "*.png"))
    {
        Remove-item -Path $filename
    }
}


<#foreach ($orphan in $orphans2){
    $filename = $path + (($orphan).replace("/","\")).replace("`"","")
    
    Remove-item -Path $filename
}#>