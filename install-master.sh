#!/bin/bash

IPADDRESS=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d '/'`

kubeadm init --image-repository registry.aliyuncs.com/google_containers --kubernetes-version=v${K8SVERSION}  --apiserver-advertise-address ${IPADDRESS} --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=NumCPU

echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/profile
source /etc/profile 
echo $KUBECONFIG

sysctl net.bridge.bridge-nf-call-iptables=1

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml