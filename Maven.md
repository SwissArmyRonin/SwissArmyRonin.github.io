# Maven

## Update all pom versions in a repo

```bash
mvn versions:set -DnewVersion=1.4-SNAPSHOT
```

## Maven release with local deploy

Deploy to the local directory `./dist`:

```
mvn deploy -DaltDeploymentRepository=repo::default::file:dist
```

Release and deploy to the local directory `./dist`:

```
mvn release:prepare
mvn release:perform -Darguments=-DaltDeploymentRepository=repo::default::file:dist
```

## Maven repo on GitHub

[Hosting maven repos on GitHub](https://cemerick.com/2010/08/24/hosting-maven-repos-on-github/)

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

[gimmick:Disqus](swissarmyronin-github-io)
