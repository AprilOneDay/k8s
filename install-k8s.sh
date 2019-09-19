#!/bin/bash

NAME=$1
IPADDRESS=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d '/'`
K8SVERSION=1.13.3
DOCKERVERSION=18.06.1.ce-3.el7

if [ ! $NAME ]; then
	echo  'error:plase input [ $1 ] -- 请输入[ name ]'
	exit
fi

if [ ! $IPADDRESS ]; then
	echo  'error:ipaddress not find -- ipaddress 不能为空'
	exit
fi

echo "export K8SVERSION=${K8SVERSION}" >> /etc/profile

# 更改yum源
isWget=`yum list installed | grep wget`
if [ ! $isWget ]; then
	yum install wget -y
fi

cd /etc/yum.repos.d/
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# 开启转发功能
echo "1" > /proc/sys/net/ipv4/ip_forward

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

echo 1 > /proc/sys/net/bridge/bridge-nf-call-ip6tables 
echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables

# 设置主机名称
hostnamectl --static set-hostname  ${NAME}
# 修改hosts
sed -i "$a ${IPADDRESS} ${NAME}" /etc/hosts 
# 关闭防火墙
systemctl disable firewalld.service 
systemctl stop firewalld.service

setenforce 0

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

swapoff -a

# yum list docker-ce.x86_64 --showduplicates
yum -y install docker-ce-${DOCKERVERSION}
systemctl enable docker && systemctl start docker

yum install -y kubelet-${K8SVERSION} kubeadm-${K8SVERSION} kubectl-${K8SVERSION} kubernetes-cni-0.6.0-0
kubectl version

cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system

systemctl enable kubelet && systemctl start kubelet

