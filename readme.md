# Kubernetes v1.9 with Windows Workers - Vagrant Multi-Machine Setup #

## Goal: ##
This guide will help you stand up a local Kubernetes cluster in Hyper-V VMs through Vagrant.
You should be able to use this guide to have a working cluster with 2 Windows nodes within about 3 hours (as short as 80 minutes given my experience).

This is based on [GitHub docs from Microsoft](https://github.com/Microsoft/SDN/blob/k8s-guide/Kubernetes/HOWTO-on-prem.md) and you should at least read that before diving in here.

All directories should have a README to convey its purpose

## Current status ##

- Focused on `./vagrant-k8s-manual/` work
  - Stands up a working Windows worker cluster (deployments can be created)
  - Leverages Vagrant 2.0 and Hyper-V
  - `k-builder` builds windows binaries and places them and other resources in `./vagrant-synced/` for subsequent Vagrant instances to leverage
  - `k-m1` preps an instance with control plane running
  - Using v1.9.0-beta.2 precompiled/downloaded binaries for master, and branch release-1.9 for building Windows binaries
  - Windows worker nodes `k-w-w1` and `k-w-w2` ready to join the cluster
  - You can use `kubectl` on your system to connect to the master by copying the config from `./vagrant-synced/kube/config` to `~/.kube/config`

## Usage ##

- Ensure requirements below are met
- Update Vagrantfile at `./vagrant-k8s-manual/Vagrantfile` 
  - Set the Cluster CIDR you want to use. I chose 10.4.0.0/16 as a unique network that won't collide with other networks. You want to choose a range that overlaps with the external IPs that the nodes will get so they have routing to each other by default
- Open Powershell Administrator prompt
- CD to repo location
- CD to `./vagrant-k8s-manual/`
```
# do you need windows binaries? if you already have exe files for kubectl, kubelet, kube-proxy, place them in `../vagrant-synced/kube-win/`
vagrant up k-builder
# enter credentials that can access `../vagrant-synced/` as an SMB share. Administrator rights required.
# wait approximately 30 minutes for Windows binaries to be compiled and placed in `../vagrant-synced/kube-win/`
# you will likely build windows binaries once if at all
vagrant up
# wait approximately 10 minutes for k-m1 to complete
# at this point you can check the dashboard via kubectl proxy below if you're interested
# wait approximately 10 minutes for k-w-w1 to come up, with majority of time for WinRM copy of kube*.exe to node
# wait approximately 10 minutes for k-w-w2 to come up for the same reason
```
Login to each `k-w-w1` and `k-w-w2` (via `vagrant rdp k-w-w1` or Hyper-V Manager) and run via Powershell (due to TODO in 00-windows.ps1 provisioning script)
```
#NOTE: (Replace with your chosen ClusterCIDR)
$ClusterCIDR="10.4.0.0/16"

Start-Job -Name kubelet {c:\k\start-kubelet.ps1 -clusterCIDR $ClusterCIDR *> c:\k\kubelet-logs.txt}
Start-Job -Name kubeproxy {c:\k\start-kubeproxy.ps1 *> c:\k\kubeproxy-logs.txt}
```
Continue with kubectl to view the cluster info
```
cp ../vagrant-synced/kube/config ~/.kube/config
kubectl cluster-info
kubectl proxy
# navigate web browser to http://localhost:8001/api/v1/namespaces/kube-system/services/kubernetes-dashboard/proxy/#!/node?namespace=_all
```

## Other directories ##

- Previous work on `./vagrant-k8s-kubeadm-vanilla/` was used for testing v1.8 kubeadm to standup a master and join a Linux worker node
  - This creates a functioning master in `vagrant up`
  - Manual step to grab the `kubeadm join` command and run from the worker

## Requirements ##

- RAM: 5GB RAM for Master, 2GB RAM for each Windows worker
- Vagrant 2.0
- Hyper-V
- Vagrant box created for Windows Server 1709 with Containers feature and Docker installed per [Vagrant/Packer Box instructions](https://github.com/StefanScherer/packer-windows) or similar
  - Box generation takes roughly 1 hr, which includes caching the 1709 Docker images
  ```
  packer build --only hyperv-iso -var 'hyperv_switchname=External' -var 'iso_url=c:/images/en_windows_server_version_1709_x64_dvd_100090904.iso' .\windows_server_1709_docker.json
  vagrant box add windows_server_1709_docker_hyperv.box --name WindowsServer1709Docker
  ```
- Internet connectivity for connecting to GitHub, and also download Kubernetes bits

**Note:** `./Setup-Environment.ps1` may or may not help to install the Requirements listed above

## Known issues ##

- Windows nodes do not join automatically as part of `vagrant up`. This is due to some issue with **Start-Job** running in the context of Vagrant and then disconnecting, perhaps.
- Windows nodes do not report CPU or RAM metrics
- Vagrant SMB synced folder to Windows nodes does not work, and the file provisioner to copy files is slow (~5 minutes to copy 250MB)
- SMB synced folder does not accept parameters for some reason. This means typing in the username/password for SMB sync a couple minutes into the standup of each Linux instance
- kube-dns on the master gets into a crash loop and is likely due to a configuration error or could be related to https://github.com/kubernetes/kubernetes/issues/56902
