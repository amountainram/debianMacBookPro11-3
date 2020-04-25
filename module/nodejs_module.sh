#!/bin/bash
#
# here we handle nodejs, npm and react
#
# we want to install the latest LTS v12.x
curl -sL https://deb.nodesource.com/setup_12.x | bash -
check_install $un nodejs
check_install $un npm
sudo -u $un npm i -g create-react-app
#
# further information at:
# https://github.com/nodesource/distributions
