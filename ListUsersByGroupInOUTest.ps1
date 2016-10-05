<#
    .Name
        List Group Members and Membership in OU
    .Synopsis

    .Description
        Script file that returns a list of all the other AD users in each group under an Organizational Unit.
        Returns a hash table with custom objects that show username, first name, last name, and the AD
        group name. It has one mandatory parameted that is the OU name, not including the DC components 
        to the name (eg ou-aa,ou-sharepoint). Script can be modified to output the hash table to a csv.

#>

#Title: List OU Group Members
#Creator: Jacob Koza
#Date 8/5/16
#Updated 8/5/16


#Parameters
Param (
    #Required parameter, the name of the AD group, as it appears
   [Parameter(Mandatory=$true,ValueFromPipeline=$true)][string]$OUName,
   [Parameter(Mandatory=$false)][string]$exportPath

)

#Import the AD module to be able to query against ad
Import-Module ActiveDirectory

#The top level Organizaitonal unit you want to query, change the SearchBase field to a different OU for other areas
$Groups = (Get-AdGroup -filter * -SearchBase "$OUName,dc=unfcsd,dc=unf,dc=edu")

#Create an empty array to hold the object
$Table = @()

#Create a custom hast table to hold the necessary information
$Record = @{
  "Group Name" = ""
  "First Name" = ""
  "Last Name" = ""
  "Username" = ""
}


#Loop through each of the groups found in the OU
Foreach ($Group in $Groups) {

    #Create an array of ADUser objects recursively based on their group
    try{

        #Creates an array of AdUser objects, if the selected item is not an ad user, the error is supressed and code continues
        $Arrayofmembers = Get-ADGroupMember -identity $Group -recursive | Get-ADUser -ErrorAction SilentlyContinue

        #create an instance of the Member object with the information attached to the user
        foreach ($Member in $Arrayofmembers) {
            $Record."Group Name" = $Group.Name
            $Record."First Name" = $Member.GivenName
            $Record."Last Name" = $Member.Surname
            $Record."UserName" = $Member.samaccountname
            $objRecord = New-Object PSObject -property $Record
            $Table += $objrecord
        }
    }catch{  }
}


#Remove comment to export list to a csv document, otherwise contents of hash table with be printed in shell
if($exportPath){
    $Table | sort -Property "Group Name","UserName" | export-csv $exportPath -NoTypeInformation
}else{
    $Table | sort -Property "Group Name","UserName"
}
