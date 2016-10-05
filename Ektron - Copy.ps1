<#
    .Name
        Ektron Server Disk Space
    .Synopsis

    .Description
        Script file that pulls computers from a text file and outputs the  drive information

    .Examples
        
    .Example

#>

#Title: Ektron Server Free Space
#Creator: Jacob Koza
#Date 7/19/16
#Updated 7/20/16
#References

#Parameters

#Variables
#Read computers from text file
$computers = (Get-Content C:\Users\n00974115\Documents\EktronComps.txt) 

#Create transcript every time the command in order to 
Start-Transcript -Path C:\Users\n00974115\Documents\EktronSpaceTrans.txt -Append -NoClobber

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
#Closes Transcript to allow it to be used by other processes
Stop-Transcript


