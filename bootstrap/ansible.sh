#!/bin/bash
set -e

echo "[+] Creating dedicated ansible user..."
if ! id "ansible" &>/dev/null; then
    sudo useradd -m -s /bin/bash ansible
fi

echo "[+] Granting passwordless sudo to ansible user..."
echo "ansible ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansible > /dev/null
sudo chmod 0440 /etc/sudoers.d/ansible

echo "[+] Installing Ansible and Git..."
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt update
sudo apt install -y ansible

echo "[+] Initializing Ansible log file..."
sudo touch /var/log/ansible.log
sudo chown ansible:ansible /var/log/ansible.log
sudo chmod 664 /var/log/ansible.log
echo "[+] Bootstrap complete! Ready to clone repo and execute playbooks."