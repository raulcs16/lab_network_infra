
BASHTON := ssh console-server 

PLAYBOOK := git-latest.yml
DEBUG := False

cat-key:
	$(BASHTON) "cat ~/.ssh/netlab.pub"
hex-key:
	$(BASHTON) 'ssh-keygen -f ~/.ssh/netlab.pub -e -m RFC4716 | grep -v "^----" | grep -v "^Comment:" | xxd -p' 
hold:
	| grep -v "^----" | tr -d '\n' | xxd -p | fold -w 64'
ex-config:
	$(BASHTON) "ansible-config init --disabled > example.cfg"
cat-config:
	$(BASHTON) "cat example.cfg"

run-play:
	$(BASHTON) "cd ./lab_network_infra/ansible && ANSIBLE_DEBUG=$(DEBUG) ansible-playbook playbooks/$(PLAYBOOK)"

show-config:
	$(BASHTON) "cd ./lab_network_infra/ansible && ansible R1 -m ios_command -a \"commands='show version'\" "

.PHONY: ex-config cat-config run-play show-config
