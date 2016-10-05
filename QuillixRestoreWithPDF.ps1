$knownHeaders = @{

            jpg = @( "FF", "D8" );

            bmp = @( "42", "4D" );

            gif = @( "47", "49" );

            tif = @( "49", "49");

            png = @( "89", "50" );

            pdf = @( "25", "50" );

        }

$date = get-date
Add-Content -path "c:\temp\testlog.txt" "Modifiying files - $date"
cd C:\Users\n00974115\Desktop\Copied
$folders = Get-ChildItem
$count = ($folders | Measure-Object).count
$foldersAffected = 0
foreach($folder in $folders){
    $imgcounter = 1
    $filecounter = 1
    $files = Get-ChildItem $folder
    $filecount = ($files).Count
    Move-Item -Path "$folder\*.xml" -Destination "$folder\batch.rtf" -ErrorAction SilentlyContinue

    foreach ($file in $files){
        $bytes = Get-Content -literalPath $file.FullName -Encoding Byte -ReadCount 1 -TotalCount 8 -ErrorAction Ignore
        $fileHeader = $bytes | Select-Object -First $knownHeaders["jpg"].Length | ForEach-Object { $_.ToString("X2") }
        $dif = Compare-Object -ReferenceObject $knownHeaders["pdf"] -DifferenceObject $fileHeader -ErrorAction SilentlyContinue
        if(($dif | Measure-Object).Count -eq 0){
            Move-Item -Path $file.FullName -Destination "$folder\$path\image$filecounter.pdf"  
            $filecounter++  
        }else{
            if(($file.Name -like "*.xml*") -or ($file.Name -like "*.qdb*") -or ($file.Name -like "*.flg*")){
                Remove-Item $folder\$file -ErrorAction SilentlyContinue
            }
            elseif($file.Name -like "*.rtf"){

            }else{
                Move-Item -Path $folder\$file -Destination "$folder\image$imgcounter.tiff"
                $imgcounter++
            }
        }
        
    }
    $filecounter--
    $imgcounter--
    Add-Content -path "c:\temp\testlog.txt" "Modified $imgcounter TIFF files and $filecounter PDFs in $folder......"
    $foldersAffected++
}  
Add-Content -path "c:\temp\testlog.txt" "Modified $foldersAffected folders of $count total folders"

