#!/usr/bin/env bash

#name_IPs_Me=ip addr show | grep 'inet ' | awk '{print $2}'

#IPs=$(ip addr show | grep 'inet ' | awk '{print $2}')
#MACs=$(ip addr show | grep 'ether ' | awk '{print $2}')
readarray -t Intf < <(ip addr show | grep '^[0-9]: ' | awk '{print $2}' | cut -d ':' -f1) 
readarray -t IPs < <(ip addr show | grep 'inet ' | awk '{print $2}')
readarray -t MACs < <(ip addr show | grep 'ether ' | awk '{print $2}')


function list_allArrays() {
	
	for ((i = 0; i <${#Intf[@]}; i++)); do # Loop the Intf Array for length - Display all 3
		echo $i - ${Intf[i]} - ${MACs[i]} - ${IPs[i]}
	done
}

function scan_SinInt() {
	echo "Singular Interface"

	echo "Here are your options:"
	list_allArrays

} 

function scan_AllInt() {
	echo "Multiple Interfaces"

	echo "All the following Interfaces will be Scanned"
	list_allArrays

}

function q_specific_ip() {	#Question if ! n or y; GoodBye
	echo "Would you like to scan all your interfaces(y OR n): "
	read broad_scan
	local upper_bs="${broad_scan^^}"	#I hope you appreciate the humor (:

	echo $upper_bs	
	if [[ "$upper_bs" = "Y" ]]; then
		echo "Scan of all interfaces is underway!"
		scan_AllInt
	elif [[ "$upper_bs" = "N" ]]; then
		echo "Scan of a specific Interface is underway"
		scan_SinInt
	else
		echo "Goodbye! (1)"
		exit
	fi
} 


q_specific_ip
echo ${Intf[0]}

echo ${IPs[0]}
for ((i = 0; i <${#IPs[@]}; i++)); do
	echo ${IPs[i]}+"$i"
done       

#ip addr show | grep 'ether ' | awk  '{print $2}'
