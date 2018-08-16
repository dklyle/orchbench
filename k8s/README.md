---
To set up a k8s cluster you can use kube-master-init.sh and kube-client-init.sh.

The test deployment is hello.json. This depends on a docker container dklyle/hello-node:v2.

The timing happens with k8s-run-test, the variable ITERATIONS can be changed to get an average rather than one iteration.
