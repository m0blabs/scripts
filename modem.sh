#!/bin/env bash
# Um quebra galho para automatizar a reinicilização do TD5130

LOGIN=admin
PASS=admin
IP="192.168.1.1"
COOKIE="/tmp/cookies$$.txt"

echo " *---------------------------------*"
echo " *   REINICIALIZADOR DE MODEMs     *"
echo " *      Technicolor TD5130        *"
echo " *---------------------------------*"
echo ""

echo " Logando no roteador ..."
curl -s --cookie-jar $COOKIE \
        --data "user=$LOGIN" \
        --data "password=$PASS" \
        http://$IP/cgi-bin/basicauth.cgi?index.html > /dev/null

sleep 1

echo " Reinicializando..."
curl -s --cookie $COOKIE \
        --data 'setobject_token=SESSION_CONTRACT_TOKEN_TAG%3D0123456789012345' \
        --data 'setobject_reboot=i1.3.6.1.4.1.283.1000.2.1.6.3.1.0%3D1' \
        http://192.168.1.1/cgi-bin/setobject?/tools/reboot_done.shtml > /dev/null

[[ -e $COOKIE ]] && rm $COOKIE

echo " Foi ;-)"
