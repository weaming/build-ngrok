#!/bin/bash

domain="ngrok.bitsflow.org"
root="`pwd`/ngrok"
dir="$root/certificate"
dist="$root/../dist"

# git clone
git clone https://github.com/inconshreveable/ngrok && cd $root
#https://github.com/inconshreveable/ngrok/issues/181
go get github.com/jteeuwen/go-bindata
[ -d $root/bin ] || mkdir bin && cp $GOPATH/bin/go-bindata $root/bin

# 自建ngrokd服务，如果不想买SSL证书，我们需要生成自己的自签名证书，并编译一个携带该证书的ngrok客户端
[ -d $dir ] || mkdir $dir && cd $dir

openssl genrsa -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -subj "/CN=$domain" -days 5000 -out rootCA.pem
openssl genrsa -out device.key 2048
openssl req -new -key device.key -subj "/CN=$domain" -out device.csr
openssl x509 -req -in device.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out device.crt -days 5000

# ngrok通过bindata将ngrok源码目录下的assets目录（资源文件）打包到可执行文件(ngrokd和ngrok)中去
cd $dir
cp rootCA.pem ../assets/client/tls/ngrokroot.crt
cp device.crt ../assets/server/tls/snakeoil.crt
cp device.key ../assets/server/tls/snakeoil.key

# make
cd $root
make release-server
make release-client
# build for my raspberry
unset GOBIN && GOOS="linux" GOARCH="arm" make release-client

[ -d $dist ] || mkdir $dist
cp $root/bin/ngrok* $dist
cp -r $root/bin/*arm* $dist

