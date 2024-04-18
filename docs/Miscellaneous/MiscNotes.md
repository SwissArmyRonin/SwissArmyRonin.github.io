# Misc. Notes

<!-- toc -->

----

This page contains a collection of unrelated notes pertaining to issues I have Googled more than once.

## Start a process as a different user in Windows

In PowerShell:

```powershell
Start-Process -FilePath "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe" -Credential (Get-Credential)
```

Directly from a link, i.e. with the default CMD shell:

```batch
%windir%\System32\runas.exe /profile /u:domain\user "%programfiles(x86)%\Microsoft\Edge\Application\msedge.exe"
```

## "God mode"

In Windows, create a folder on the desktop and rename it to:

```text
GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}
```

## Recommend VS Code plugin

Create a file `.vscode/extensions.json` with a recommendation array of extension ids, e.g.:

```json
{
 "recommendations": ["ms-vscode.csharp", "ms-mssql.mssql"]
}
```

## Terraform docs for 0.12+

```shell
docker run --rm \
  -v $(pwd):/data \
  cytopia/terraform-docs \
  terraform-docs-012 --sort-inputs-by-required --with-aggregate-type-defaults md . > README.md
```

## Decompiler plugin Java

[Mchr3k - JDEclipse-Realign](https://mchr3k.github.io/jdeclipse-realign/)

## Run command as admin

To run a command as admin without the mouse:

- `Win-R` to open file dialog
- type command name and run with `Ctrl-Shift-Enter`

## Export an existing environment to Terraform

```shell
docker run --rm -iv "${PWD}":/outputs cycloid/terracognita aws --tfstate /outputs/terraform.tfstate \
  --access-key $AWS_ACCESS_KEY_ID --secret-key $AWS_SECRET_ACCESS_KEY --region eu-west-1 --hcl /outputs/main.tf
```

## 260 character path length restriction

To remove path length restriction in Windows 10 anniversary edition, run:

```powershell
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled /t REG_DWORD /d 1
```

Can break old 32 bit apps.

## GitHub

- License overview: <https://help.github.com/articles/licensing-a-repository/>

## Free S/MIME certificates

[Actalis](https://extrassl.actalis.it/portal/uapub/freemail?lang=en) provides free S/MIME certifcates for non-commercial use.

## Allow changing the password on first login via RDP

Add a line to the RDP file with the text (or change the existing one):

```text
enablecredsspsupport:i:0
```

Afterwards, delete the line again. [Technet](https://technet.microsoft.com/en-us/library/ff393716) has a good explanation.

## Removing bloat ware from a new Windows machine

[Removing bloat ware from a new Windows machine](http://osherove.com/blog/2017/9/29/removing-bloatware-from-a-new-windows-machine.html)

## Turn a JAR file into an executable

Download [JSmooth](http://jsmooth.sourceforge.net/). Only works if `JAVA_HOME` is set to a working JRE.

## SecurityException on binaries running from a network share

Let's say I get a SecurityException when running my .NET console application from "\\vmware-host\Shared Folders". In this case, simply open a developer prompt and type:

```powershell
CasPol.exe -m -ag 1.2 -url "file://\\vmware-host\Shared Folders/*" FullTrust
```

From "[Using CasPol to Fully Trust a Share](https://blogs.msdn.microsoft.com/shawnfa/2004/12/30/using-caspol-to-fully-trust-a-share/)".

## Netcopy

Want to copy a file from one \*Nix macine to another without the hassle of FTP?

DestinationShell:

```shell
nc -l -p 2020 > file.txt
```

SourceShell:

```shell
 cat file.txt | nc dest.ip.address 2020
```

## TWiki syntax high-lighting

TWiki sucks. But it sucks harder without syntax higlighting of snipptes. This plugin fixes that: [DpSyntaxHighlighterPlugin](http://twiki.org/cgi-bin/view/Plugins/DpSyntaxHighlighterPlugin)

## Cruft detection

Legacy projects are hoary with cruft. Find it and remove it with ...

- [Classpath Helper](http://classpathhelper.sourceforge.net)
- [UCDetector: Unnecessary Code Detector](http://www.ucdetector.org)
- [Tattletale](http://tattletale.jboss.org)

## Codesigning

Signing a .NET binary post build is easy with a X.509 certificate. Heres how to sign `MyApp.exe` with `mycert.pfx`:

```powershell
signtool.exe sign /v /f "mycert.pfx" -t "<http://timestamp.verisign.com/scripts/timstamp.dll>" "MyApp.exe"
```

## Custom Security Contexts in Jersey

[Jersey (JAX-RS) SecurityContext in action](https://simplapi.wordpress.com/2015/09/19/jersey-jax-rs-securitycontext-in-action/)

## Linux & PAM

Sometimes you have a Linux server that uses PAM/ActiveDirectory to validate logins. If the connection to the AD lapses for some reason, you can find yourself locked out. These steps fix that.

Boot into single-user mode, hold shift during startup and choose `advanced options -> recoverymode -> drop to root shell` from the Grub menu.

Remount hard disk in RW mode:

```shell
mount -o remount,rw /
```

Reestablish AD trust with Kerberos:

```shell
kinit xxx@MY-DOM
```

... where `xxx` is an AD browser account on the `MY-DOM` domain.

## .NET Core notes

- [.NET Core download](https://www.microsoft.com/net/core)
- [Documentation](https://docs.asp.net/en/latest)
- [How to setup Https on Kestrel](http://dotnetthoughts.net/how-to-setup-https-on-kestrel)
- [Using both xproj and csproj with .NET Core](http://stackify.com/using-both-xproj-and-csproj-with-net-core)

## REST Services

[Service versioning](http://www.hanselman.com/blog/ASPNETCoreRESTfulWebAPIVersioningMadeEasy.aspx)
