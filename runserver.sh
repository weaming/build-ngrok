#!/bin/bash

ROOT="./ngrok"
EXE="$ROOT/bin/ngrokd"
KEY="$ROOT/certificate/device.key"
CRT="$ROOT/certificate/device.crt"

$EXE -tlsKey=$KEY -tlsCrt=$CRT -domain="ngrok.bitsflow.org" -httpAddr=":9080" -httpsAddr=":9443"
