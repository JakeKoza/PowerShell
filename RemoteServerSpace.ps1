<#
    .Name
        Remote Server Disk Space
    .Synopsis

    .Description
        Script file that gathers drive information from both remote and local computers. There is no logging as this is intended for a
        quick look at server/computer storage spaces.

    .Examples
        .\RemoteServerSpace.ps1 -ComputerName its-62189
        
        Output:
        Analyzing its-62189
        Size C: 465.47 GB
        Free C: 374.9 GB

    .Example

#>

#Title: Remote Server Free Space
#Creator: Jacob Koza
#Date 7/18/16
#Updated 7/20/16
#References

#Parameters
Param (
   [Parameter(Mandatory=$true,ValueFromPipeline=$true)][string[]]$computers
)

#Iterate over each computer entered

foreach($computer in $computers){

    try{
        #attempt te get wmi obejct, fall out of try loop if computer could not be connected to
        $os = Get-WmiObject win32_operatingSystem -ComputerName $computer -ErrorAction Stop
        $filesystems = Get-WmiObject win32_logicaldisk -ComputerName $computer

        #iterate through all the filesystems on the device
        $files = foreach($filesystem in $filesystems){

            #create a custom object with their size and freespace
            [pscustomobject][ordered]@{ "Drive"=$filesystem.deviceId;
            "Size"=[math]::Round($filesystem.size/1gb,2);
            "FreeSpace"=[math]::Round($filesystem.freespace/1gb,2)}
        }

        #write out the computername and the custom object in table
        Write-Host "Name:" $os.CsName
        $files | ft
     }catch{
        #if computer cant be connected to, write out error
        Write-Host "Unable to communicate with $Computer"
     }
}