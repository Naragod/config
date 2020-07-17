#!/bin/bash

echo "Installing dependencies";

# install git
echo "****************** Installing git ******************";
sudo apt install -y git;
# install vim
echo "****************** Installing vim ******************";
sudo apt install -y vim;
# install node;
echo "****************** Installing node ******************";
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs;

# install vscode
# repository and key can also be installed manually with the following
echo "****************** Installing vscode ******************";
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

# update the package cache and install the package
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install code; # or code-insiders


# install l2tp vpn tunnel. Might now always be needed
# sudo apt-get install network-manager-l2tp-gnome;


