#!/bin/bash
systemctl status firewalld
systemctl disable firewalld
systemctl stop  firewalld

yum install -y  nfs-utils rpcbind 

echo '/k8s/ *(insecure,rw,sync,no_root_squash,fsid=0)' >> /etc/exports

# mkdir -p /k8s 
chmod 777 /k8s 

systemctl enable rpcbind && systemctl start rpcbind
systemctl enable nfs && systemctl start nfs

# touch /nfs

# chown -R nfsnobody.nfsnobody /k8s/