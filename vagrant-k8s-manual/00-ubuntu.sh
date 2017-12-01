#!/usr/bin/env bash
echo "Starting bootstrap"

systemctl stop apt-daily.service
systemctl kill --kill-who=all apt-daily.service

# wait until `apt-get updated` has been killed
while ! (systemctl list-units --all apt-daily.service | fgrep -q dead)
do
  echo "apt-daily still running"
  sleep 1;
done

sudo apt-get update
sudo apt-get install -y git

#####################################################################################
# Make directories
DIST_DIR="/vagrant/kube-win/"
KUBE_DIR="/vagrant/kube/"
if [ -d ${DIST_DIR} ]; 
then (echo "Directory exists: ${DIST_DIR}");
else (mkdir -p ${DIST_DIR});
fi

if [ -d ${KUBE_DIR} ]; 
then (echo "Directory exists: ${KUBE_DIR}");
else (mkdir -p ${KUBE_DIR});
fi
#####################################################################################

#####################################################################################
# Clone k8s guide
SRC_DIR="/vagrant/k8s-guide/"
BRANCH="k8s-guide"
REPO_URL="https://github.com/Microsoft/SDN"


if [ -d $SRC_DIR ]; 
then (
    cd $SRC_DIR && git checkout $BRANCH && git pull
    ); 
else (
    git clone --progress $REPO_URL $SRC_DIR && cd $SRC_DIR && git checkout $BRANCH
    );
fi

cp -rf ${SRC_DIR}/Kubernetes/linux/* /vagrant/kube/
cp -rf ${SRC_DIR}/Kubernetes/windows/* /vagrant/kube-win/
#####################################################################################
