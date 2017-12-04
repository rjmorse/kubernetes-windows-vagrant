Param(
    $ClusterCIDR="192.168.0.0/16"
)
"...Info about this box..."
Get-WmiObject -Class Win32_OperatingSystem | ForEach-Object -MemberName Caption
(Get-ItemProperty -Path c:\windows\system32\hal.dll).VersionInfo.FileVersion
"...End info..."

cd c:/k/
ls c:/k/

docker system info
docker images
docker pull microsoft/windowsservercore:1709
docker tag microsoft/windowsservercore:1709 microsoft/windowsservercore:latest
docker build -t kubeletwin/pause .

#This file should have been created by the master, placed in the synced folder, and then copied to c:/k upon Vagrant provisioning
Get-Item c:/k/config
Get-Content c:/k/config

"Run these commands to continue:"
"start-process powershell.exe ./start-kubelet.ps1 -clusterCIDR $ClusterCIDR"
"start-process powershell.exe ./start-kubeproxy.ps1"

