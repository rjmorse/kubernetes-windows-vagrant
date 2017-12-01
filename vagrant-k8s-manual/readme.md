# Usage instructions

- This will standup a 2 Ubuntu Linux instances: one Master, one Worker
  - Pulls k8s binaries that are published to http://apt.kubernetes.io/ 
  - Master is schedulable, with Flannel
  - Worker needs you to SSH and run a `kubeadm join` command