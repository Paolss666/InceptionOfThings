# InceptionOfThings

This project sets up a Kubernetes cluster using Vagrant and K3s. It includes:

- A controller node (`npaolettS`) configured with K3s in server mode.
- A worker node (`npaolettSW`) configured with K3s in agent mode.

## Prerequisites

- Vagrant installed on your system.
- VirtualBox as the provider for Vagrant.

## How to Use

1. Clone this repository to your local machine.
2. Navigate to the `p1` directory.
3. Run `vagrant up` to start and provision the virtual machines.
4. Access the controller node using `vagrant ssh npaolettS`.
5. Access the worker node using `vagrant ssh npaolettSW`.

## Vagrant Commands

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

## Project Structure

- `Vagrantfile`: Configuration for the virtual machines.
- `scripts/server_setup.sh`: Provisioning script for the controller node.
- `scripts/worker_setup.sh`: Provisioning script for the worker node.

## Notes

- The controller node is assigned the IP `192.168.56.110`.
- The worker node is assigned the IP `192.168.56.111`.
- Ensure that your host machine does not have conflicting IPs in the `192.168.56.x` range.