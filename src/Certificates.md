# Certificates

<!-- toc -->

## Get remote certificate

```shell
HOST="www.dr.dk"
echo -n | openssl s_client -showcerts -connect $HOST:${PORTNUMBER:-443}
```

## Add new CA trust

Works on Amazon Linux:

```shell
cp swissarmyronin.crt /etc/pki/ca-trust/source/anchors/.
update-ca-trust extract
```

For more info: `man update-ca-trust`.

## Create a signed certificate

```shell
## Create keys
openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 3650

## Create CSR
openssl req -new -sha256 -key key.pem -out certificate.csr

## ... get the CSR signed ...

## Download signed certificate.pem and verify it
openssl x509 -text -noout -in certificate.pem

## Combine private key with signed public key
openssl pkcs12 -inkey key.pem -in certificate.pem -export -out certificate.p12 -name tomcat
```

## Create an self-signed certificate

```shell
## Create keys
openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 3650 -out certificate.pem

## Verify the certificate        
openssl x509 -text -noout -in certificate.pem

## Combine private and public key
openssl pkcs12 -inkey key.pem -in certificate.pem -export -out certificate.p12 -name tomcat
```

## Significance of "name"

"-name tomcat" sets the alias of the key in the p12 keystore´. This is needed to reference the
key from Tomcat's connector configuration.

## Misc

If running openssl on Windows it sometimes freezes during the last step. If that happens,
prefix the command with "winpty", eg:

```shell
winpty openssl pkcs12 -inkey key.pem -in certificate.pem -export -out certificate.p12 -name tomcat
```

## Troubleshooting

```shell
openssl s_client -connect localhost:8443 -tls1
openssl s_client -connect localhost:8443 -tls1_1
openssl s_client -connect localhost:8443 -tls1_2
```
