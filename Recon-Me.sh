#!/usr/bin/env bash

#name_IPs_Me=ip addr show | grep 'inet ' | awk '{print $2}'

#IPs=$(ip addr show | grep 'inet ' | awk '{print $2}')
#MACs=$(ip addr show | grep 'ether ' | awk '{print $2}')
readarray -t Intf < <(ip addr show | grep '^[0-9]: ' | awk '{print $2}' | cut -d ':' -f1) 
readarray -t IPs < <(ip addr show | grep 'inet ' | awk '{print $2}')
readarray -t MACs < <(ip addr show | grep 'ether ' | awk '{print $2}')



function list_allArrays() {	# Display Intf + Ips + MACs
	
	for ((i = 0; i <${#Intf[@]}; i++)); do # Loop the Intf Array for length - Display all 3
		echo $i - ${Intf[i]} - ${MACs[i]} - ${IPs[i]}
	done
}

function scan_SinInt() {	# 1 - n_option string validation + input validation for array i.e. Check if array[weewoo] - returns index 0 by def (odd) - OS Detection code included 
	echo "Singular Interface"

	echo "Here are your options:"
	list_allArrays
	read n_option

	#echo $n_option - return right output so assignment of array may be incorrect look below
	#considering do while - no definative loop length known
	
	#Test return of length Array_Intf
	echo "intf length" ${#Intf[@]} 

	#Validation not complete in do while - will be handled before - assume n_options[weewoo] returns index 0 by def

	while [[ $n_option -ge 0 && $n_option -lt ${#Intf[@]} ]]; do	#check while n_option in range of length > 0 
		echo "nmap ${IPs[$n_option]}"	#nmap command being displayed
		nmap ${IPs[$n_option]}	#nmap command being run

		#	This is where the OS Detection will go - for loop here with index
		echo "Would you like to proceed with OS Detection(ROOT Access Required"
		echo "Type y - yes | n - no :"
		read q_OS

		#nmap print def to 127 loopback - def addr
		local upper_OS="${q_OS^^}"
		if [[ "$upper_OS" = "Y" ]]; then
			echo "OS Detection --- "${IPs[$n_option]}
			sudo nmap ${IPs[$n_option]} -O
		elif [[ "$upper_OS" = "N" ]]; then
			echo "Undertood ... Halted OS Detection"
			q_specific_ip
		else
			echo "This Input was invalid"
			q_specific_ip
		fi

		#	command to logically match -
		list_allArrays
		read n_option
	done 


} 

function scan_AllInt() {	# All Intf before nmap lists name + MACs + IPs 
	echo "Multiple Interfaces"

	echo "All the following Interfaces will be Scanned"
	echo "OPTION - INTERFACE - MAC Addr - IP Addr"	# Formatting
	echo ""		# Formatting
	list_allArrays

	for ((i = 0; i <${#IPs[@]}; i++)); do
		echo "OPTION :" $i
		echo "Interface :" ${Intf[i]}
		echo "MAC Address :" ${MACs[i]}
		echo "Nmap Starting :" ${IPs[i]}
		nmap ${IPs[$i]}
		echo "Host "$i" Complete"
		echo "######################################"

	done
}


function q_specific_ip() {	#Question if ! n or y; GoodBye
	echo "Would you like to scan all your interfaces(y OR n): "
	read broad_scan
	local upper_bs="${broad_scan^^}"	#I hope you appreciate the humor (:

	echo $upper_bs	
	if [[ "$upper_bs" = "Y" ]]; then
		echo "Scan of all interfaces is underway!"
		scan_AllInt

		check_OSdetection	#Requires root (will prompt + run command)
	elif [[ "$upper_bs" = "N" ]]; then
		echo "Scan of a specific Interface is underway"
		scan_SinInt
	else
		echo "Goodbye! (1)"
		exit
	fi
} 


q_specific_ip


echo ${IPs[0]}
for ((i = 0; i <${#IPs[@]}; i++)); do
	echo ${IPs[i]}+"$i"
done       

#ip addr show | grep 'ether ' | awk  '{print $2}'
