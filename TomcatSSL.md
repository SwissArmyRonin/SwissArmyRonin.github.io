# Tomcat HTTPS

## Make a keystore with a self-signed key

Tomcat uses a keystore to access the SSL certifcate. For development servers,
the easiest method is to just make a new self-signed certifcate using "keytool"
from the JDK:

    $ keytool -genkey -keyalg RSA -alias tomcat -keystore $CATALINA_HOME/conf/keystore.jks -storepass changeit -keypass changeit -validity 9999 -keysize 2048
    What is your first and last name?
      [Unknown]:  localhost
    What is the name of your organizational unit?
      [Unknown]:
    What is the name of your organization?
      [Unknown]:
    What is the name of your City or Locality?
      [Unknown]:
    What is the name of your State or Province?
      [Unknown]:
    What is the two-letter country code for this unit?
      [Unknown]:
    Is CN=localhost, OU=Unknown, O=Unknown, L=Unknown, ST=Unknown, C=Unknown correct?
      [no]:  yes

"First and last name should be the hostname of the virtual host you plan to use
"it for, which is localhost in this case.

Remember to use a different password than "changeit" for the store and key. This
tutorial assumes that they are the same.

Next, ad the following connector to `$CATALINA_HOME/conf/server.xml`:

```xml
<Connector protocol="org.apache.coyote.http11.Http11Nio2Protocol"
  sslImplementationName="org.apache.tomcat.util.net.jsse.JSSEImplementation"
  port="8443" maxThreads="200" scheme="https" secure="true" SSLEnabled="true"
  keystoreFile="conf/keystore.jks" keystorePass="changeit" keystoreType="JKS"
  keyAlias="tomcat" clientAuth="false" sslProtocol="TLS"/>
```

## Using an existing certifcate in PKCS#12 format

If there is an existing certifcate in PKCS#12 for (*.p12 or *.pfx), 
copy it to the Tomcat server's "conf" dir. The following assumes it's called "keystore.p12".

Once the certificate is in the conf-dir, we need to find the alias for the key.

    keytool -list -storetype pkcs12 -keystore keystore.p12 -v

... the output should resemble the following:

    Keystore type: PKCS12
    Keystore provider: SunJSSE
    
    Your keystore contains 1 entry
    
    Alias name: {69010cf9-776d-4c4d-8ff8-4f5ae6b8cbc4}
    Creation date: Nov 23, 2017
    Entry type: PrivateKeyEntry
    Certificate chain length: 2
    Certificate[1]:
    Owner: CN=example.org, O=Internet Widgits Pty Ltd, ST=Some-State, C=DK
    Issuer: EMAILADDRESS=noreply@example.org, CN=Example Root Certificate, O=Example Inc.
    Serial number: 8efdc8df1da50d75
    Valid from: Mon Nov 30 11:13:11 CET 2015 until: Thu Apr 16 12:13:11 CEST 2043
    Certificate fingerprints:
    ...

From the output we can see that the alias for the key is: `{69010cf9-776d-4c4d-8ff8-4f5ae6b8cbc4}`

Now we can add the connector to server.xml:

```xml
<Connector protocol="org.apache.coyote.http11.Http11Nio2Protocol"
  sslImplementationName="org.apache.tomcat.util.net.jsse.JSSEImplementation"
  port="8443" maxThreads="200" scheme="https" secure="true" SSLEnabled="true"
  keystoreFile="conf/keystore.p12" keystorePass="changeit" keystoreType="PKCS12"
  keyAlias="{69010cf9-776d-4c4d-8ff8-4f5ae6b8cbc4}" clientAuth="false" sslProtocol="TLS"/>
```

## Test SSL

After adding the connector, the server now runs SSL on port 8443, e.g. `https://localhost:8443`


[gimmick:Disqus](swissarmyronin-github-io)