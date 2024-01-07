# Rust

## Self signed CA problem

Sometimes you need to access a system with a self-signed root CA via SSL, and you might get errors like:

```
No response received: error trying to connect: error:1416F086:SSL
routines:tls_process_server_certificate:certificate verify failed:ssl/statem/statem_clnt.c:1919:: 
self signed certificate in certificate chain
```

If you don't own the system you are running on, but are seeing issues with self-signed certificates in the trust chain of a site you are connecting to, try this:

Copy a version of the system's CA setup to a local file, e.g.:

```shell
cp /etc/ssl/certs/ca-certificates.crt $HOME/ca-certificates.crt
```

Add the CA you want to trust to the end of the new file. The cert snippet should look something like:

```
-----BEGIN CERTIFICATE-----
MIIGTzCCBDegAwIBAgIQWAoyV+tzprJIl8dVQmA0CjANBgkqhkiG9w0BAQsFADBf
... base64 encoded nonsense ...
HSsB3yggN5bqCpTpSDGKsWU30sZ1152T/KaVwwCfzZ3e5jc=
-----END CERTIFICATE-----
```

Now export the new CA as an env var:

```
export SSL_CERT_FILE=$HOME/ca-certificates.crt
```

This should replace the system CA with your ammended CA.

## Lambda links

* Official [aws-lambda-rust-runtime](https://github.com/awslabs/aws-lambda-rust-runtime)
* [Using Rust Lambdas in Production](https://www.cvpartner.com/blog/using-rust-lambdas-in-production)

[gimmick:Disqus](swissarmyronin-github-io)

