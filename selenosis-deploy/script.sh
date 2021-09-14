#!/bin/bash

kubectl apply -f ./selenosis-deploy/01-namespace.yaml

kubectl apply -f ./selenosis-deploy/06-coredns.yaml

kubectl apply -f ./selenosis-deploy/07-pre-pull-images.yml

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