#!/usr/bin/env bash

apt-get update && apt-get install -y curl apt-transport-https
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/docker.list
deb https://download.docker.com/linux/$(lsb_release -si | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable
EOF
apt-get update && apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep 17.03 | head -1 | awk '{print $3}')

cat /proc/swaps
echo "disabling swap"
awk '/swap/{$0="#"$0} 1' /etc/fstab >/etc/fstab.tmp && mv /etc/fstab.tmp /etc/fstab
sudo swapoff -a
sudo sysctl vm.swappiness=0
cat /proc/swaps

cd $HOME
#install linux binaries per https://github.com/Microsoft/SDN/blob/k8s-guide/Kubernetes/HOWTO-on-prem.md#installing-the-linux-binaries
wget --quiet -O kubernetes.tar.gz https://github.com/kubernetes/kubernetes/releases/download/v1.9.0-beta.1/kubernetes.tar.gz
tar -xzf kubernetes.tar.gz #removed -v for verbose
cd kubernetes/cluster 
# follow the prompts from this command:
./get-kube-binaries.sh
cd ../server
tar -xzf kubernetes-server-linux-amd64.tar.gz #removed -v for verbose
cd kubernetes/server/bin

# TODO: check that this PATH is not creating a problem
# changed from $HOME to /vagrant. Have to mkdir since the bin isn't there regardless
mkdir -p /vagrant/kube/bin/
cp hyperkube kubectl /vagrant/kube/bin/
PATH="/vagrant/kube/bin/:$PATH"

# #Get CNI plugins per https://github.com/Microsoft/SDN/blob/k8s-guide/Kubernetes/HOWTO-on-prem.md#install-cni-plugins
# Changed from $HOME to /vagrant
DOWNLOAD_DIR="/vagrant/kube/cni-plugins"
CNI_BIN="/opt/cni/bin/"
mkdir ${DOWNLOAD_DIR}
cd $DOWNLOAD_DIR
curl --silent -L $(curl -s https://api.github.com/repos/containernetworking/plugins/releases/latest | grep browser_download_url | grep 'amd64.*tgz' | head -n 1 | cut -d '"' -f 4) -o cni-plugins-amd64.tgz
tar -xzf cni-plugins-amd64.tgz #removed -v for verbose
sudo mkdir -p ${CNI_BIN}
# This command doesn't work
#sudo cp -r !(*.tgz) ${CNI_BIN}
sudo cp -r `ls | egrep -v '^.*tgz$'` ${CNI_BIN}
ls ${CNI_BIN}

