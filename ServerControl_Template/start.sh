/bin/bash
#
# script to start AC server, minorating and stracker
# usage:
# ./start.sh <idx> [<module>]
# <idx> the server instance , e.g. 2017_SRU_ACL
# <module> optional specify the module to be started (if omitted all modules are started). Must be one of AC, MR or ST.

IDX="$1"
M="$2"

CFG="cfg"

if test -z "$1" -o '!' -d "$cfg/$IDX"; then
  echo "Index of server missing or invalid"
else
  ./stop.sh "$1" "$2"

  if test -z "$M" -o "$M" = "ST"; then
    # stracker
    echo "Starting stracker $IDX"
    cd stracker
    screen -S stracker-$IDX -d -m ./stracker_linux_x86/stracker --stracker_ini=../"$cfg/$IDX"/stracker.ini
    cd ..
  fi
  if test -z "$M" -o "$M" = "MR"; then
    # minorating
    echo "Starting minorating $IDX"
    rm "$cfg/$IDX"/*.exe "$cfg/$IDX"/*.dll "$cfg/$IDX"/*.pdb
    ln minorating/*.exe minorating/*.pdb minorating/*.dll "$cfg/$IDX"
    cd "$cfg/$IDX"
    test -f screenlog.0 && rm screenlog.0
    mv ../logs/minorating$IDX.log screenlog.0
    echo "-------------------------------------" >> screenlog.0
    echo "RESTART" >> screenlog.0
    echo "-------------------------------------" >> screenlog.0
    screen -S minorating-$IDX -d -m -L mono MinoRatingPlugin.exe
    sleep 2
    ln screenlog.0 ../logs/minorating$IDX.log
    cd ..
  fi

  if test -z "$M" -o "$M" = "AC"; then
    # ac server
    echo "Starting AC server $IDX"
    cd acserver
    test -d wd$IDX || mkdir wd$IDX
    cd wd$IDX
    ln -sf ../content .
    ln -sf ../system .
    test -d results || mkdir results
    chmod 0755 results
    test -f screenlog.0 && rm screenlog.0
    mv ../../logs/acserver$IDX.log screenlog.0
    echo "-------------------------------------" >> screenlog.0
    echo "RESTART" >> screenlog.0
    echo "-------------------------------------" >> screenlog.0
    ionice -n 0 screen -S acserver-$IDX -d -m -L sh -c "../acServer -c=../../"$cfg/$IDX"/server_cfg.ini -e=../../"$cfg/$IDX"/entry_list.ini | ts \\\'{%F %T}:'"
    sleep 2
    ln screenlog.0 ../../logs/acserver$IDX.log
    cd ..
  fi

  sleep 2

  screen -ls
fi
