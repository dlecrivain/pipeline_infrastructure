#!/bin/bash

script_verbose="no"
script_step_pause="no"

while [ $# -ge 1 ]; do
case "$1" in
      -v)
        script_verbose="yes"
        echo "cas -v"
        shift
        ;;
      -t)
        script_step_pause="yes"
        echo "cas -t"
        shift
        ;;
      -vt|-tv)
        script_verbose="yes"
        script_step_pause="yes"
        echo "cas -vt ou -tv"
        shift
        ;;
      *)
        echo "unknown parameter '$1'." 1>&2
        break
        exit 1
        ;;
esac
done

echo "la valeur de script_verbose est à ${script_verbose}, et script_step_pause à ${script_step_pause}"

verbose()
{
if [ $script_verbose == "yes" ]; then
        echo $1
fi
}

install_vagrant_rhel()
{
  verbose "we are in install_vagrant_rhel function"
  #sudo yum install -y yum-utils
  #sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
  #sudo yum install -y vagrant
}

install_vagrant_debian()
{
  verbose "we are in install_vagrant_debian function"
  #curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  #sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  #sudo apt-get update && sudo apt-get install vagrant
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
     "debian"|"ubuntu")
        echo "we are in case debian"
        install_vagrant_debian
        ;;
     *) echo "$ID is not yet supported";;
esac 
