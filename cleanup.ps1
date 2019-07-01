Set-ExecutionPolicy Unrestricted

Function DisableCortana
{  
    $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"    
    IF(!(Test-Path -Path $path)) { 
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "Windows Search"
    } 
    Set-ItemProperty -Path $path -Name "AllowCortana" -Value 0    
    Stop-Process -name explorer
}

Function RemoveBloat{
    Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}"
    Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}"
    Remove-Item "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}"
    Remove-Item "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}"
    
    Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
    Remove-Item "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"

    Write-Output "Setting folder view options"
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideDrivesWithNoMedia" 0
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSyncProviderNotifications" 0

    Write-Output "Disable easy access keyboard stuff"
    Set-ItemProperty "HKCU:\Control Panel\Accessibility\StickyKeys" "Flags" "506"
    Set-ItemProperty "HKCU:\Control Panel\Accessibility\Keyboard Response" "Flags" "122"
    Set-ItemProperty "HKCU:\Control Panel\Accessibility\ToggleKeys" "Flags" "58"
}

Function RemoveDefaultApps
{

    $AppsList = "Microsoft.BingFinance","Microsoft.BingNews","Microsoft.BingWeather","Microsoft.XboxApp","Microsoft.SkypeApp","Microsoft.MicrosoftSolitaireCollection","Microsoft.BingSports","Microsoft.ZuneMusic","Microsoft.ZuneVideo","Microsoft.Windows.Photos","Microsoft.People","Microsoft.MicrosoftOfficeHub","Microsoft.WindowsMaps","microsoft.windowscommunicationsapps","Microsoft.Getstarted","Microsoft.3DBuilder"
    ForEach ($App in $AppsList)
    {
        $PackageFullName = (Get-AppxPackage $App).PackageFullName
        $ProPackageFullName = (Get-AppxProvisionedPackage -online | where {$_.Displayname -eq $App}).PackageName
        write-host $PackageFullName
        Write-Host $ProPackageFullName
        if ($PackageFullName)
        {
            Write-Host "Removing Package: $App"
            remove-AppxPackage -package $PackageFullName
        }
        else
        {
        Write-Host "Unable to find package: $App"
        }
        if ($ProPackageFullName)
        {
        Write-Host "Removing Provisioned Package: $ProPackageFullName"
        Remove-AppxProvisionedPackage -online -packagename $ProPackageFullName
        }
        else
        {
        Write-Host "Unable to find provisioned package: $App"
        }
    }
}

Function DisableStickyKeys {
    Write-Output "Disabling Sticky keys prompt..."
    Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"
}

Function ShowTrayIcons {
    Write-Output "Showing all tray icons..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Type DWord -Value 0
}

Function DisableNewAppPrompt {
    Write-Output "Disabling 'How do you want to open this file?' prompt..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "NoNewAppAlert" -Type DWord -Value 1
}

DisableCortana
RemoveDefaultApps
RemoveBloat
DisableStickyKeys
ShowTrayIcons
DisableNewAppPrompt