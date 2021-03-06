#!/bin/sh
# Copyright (c) 2010 TeamSpeak Systems GmbH
# All rights reserved

COMMANDLINE_PARAMETERS="${2}" #add any command line parameters you want to pass here
D1=$(readlink -f "$0")
BINARYPATH="$(dirname "${D1}")"
cd "${BINARYPATH}"
LIBRARYPATH="$(pwd)"
BINARYNAME="ts3server"

case "$1" in
	start)
		if [ -e ts3server.pid ]; then
			if ( kill -0 $(cat ts3server.pid) 2> /dev/null ); then
				echo "The server is already running, try restart or stop"
				exit 1
			else
				echo "ts3server.pid found, but no server running. Possibly your previously started server crashed"
				echo "Please view the logfile for details."
				rm ts3server.pid
			fi
		fi
		if [ "${UID}" = "0" ]; then
			echo WARNING ! For security reasons we advise: DO NOT RUN THE SERVER AS GROOT
			c=1
			while [ "$c" -le 10 ]; do
				echo -n "!"
				sleep 1
				c=$(($c+1))
			done
			echo "!"
		fi
		echo "Starting the TeamSpeak 3 server"
		if [ -e "$BINARYNAME" ]; then
			if [ ! -x "$BINARYNAME" ]; then
				echo "${BINARYNAME} is not executable, trying to set it"
				chmod u+x "${BINARYNAME}"
			fi
			if [ -x "$BINARYNAME" ]; then
				export LD_LIBRARY_PATH="${LIBRARYPATH}:${LD_LIBRARY_PATH}"					
				"./${BINARYNAME}" ${COMMANDLINE_PARAMETERS} > /dev/null &
 				PID=$!
				ps -p ${PID} > /dev/null 2>&1
				if [ "$?" -ne "0" ]; then
					echo "TeamSpeak 3 server could not start"
				else
					echo $PID > ts3server.pid
					echo "TeamSpeak 3 server started, for details please view the log file"
				fi
			else
				echo "${BINARNAME} is not exectuable, cannot start TeamSpeak 3 server"
			fi
		else
			echo "Could not find binary, aborting"
			exit 5
		fi
	;;
	stop)
		if [ -e ts3server.pid ]; then
			echo -n "Stopping the TeamSpeak 3 server"
			if ( kill -TERM $(cat ts3server.pid) 2> /dev/null ); then
				c=1
				while [ "$c" -le 300 ]; do
					if ( kill -0 $(cat ts3server.pid) 2> /dev/null ); then
						echo -n "."
						sleep 1
					else
						break
					fi
					c=$(($c+1)) 
				done
			fi
			if ( kill -0 $(cat ts3server.pid) 2> /dev/null ); then
				echo "Server is not shutting down cleanly - killing"
				kill -KILL $(cat ts3server.pid)
			else
				echo "done"
			fi
			rm ts3server.pid
		else
			echo "No server running (ts3server.pid is missing)"
			exit 7
		fi
	;;
	restart)
		$0 stop && $0 start ${COMMANDLINE_PARAMETERS} || exit 1
	;;
	status)
		if [ -e ts3server.pid ]; then
			if ( kill -0 $(cat ts3server.pid) 2> /dev/null ); then
				echo "Server is running"
			else
				echo "Server seems to have died"
			fi
		else
			echo "No server running (ts3server.pid is missing)"
		fi
	;;
	*)
		echo "Usage: ${0} {start|stop|restart|status}"
		exit 2
esac
exit 0

