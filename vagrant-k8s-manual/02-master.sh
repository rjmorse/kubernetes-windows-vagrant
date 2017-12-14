#!/usr/bin/env bash
FULL_CLUSTER=$1
CLUSTER=$2

cd /vagrant/kube
MASTER_IP=$(ifconfig eth0 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
echo $MASTER_IP | tee /vagrant/kube/masterip /vagrant/kube-win/masterip

cd /vagrant/kube/certs
./generate-certs.sh $MASTER_IP

cd /vagrant/kube/manifest
./generate.py $MASTER_IP --cluster-cidr $FULL_CLUSTER
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
echo "now running:"
echo "cd /vagrant/kube"
echo "./start-kubelet.sh $CLUSTER &> /vagrant/master-kubelet-logs.txt &disown"
echo "./start-kubeproxy.sh $CLUSTER &> /vagrant/master-kubeproxy-logs.txt &disown"
echo "./generate-routes.sh $CLUSTER &> /vagrant/master-routes.txt &disown"

cd /vagrant/kube
./start-kubelet.sh $CLUSTER &> /vagrant/master-kubelet-logs.txt &disown
./start-kubeproxy.sh $CLUSTER &> /vagrant/master-kubeproxy-logs.txt &disown
./generate-routes.sh $CLUSTER &> /vagrant/master-routes.txt &disown

docker ps
docker images
echo "waiting 10s before next update"
sleep 10
docker ps
docker images
tail -n 10 /vagrant/master-kubelet-logs.txt

echo "done. continuing..."