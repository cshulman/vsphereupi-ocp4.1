#!/bin/bash

export BASE_DIR="/root/vsphere"
export TERRA_DIR="/root/openshift/installer/upi/vsphere"
export MASTER_IGN="http://master"


rm -rf $BASE_DIR/* $BASE_DIR/.op*
cp /root/install-config.yaml $BASE_DIR/
openshift-install --dir $BASE_DIR create ignition-configs
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null  $BASE_DIR/bootstrap.ign lb.jk308.com:/var/www/html/pub/


export MASTER_IGN=$(<$BASE_DIR/master.ign)
export WORKER_IGN=$(<$BASE_DIR/worker.ign)

sed -i -e "/control_plane_ignition = <<END_OF_MASTER_IGNITION/,/END_OF_MASTER_IGNITION/c\control_plane_ignition = <<END_OF_MASTER_IGNITION\n$MASTER_IGN\nEND_OF_MASTER_IGNITION" $TERRA_DIR/terraform.tfvars
sed -i -e "/compute_ignition = <<END_OF_WORKER_IGNITION/,/END_OF_WORKER_IGNITION/c\compute_ignition = <<END_OF_WORKER_IGNITION\n$WORKER_IGN\nEND_OF_WORKER_IGNITION" $TERRA_DIR/terraform.tfvars

