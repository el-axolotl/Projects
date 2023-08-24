Cls
$File
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

Try{
    Function Display-SaveFileDialog{
        $SaveFileDialog = New-Object windows.forms.savefiledialog
        $SaveFileDialog.initialDirectory = [System.IO.Directory]::GetCurrentDirectory()   
        $SaveFileDialog.title = "Save File to Disk"   
        $SaveFileDialog.filter = "Text Files|*.txt|All Files|*.*" 
        $SaveFileDialog.ShowHelp = $True   
        Write-Host "Where would you like to create encrypted file?... (see File Save Dialog. You might need to minimize opened windows.)" -ForegroundColor Green  
        $result = $SaveFileDialog.ShowDialog()    
        $result 
        If($result -eq "OK"){    
            Write-Host "Selected File and Location:"  -ForegroundColor Green  
            $SaveFileDialog.filename
            $File = $SaveFileDialog.FileName
            $Length = $File.Length
            If($File.Substring($Length -4) -ne ".txt"){
                $File = $File + ".txt"
            }
            $Script:File = $SaveFileDialog.filename
        } 
        Else{
            Write-Host "File Save Dialog Cancelled!" -ForegroundColor Yellow
        } 
    }

    $Password = Read-Host -Prompt "Enter your password" -AsSecureString
    $ConfirmPassword = Read-Host -Prompt "Confirm your password" -AsSecureString
    $P = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
    $CP = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($ConfirmPassword))
    If($P -eq $CP){
        $File = Display-SaveFileDialog
        $Bytes = ConvertFrom-SecureString $Password
        $Bytes | Out-File -LiteralPath $File[1]
    }
    Else{
        Write-Host "Passwords did not match"
    }
}
Catch{
    $ErrorMessage = $_.Exception.Message
    Write-Error $ErrorMessage
}