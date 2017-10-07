#!/bin/sh
export TUNNEL_MODE=geneve
export LOCAL_IP=`hostname -i`
export MASTER_IP=$LOCAL_IP

ovs-vsctl set Open_vSwitch . external_ids:ovn-remote="tcp:$MASTER_IP:6642" \
external_ids:ovn-nb="tcp:$MASTER_IP:6641" \
external_ids:ovn-encap-ip="$LOCAL_IP" \
external_ids:ovn-encap-type="$TUNNEL_MODE"
cd ~/kubernetes-ovn-heterogeneous-cluster/master
rm -rf tmp
mkdir tmp
cp -R make-certs openssl.cnf kubedns-* manifests systemd tmp/

export HOSTNAME=`hostname`
export K8S_VERSION=1.7.3
export K8S_POD_SUBNET=10.244.0.0/16
export K8S_NODE_POD_SUBNET=10.244.1.0/24
export K8S_SERVICE_SUBNET=10.100.0.0/16
export K8S_API_SERVICE_IP=10.100.0.1
export K8S_DNS_VERSION=1.13.0
export K8S_DNS_SERVICE_IP=10.100.0.10
export K8S_DNS_DOMAIN=cluster.local
export ETCD_VERSION=3.1.1
export MASTER_INTERNAL_IP=10.244.1.2

sed -i"*" "s|__K8S_VERSION__|$K8S_VERSION|g" tmp/manifests/*.yaml
sed -i"*" "s|__K8S_VERSION__|$K8S_VERSION|g" tmp/systemd/kubelet.service
sed -i"*" "s|__ETCD_VERSION__|$ETCD_VERSION|g" tmp/systemd/etcd3.service
sed -i"*" "s|__MASTER_IP__|$MASTER_IP|g" tmp/manifests/*.yaml
sed -i"*" "s|__MASTER_IP__|$MASTER_IP|g" tmp/systemd/kubelet.service
sed -i"*" "s|__MASTER_IP__|$MASTER_IP|g" tmp/openssl.cnf
sed -i"*" "s|__MASTER_INTERNAL_IP__|$MASTER_INTERNAL_IP|g" tmp/manifests/*.yaml
sed -i"*" "s|__HOSTNAME__|$HOSTNAME|g" tmp/systemd/kubelet.service
sed -i"*" "s|__HOSTNAME__|$HOSTNAME|g" tmp/make-certs
sed -i"*" "s|__HOSTNAME__|$HOSTNAME|g" tmp/openssl.cnf
sed -i"*" "s|__K8S_API_SERVICE_IP__|$K8S_API_SERVICE_IP|g" tmp/openssl.cnf
sed -i"*" "s|__K8S_POD_SUBNET__|$K8S_POD_SUBNET|g" tmp/manifests/*.yaml
sed -i"*" "s|__K8S_SERVICE_SUBNET__|$K8S_SERVICE_SUBNET|g" tmp/manifests/*.yaml
sed -i"*" "s|__K8S_DNS_SERVICE_IP__|$K8S_DNS_SERVICE_IP|g" tmp/systemd/kubelet.service
sed -i"*" "s|__K8S_DNS_DOMAIN__|$K8S_DNS_DOMAIN|g" tmp/systemd/kubelet.service
sed -i"*" "s|__K8S_DNS_SERVICE_IP__|$K8S_DNS_SERVICE_IP|g" tmp/kubedns-service.yaml
sed -i"*" "s|__K8S_DNS_VERSION__|$K8S_DNS_VERSION|g" tmp/kubedns-deployment.yaml
sed -i"*" "s|__K8S_DNS_DOMAIN__|$K8S_DNS_DOMAIN|g" tmp/*.*
cp -R tmp/systemd/*.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable etcd3
systemctl start etcd3
cd tmp
chmod +x make-certs
./make-certs
cd ..
mkdir -p /etc/kubernetes
cp -R tmp/manifests /etc/kubernetes/
systemctl enable kubelet
systemctl start kubelet
curl -Lskj -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v$K8S_VERSION/bin/linux/amd64/kubectl
chmod +x /usr/bin/kubectl
kubectl config set-cluster default-cluster --server=https://$MASTER_IP --certificate-authority=/etc/kubernetes/tls/ca.pem
kubectl config set-credentials default-admin --certificate-authority=/etc/kubernetes/tls/ca.pem --client-key=/etc/kubernetes/tls/admin-key.pem --client-certificate=/etc/kubernetes/tls/admin.pem
kubectl config set-context local --cluster=default-cluster --user=default-admin
kubectl config use-context local
