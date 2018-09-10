# enable passwordless ssh
eval `ssh-agent`
ssh-add ~/.ssh/id_rsa

# start timing
START=$(date +%s%N | cut -b1-13)

# configure k8s master node
JOIN_ARGS=$(sudo kubeadm init --config kubeadm.yaml | grep -o "kubeadm join.*" | cut -c 14-)
if [ $? -ne 0 ]; then
    echo "kubeadm init failed"
    exit
fi

mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# setup CNI plugin
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=1.10"
if [ $? -ne 0 ]; then
    echo "weave install failed"
    exit
fi

# configure the client nodes
mussh -H ./kclients -c "sudo kubeadm join $JOIN_ARGS"
if [ $? -ne 0 ]; then
    echo "failed remote kubeadm join"
    exit
fi

# stop timing
END=$(date +%s%N | cut -b1-13)
DIFF=$((END-START))

# report time to bring up cluster
echo "----------"
echo "total milliseconds: $DIFF"
