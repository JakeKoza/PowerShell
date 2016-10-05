function getUserMemebership{
    param($userName)

    Write-Host "Attempting to get info for $userName`n"
    
    try{
        $name = Get-ADUser $userName -Properties *
        Write-Host "Name: "($name).DisplayName
        Get-ADPrincipalGroupMembership $username | select @{Name="Group Membership"; Expression={$_.name}} -ErrorAction stop
    }catch{
        Write-Host "Could not find user"
    }
    
}


$user = Read-Host "Enter username"
$filter = Read-Host "Enter a filter"

getUserMemebership -userName $user | where "Group Membership" -Like "*$filter*"

