#!/bin/bash
TOKEN=$1
MASTER_IP=$2

kubeadm join --token ${TOKEN} ${MASTER_IP}

sysctl net.bridge.bridge-nf-call-iptables=1

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml