#!/bin/bash
ppid="$(ps -ef | grep 'paycoind' | grep -v grep | awk '{print $2}')"
if [ $ppid -gt 0 ]
then
ppid=Yes
else
ppid=No
fi
#ptime="$(ps -p $ppid -o etime=)"
#echo $ppid
