#!/usr/bin/env bash

#name_IPs_Me=ip addr show | grep 'inet ' | awk '{print $2}'

#IPs=$(ip addr show | grep 'inet ' | awk '{print $2}')
#MACs=$(ip addr show | grep 'ether ' | awk '{print $2}')
readarray -t IPs < <(ip addr show | grep 'inet ' | awk '{print $2}')
readarray -t MACs < <(ip addr show | grep 'ether ' | awk '{print $2}')


echo ${IPs[0]}
for ((i = 0; i <  ${#IPs}-1; i++)); do
	echo ${IPs[i]}+"$i"
done       

#ip addr show | grep 'ether ' | awk  '{print $2}'
