
BASHTON := ssh console-server 

PLAYBOOK := git-latest.yml
DEBUG := False

hex-key:
	$(BASHTON) "ssh-keygen -f ~/.ssh/netlab.pub -e -m PEM | xxd -p | tr -d '\n'"
ex-config:
	$(BASHTON) "ansible-config init --disabled > example.cfg"
cat-config:
	$(BASHTON) "cat example.cfg"

run-play:
	$(BASHTON) "cd ./lab_network_infra/ansible && ANSIBLE_DEBUG=$(DEBUG) ansible-playbook playbooks/$(PLAYBOOK)"

show-config:
	$(BASHTON) "cd ./lab_network_infra/ansible && ansible R1 -i inventory.yaml -m ios_command -a \"commands='show version'\" "

.PHONY: ex-config cat-config run-play show-config
