#!/bin/bash
#
# module init
#
if [[ ! -d "$logs_dir" ]]
then 
	su $(logname) -c "mkdir -p $logs_dir"
fi
if [[ -f "$logs_dir/$log_file_name" ]]
then
	new_run
	info "Logs are written at $logs_dir/$log_file_name"
else
	su $(logname) -c "touch $logs_dir/$log_file_name"
	new_run
	success "Log file successfully created at $logs_dir/$log_file_name"
	info "Logs are written at $logs_dir/$log_file_name"
fi

if [[ ! -d "$source_dir" ]] 
then 
	error "Source directory has been removed. Cannot continue!"
	exit 1
fi
