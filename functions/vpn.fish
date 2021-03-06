#!/usr/bin/env fish

function vpn -d 'Interact with ExpressVPN'
	# Check what servers are available, sorted by recommendation.
	set mine "auto  Reconnect to last server"  "none  Disconnect from server"
	set rec  (expressvpn list all 1>| sed -En -e '1,/^---/ d' -e 's/(.*)\s*Y$/\1/p')
	set rest (expressvpn list all 1>| sed -En -e '1,/^---/ d' -e 's/(.*)\s+$/\1/p')
	
	# Select an ExpressVPN server.
	if count $argv > /dev/null
		# Read from command line arguments.
		set server "$argv"
	else
		# Read from interactive selection.
		set server (
			for line in $mine $rec $rest
				echo $line
			end | fzf --prompt='ExpressVPN> '
		) 
	end
	
	# If a choice was made, extract name.
	if [ -n "$server" ]
		set name (echo $server | sed -e 's/\(\S*\).*/\1/')
	else
		return 1
	end
	
	# Connect to the chosen server.
	if [ "$name" = "none" ]
		# Disconnect from current server.
		expressvpn disconnect
	else if [ "$name" = "auto" ]
		# Reconnect to previous server.
		expressvpn disconnect &> /dev/null
		expressvpn connect
		
		# Fix Snap/AppArmor issues.
		if [ -n "$expressvpn_relink" ]
			sudo cp --remove-destination /var/lib/expressvpn/resolv.conf /etc/resolv.conf
		end
	else
		# Connect to a new server.
		echo Disconnecting...
		expressvpn disconnect &> /dev/null
		expressvpn connect $name
		
		# Fix Snap/AppArmor issues.
		if [ -n "$expressvpn_relink" ]
			sudo cp --remove-destination /var/lib/expressvpn/resolv.conf /etc/resolv.conf
		end
	end
end
