#!/bin/bash

#oc patch configs.imageregistry.operator.openshift.io cluster --type merge --patch '{"spec":{"storage":{"emptyDir":{}}}}'
oc patch -n openshift-ingress-operator ingresscontroller/default --patch '{"spec":{"replicas": 3}}' --type=merge


oc create secret generic htpass-secret --from-file=htpasswd=/root/users.htpasswd -n openshift-config
oc apply -f /root/passwd-auth.yaml
oc adm policy add-cluster-role-to-user cluster-admin huddlesj


oc new-project sandbox-manager
oc apply -f /root/git/onboarding-manager/deploy/

