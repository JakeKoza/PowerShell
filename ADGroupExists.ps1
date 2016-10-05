param(
    [Parameter(mandatory=$true)][string]$ADGroup
)

$group = Get-ADGroup -filter {name -like $ADGroup} -ErrorAction stop
if(-not($group)){
    Write-Host -ForegroundColor White -BackgroundColor Red "Active Directory Group Could Not Be Found"
}else{
    $group
}
