$temp = Read-Host -Prompt "Enter Username: "
$user = Get-ADUser -Filter {samAccountName -like $temp} -Properties employeeNumber | Select employeeNumber
"Employee Number: " + $user.employeeNumber