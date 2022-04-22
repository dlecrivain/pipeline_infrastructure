#!/bin/sh

script_verbose="no"
script_step_pause="no"
prerequisites_wsl="no"

while [ $# -ge 1 ]; do
case "$1" in
      -v)
        script_verbose="yes"
        shift
        ;;
      -t)
        script_step_pause="yes"
        shift
        ;;
      -vt|-tv)
        script_verbose="yes"
        script_step_pause="yes"
        shift
        ;;
      --wsl)
        prerequisites_wsl="yes"
        shift
        ;;
      *)
        echo "unknown parameter '$1'." 1>&2
        break
        exit 1
        ;;
esac
done

echo "la valeur de script_verbose est à ${script_verbose}, script_step_pause à ${script_step_pause}, prerequisites_wsl à ${prerequisites_wsl}"

verbose()
{
if [ $script_verbose = "yes" ]; then
        echo $1
fi
}

step_pause()
{
if [ $script_step_pause = "yes" ]; then
        echo "press a key to continue"
        read a
fi
}
install_vagrant_rhel()
{
  verbose "we are in install_vagrant_rhel function"
  if which vagrant >/dev/null
  then
    echo "vagrant already installed"
    step_pause
  else  
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
    sudo yum install -y vagrant
    verbose "we finished install_vagrant_rhel function"
    step_pause
  fi 
}

install_vagrant_debian()
{
  verbose "we are in install_vagrant_debian function"
  step_pause
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  sudo apt-get update && sudo apt-get install vagrant
    if [ $prerequisites_wsl = "yes" ]; then
      wsl_bashrc_param1=$(grep -c "VAGRANT_WSL_ENABLE_WINDOWS_ACCESS" ~/.bashrc)
      wsl_bashrc_param2=$(grep -c "PATH:/mnt/c/Program Files/Oracle/VirtualBox" ~/.bashrc)
         if [ $wsl_bashrc_param1 -eq "0" ]; then
           echo 'export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"' >> ~/.bashrc
         fi
         
         if [ $wsl_bashrc_param2 -eq "0" ]; then
           echo 'export PATH="$PATH:/mnt/c/Program Files/Oracle/VirtualBox"' >> ~/.bashrc
         fi
          source ~/.bashrc
          vagrant plugin install virtualbox_WSL2
    fi
  verbose "we finished install_vagrant_debian function"
  step_pause
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
        verbose "we are in case rhel"
        step_pause
        install_vagrant_rhel
        verbose "we finished case rhel"
        step_pause
        ;;
     "debian"|"ubuntu")
        verbose "we are in case debian"
        step_pause
        install_vagrant_debian
        verbose "we finished case debian"
        step_pause
        ;;
     *) echo "$ID is not yet supported";;
esac 
