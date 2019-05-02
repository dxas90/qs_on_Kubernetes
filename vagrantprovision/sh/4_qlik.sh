#Install storageClass on NFS provider
helm install --name qmi stable/nfs-client-provisioner -f /vagrant/files/storageClass.yaml

#Create Persistent Volume Claims
kubectl apply -f /vagrant/files/qsefe/pvc.yaml

#Install Mongo
helm install --name qlikmongo -f /vagrant/files/qsefe/mongo-helm.yaml stable/mongodb


#Install qliksense from stable repo
helm repo add qlik-stable https://qlik.bintray.com/stable
helm repo add qlik-edge https://qlik.bintray.com/edge

# install the initial settings
helm install -n qsek8s-init qlik-stable/qliksense-init

# install qlik sense enterprise on kubernetes
helm install -n qsek8s qlik-stable/qliksense -f /vagrant/files/qliksense.yaml 