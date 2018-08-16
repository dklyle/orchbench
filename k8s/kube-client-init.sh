#!/bin/bash

echo "$1"
echo "$2"
echo "$3"
echo "$4"
echo "$5"

case $1 in
    -?|--help)
    echo "usage is ./kube-client-init.sh <IP:port> --token <token> --discovery-token-ca-cert-hash <discovery-token-ca-cert-hash>"
    exit
    ;;
esac

mussh -H ./kclients -c 'sudo kubeadm reset'
if [ $? -ne 0 ]; then
    echo "failed remote kubeadm reset"
    exit
fi

mussh -H ./kclients -c 'sudo swapoff -a'
if [ $? -ne 0 ]; then
    echo "failed remote swapoff"
    exit
fi

mussh -H ./kclients -c "sudo kubeadm join $1 $2 $3 $4 $5"
if [ $? -ne 0 ]; then
    echo "failed remote kubeadm join"
    exit
fi
