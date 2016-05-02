#!/bin/bash
vagrant plugin install vagrant-digitalocean
vagrant box add digital_ocean https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box
ssh-keygen -f id_rsa
