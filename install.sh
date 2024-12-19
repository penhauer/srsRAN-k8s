#!/bin/bash

print_subheader() {
    echo -e "\e[1;36m--- $1 ---\e[0m"
}

print_header() {
    echo -e "\n\e[1;34m############################### $1 ###############################\e[0m"
}

print_success() {
    echo -e "\e[1;32m$1\e[0m"
}

print_error() {
    echo -e "\e[1;31mERROR: $1\e[0m"
}

print_info() {
    echo -e "\e[1;33mINFO: $1\e[0m"
}

setup-ovs-bridges() {
  if [ -x "$(command -v ovs-vsctl)" ]; then
    print_info "OpenVSwitch is already installed."
  else
    print_info "Installing OpenVSwitch ..."
    sudo apt-get update
    sudo apt-get install -y openvswitch-switch
  fi

  print_info "Configuring the front haul and mid haul bridges"

  # Midhaul bridge (F1 interface)
  sudo ovs-vsctl --may-exist add-br f1-br

  # Fronthaul bridge or the USRP interface
  sudo ovs-vsctl --may-exist add-br fronthaul-br
}

create-ran-namespace
setup-ovs-bridges

kubectl apply -k ./srsRAN -n ran

