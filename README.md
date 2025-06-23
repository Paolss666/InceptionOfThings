# InceptionOfThings

## Part 1

This project sets up a Kubernetes cluster using Vagrant and K3s. It includes:

- A controller node (`galambeyS`) configured with K3s in server mode.
- A worker node (`galambeySW`) configured with K3s in agent mode.

### Prerequisites

- Vagrant installed on your system, if not please run :
```sh
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant
```
- VirtualBox as the provider for Vagrant.


### Vagrant Commands

- **Start the VMs**:  
  ```sh
  vagrant up
  ```

- **Stop the VMs**:  
  ```sh
  vagrant halt
  ```

- **Destroy the VMs**:  
  ```sh
  vagrant destroy
  ```

- **Reprovision the VMs**:  
  ```sh
  vagrant provision
  ```

- **Commmand to check config**: 
```sh
vagrant ssh <machine_name>
sudo kubectl get nodes -o wide
ifconfig eth1
```

### Project Structure

- `Vagrantfile`: Configuration for the virtual machines.
- `scripts/server_setup.sh`: Provisioning script for the controller node.
- `scripts/worker_setup.sh`: Provisioning script for the worker node.

### Notes

- The controller node is assigned the IP `192.168.56.110`.
- The worker node is assigned the IP `192.168.56.111`.
- Ensure that your host machine does not have conflicting IPs in the `192.168.56.x` range.