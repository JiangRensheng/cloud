#!/usr/bin/env bash
##
 # Copyright © 2016 by David Alger. All rights reserved
 # 
 # Licensed under the Open Software License 3.0 (OSL-3.0)
 # See included LICENSE file for full text of OSL-3.0
 # 
 # http://davidalger.com/contact/
 ##

set -e

source ./scripts/lib/utils.sh

########################################
:: configuring local ssh
########################################

# create key/pair on node for use as a deploy key
[[ ! -f ~/.ssh/id_rsa ]] && ssh-keygen -N '' -t rsa -f ~/.ssh/id_rsa

# copy authorized_keys to correctly location if we have one to import
if [[ -f /vagrant/etc/ssh/authorized_keys ]]; then
    cp /vagrant/etc/ssh/authorized_keys ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
fi

# setup sshusers group and authorize vagrant ssh user (typically 'vagrant' but on Digital Ocean it's 'root')
groupadd sshusers
usermod -a -G sshusers $(whoami)

# reload ssh daemon since we have a custom config it needs to load
service sshd reload
