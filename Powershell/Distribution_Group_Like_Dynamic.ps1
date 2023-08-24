##########################################################
# Objective: Adds everyone who reports up through the
#            CTO, to the Distro, then
#            adds the COO to the distro too.
# Created by: Christopher Munoz
# Creation date: 6/21/2018
##########################################################

#Set credentials for Office 365
$Username = "username@domain.com"
$Password = Get-Content "C:\encryptedpasswordfile.txt" | ConvertTo-SecureString
$credentials = New-Object System.Management.Automation.PsCredential($Username, $Password)
# Create Exchange Online session
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $credentials -Authentication Basic -AllowRedirection
# Import Exhcange Online session
Import-PSSession $Session


cls

# Used for control statement
[System.Collections.ArrayList]$totalList = @()

#Used to pull the current members of the group
[System.Collections.ArrayList]$currentList = @()
$currentList = Get-DistributionGroupMember -Identity 'Distribution Group' | Select primarysmtpaddress

$Server = 'domain.com'

# Gets the CTO and adds them to the group.
$temp = Get-ADUser -Filter {Title -like 'CHIEF TECHNICAL OFFICER - COMPANY NAME' -and Department -like 'DEPARTMENT NAME'} -Server $Server -Properties mail
if($currentList -match $temp.mail){
    $temp.mail + " is already in the group"
}
else{
    Add-DistributionGroupMember -Identity 'Distribution Group' -Member $temp.mail
}

# Gets the COO and adds them to the group.
$temp = Get-ADUser -Filter {Title -like 'CHIEF OPERATING OFFICER - COMPANY NAME' -and Department -like 'DEPARMENT NAME'} -Server $Server -Properties mail
if($currentList -match $temp.mail){
    $temp.mail + " is already in the group"
}
else{
    Add-DistributionGroupMember -Identity 'Distribution Group' -Member $temp.mail
}

# Gets the directreports of the CTO and sticks them into an array
$Reports = Get-ADUser -Filter {Title -like 'CHIEF TECHNICAL OFFICER - COMPANY NAME' -and Department -like 'DEPARTMENT NAME'} -Server $Server -Properties directreports | Select directreports

# At the end of each iteration, it adds the direct report to the group, and to a list that is used as a control statement
# for the do while loop at the bottom.
For ($i = 0; $i -lt $Reports.directreports.Count; $i++) {
    $User = $Reports.directreports.Item($i)
    $temp = Get-ADUser -Identity $User -Properties mail -Server $Server
    if ($currentList -match $temp.mail){
        $temp.mail + " is already in the group"
        $totalList += $temp
    }
    else {
        if ($temp.Enabled -eq $true){
            Add-DistributionGroupMember -Identity 'Distribution Group' -Member $temp.mail
        }
    }
}

# Grabs each person in the totalList and searches for their directreports and adds them to the group.
# It then removes the person from the totalList at the end so the do while doesn't loop forever.
Do {
    try{
        Foreach($Member in $totalList) {
            $Reports = Get-ADUser $Member -Server $Server -Properties directreports | Select directreports
    
            For ($i = 0; $i -lt $Reports.directreports.Count; $i++) {
                $User = $Reports.directreports.Item($i)
                $temp = Get-ADUser -Identity $User -Properties mail -Server $Server
            if ($currentList -match $temp.mail){
                $temp.mail + " is already in the group"
                $totalList += $temp
            }
            else {
                if ($temp.Enabled -eq $true){
                    Add-DistributionGroupMember -Identity 'Distribution Group' -Member $temp.mail
                }
            }
                # OPTIONAL: Uncomment for testing of the script.
                #echo $temp "was added"
                #""
                #pause
            }
            $totalList.Remove($Member)
        }
    }
    catch [InvalidOperationException]{
    
    }
} While ($totalList.Count -gt 0)

""
""
"******************** Process Complete ********************"


# Remove Exchange Online session
Remove-PSSession $Session