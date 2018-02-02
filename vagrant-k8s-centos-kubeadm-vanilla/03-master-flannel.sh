#!/usr/bin/env bash
kubeadm init --pod-network-cidr=10.244.0.0/16 #flannel CIDR

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.0/Documentation/kube-flannel.yml
kubectl taint nodes --all node-role.kubernetes.io/master

kubectl get all --all-namespaces