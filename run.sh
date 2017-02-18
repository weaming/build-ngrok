#!/bin/bash

ROOT="./ngrok"
KEY="$ROOT/certificate/device.key"
CRT="$ROOT/certificate/device.crt"
DOMAIN="ngrok.bitsflow.org"

SERVER="./dist/ngrokd"
CLIENT="./dist/ngrok"

if [ "$1" = "server" ]; then
	$SERVER -tlsKey=$KEY -tlsCrt=$CRT -domain="$DOMAIN" -httpAddr=":9080" -httpsAddr=":9443"
elif [ "$1" = "client" ]; then
	echo -e "server_addr: $DOMAIN:4443\ntrust_host_root_certs: false" > ngrok-config
	$CLIENT -config=ngrok-config -proto=tcp 22
elif [ "$1" = "pi" ]; then
	echo -e "server_addr: $DOMAIN:4443\ntrust_host_root_certs: false" > ngrok-config
	./dist/linux_arm/ngrok -config=ngrok-config -proto=tcp 22
else
	echo './run.sh server/client'
fi
