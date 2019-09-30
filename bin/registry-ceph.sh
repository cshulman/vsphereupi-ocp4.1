#!/bin/bash

export rs_path="path/to/ceph/registry"

oc create -f $rs_path/filesystem.yaml
oc create -f $rs_path/cephfs-storageclass.yaml
oc create -f $rs_path/registry-pvc.yaml

