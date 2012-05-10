#!/bin/sh
bot=

n=`ps x |grep ruby|grep ngskbot|wc -l`

if [ $n -eq 0 ]; then
	ruby ${bot}
fi

