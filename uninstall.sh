#!/bin/bash

source common.sh

if [ ! $(kubectl get all -n ran -o json | jq " .items  | length") -eq "0" ]; then
  kubectl delete -k srsRAN -n ran --wait
fi

sudo ovs-vsctl --if-exists del-br fronthaul-br
sudo ovs-vsctl --if-exists del-br f1-br

