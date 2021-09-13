#!/bin/bash

kubectl apply -f ./selenosis-deploy/01-namespace.yaml

kubectl apply -f ./selenosis-deploy/06-coredns.yaml

wget https://github.com/stern/stern/releases/download/v1.20.1/stern_1.20.1_linux_amd64.tar.gz

tar xvzf stern_1.20.1_linux_amd64.tar.gz

mv stern_1.20.1_linux_amd64 stern

chmod +x stern

./stern -n selenosis --selector='type=browser' > seleniferous.log
./stern -n selenosis --selector='app=selenosis' > selenosis.log

if [ $LOCAL ] 
then
    kubectl create cm selenosis-config --from-file=browsers.yaml=selenosis-deploy/vnc-browsers.yaml -n selenosis
    kubectl apply -f ./selenosis-deploy/04-selenoid-ui.yaml
else
    kubectl create cm selenosis-config --from-file=browsers.yaml=selenosis-deploy/browsers.yaml -n selenosis
fi

kubectl apply -f ./selenosis-deploy/02-service.yaml

kubectl apply -f ./selenosis-deploy/03-selenosis.yaml

kubectl apply -f ./selenosis-deploy/05-selenosis-hpa.yaml