#!/bin/bash

CIPHERS_LIST="/tmp/cipher.list"
WORDLIST="/home/kingm0b_/hotmail.txt"

FILE_ENCRYPTED="/tmp/criptografado"
FILE_DECRYPTED="/tmp/descriptografado"

[[ -f $WORDLIST ]] 		|| { echo "Wordlist não existe!"; exit 1; }
[[ -f $CIPHERS_LIST ]]		|| { echo "Lista de cifras não existe!"; exit 1; }
[[ -f $FILE_ENCRYPTED ]]	|| { echo "Arquivo criptografado fornecido não existe!"; exit 1; }
[[ -f $FILE_DECRYPTED ]] 	&& rm $FILE_DECRYPTED

while read CIPHER; do
	echo " Usando cifra ${CIPHER}..."
	while read PASSWORD; do
		openssl enc "$CIPHER" -d -in "$FILE_ENCRYPTED" -out "$FILE_DECRYPTED" -pass pass:"$PASSWORD" 2> /dev/null

		if [ $? -eq 0 ]; then
			echo " Chave descoberta: $PASSWORD"
			exit 0
		fi

	done < $WORDLIST
done < $CIPHERS_LIST


# openssl enc -h 2>&1 | grep -A60 ^Cipher | tail -39 | paste -s | xargs echo | tr ' ' '\n' > /tmp/cipher.list
