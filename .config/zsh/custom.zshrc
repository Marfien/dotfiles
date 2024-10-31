#!/bin/zsh

ssh-node() {
   if [ -z "$1" ]; then
     echo "Usage: ssh-node <node-name>"
     return 1
   fi

   ssh -i ~/.ssh/id_conf_mgmt conf-mgmt@$1
}
