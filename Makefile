all: usage

usage:

up: ssh-keyclean machine-up ssh-keyscan ssh-keyreplace

destroy: machine-destroy ssh-keyclean

machine-up:
	vagrant up

machine-destroy:
	vagrant destroy -f

ssh-keyclean:
	ssh-keygen -R '[127.0.0.1]:2222'

ssh-keyreplace:
	scp -i .vagrant/machines/dpdk/virtualbox/private_key -P 2222 ~/.ssh/local/id_ed25519.pub vagrant@127.0.0.1:
	cp ~/.ssh/local/id_ed25519 .vagrant/machines/dpdk/virtualbox/private_key

ssh-keyscan:
	ssh-keyscan -p 2222 127.0.0.1 >> ~/.ssh/known_hosts