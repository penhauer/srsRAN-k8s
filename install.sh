#!/bin/bash


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

connect-usrp-interface-to-bridge() {
  USRP_ADDRESS=$(uhd_find_devices 2> /dev/null | grep addr | awk '{ print $2} ') # "192.168.40.2"
  USRP_SUBNET=$(echo "${USRP_ADDRESS}" | grep -E '^[0-9]*\.[0-9]*\.[0-9]*' -o ) # "192.168.40"
  USRP_INTERFACE=$(ip -br a | grep "${USRP_SUBNET}" | awk '{ print $1 }' )

  # Add the usrp's interface as a port to fronthaul-br
  sudo ovs-vsctl add-port fronthaul-br "${USRP_INTERFACE}"

  timer-sec 5
  # add an ip address to fronthaul-br interface so usrp is findable in the host
  sudo ip address add "${USRP_SUBNET}.123" dev fronthaul-br
  sudo ip link set fronthaul-br up
}

source common.sh

kubectl create namespace ran 2> /dev/null

setup-ovs-bridges
connect-usrp-interface-to-bridge

kubectl apply -k ./srsRAN -n ran

