# Kubernetes On-Premises Deployment From Scratch -- Start to Finish #

**Future goal:** This guide will walk you through deploying *Kubernetes 1.9* on a Linux master and join two Windows nodes to it without a cloud provider.

This is based on work at https://github.com/Microsoft/SDN/blob/k8s-guide/Kubernetes/HOWTO-on-prem.md

All directories should have a README to convey its purpose

## Current status ##

- Focused on `./vagrant-k8s-manual/` work
  - Not fully functional yet to get a working cluster
  - Leverages Vagrant 2.0 and Hyper-V
  - `k-builder` builds windows binaries and places them and other resources in `./vagrant-synced/` for subsequent Vagrant instances to leverage
  - `k-m1` preps an instance so you can login and run a few commands in two `vagrant ssh` sessions
    ```
    sudo su -
    cd /root/kube
    ./start-kubelet.sh
    ```
    ```
    sudo su -
    cd /root/kube
    ./start-kubeproxy.sh 192.168
    ```
  - Using v1.9.0-beta.1 for master, and branch release-1.9 for building Windows binaries
  - The master runs but missing heapster, dashboard, etc
  - `k-w-w1` preps a windows worker with a pause image
  - You can use `kubectl` to connect to the master by copying the config from `./vagrant-synced/kube/config` to `~/.kube/config`
- Previous work on `./vagrant-k8s-kubeadm-vanilla/` was used for testing v1.8 kubeadm to standup a master and join a Linux worker node
  - This creates a functioning master in `vagrant up`
  - Manual step to grab the `kubeadm join` command and run from the worker

## Requirements ##

- RAM: 3GB RAM for Master, 1GB RAM for each Windows worker (minimums)
- Vagrant 2.0
- Hyper-V
- Vagrant box created for Windows Server 1709 with Containers feature and Docker installed per https://git.tmaws.io/robert.morse/vagrant-hyperv-windows or similar
- Internet connectivity for connecting to GitHub, and also download Kubernetes bits

**Note:** `./Setup-Environment.ps1` may or may not help to install the Requirements listed above