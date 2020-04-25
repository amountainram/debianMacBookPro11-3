#!/bin/bash
#

print_list() {
		echo -e "\n"
		cat $FILE_CT | { while read -r line ;
		do
				the_number=$( echo $line | awk '{print $1}' )
				the_tick=$( echo $line | awk '{print $2}' )
				the_name=$( echo $line | awk '{print $3}' )
				if [[ $the_tick -eq 1 ]] ; 
				then echo -e "[\e[92m\xE2\x9C\x94\e[0m]\t$the_number\t$the_name" ;
				else echo -e "[\e[91m\xE2\x9C\x97\e[0m]\t$the_number\t$the_name" ;
				fi
		done
		}
		echo -e "\n"
}

FILE_CT=$tmp_dir/modules.tmp.conf
if [[ -f "$FILE_CT" ]] ; then rm $FILE_CT ; fi

sudo -u $un touch $FILE_CT

counter=0
find $modules_dir -type f -iname "*.sh" | { while read -r line ;
do
		echo -e "$counter\t1\t$(basename $line)\t$(sed -n '2p' $line)" >> $FILE_CT ;
		(( counter++ ))
done }

		print_list
		#query to user
		#check valid query
