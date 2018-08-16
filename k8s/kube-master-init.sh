#!/bin/bash

sudo kubeadm reset
if [ $? -ne 0 ]; then
    echo "kubeadm reset failed"
    exit
fi

sudo kubeadm init --config kubeadm.yaml
if [ $? -ne 0 ]; then
    echo "kubeadm init failed"
    exit
fi

mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=1.10"
if [ $? -ne 0 ]; then
    echo "weave install failed"
    exit
fi

#kubectl create -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml
#if [ $? -ne 0 ]; then
#    echo "influxdb install failed"
#    exit
#fi

#kubectl create -f https://raw.githubusercontent.com/luxas/kubeadm-workshop/master/demos/monitoring/heapster.yaml
#if [ $? -ne 0 ]; then
#    echo "heapster install failed"
#    exit
#fi

#kubectl create -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/grafana.yaml 
#if [ $? -ne 0 ]; then
#    echo "grafana install failed"
#    exit
#fi

#kubectl create -f https://git.io/kube-dashboard
#if [ $? -ne 0 ]; then
#    echo "dashboard install failed"
#    exit
#fi

kubectl proxy --port=8090 &
