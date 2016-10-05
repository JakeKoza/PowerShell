$images = get-childitem -Path C:\temp\CopiedUploads_Images
$itemsdeleted = Get-Content C:\temp\ImagesToDelete.csv



foreach($item in $itemsdeleted){
    foreach($image in $images){
        if($item -like "*$image"){
            $item = ($item).Replace("/","\")
            #write-host $item
            copy-item -path "C:\temp\CopiedUploads_Images\$image" -destination "C:\temp\FileStructure$item" -container
        }
    }
     
}

<#foreach ($image in $images){
    $image = $image.Name
    
}




$Table = @()
$Record = @{
  "Path" = ""
}
foreach($image in $images){
    $Record."Path" = "C:\temp\$image"
     $objRecord = New-Object PSObject -property $Record
        $Table += $objrecord
}

$Table#>