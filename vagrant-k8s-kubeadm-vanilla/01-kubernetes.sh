#!/usr/bin/env bash

apt-get update && apt-get install -y curl apt-transport-https
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/docker.list
deb https://download.docker.com/linux/$(lsb_release -si | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable
EOF
apt-get update && apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep 17.03 | head -1 | awk '{print $3}')


#cat << EOF > /etc/docker/daemon.json
# {
#  "exec-opts": ["native.cgroupdriver=systemd"]
# }
#EOF
#sudo systemctl restart docker

cat /proc/swaps
echo "disabling swap"
awk '/swap/{$0="#"$0} 1' /etc/fstab >/etc/fstab.tmp && mv /etc/fstab.tmp /etc/fstab
sudo swapoff -a
sudo sysctl vm.swappiness=0
cat /proc/swaps


apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update
apt-get install -y kubelet kubeadm kubectl

systemctl status kubelet
journalctl -xeu kubelet

cat /proc/swaps
sudo swapoff -a
cat /proc/swaps


# #For after
# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config
# source <(kubectl completion bash)
# source <(kubeadm completion bash)
# 
# 


# kubeadm join --token f9af47.a217eadf051789fc 10.4.128.254:6443 --discovery-token-ca-cert-hash sha256:463a498dd399781da87b6e08cba694e95ac3fe97fb8c713891b7b9b970a25d1c