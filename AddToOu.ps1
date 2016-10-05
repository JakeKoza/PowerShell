param(
    [Parameter(Mandatory=$true)][string]$nNumber,
    [Parameter(Mandatory=$true)][string[]]$ou
)

#variables
$DomainOn = (Get-ADDomain).distinguishedname
$orgunits = @()

#assign person to ou
foreach($unit in $ou){
    try{
        $user = Get-ADUser $nNumber -ErrorAction stop
        $OUpath = Get-ADGroup -Filter {name -like $unit}
        if(!$OUpath){
            Throw "OU: $unit does not exist as written"
        }elseif ((get-ADUser $User -Properties memberof).memberof -like $OUpath){
            Throw "User already a member of $unit"
        }
        else{
            Add-ADGroupMember -Identity $OUpath -Members $user
            $cn = Get-ADUser $nNumber -Properties *
            $ouname = (Get-ADGroup $OUpath).Name
            if( $ouname -Like "*-ecomm*"){
                $ouname = "CMS > eCommunications > $ouname"
            }
            else{
                $ouname = "CMS > CMS-Approvers > $ouname"
            }
            $orgunits += $ouname
        }
    }catch{
        Write-Host "Error: $_" -ForegroundColor Red
    }
}
if($orgunits){
    Write-Host "Client "$cn.DisplayName  "($nNumber) has been added to the following group(s) in CMS:" -ForegroundColor Green
        foreach ($unit in $orgunits){
            Write-Host $unit -ForeGroundColor Green
        }
}

