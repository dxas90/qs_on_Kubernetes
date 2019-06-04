#!/bin/bash
#Initialize Helm Tiller pod, upgrade and update the repos
helm init
helm init --wait --upgrade
helm repo update

#Install storageClass on NFS provider
helm install -n nfs stable/nfs-client-provisioner -f $PWD/files/storageClass.yaml

#Create Persistent Volume Claims
kubectl apply -f $PWD/files/pvc.yaml

#Install MongoDB
helm install -n mongo stable/mongodb -f $PWD/files/mongo.yaml

#Install qliksense from stable repo
helm repo add qlik-stable https://qlik.bintray.com/stable
helm repo add qlik-edge https://qlik.bintray.com/edge

# install the initial settings
helm install -n qlikinit qlik-stable/qliksense-init

# install qlik sense enterprise on kubernetes
helm install -n qlik qlik-stable/qliksense -f $PWD/files/qliksense.yaml
