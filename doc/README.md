## Issues

### Self Hosted ngrokd fails to allow client to connect

https://github.com/inconshreveable/ngrok/issues/84

So the server (ngrokd) has two ports which you need to think about: one is for http requests (this is specified with -httpAddr) and the other is for ngrok clients to connect to the server (this is specified with -tunnelAddr). By default, tunnelAddr will listen on port 4443. If you change your `server_addr` to point at that port it will connect, although you're going to need a valid ssl cert or to recompile ngrok to use your own self signed authority.

