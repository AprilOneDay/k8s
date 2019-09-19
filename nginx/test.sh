#!/bin/bash

IPADDRESS=$1
NAME=$2
K8SVERSION=1.13.3
DOCKERVERSION=18.06.1.ce-3.el7

if [ ! $NAME ];then
	echo  'plase input [ $1 ] -- 请输入[ name ]'
	exit
fi

echo 'success'