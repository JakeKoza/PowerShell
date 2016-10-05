cd C:\Users\n00974115\Desktop\Copied
$folders = Get-ChildItem

$count = ($folders | Measure-Object).count
$foldersAffected = 1

foreach($folder in $folders){
    $counter = 0
    $files = Get-ChildItem $folder
    $filecount = ($files).Count
    Move-Item -Path "$folder\*.xml" -Destination "$folder\batch.rtf"
    foreach ($file in $files){
        if(($file.Name -like "*.xml*") -or ($file.Name -like "*.qdb*") -or ($file.Name -like "*.flg*")){
            Remove-Item $folder\$file
        }elseif($file.Name -like "*.pdf*"){
           
        }elseif($file.Name -like "*.rtf"){

        }
        else{
            Move-Item -Path $folder\$file -Destination $folder\image$counter.png
            $counter++
        }
    }
    Write-Host "Modified $fileCount files in $folder......"
    $foldersAffected++

}
Write-Host "Modified $foldersAffected of $count" -ForegroundColor Red
