# srsRAN-k8s

This reposistory deploys a disaggregated CU/DU srsRAN onto a Kubernetes cluster. 
The srsRAN images are built from [srsRAN_Project](https://github.com/srsran/srsRAN_Project) release 24_10.
It provides Kubernetes manifests files in the ```srsRAN``` directory. 
The configurations are made to be compatibly deployed with a [custom Open5GS delployment](https://github.com/niloysh/open5gs-k8s) and should require no further configurations. 


# Requirements
+ Supported OS: Ubuntu 22.04 LTS (recommended) or Ubuntu 20.04 LTS
+ Minimum hardware: 4 cores, 4GB RAM
+ Kubernetes v1.28 with Multus and OVS-CNI: We recommend using the [testbed-automator](https://github.com/niloysh/testbed-automator) to prepare the Kubernetes cluster.
This includes setting up the K8s cluster, configuring the cluster, installing various Container Network Interfaces (CNIs), configuring OVS bridges, and preparing for the deployment of the 5G Core network.
+ Open5GS core: We have tested this repository with a 5G core deployed on a Kubernetes cluster using [Open5GS-k8s](https://github.com/niloysh/open5gs-k8s).
By using the mentioned repo, no further configuration is needed. Alternatively, manifest files at ```srsRAN``` and the configuration files ```srsRAN/configmap.yaml``` may need to be changed
for other 5G core deployments.
+ UHD (USRP Hardware Driver™): please refer to the [Deployment](#deployment) section.


# Deployment

All you need to do is to run the ```install.sh``` script. This will create a midhaul bridge for F1 interface as an ovs bridge. Since the open source RAN softare is not mature enough as of now, 
deploying F1 interface with Kubernetes primiteves like Service was more complicated, and we resorted to using ovs as a workaround. Also, fronthaul is created as an ovs bridge 
named ```fronthaul-br```.  Two ports are added to ```fronthaul-br```, one connecting the bridge to the USRP interface on the host and the other to an interface in the DU pod. 
This enables the `uhd_fine_devices` to find the USRP inside the Kubernetes pod, without being attached to host's network. The installation script using 
`uhd_find_devices` to find the USRP interface, hence, UHD is needed before running the script.

Please refer to [this page](https://files.ettus.com/manual/page_install.html) for UHD installation. Alternatively, you can install it the following packages:

```bash
$ sudo apt-get install libuhd-dev uhd-host
```
## Usage

```bash
# Run the installation script
$ sudo ./install.sh

# Uninstall the created bridges and remove the pods from the cluster
$ sudo ./uninstall.sh
```
