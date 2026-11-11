#!/bin/bash
set -e

REPO_URL="https://github.com/raulcs16/lab_network_infra.git"
TARGET_DIR="/home/ansible/repo"
# Replace this with your actual SSH public key from your management machine
CONTROL_NODE_PUBKEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCsP1wAUU8xxsX22EsnnwdPrCBqYPICyYIhR31vbysEfBH4DRTl79hJdgO6qo7UBrUrGeLoFBRRAN+UmTuIP1azBcJTVbjRyDrajnzkeTMzfVLb8IkEvhdpxUjClvn65P73/d9g1Gwyj3NikJhzDMVrEYz1XWu40YE2oZ61UzAJerS0aK6k7iVjdLsa1iyiQgFAZKMRUxk0Yg1m74xC+u2lkoYKlT1z1MYduZYV23uJUka79xSTi1KbF7iCyzeHEBEk6xs7oWy2xSRXzzKGkEqtOMxXmf9j4mKIm6Uc8U5I3hOyKdzLBrqrbjjrG2cLtd+8Mj5MFRZTLAXUWaw0VVKV4BWgBPZAKE8D5W+nBrJp5jHNcJFcUPrmWocquGmOkMNeR4QXvpyyyC5ILsvZXXF9p7ydohheMJyZxMcVZSOGl7KNxNoAZ2kbQShRa0AhhUmUO2KxO1KKrL/C1WA4+jjM9siTEov24n93OMRa0JcqB4tuCVbyAvuJQAUQU8ZhoWp/LhoUR2zBxOdGquujJTGIVGZxc/zD3QvHSVOF6D9DpeiWCsbBHYTKvRurwUYda655WquzIxJdClODCN8jCAaL//C50THRH3XOpZc/oPj5htB6emHFkGDhYog0aBLF6e6He7q5cIUxR9VfF67h+zapBlkGt3FJT9GUfuvwO2K2+Q== home@Mac-mini.local"

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
sudo apt install -y ansible git

echo "[+] Setting up SSH access for ansible user..."
sudo mkdir -p /home/ansible/.ssh
echo "$CONTROL_NODE_PUBKEY" | sudo tee /home/ansible/.ssh/authorized_keys > /dev/null
sudo chmod 700 /home/ansible/.ssh
sudo chmod 600 /home/ansible/.ssh/authorized_keys
sudo chown -R ansible:ansible /home/ansible/.ssh

echo "[+] Cloning repository into ansible user's home directory..."
if [ -d "$TARGET_DIR" ]; then
    sudo rm -rf "$TARGET_DIR"
fi
sudo git clone "$REPO_URL" "$TARGET_DIR"
sudo chown -R ansible:ansible "$TARGET_DIR"

echo "[+] Initializing Ansible log file..."
sudo touch /var/log/ansible.log
sudo chown ansible:ansible /var/log/ansible.log
sudo chmod 664 /var/log/ansible.log

echo "[+] Bootstrap complete! You can now switch to the ansible user or run playbooks."