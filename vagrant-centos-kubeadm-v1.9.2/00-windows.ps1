Param(
  [String]$pauseimagename
)

docker import \baseimages\CBaseOs_rs_onecore_stack_17089.1000.180129-1709_amd64fre_NanoServer_en-us.tar.gz microsoft/nanoserver-insider
docker import \baseimages\CBaseOs_rs_onecore_stack_17089.1000.180129-1709_amd64fre_ServerDatacenterCore_en-us.tar.gz microsoft/windowsservercore-insider

mkdir C:\k
copy \vagrant\kubelet.exe C:\k\kubelet.exe
copy \vagrant\kube-proxy.exe C:\k\kube-proxy.exe
copy \vagrant\kubeadm.exe C:\k\kubeadm.exe

mkdir C:\k\kubeletsvc 
cd C:\k\kubeletsvc
curl https://github.com/kohsuke/winsw/releases/download/winsw-v2.1.2/WinSW.NET4.exe -UseBasicParsing -o kubelet-service.exe

mkdir C:\k\cni
mkdir C:\k\cni\config

$myhostname=hostname
$kubesvcpath = "C:\\k\\kubeletsvc"

New-Item -Path $kubesvcpath -Name "kubelet-service.xml" -ItemType File
$ServiceDefn = @"
<service>
    <id>kubelet</id>
    <name>kubelet</name>
    <description>This service runs kubelet.</description>
    <executable>C:\k\kubelet.exe</executable>
    <arguments>--hostname-override=$myhostname --v=6 --pod-infra-container-image=$pauseimagename --resolv-conf="" --allow-privileged=true --enable-debugging-handlers --cluster-dns=10.96.0.10 --cluster-domain=cluster.local --bootstrap-kubeconfig="C:\etc\kubernetes\bootstrap-kubelet.conf" --kubeconfig=c:\k\config --hairpin-mode=promiscuous-bridge --image-pull-progress-deadline=20m --cgroups-per-qos=false --enforce-node-allocatable="" --network-plugin=cni --cni-bin-dir="c:\k\cni" --cni-conf-dir "c:\k\cni\config"</arguments>
    <logmode>rotate</logmode>
    </service>
"@

$ServiceDefn | Out-File -FilePath "$kubesvcpath\kubelet-service.xml"

# TODO: This should probably move into the Packer JSON
cd C:\build
docker build -t $pauseimagename -f Dockerfile.pause .

# Start kubelet
cd C:\k\kubeletsvc
C:\k\kubeletsvc\kubelet-service.exe install