#365_DGCounterReport.ps1
# ------ SCRIPT CONFIGURATION ------
#Log File Path
$LogPath = $MyInvocation.MyCommand.Path.Replace($MyInvocation.MyCommand.Name,"Logs\")
#Table Names
$MasterTableName = "DG_Emails_Received"
$ResultTableName = "DG_Emails_Received"
# ------ END CONFIGURATION ------
cls
#Import XML Files to Master Table
$MasterTable = New-Object system.Data.DataTable $MasterTableName
$MasterCol1 = New-Object system.Data.DataColumn Date,([datetime])
$MasterCol2 = New-Object system.Data.DataColumn Email,([string])
$MasterCol3 = New-Object system.Data.DataColumn Count,([int])
$MasterTable.columns.add($MasterCol1)
$MasterTable.columns.add($MasterCol2)
$MasterTable.columns.add($MasterCol3)
Get-ChildItem $LogPath -Filter "*.xml" | Sort-Object Name | ForEach-Object {
	$XmlDocument = [xml](Get-Content -Path $_.FullName)
	$XmlDocument.DocumentElement.$MasterTableName | ForEach-Object {
		$MasterRow = $MasterTable.NewRow()
		$MasterRow.Date = [datetime]$_.Date
		$MasterRow.Email = $_.Email
		$MasterRow.Count = [int]$_.Count
		$MasterTable.Rows.Add($MasterRow)
	}
}

#Get List of Unique Distribution Groups from Master Table
$DGs = @{}
$MasterTable | ForEach-Object {
	If (!($DGs.ContainsKey($_.Email))){
		$DGs.Add($_.Email,$_.Email)
	}
}
$DGs = $DGs.GetEnumerator() | Sort-Object Name

#Count Emails By Month
$ResultTable = New-Object system.Data.DataTable $ResultTableName
$ResultCol1 = New-Object system.Data.DataColumn Email,([string])
$ResultCol2 = New-Object system.Data.DataColumn Mon,([int])
$ResultCol3 = New-Object system.Data.DataColumn Mon_1,([int])
$ResultCol4 = New-Object system.Data.DataColumn Mon_2,([int])
$ResultCol5 = New-Object system.Data.DataColumn Mon_3,([int])
$ResultCol6 = New-Object system.Data.DataColumn Mon_4,([int])
$ResultCol7 = New-Object system.Data.DataColumn Mon_5,([int])
$ResultCol8 = New-Object system.Data.DataColumn Mon_6,([int])
$ResultCol9 = New-Object system.Data.DataColumn Mon_7,([int])
$ResultCol10 = New-Object system.Data.DataColumn Mon_8,([int])
$ResultCol11 = New-Object system.Data.DataColumn Mon_9,([int])
$ResultCol12 = New-Object system.Data.DataColumn Mon_10,([int])
$ResultCol13 = New-Object system.Data.DataColumn Mon_11,([int])
$ResultCol14 = New-Object system.Data.DataColumn Total,([int])
$ResultTable.columns.add($ResultCol1)
$ResultTable.columns.add($ResultCol2)
$ResultTable.columns.add($ResultCol3)
$ResultTable.columns.add($ResultCol4)
$ResultTable.columns.add($ResultCol5)
$ResultTable.columns.add($ResultCol6)
$ResultTable.columns.add($ResultCol7)
$ResultTable.columns.add($ResultCol8)
$ResultTable.columns.add($ResultCol9)
$ResultTable.columns.add($ResultCol10)
$ResultTable.columns.add($ResultCol11)
$ResultTable.columns.add($ResultCol12)
$ResultTable.columns.add($ResultCol13)
$ResultTable.columns.add($ResultCol14)
$CurDate = Get-Date
$DGs | ForEach-Object{
	$DG = $_.Name
	$ResultRow = $ResultTable.NewRow()
	$ResultRow.Email = $DG
	$ResultRow.Mon = 0
	$ResultRow.Mon_1 = 0
	$ResultRow.Mon_2 = 0
	$ResultRow.Mon_3 = 0
	$ResultRow.Mon_4 = 0
	$ResultRow.Mon_5 = 0
	$ResultRow.Mon_6 = 0
	$ResultRow.Mon_7 = 0
	$ResultRow.Mon_8 = 0
	$ResultRow.Mon_9 = 0
	$ResultRow.Mon_10 = 0
	$ResultRow.Mon_11 = 0
	$ResultRow.Total = 0
	$MasterTable | ForEach-Object {
		If ($DG -eq $_.Email){
			#Current Month
			If ($_.Date.Month -eq $CurDate.Month){
				$ResultRow.Mon += $_.Count
				$ResultRow.Total += $_.Count
			}
			#Current Month-1
			If ($_.Date.Month -eq $CurDate.AddMonths(-1).Month){
				$ResultRow.Mon_1 += $_.Count
				$ResultRow.Total += $_.Count
			}
			#Current Month-2
			If ($_.Date.Month -eq $CurDate.AddMonths(-2).Month){
				$ResultRow.Mon_2 += $_.Count
				$ResultRow.Total += $_.Count
			}
			#Current Month-3
			If ($_.Date.Month -eq $CurDate.AddMonths(-3).Month){
				$ResultRow.Mon_3 += $_.Count
				$ResultRow.Total += $_.Count
			}
			#Current Month-4
			If ($_.Date.Month -eq $CurDate.AddMonths(-4).Month){
				$ResultRow.Mon_4 += $_.Count
				$ResultRow.Total += $_.Count
			}
			#Current Month-5
			If ($_.Date.Month -eq $CurDate.AddMonths(-5).Month){
				$ResultRow.Mon_5 += $_.Count
				$ResultRow.Total += $_.Count
			}
			#Current Month-6
			If ($_.Date.Month -eq $CurDate.AddMonths(-6).Month){
				$ResultRow.Mon_6 += $_.Count
				$ResultRow.Total += $_.Count
			}
			#Current Month-7
			If ($_.Date.Month -eq $CurDate.AddMonths(-7).Month){
				$ResultRow.Mon_7 += $_.Count
				$ResultRow.Total += $_.Count
			}
			#Current Month-8
			If ($_.Date.Month -eq $CurDate.AddMonths(-8).Month){
				$ResultRow.Mon_8 += $_.Count
				$ResultRow.Total += $_.Count
			}
			#Current Month-9
			If ($_.Date.Month -eq $CurDate.AddMonths(-9).Month){
				$ResultRow.Mon_9 += $_.Count
				$ResultRow.Total += $_.Count
			}
			#Current Month-10
			If ($_.Date.Month -eq $CurDate.AddMonths(-10).Month){
				$ResultRow.Mon_10 += $_.Count
				$ResultRow.Total += $_.Count
			}
			#Current Month-11
			If ($_.Date.Month -eq $CurDate.AddMonths(-11).Month){
				$ResultRow.Mon_11 += $_.Count
				$ResultRow.Total += $_.Count
			}
		}
	}
	$ResultTable.Rows.Add($ResultRow)
}

#Rewrite Column Names as Months
For ($i=0; $i -lt 12; $i++) {
	If ($i -eq 0){
		$ResultTable.columns["Mon"].ColumnName = "$((Get-Culture).DateTimeFormat.GetAbbreviatedMonthName($CurDate.Month)) $($CurDate.Year)"
	}Else{
		$ResultTable.columns["Mon_$($i)"].ColumnName = "$((Get-Culture).DateTimeFormat.GetAbbreviatedMonthName($CurDate.AddMonths($i * -1).Month)) $($CurDate.AddMonths($i * -1).Year)"
	}
}

#Output Results
$ResultTable | format-table -AutoSize
$ResultTable | Export-CSV -Path C:\Users\adminchris.munoz\Desktop\Logs\Reports.CSV