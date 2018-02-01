#!/usr/bin/env bash
echo "worker command depends on master output..."
echo "use 'kubeadm join' command output from master..."

#kubeadm join --token windowsheartk8s 10.4.128.166:6443 --discovery-token-ca-cert-hash sha256:d77b66d50b7da8a93b4696f1b1562ee35fecd4fe521de74ab13be5becb311643
#kubeadm join --token abcdef.1234567890abcdef --discovery-token-unsafe-skip-ca-verification --ignore-preflight-errors all 10.127.132.215:6443