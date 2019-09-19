#!/bin/bash

IPADDRESS=$1
NAME=$2
K8SVERSION=1.13.3
DOCKERVERSION=18.06.1.ce-3.el7

echo "export K8SVERSION=${K8SVERSION}" >> /etc/profile
echo "export IPADDRESS=${IPADDRESS}" >> /etc/profile

if[!IPADDRESS || !NAME];then
	echo  'plase input [ ip and name ] -- 请输入[ ip 和 name]'
	exit
fi

isWget=`yum list installed | grep wget`
if[!isWget];then
	yum install wget -y
fi

cd /etc/yum.repos.d/
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

hostnamectl --static set-hostname  ${NAME}

sed -i '$a ${IPADDRESS} ${NAME}' /etc/hosts 

systemctl disable firewalld.service 
systemctl stop firewalld.service

setenforce 0

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

swapoff -a

#yum list docker-ce.x86_64 --showduplicates
yum -y install docker-ce-${DOCKERVERSION}
systemctl enable docker && systemctl start docker

yum install -y kubelet-${K8SVERSION} kubeadm-${K8SVERSION} kubectl-${K8SVERSION} kubernetes-cni-0.6.0-0 ipvsadm

cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system

systemctl enable kubelet && systemctl start kubelet

