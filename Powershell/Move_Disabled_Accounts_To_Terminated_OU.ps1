<#
.SYNOPSIS   
Script that moves Disabled accounts to the Terminated OU
    
.DESCRIPTION 
This script grabs all the disabled users for each sub company, checks if they are in the Terminated OU for their domain, and if not, moves them to the Terminated OU in their domain.

.NOTES   
Name: Move_Disabled_Accounts_To_Terminated_OU.ps1
Author: Christopher Munoz
DateCreated: 12/11/2019
#>

cls
$domains = 'company1.domain.com', 'company2.domain.com', 'company3.domain.com'

foreach($domain in $domains) {
    $temp = $domain.IndexOf('.')
    $company = $domain.Substring(0,$temp)
    $disabled_ou = 'OU=Terminated,OU=Accounts,DC=' + $company + ',DC=domain,DC=com'
    
    # Grabs a list of disabled users and returns their Distinguished Name
    $userlist = Get-ADUser -Filter 'enabled -eq $false' -Server $domain -Properties distinguishedname | select distinguishedname

    foreach($user in $userlist) {

        # Finds index of first comma, plus 1. Will be used to trim the user's distinguishedName, to simply grab the OU
        $trim = $user.distinguishedname.IndexOf(',') + 1
        $ou = $user.distinguishedname.Substring($trim)
            
        if ($ou -ne $disabled_ou) {
            Move-ADObject -Identity $user.distinguishedname -TargetPath $disabled_ou -Server $domain
        }
    }
}