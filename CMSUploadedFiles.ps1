function recursiveFind{
    param($path)

    $items = Get-ChildItem -Path $path -Recurse

    foreach ($item in $items){
        $Record."FileName" = $item.Name
        $Record."Path" = (($item.FullName).Replace("C:\inetpub\wwwroot\unfwebsite","")).Replace("\","/")
        $Record."FileSize" = $item.Length / 1kb
        $objRecord = New-Object PSObject -property $Record
        $Table += $objrecord
    }
}

$directory = "C:\inetpub\wwwroot\unfwebsite\"

$Table = @()

#Create a custom hast table to hold the necessary information
$Record = @{
  "FileName" = ""
  "Path" = ""
  "FileSize" = ""
}

recursiveFind -path "C:\temp\CopiedUploads_Images"

$Table 