#!/bin/bash
systemctl status firewalld
systemctl disable firewalld
systemctl stop  firewalld

yum install -y  nfs-utils rpcbind 

echo '/nfs/ *(insecure,rw,sync,no_root_squash,fsid=0)' >> /etc/exports

mkdir -p /nfs 
chmod 777 /nfs 

systemctl enable rpcbind && systemctl start rpcbind
systemctl enable nfs && systemctl start nfs

# touch /nfs

# chown -R nfsnobody.nfsnobody /nfs/