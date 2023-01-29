#!/bin/bash

architecture=$(uname -a)
cpu_physical=$(cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l) 
cpu_virtual=$(cat /proc/cpuinfo | grep "processor" | uniq | wc -l )
total_memory=$(free -m | grep "Mem:" | awk '{print $2}' )
used_memory=$(free -m | grep "Mem:" | awk '{print $3}' )
used_percentage_memory=$(free -m | grep "Mem:" | awk '{printf("%.2f"), $3*100/$2}')
total_disk=$(df -BG | grep "^/dev/" | awk '{drivers_total += $2} END {print drivers_total}')
used_disk=$(df -BM | grep "^/dev/" | awk '{drivers_usage += $3} END {print drivers_usage}')
used_percentage_disk=$(df | grep "^/dev/" | awk '{drivers_total += $2; drivers_usage += $3} END {printf("%d"), (drivers_usage * 100)/drivers_total}')
cpu_load=$(top -bn2 | grep '%Cpu(s):' | cut -c 36-40 | awk '{idle_sum += $1} END {printf("%.1f%%", 100 - (idle_sum/NR)}')
last_boot=$(uptime -s | awk -F ':' '{print $1":"$2}')
lvm_usage=$(if [ $(lsblk | grep "lvm" | awk 'END {print NR}') -ge 1 ]; then echo yes; else echo no; fi)
tcp_connections=$(ss -neopt state established | awk 'END {print NR}')
users_on_server=$(who | awk 'END {print NR}')
network_ip=$(hostname -I | awk '{print $1}')
mac_address=$(ip link show | grep "ether" | awk '{printf $2" "}')
sudo_commands=$(journalctl _COMM=sudo | grep "COMMAND" | awk 'END {print NR}')

wall "	#Architecture: $architecture
	#CPU physical: $cpu_physical
	#vCPU: $cpu_virtual
	#Memory Usage: $used_memory/${total_memory}MB ($used_percentage_memory%)
	#Disk Usage: $used_disk/${total_disk}Gb ($used_percentage_disk%)
	#CPU load: $cpu_load
	#Last boot: $last_boot
	#LVM use: $lvm_usage
	#Connections TCP: $tcp_connections ESTABLISHED
	#User log: $users_on_server
	#Network: IP $network_ip ( $mac_address)
	#Sudo: $sudo_commands cmd"
