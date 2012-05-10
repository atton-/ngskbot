#!/bin/sh
bot=

n=`ps x |grep ruby|grep ngskbot|wc -l`

if [ $n -eq 1 ]; then
	ruby ${bot}
fi

