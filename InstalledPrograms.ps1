<#
.Synopsis
Generates a list of installed programs on a computer

.DESCRIPTION
This function generates a list by querying the registry and returning the installed programs of a local or remote computer.

.NOTES   
Name: InstalledPrograms
Author: Jake Koza based on code by Jaap Brasser
Version: 1.0
DateCreated: 7/29/16
Blog: http://www.jaapbrasser.com

.PARAMETER ComputerName
The computer to which connectivity will be checked

.EXAMPLE
Get-RemoteProgram -ComputerName server01,server02

Description:
Will generate a list of installed programs on server01 and server02

#>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        [string]
            $ComputerName
    )

    $RegistryLocation = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\'
    $HashProperty = @{}
    $SelectProperty = @('ProgramName')
    
    

    
    foreach ($Computer in $ComputerName) {
        $RegBase = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine,$Computer)
        foreach ($CurrentReg in $RegistryLocation) {
            if ($RegBase) {
                $CurrentRegKey = $RegBase.OpenSubKey($CurrentReg)
                if ($CurrentRegKey) {
                    $CurrentRegKey.GetSubKeyNames() | ForEach-Object {
                        if ($Property) {
                            foreach ($CurrentProperty in $Property) {
                                $HashProperty.$CurrentProperty = ($RegBase.OpenSubKey("$CurrentReg$_")).GetValue($CurrentProperty)
                            }
                        }
                        $HashProperty.ComputerName = $Computer
                        $HashProperty.ProgramName = ($DisplayName = ($RegBase.OpenSubKey("$CurrentReg$_")).GetValue('DisplayName'))
                        if ($DisplayName) {
                            New-Object -TypeName PSCustomObject -Property $HashProperty |
                            Select-Object -Property $SelectProperty
                        } 
                    }
                }
            }
        }
    }
 
