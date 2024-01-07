# Misc. Notes

This page contains a collection of unrelated notes pertaining to issues I have Googled more than once.

## YAML

Extra features: https://blog.daemonl.com/2016/02/yaml.html

## Free S/MIME certificates

[Actalis](https://extrassl.actalis.it/portal/uapub/freemail?lang=en) provides free S/MIME certifcates for non-commercial use.

## Allow changing the password on first login via RDP

Add a line to the RDP file with the text (or change the existing one):

    enablecredsspsupport:i:0

Afterwards, delete the line again. [Technet](https://technet.microsoft.com/en-us/library/ff393716) has a good explanation.

## Removing bloat ware from a new Windows machine

[Removing bloat ware from a new Windows machine](http://osherove.com/blog/2017/9/29/removing-bloatware-from-a-new-windows-machine.html)

## Turn a JAR file into an executable

Download [JSmooth](http://jsmooth.sourceforge.net/). Only works if ``JAVA_HOME`` is set to a working JRE.

## Move a feature branch from one product to another

If, by accident, one has created a feature ``foo`` from the wrong product version branch (eg.: ``tmtand-3.1/develop``) and it really should have started from another product version branch (eg.: ``tmtand-3.2/develop``)), then it's easy to rebase the feature on the proper product version with:

    git rebase --onto target-branch source-branch

So in the case above, that would be:

    git checkout tmtand-3.1/feature/foo
    git rebase --onto tmtand-3.2/develop tmtand-3.1/develop

## SecurityException on binaries running from a network share

Let's say I get a SecurityException when running my .NET console application from "\\vmware-host\Shared Folders". In this case, simply open a developer prompt and type:

    CasPol.exe -m -ag 1.2 -url "file://\\vmware-host\Shared Folders/*" FullTrust

From "[Using CasPol to Fully Trust a Share](https://blogs.msdn.microsoft.com/shawnfa/2004/12/30/using-caspol-to-fully-trust-a-share/)".

## Netcopy

Want to copy a file from one *Nix macine to another without the hassle of FTP?


    DestinationShell# nc -l -p 2020 > file.txt
    SourceShell# cat file.txt | nc dest.ip.address 2020

## Working with multiple git repositories

If your product consists of specific versions across multiple repositories, there are multiple options for managing that. I prefer [Gitslave](http://gitslave.sourceforge.net) or ``gits``, but while researching the issue, I came across a number of tools for the same problem:

   * [gr -- A tool for managing multiple git repositories](http://mixu.net/gr/)
   * [Alternatives To Git Submodule: Git Subtree](http://blogs.atlassian.com/2013/05/alternatives-to-git-submodule-git-subtree/)
   * [git-repo](https://code.google.com/p/git-repo/)
   * [giternal](https://github.com/patmaddox/giternal)
   * [braid](https://github.com/cristibalan/braid)

## Temp. Git ignore

So, to temporarily ignore changes in a certain file, run:

    git update-index --assume-unchanged <file>

Then when you want to track changes again:

    git update-index --no-assume-unchanged <file>

## TWiki syntax high-lighting

TWiki sucks. But it sucks harder without syntax higlighting of snipptes. This plugin fixes that: [DpSyntaxHighlighterPlugin](http://twiki.org/cgi-bin/view/Plugins/DpSyntaxHighlighterPlugin)

## Cruft detection

Legacy projects are hoary with cruft. Find it and remove it with ...

   * [Classpath Helper](http://classpathhelper.sourceforge.net)
   * [UCDetector: Unnecessary Code Detector](http://www.ucdetector.org)
   * [Tattletale](http://tattletale.jboss.org)

## Codesigning

Signing a .NET binary post build is easy with a X.509 certificate. Heres how to sign ``MyApp.exe`` with ``mycert.pfx``:

    signtool.exe sign /v /f "mycert.pfx" -t "http://timestamp.verisign.com/scripts/timstamp.dll" "MyApp.exe"

## Custom Security Contexts in Jersey

[Jersey (JAX-RS) SecurityContext in action](https://simplapi.wordpress.com/2015/09/19/jersey-jax-rs-securitycontext-in-action/)

## Linux & PAM

Sometimes you have a Linux server that uses PAM/ActiveDirectory to validate logins. If the connection to the AD lapses for some reason, you can find yourself locked out. These steps fix that.

Boot into singleuser mode, hold shift duirng startup and choose ``advanced options -> recoverymode -> drop to root shell`` from the Grub menu.

Remount harddisk in RW mode:

    mount -o remount,rw /

Reestablish AD trust with Kerberos:

    kinit xxx@MY-DOM

... hvor ``xxx`` is an AD browser account on the ``MY-DOM`` domain.

## .NET Core notes

* [.NET Core download](https://www.microsoft.com/net/core)
* [Documentation](https://docs.asp.net/en/latest)
* [.NET Compatibility Diagnostic Tools](http://dotnetstatus.azurewebsites.net)
* [How to setup Https on Kestrel](http://dotnetthoughts.net/how-to-setup-https-on-kestrel)
* [Using both xproj and csproj with .NET Core](http://stackify.com/using-both-xproj-and-csproj-with-net-core)

## REST Services 
[Service versioning](http://www.hanselman.com/blog/ASPNETCoreRESTfulWebAPIVersioningMadeEasy.aspx)

[gimmick:Disqus](swissarmyronin-github-io)

## Maven master password

To configure encrypted passwords, create a master password by running mvn -emp or mvn --encrypt-master-password followed by your master password.

```shell
$ mvn -emp mypassword
{rsB56BJcqoEHZqEZ0R1VR4TIspmODx1Ln8/PVvsgaGw=}
```

Maven prints out an encrypted copy of the password to standard out. Copy this encrypted password and paste it into a ~/.m2/settings-security.xml file.

```xml
<settingsSecurity>
  <master>{rsB56BJcqoEHZqEZ0R1VR4TIspmODx1Ln8/PVvsgaGw=}</master>
</settingsSecurity>
```

After you have created a master password, you can then encrypt passwords for use in your Maven Settings. To encrypt a password with the master password, run mvn -ep or mvn --encrypt-password. Assume that you have a repository manager and you need to send a username of "deployment" and a password of "qualityFIRST". To encrypt this particular password, you would run the following command:

```shell
$ mvn -ep qualityFIRST
{uMrbEOEf/VQHnc0W2X49Qab75j9LSTwiM3mg2LCrOzI=}
```

At this point, copy the encrypted password printed from the output of mvn -ep and paste it into your Maven Settings.

```xml
<settings>
  <servers>
    <server>
      <id>nexus</id>
      <username>deployment</username>
<password>{uMrbEOEf/VQHnc0W2X49Qab75j9LSTwiM3mg2LCrOzI=}</password>
    </server>
  </servers>
  ...
</settings>
```