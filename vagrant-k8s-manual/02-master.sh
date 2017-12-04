#!/usr/bin/env bash
CLUSTER=$1

cd /vagrant/kube
MASTER_IP=$(ifconfig eth0 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
echo $MASTER_IP | tee /vagrant/kube/masterip /vagrant/kube-win/masterip

cd /vagrant/kube/certs
./generate-certs.sh $MASTER_IP

cd /vagrant/kube/manifest
./generate.py $MASTER_IP --cluster-cidr $CLUSTER.0.0/16
rm ./generate.py

cp -R /vagrant/* /root

cd /vagrant/kube
./configure-kubectl.sh $MASTER_IP

cd /vagrant/kube
sudo cp ~/.kube/config /vagrant/kube/config
sudo cp ~/.kube/config /vagrant/kube-win/config

mkdir -p /root/kube/kubelet/
sudo cp ~/.kube/config /root/kube/kubelet/config #critical this is here

cd /vagrant/kube
ls -lah
echo "You'll want to run the below commands as root from /root/kube/"
echo "./start-kubelet.sh &"
echo "./generate-routes.sh $CLUSTER &" 
echo "Let's do that anyway..."

./start-kubelet.sh &
./generate-routes.sh $CLUSTER &
docker ps
sleep 20
docker ps