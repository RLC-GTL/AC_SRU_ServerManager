#!/bin/sh
#
# stops running instances started with start.sh. See start.sh for usage.

IDX="$1"
M="$2"

if test -z "$1"; then
  echo "Supply server index as argument (sarting with 0)"
else
  if test -z "$M" -o "$M" = "AC"; then
    echo "Stopping AC server $IDX"
    screen -X -S acserver-$IDX quit
  fi
  if test -z "$M" -o "$M" = "ST"; then
    echo "Stopping stracker $IDX"
    screen -X -S stracker-$IDX quit
  fi
  if test -z "$M" -o "$M" = "MR"; then
    echo "Stopping minorating $IDX"
    screen -X -S minorating-$IDX quit
  fi
  if test -z "$M" -o "$M" = "MRC"; then
    if test "$IDX" = 0; then
      echo "Stopping minorating cache"
      screen -X -S mr-cache quit
    fi
  fi
  sleep 2
  screen -ls
fi
