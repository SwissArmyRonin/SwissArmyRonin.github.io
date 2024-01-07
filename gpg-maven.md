# GPG with Maven

To sign Maven artifacts add the following to the POM;

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-gpg-plugin</artifactId>
    <version>1.5</version>
    <executions>
    <execution>
        <id>sign-artifacts</id>
        <phase>verify</phase>
        <goals>
        <goal>sign</goal>
        </goals>
    </execution>
    </executions>
</plugin>
```

The passphrase for the default key should go in a property in the POM, or preferably, in the "~/.m2/settings.xml" file.

```xml
...
<properties>
  <gpg.passphrase>secretpassword</gpg.passphrase>
</properties>
...
```

This signs using the default local key, and uses the "gpg"-command for signing. There are more options in the [documentation](http://maven.apache.org/plugins/maven-gpg-plugin/sign-mojo.html).

## Troubleshooting

Signing can fail with the message:

    gpg: signing failed: Inappropriate ioctl for device

This is because the local GPG install wants to ask for the userpassword with a popup. Override by executing:

    export GPG_TTY=$(tty)

## GPG cheat sheet

There is a nice GPG cheatsheet [here](http://irtfweb.ifa.hawaii.edu/~lockhart/gpg/).

[gimmick:Disqus](swissarmyronin-github-io)