cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
setenforce 0

yum install -y -q yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum-config-manager --disable docker-ce-edge
yum makecache fast
yum install -y -q kubelet kubeadm
yum install -y -q docker-ce

#Workaround from  https://github.com/kubernetes/kubernetes/issues/43805
sed -i"*" "s|KUBELET_CGROUP_ARGS=--cgroup-driver=systemd|KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs|g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

systemctl enable kubelet && systemctl start kubelet
systemctl enable docker.service && systemctl start docker
#systemctl daemon-reload
#systemctl restart kubelet.service

#CentOS issue per https://github.com/kubernetes/kubeadm/issues/312
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
kubeadm init --pod-network-cidr=10.244.0.0/16
#roughly 120s for init

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#allow the master to be scheduable
kubectl taint nodes --all node-role.kubernetes.io/master-
#add flannel
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
#add flannel part 2 - rbac
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel-rbac.yml
#add dashboard
kubectl create -f https://rawgit.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml
#check for pods not running (tail excludes the header line)
kubectl get pods --all-namespaces | tail -n +2 | grep -v Running
