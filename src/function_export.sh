#!/bin/bash
#
new_run_message="Starting script"

remove_logs() { rm -rf $logs_dir/* 2>/dev/null ; exit 0 ; }
help_message() { echo "to do"  ; exit 0 ; }
user_data() { echo "Username: $USER" ; echo "    EUID: $EUID" ; }
timestamp() { date "+%F %T" ; }
decho() { echo -e "$1" | tee -a "$logs_dir/$log_file_name" ; }	
# standardize log output
info() { 
	echo -e "[\e[93minfo\e[0m] $(timestamp) : $1" 1>&1 ;
	echo "[info] $(timestamp) : $1" >> $logs_dir/$log_file_name ;
}
new_run() { info "$new_run_message" 1>&1 ; }
error() { 
	echo -e "[\e[91merror\e[0m] $(timestamp) : $1" 1>&2 ; 
	echo "[error] $(timestamp) : $1" >> $logs_dir/$log_file_name ;
}
warn() { 
	echo -e "[\e[93mwarn\e[0m] $(timestamp) : $1" 1>&2 ; 
	echo "[warn] $(timestamp) : $1" >> $logs_dir/$log_file_name ; 
}
success() { 
	echo -e "[\e[92msuccess\e[0m] $(timestamp) : $1" 1>&1 ; 
	echo "[success] $(timestamp) : $1" >> $logs_dir/$log_file_name ; 
}
gecho() { echo -e "[\e[93mwarn\e[0m] $(timestamp) : $1" 1>&2 ; } 
module_done() { 
	echo -e "\e[1m===>\e[0m [\e[92m\xE2\x9C\x94\e[0m] $1 module correctly executed." 1>&1 ;
	echo -e "===> [OK] $1 module correctly executed." >> $logs_dir/$log_file_name ; 
}

# standard check if package then install
# > check_install <user> <package>
check_install() { 
		sudo -u $1 dpkg -s $2 ; 
		if [[ $? -ne 0 ]] ; 
		then 
				apt-get --yes install $2 ;
			   	if [[ $? -eq 0 ]] ; then success "Package $2 installed." ; fi
		else
				info "Package $2 is already installed." ;
		fi 
}

export -f user_data timestamp decho info error warn 
export -f success gecho new_run module_done check_install
