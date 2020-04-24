#!/bin/bash
#

export log_file_name=logs.post-install.txt
export log_shell=logs.shell.txt
export local_dir=$(realpath .)
export app_name=$0
export logs_dir=$local_dir/log
export source_dir=$local_dir/src
export conf_dir=$local_dir/config

remove_logs() { rm -rf $logs_dir/* 2>/dev/null ; exit 0 ; }
help_message() { echo "to do"  ; exit 0 ; }

. $source_dir/function_export.sh

# args handling
# Execute getopt on the arguments passed to this program, identified by the special character $@
PARSED_OPTIONS=$(getopt -q -n "$0"  -o rhm: -l "remove-logs,help,modules:"  -- "$@")
# if wrong args are parsed
if [[ $1 -ne 0 ]]
then 
	gecho "Unknown option. Please use -h, --help, ? for help." ; exit 1 ;
fi

# putting args in an eval set
eval set -- "$PARSED_OPTIONS"
# parsing
while true
do 
	case "$1" in
		-r | --remove-logs ) remove_logs
			shift;;
		-h | --help | ? ) help_message
			shift;;
		-m | --modules ) #We need to collect extra args
			if [[ -n "$2" ]]
			then 
				echo "Argument $2"
			fi
			exit 0
			shift;;
		*) 
			shift
			break;;
	esac
	shift
done

# The shan't be run as root
if [[ "$EUID" -ne "0" ]]
then
	gecho "Please run the script as root."
	exit 1
fi

export un=$(logname)
export uhome=$( su $un -c "echo \$HOME" ) 

source $conf_dir/module.conf.sh

#
# module 00 -- init
# 	this contains:
#		* the root check
#		* creation/check of log files
#
. $source_dir/init.sh
module_done "function_export"

#
# module 01 -- wireless_driver
# 	this contains:
#		* 
#
#. $source_dir/wireless_driver.sh
module_done "wireless_driver"

#
# module 02 -- python_install
# 	this contains:
#		* python pip and packages install
#		* configuration of powerline
#
#. $source_dir/python_install.sh
module_done "python_install"

#
# module 03 -- java_install
# 	this contains:
#
#. $source_dir/java_install.sh
module_done "java_install"

#
# module n -- nodejs_module
# 	this contains:
#		*
#
#. $source_dir/nodejs_module.sh
module_done "nodejs_module"

#
# module n+1 -- postgresql_install
# 	this contains:
#		* adding postgreSQL repos
#		* installing client/server
#
#. $source_dir/postgresql_install.sh
module_done "postgresql_install"
success "Test"
