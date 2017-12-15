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

#Change to userspace until bugfix merged from https://github.com/kubernetes/kubernetes/pull/56529
"Before:"
(Get-Content c:\k\start-kubeproxy.ps1)
#(Get-Content c:\k\start-kubeproxy.ps1).replace('--proxy-mode=kernelspace ', '--proxy-mode=userspace ') | Set-Content c:\k\start-kubeproxy.ps1
"After:"
(Get-Content c:\k\start-kubeproxy.ps1)

"TODO: Starting kubelet and joining cluster"
"Check logs at c:\k\kubelet-logs.txt or c:\k\kubeproxy-logs.txt on this node"

#TODO: these create jobs, but do not actually register. Running manually from Powershell works fine
#Start-Job -Name kubelet {c:\k\start-kubelet.ps1 -clusterCIDR $ClusterCIDR *> c:\k\kubelet-logs.txt}
#Start-Job -Name kubeproxy {c:\k\start-kubeproxy.ps1 *> c:\k\kubeproxy-logs.txt}

