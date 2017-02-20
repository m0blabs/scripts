#!/bin/bash
# PwnerRank - CTF
# Task: Programming/Calculator
# By Kingm0b_

function max()
{
	echo $1 | tr ' ' '\n' | sort -n | tail -1
}

function min()
{
	echo $1 | tr ' ' '\n' | sort -n | head -1
}

function sum()
{
	SUM=$(echo $1 | sed 's; ; + ;g')

	echo "$SUM" | bc
}

function avg()
{
	COUNT=$(echo $1 | tr ' ' '\n' | sort -n | wc -l)
	SUM=$(echo $1 | sed 's; ; + ;g')

	echo "scale=8; ($SUM) / $COUNT" | bc
}

echo -e " PwnerRank - CTF\n Task: Calculator\n"

HOST="92.222.90.84"
PORT="5003"

exec 3<>/dev/tcp/${HOST}/${PORT}

while true; do
	read NUMBERS <&3
	MESSAGE=$(timeout 10 cat <&3)

	echo $NUMBERS
	echo -n $MESSAGE

	echo "$NUMBERS" | grep -i wrong &> /dev/null
	if [[ $? -eq 0 ]]; then
		echo " [-] Wrong answer!"
		break
	fi

	MAX=$(echo $MESSAGE | grep max &> /dev/null; echo $?)
	MIN=$(echo $MESSAGE | grep min &> /dev/null; echo $?)
	SUM=$(echo $MESSAGE | grep sum &> /dev/null; echo $?)
	AVG=$(echo $MESSAGE | grep avg &> /dev/null; echo $?)

	if [ $MAX -eq 0 ]; then
		MAX=$(max "$NUMBERS")
		echo -en " $MAX\n\n"
		echo "$MAX" >&3
	elif [ $MIN -eq 0 ]; then
		MIN=$(min "$NUMBERS")
		echo -en " $MIN\n\n"
		echo $MIN >&3
	elif [ $AVG -eq 0 ]; then
		AVG=$(avg "$NUMBERS")
		echo -en " $AVG\n\n"
		echo $AVG >&3
	elif [ $SUM -eq 0]; then
		SUM=$(sum "$NUMBERS")
		echo -en " $SUM\n\n"
		echo $SUM >&3
	else
		echo " [+] FLAG? $MESSAGE"
		break
	fi
done

exec 3>&-
exit $?
