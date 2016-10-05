<#
    .Name
        List AD Group Members
    .Synopsis

    .Description
        Script file that returns a list of all the other AD users in a specific AD group.
        Returns a hash table with custom objects that show username, first name, and last name. It has one 
        mandatory parameted that is the AD name, as it appears in Active Directory.Script can be modified to 
        output the hash table to a csv.

#>

#Title: List AD Group Members
#Creator: Jacob Koza
#Date 8/5/16
#Updated 8/5/16


#Parameters
Param (
    #Required parameter, the name of the AD group, as it appears
   [Parameter(Mandatory=$true,ValueFromPipeline=$true)][string]$ADGroup
)

#Import the AD module to be able to query against ad
Import-Module ActiveDirectory



try {

    #Create an object on the AD group, breaks out of try if not found
    $Group = (Get-AdGroup -filter {Name -eq $ADGroup} -ErrorAction Stop)

    #Create an empty array to hold the object
    $Table = @()

    #Create an object to hold the necessary information
    $Record = @{
        "First Name" = ""
        "Last Name" = ""
        "Username" = ""
    }


    #Create an array of ADUser objects recursively based on their group
    $Arrayofmembers = Get-ADGroupMember -identity $Group -recursive | Get-ADUser

    #create an instance of the Member object with the information attached to the user
    foreach ($Member in $Arrayofmembers) {
        $Record."First Name" = $Member.GivenName
        $Record."Last Name" = $Member.Surname
        $Record."UserName" = $Member.samaccountname
        $objRecord = New-Object PSObject -property $Record
        $Table += $objrecord

    }


    #Remove comment to export list to a csv document
    $Table | sort -Property "Username" #| export-csv "C:\temp\SecurityGroups1.csv" -NoTypeInformation

}
catch{
    Write-Host "Could Not Find AD Group"
}
