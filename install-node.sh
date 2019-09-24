#!/bin/bash

TOKEN=$1

MASTER_IP=$2

if [ ! $TOKEN ]; then
	echo  'error:plase input [ $1 ] -- 请输入[ TOKEN ]'
	exit
fi

if [ ! $MASTER_IP ]; then
	echo  'error:plase input [ $2 ] -- 请输入[ MASTER_IP:prot ]'
	exit
fi

kubeadm join --token ${TOKEN} ${MASTER_IP} --discovery-token-unsafe-skip-ca-verification

# 安装nfs客服端
yum -y install nfs-utils
systemctl start nfs && systemctl enable nfs