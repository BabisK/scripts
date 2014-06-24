# /etc/profile.d/complete-hosts.sh
# Put the script in the folder above and start a new session
# It will automatically retrieve any hosts defined in /etc/ssh_config,
# /etc/ssh/ssh_config, ~/.ssh/config, /etc/ssh_known_hosts, /etc/ssh/ssh_known_hosts,
# ~/.ssh/known_hosts and /etc/hosts and provide them for autocomplete
# in commands ssh, scp, telnet and host
# Autocomplete Hostnames for SSH etc.
# by Jean-Sebastien Morisset (http://surniaulula.com/)
# case insensitive by Babis Kaidos
_complete_hosts () {
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	host_list=`{ 
		for c in /etc/ssh_config /etc/ssh/ssh_config ~/.ssh/config
		do [ -r $c ] && sed -n -e 's/^Host[[:space:]]//pI' -e 's/^[[:space:]]*HostName[[:space:]]//pI' $c
		done
		for k in /etc/ssh_known_hosts /etc/ssh/ssh_known_hosts ~/.ssh/known_hosts
		do [ -r $k ] && egrep -v '^[#\[]' $k|cut -f 1 -d ' '|sed -e 's/[,:].*//gI'
		done
		sed -n -e 's/^[0-9][0-9\.]*//pI' /etc/hosts; }|tr ' ' '\n'|grep -v '*'`
	COMPREPLY=( $(compgen -W "${host_list}" -- $cur))
	return 0
}
complete -F _complete_hosts ssh
complete -F _complete_hosts scp
complete -F _complete_hosts telnet
complete -F _complete_hosts host