#Param (
    #Required parameter, the name of the AD group, as it appears
   #[Parameter(Mandatory=$true,ValueFromPipeline=$true)][string]$OUName
#)
#Import the AD module to be able to query against ad
Import-Module ActiveDirectory

#The top level Organizaitonal unit you want to query, change the SearchBase field to a different OU for other areas
$Groups = (Get-AdGroup -filter * -SearchBase "ou=cms,dc=unfcsd,dc=unf,dc=edu")

#Create an empty array to hold the object
$Table = @()

#Create an object to hold the necessary information
$Record = @{
  "Group Name" = ""
  "First Name" = ""
  "Last Name" = ""
  "Username" = ""
}


#Loop through each of the groups found in the OU
Foreach ($Group in $Groups) {

  #Create an array of ADUser objects recursively based on their group
  $Arrayofmembers = Get-ADGroupMember -identity $Group -recursive | Get-ADUser

  #create an instance of the Member object with the information attached to the user
  foreach ($Member in $Arrayofmembers) {
    $Record."Group Name" = $Group.Name
    $Record."First Name" = $Member.GivenName
    $Record."Last Name" = $Member.Surname
    $Record."UserName" = $Member.samaccountname
    $objRecord = New-Object PSObject -property $Record
    $Table += $objrecord

  }
}

#Remove comment to export list to a csv document
$Table | sort -Property "Group Name","UserName" #| export-csv "C:\temp\SecurityGroups1.csv" -NoTypeInformation
