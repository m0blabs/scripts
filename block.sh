#!/bin/bash

#	FORMATO DO ARQUIVO 'REDES_LOCAIS':
#	<INTERFACE>	<NET>
#	eth0		192.168.1.0/24
#

PATH=/sbin/:/usr/sbin/
REDES_LOCAIS=redes
FACEBOOK_FILE=facebook-list.txt

echo "  Executando script para bloqueio de sites..."

sysctl -q -w net.ipv4.ip_forward=1

iptables -t filter -P FORWARD ACCEPT
iptables -t filter -F
iptables -t filter -X
iptables -N SITES_BLOQUEADOS

# Popula chain "SITES_BLOQUEADOS" com a lista de ranges do Facebook
while read DESTINO
do
	if [[ ! "$DESTINO" =~ ^# && ! "$DESTINO" =~ ^$ ]]; then
		iptables -t filter -A SITES_BLOQUEADOS -d $DESTINO -j REJECT
	fi
done < $FACEBOOK_FILE

# Função para aplicação da chain "SITES_BLOQUEADOS" para a redes internas
function bloquear() {
	while read INTERFACE ORIGEM
	do
		if [[ ! "$ORIGEM" =~ ^# && ! "$ORIGEM" =~ ^$ ]]; then
			iptables -t filter -A FORWARD -i $INTERFACE -s $ORIGEM -j SITES_BLOQUEADOS
		fi
	done < $1
}

# Chama função 'bloquear' para ler arquivo com as interfaces e redes definidas
bloquear $REDES_LOCAIS

