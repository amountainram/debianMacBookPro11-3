#!/bin/bash
#
# install python
# configure powerline
#

apt update

check_install $un python
check_install $un python-pip
check_install $un python3
check_install $un python3-pip

#
# upgrade pip, pip3 
# install python modules:
#	* powerline-status
#	* powerline-gitstatus
#	* virtualenv
#	* ipython
#
sudo -u $un python -m pip install --user --upgrade pip
sudo -u $un python3 -m pip install --user --upgrade pip
sudo -u $un python3 -m pip install --user powerline-status powerline-gitstatus virtualenv ipython
#
# Powerline configuration
#
# impose sourcing of .bash_powerline
# into .bashrc
#
FILE=$uhome/.bashrc
if [[ ! -f $FILE ]] 
then 
	sudo -u $un touch $FILE
fi
echo -e "if [[ -f \"~/$bash_p_name\" ]] \nthen\n\t. ~/$bash_p_name\nfi" >> $FILE
#
# write .bash_powerline 
# with powerline configuration
#
bash_p_name=.bash_powerline
path_to_powerline=$( sudo -u $un python3 -m pip show powerline-status | grep Location | awk '{print $2}' )
path_to_powerline_daemon=$( dirname $(find $uhome -name powerline-daemon) )
FILE=$uhome/$bash_p_name
if [[ ! -f $FILE ]] 
then 
	sudo -u $un touch $FILE
fi
echo "export PATH=\$PATH:$path_to_powerline_daemon" >> $uhome/$bash_p_name
echo "powerline-daemon -q" >> $uhome/$bash_p_name
echo -e "POWERLINE_BASH_CONTINUATION=1\nPOWERLINE_BASH_SELECT=1" >> $uhome/$bash_p_name
echo ". $path_to_powerline/powerline/bindings/bash/powerline.sh" >> $uhome/$bash_p_name
