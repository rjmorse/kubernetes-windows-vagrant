If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
[Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
    Break
}
if ((Get-WindowsOptionalFeature -Online -FeatureName:Microsoft-Hyper-V).State -ne "Enabled")
{
    Write-Warning "You will need to restart after Hyper-V is enabled"
    Enable-WindowsOptionalFeature -Online -FeatureName:Microsoft-Hyper-V -All
}
if((Get-VMSwitch -SwitchType External).Count -lt 1)
{
    Write-Warning "You need at least one external vSwitch. Please create an External vSwitch."
}

if((Get-Command choco).Count -ne 1)
{
    Write-Warning "Chocolatey (choco) should be installed"
    Write-Host "Installing Chocolatey"
    iex ((new-object net.webclient).DownloadString('http://bit.ly/psChocInstall'))
    
}
else {
    if((Get-Command choco).Count -ne 1)
    {
        Write-Warning "Vagrant should be installed"
        Write-Host "Installing applications from Chocolatey"
        choco install vagrant -y
    }
}
