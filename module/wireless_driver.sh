#!/bin/bash
#
# module for wireless driver
#
#
# #Preliminary information
# In order to check the hardware configuration, consider using the following commands
# ```bash
# lspci -nn -v | grep <name>
nc_name=$(lspci -nn | grep --ignore-case "network controller")
info "Network controller is identified as:\n\t$nc_name"
lspci -nn | grep --ignore-case "network controller" | grep "BCM4360" >/dev/null
if [[ $? -eq 0 ]]
then 
		info "Network controller will be handled by this module."
# ```
# **lspci** lists every PCI device with its vendor name (-nn option) and with several verbose modes (-v, -vv, -vvv) according to the level of details needed.
# Using some **grep** will help through a keyword to filter. Keywords are Network, PCI bridge, Audio, and so on.
# Beside we may obtain other general infomation about the machine. DMI or SMBIOS is invoked via
# ```bash
# sudo dmidecode -s <keyword>
# ```
# where keywords are *bios-vendor, bios-version, bios-release-date, system-manufacturer*, and so on.
# For instance
# > sudo dmidecode -s system-product-name
# returns
# > MacBookPro11,3 
# #Wireless Network
# MacBookPro11,3 mounts *Broadcom Limited BCM4360 802.11ac Wireless Network Adapter* which is not
# supported by open-source firmware. The appropriate firmware is called *wl* and can be retrieved 
# with third-party software.
# This means that, without a customized debian-installer, it is impossible to do a *netinst*. Of 
# course the *netinst* over a LAN ethernet connection works just fine. Once we installed the 
# system we have to add the Wireless Card firmware.
# We need to check the presence of some apt packages
# ```bash
# sudo apt-get install wireless-tools network-manager-gnome wpasupplicant
# ```
		check_install $un wireless-tools
		check_install $un network-manager-gnome
		check_install $un wpasupplicant
# which, in case of GNOME environment, should all be present.
# We need to add "contrib non-free" to all repos for debian by modifying /etc/apt/sources.list
# and add to each "main" a "main contrib non-free" which allows us to get third-party 
# non-open source software. 
#
		cp /etc/apt/sources.list /etc/apt/sources.list.old.$(date +%s)
		cat /etc/apt/sources.list | grep "deb.debian.org/debian" | while read -r line ;
		do
				the_type=$( echo $line | awk '{print $1}' )
				the_site=$( echo $line | awk '{print $2}' )
				the_distro=$( echo $line | awk '{print $3}' )
				the_main=$( echo $line | awk '{print $4}' )
				the_extra1=$( echo $line | awk '{print $5}' )
				the_extra2=$( echo $line | awk '{print $6}' )
				if [[ "$the_distro" -eq "buster" ]] | [[ "$the_main" -eq "main" ]]
				then 
					if [[ -z "$the_extra1" ]] 
					then 
						add-apt-repository --remove "$line"
						info "Removed '$line' repo from '/etc/apt/sources.list'"
						add-apt-repository "$line contrib non-free"
						info "Added '$line contrib non-free' repo from '/etc/apt/sources.list'"
					fi
				fi
		done
# After a apt-get update and dist-update we can obtain the firmware, 
# remove conflicting firmwares for other chipsets and add the proper module to the kernel:
# ```bash
		apt update
		check_install $un broadcom-sta-dkms
		lsmod | awk '{print $1}' | grep wl >/dev/null
		if [[ $? -eq 0 ]]
		then 
				info "Module 'wl' is already loaded onto the kernel."
		else
				modprobe -r b44 b43 b43legacy ssb brcmsmac bcma
				modprobe wl
		fi
# 
# scan for wi-fi
#
		config_ok=false
		while [[ "$config_ok" -eq "false" ]] ; 
		do
				echo "List of available WiFi connections" ; 
				iwlist scan 2>/dev/null | grep ESSID | awk 'BEGIN { FS = ":" } ; {print $2}' | sed 's/\"//g' | while read -r line ;
				do
						echo "ESSID = $line";
				done
				echo "List of available drivers" ; 
				ip -o link show | awk -F': ' '{print $2}' | while read -r dev ;
				do
						echo "$dev";
				done
				echo "Which connection? :"
				read connection
				echo -n "Password: "
				read -s password
		done

# ```
# The procedures are described at: https://wiki.debian.org/bcm43xx
# Compatibility of hardware is listed at: https://wireless.wiki.kernel.org/en/users/drivers/b43
else 
		warn "No need for this module. Skipping."
fi

