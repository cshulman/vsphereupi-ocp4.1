#!/bin/bash

export rs_path="/root/rook.jay/cluster/examples/kubernetes/ceph"

oc create -f $rs_path/common.yaml
oc create -f $rs_path/operator-openshift.yaml
#oc create -f $rs_path/cluster-jay.yaml
oc create -f $rs_path/cluster.yaml
oc create -f $rs_path/toolbox.yaml
oc create -f $rs_path/dashboard-external-http.yaml 
oc expose service rook-ceph-mgr-dashboard-external-http -n rook-ceph


#https://github.com/rook/rook/blob/master/Documentation/ceph-quickstart.md#storage
oc create -f $rs_path/storageclass.yaml
#oc create -f $rs_path/object.yaml
#oc create -f $rs_path/filesystem.yaml

oc patch storageclass thin -p '{"metadata":{"annotations":{"storageclass.beta.kubernetes.io/is-default-class":"false"}}}'

#retreive ceph admin password
#oc -n rook-ceph get secret rook-ceph-dashboard-password -o jsonpath="{['data']['password']}" | base64 --decode && echo
