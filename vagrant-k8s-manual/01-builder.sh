#!/usr/bin/env bash

#####################################################################################
#Install necessary components
sudo apt-get update
sudo apt-get install -y curl git build-essential docker.io conntrack 
#add vagrant user to docker
sudo usermod -a -G docker vagrant
#####################################################################################



#####################################################################################
# Build Windows Binaries
SRC_DIR="/home/vagrant/src/k8s/"
BRANCH="release-1.9"
REPO_URL="https://github.com/kubernetes/kubernetes.git"

if [ -d ${DIST_DIR} ]; 
then (echo "Directory exists: ${DIST_DIR}");
else (mkdir -p ${DIST_DIR});
fi

if [ -d $SRC_DIR ]; 
then (
    cd $SRC_DIR && git checkout $BRANCH && git pull
    ); 
else (
    git clone --progress --depth 1 $REPO_URL $SRC_DIR && cd $SRC_DIR && git checkout $BRANCH
    );
fi

cd $SRC_DIR
build/run.sh make WHAT=cmd/kubelet    KUBE_BUILD_PLATFORMS=linux/amd64   
build/run.sh make WHAT=cmd/kubelet    KUBE_BUILD_PLATFORMS=windows/amd64 
build/run.sh make WHAT=cmd/kubectl    KUBE_BUILD_PLATFORMS=windows/amd64 
build/run.sh make WHAT=cmd/kube-proxy KUBE_BUILD_PLATFORMS=windows/amd64 
cp _output/dockerized/bin/windows/amd64/kube*.exe ${DIST_DIR}

ls -lah ${DIST_DIR}kube*.exe
#####################################################################################

