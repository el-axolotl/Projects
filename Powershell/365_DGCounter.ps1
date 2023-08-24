#365_DGCounter.ps1
# ------ SCRIPT CONFIGURATION ------
#Log File
$LogFile = $MyInvocation.MyCommand.Path.Replace($MyInvocation.MyCommand.Name,"Logs\") + ((Get-Date).AddDays(-2).ToString('yyyy_MM_dd')) + ".xml"
#Table Name
$TableName = "DG_Emails_Received"
# ------ END CONFIGURATION ------
cls
#Confirm Logs Directory Exists
$LogPath = $MyInvocation.MyCommand.Path.Replace($MyInvocation.MyCommand.Name,"Logs\")
If (!(Test-Path $LogPath)){
	New-Item -ItemType Directory -Force -Path $LogPath
}

#Import Modules and Connect to Office 365
import-module ActiveDirectory
Try {
	$UserCredential = Get-Credential
	$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
	Import-PSSession $Session
}
Catch {
	#Error Connecting to Office365
}

#Create Data Table
$CounterTable = New-Object system.Data.DataTable $TableName
$CounterCol1 = New-Object system.Data.DataColumn Date,([datetime])
$CounterCol2 = New-Object system.Data.DataColumn Email,([string])
$CounterCol3 = New-Object system.Data.DataColumn Count,([int])
$CounterTable.columns.add($CounterCol1)
$CounterTable.columns.add($CounterCol2)
$CounterTable.columns.add($CounterCol3)

#Get DG's and Add to Table
$DG = Get-DistributionGroup -Resultsize Unlimited | select Displayname, Primarysmtpaddress
$DG | ForEach-Object {
	$count = 0
	#Note: [DateTime]::Today returns 12:00 AM of the Current Date 
	#      Let's assume the date is currently 3/3/2016, the below returns the range 3/2/2016 12:00 AM to 3/3/2016 12:00 AM
	Get-MessageTrace -PageSize 5000 -RecipientAddress $_.Primarysmtpaddress -StartDate ([DateTime]::Today.AddDays(-30)) -EndDate ([DateTime]::Today.AddDays(-1)) | ForEach-Object {$count++}
	$CounterRow = $CounterTable.NewRow()
	$CounterRow.Date = [datetime](Get-Date).AddDays(-30)
	$CounterRow.Email = $_.Primarysmtpaddress
	$CounterRow.Count = $count
	$CounterTable.Rows.Add($CounterRow)
}

#Output Results
$CounterTable.WriteXml($LogFile)
$CounterTable.WriteXmlSchema($LogFile.replace(".xml",".xsd"))
$CounterTable | format-table -AutoSize

#Disconnect From Office365
Remove-PSSession $Session