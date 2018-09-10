#!/bin/bash

# reset the master node
sudo kubeadm reset -f
if [ $? -ne 0 ]; then
    echo "kubeadm reset failed"
    exit
fi
# make sure swap is off on master
sudo swapoff -a

# make sure passwordless ssh will work
eval `ssh-agent`
ssh-add ~/.ssh/id_rsa

# reset the client nodes
mussh -H ./kclients -c 'sudo kubeadm reset -f'
if [ $? -ne 0 ]; then
    echo "failed remote kubeadm reset"
    exit
fi

# make sure swap is off on clients
mussh -H ./kclients -c 'sudo swapoff -a'
if [ $? -ne 0 ]; then
    echo "failed remote swapoff"
    exit
fi
