#!/bin/sh
bot=""
log_file=""

n=`ps x |grep ruby|grep ngskbot|wc -l`

if [ $n -eq 0 ]; then
	nohup ruby ${bot} > log_file &
fi

