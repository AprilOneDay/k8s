#!/bin/bash

TOKEN=$1

MASTER_IP=$2

if [ ! $TOKEN ]; then
	echo  'error:plase input [ $1 ] -- 请输入[ TOKEN ]'
	exit
fi

if [ ! $MASTER_IP ]; then
	echo  'error:plase input [ $2 ] -- 请输入[ MASTER_IP ]'
	exit
fi

kubeadm join --token ${TOKEN} ${MASTER_IP}

sysctl net.bridge.bridge-nf-call-iptables=1

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml