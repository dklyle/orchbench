## Cluster config

### scripted cluster set up
To set up a k8s cluster you can use `kube-master-init.sh` and `kube-client-init.sh`

Make sure the nodes are ready for install
```sh
$ k8s-clean.sh
```

Time the bring up of the master and client nodes in one script
```sh
$ k8s-up.sh
```

### configure the master and clients separately (untimed)

#### kube-master-init.sh

* assumes sudo access
* will use `kubeadm` to set up the cluster with weave

```sh
./kube-master-init.sh
```

#### kube-client-init.sh

* will configure all systems in `kclients`
* assumes `mussh` is installed on the system it is executed on
* assumes passwordless ssh is configured to `kclients`

```sh
./kube-client-init.sh <IP:port> --token <token> --discovery-token-ca-cert-hash <discovery-token-ca-cert-hash>
```

## Testing

The test deployment is `hello-node.json`. This depends on a docker container `dklyle/hello-node:v2`.

The script times how long until the first line of main in the deployment container executes.

The timing happens with k8s-run-test, the variable 'ITERATIONS' can be changed to get an average rather than one iteration.

```sh
$ k8s-run-test hello-node.json
```

Alternatively, you can run a Go based workload by passing `hello-go.json`

`k8s-run-test` assumes the `kube-proxy` is running on the master node exposing port 8090.



