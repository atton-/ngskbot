#!/bin/sh
bot=

n=`ps x |grep "ngskbot.rb"|wc -l`

if [ $n -eq 1 ]; then
	ruby ${bot}
fi

