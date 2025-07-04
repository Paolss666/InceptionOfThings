# InceptionOfThings

## Prerequisites for Part 1 and Part 2

- Vagrant installed on your system, if not please run :
```sh
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vagrant
```
- VirtualBox as the provider for Vagrant.

## Vagrant Commands for Part 1 and Part 2

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

- **Command to connect in ssh**: 
  ```sh
  vagrant ssh <machine_name>
  ```

## Part 1

This project sets up a Kubernetes cluster using Vagrant and K3s. It includes:

- A controller node (`galambeyS`) configured with K3s in server mode.
- A worker node (`galambeySW`) configured with K3s in agent mode.

### Project Structure

- `Vagrantfile`: Configuration for the virtual machines.
- `scripts/server_init.sh`: Provisioning script for the controller node.
- `scripts/serverWorker_init.sh`: Provisioning script for the worker node.

### Command to check config
```sh
k get nodes -o wide
ifconfig eth1
```

### Notes

- The controller node is assigned the IP `192.168.56.110`.
- The worker node is assigned the IP `192.168.56.111`.
- Ensure that your host machine does not have conflicting IPs in the `192.168.56.x` range.
- k is an alias for sudo kubectl

## Part 2

This project sets up 3 web applications using Vagrant and K3s installed in server mode on a VM `galambeyS`.

If Host:app1.com is precised, it will display app1
If Host:app2.com is precised, it will display app2
Otherwise it will display app3 by default

### Project Structure

- `Vagrantfile`: Configuration for the virtual machines.
- `scripts/server_init.sh`: Provisioning script for the controller node.
- `synced_folder` : Folder containing the shared folders/files between the host machine and the Vagrant VM, including the appXfolder with the yaml files configuring the 3 apps
- k is an alias for sudo kubectl

### Command to check config
- **In the vagrant machine**
  ```sh
  k get nodes -o wide
  k get all -n kube-system
  k get all
  k get ingress
  ```
- **In the vagrant machine or in the host machine**
  ```sh
  curl -H "Host:app1.com" http://192.168.56.110
  curl -H "Host:app2.com" http://192.168.56.110
  curl -H "Host:app3.com" http://192.168.56.110
  curl http://192.168.56.110
  ```
- **In the browser**
  1. Go to the Inspect utils
  2. Select Network tab
  3. Select +
  4. In the Get field put http://192.168.56.110
     In the Headers fields add one : 
     Host with the value app<X>.com
  5. Send
  6. To control the response, select the Response tab 

### Notes

- The controller node is assigned the IP `192.168.56.110`.
- Ensure that your host machine does not have conflicting IPs in the `192.168.56.x` range.