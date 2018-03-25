#!/bin/bash
set -e

# Prepare Cluster 
ansible nodes -b -i hosts -m shell -a "yum install -y subscription-manager && subscription-manager clean" 
ansible nodes -b -i hosts -m shell -a "subscription-manager register --username=$RHN_USERNAME --password=$RHN_PASSWORD && subscription-manager attach --pool=$RHN_SUB_POOL && subscription-manager refresh" 
ansible nodes -b -i hosts -m shell -a "subscription-manager repos --disable='*' && subscription-manager repos --enable=rhel-7-server-rpms --enable=rhel-7-server-optional-rpms --enable=rhel-7-server-extras-rpms --enable=rhel-7-server-ose-3.7-rpms --enable=rhel-7-fast-datapath-rpms"
ansible nodes -b -i hosts -m shell -a "yum install -y docker-1.12.6 wget git net-tools bind-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct"
ansible nodes -b -i hosts -m shell -a "yum update -y"
ansible nodes -i hosts -b -m copy -a "src=docker-storage-setup dest=/etc/sysconfig/docker-storage-setup"
ansible nodes -b -i hosts -m shell -a "yum install -y atomic-openshift-utils"
#this is non-idempotent
ansible nodes -i hosts -b -m shell -a "docker-storage-setup"
ansible nodes -b -i hosts -m service -a "name=docker enabled=true state=started"
ansible nodes -b -i hosts -m shell -a "reboot"
