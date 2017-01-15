#!/bin/sh
#
# script to update AC server
# usage:
# ./start.sh <user> <password>
# <user> Steam user name.
# <password> Steam user name's password.

user="$1"
pw="$2"

~/Steam/steamcmd.sh +login "$user" "$pw" +@sSteamCmdForcePlatformType windows +app_update 302550 +quit
