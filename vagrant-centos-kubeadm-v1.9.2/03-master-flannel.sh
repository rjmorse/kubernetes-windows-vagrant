#!/usr/bin/env bash

# TODO: Save token and sha256 -- or -- specify token in args
kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors all --token abcdef.1234567890abcdef #flannel CIDR

export KUBECONFIG=/etc/kubernetes/admin.conf

# Non-Root users will need to run this
#mkdir -p $HOME/.kube
#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Pod Network (Flannel) Want to use Host-GW mode
#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.0/Documentation/kube-flannel.yml
#kubectl taint nodes --all node-role.kubernetes.io/master

#kubectl get all --all-namespaces