#!/usr/bin/env bash

install_vagrant_rhel()
{
  echo "we are in install_vagrant_rhel function"
  #sudo yum install -y yum-utils
  #sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
  #sudo yum install -y vagrant
}

if [[ -f /etc/os-release ]]
then
  . /etc/os-release
else
  echo "Error1: /etc/os-release not found"
  exit 1
fi

case $ID in
     "rhel")
        echo "we are in case rhel"
        install_vagrant_rhel
        ;;
     *) echo "$ID is not yet supported";;
