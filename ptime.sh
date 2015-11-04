#!/bin/bash
ppid="$(ps -ef | grep 'paycoind' | grep -v grep | awk '{print $2}')"
ptime="$(ps -p $ppid -o etime=)"
"python WebInterface.py $ptime"
exit 0
