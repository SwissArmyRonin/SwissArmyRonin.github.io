# Virtual Angular developer environment with Vagrant

<!-- toc -->

## Overview

_2023-09-17: Not anymore!_ 🙂

In my work, I unfortunately have to maintain some legacy applications that don't play nice with newer version of Visual Studio and MSSQL. An obvious solution was to use virtual machines for each environment, and after 5 minutes of Googling for things like "vagrant windows development" I came across this two-part article: [Virtualize Your Windows Development Environments with Vagrant, Packer, and Chocolatey](http://www.developer.com/net/virtualize-your-windows-development-environments-with-vagrant-packer-and-chocolatey-part-1.html).

Note: This tutorial ends up with a box running a preview of Windows 10 Enterprise edition, which may be fine, but I also tried using my own full edition of Windows 10. This failed later because the XML file for unattended setup didn't match. I guess I'll look into that later.

## The goal

To get started I'm going to make something simple where I can find all the packages I need with [Chocolatey](https://chocolatey.org).

I settled on building a development machine for Angular development.

Base box:

* Windows 10
* Chocolatey

Vagrant addons:

* VS Code
* Chrome
* Git
* Node.js (for npm)

## Tools

To make my Angualr dev machine I need some tools:

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads) [5.1.26]:
  This is the virtual machine host that will be running my Vagrant images.
* [Vagrant](https://www.vagrantup.com/downloads.html) [2.0.0]:
  This is the tool that manages the virtual machines
* [Packer](https://www.packer.io/downloads.html) [1.0.4]:
  I need this to build my Vagrant base box.

I install VirtualBox and Vagrant in the given order using the default options and locations. Vagrant requires a restart.

"Packer" is just an executable, so for now I just unzip it and place it in my system path.

## Creating a base box

Following the original article, I clone the example repository
([joefitzgerald/packer-windows](https://github.com/joefitzgerald/packer-windows.git)).

After cloning "packer-windows" I open a command line in the new directory.

The Windows 10 template does not include Chocolatey, so i added ``"./scripts/chocolatey.ps1",`` to the provisioners section of "windows_10.json" (it's important that it's before the compact script):

    "provisioners": [
      {
        "type": "shell",
        "remote_path": "/tmp/script.bat",
        "execute_command": "{{.Vars}} cmd /c C:/Windows/Temp/script.bat",
        "scripts": [
          "./scripts/vm-guest-tools.bat",
          "./scripts/vagrant-ssh.bat",
          "./scripts/disable-auto-logon.bat",
          "./scripts/enable-rdp.bat",
          "./scripts/compile-dotnet-assemblies.bat"
        ]
      },
      {
        "type": "powershell",
        "script": "./scripts/chocolatey.ps1"
      },
      {
        "type": "shell",
        "remote_path": "/tmp/script.bat",
        "execute_command": "{{.Vars}} cmd /c C:/Windows/Temp/script.bat",
        "script": "./scripts/compact.bat"
      }
    ],

Hint: See "[windows_10_chocolatey.json](../examples/windows_10_chocolatey.json)" and "[vagrantfile-windows_10_chocolatey.template](../examples/vagrantfile-windows_10_chocolatey.template)".

Then I ran:

    packer build windows_10_chocolatey.json

This took a while ... like 4 hours. The worst thing was that the process seeming stalled after 30 minutes while running "SDelete". Luckily, I left it running and eventually I had a new Vagrant box file in the "packer-windows" dir, called "windows_10_virtualbox.box".

I moved the box file to "c:\HashCorp" and started a new command line in that directory, where I ran:

    vagrant box add windows10 windows_10_virtualbox.box

## Configure the Vagrant box

With the base box defined, it's time to make images based on it. First I made a directory to store the virtual machine image. In the new directory I ran:

    vagrant init windows10

This creates a Vagrant file.

I edit the Vagrantfile to install some extra packages by adding the following at the bottom before the ``end`` keyword:

    config.vm.provision "shell", inline: <<-SHELL
      choco install -y googlechrome visualstudiocode nodejs.install git.install
    SHELL

Afterwards I run:

    vagrant up
    vagrant rdp

Username: ``.\vagrant``
Password: ``vagrant``

Later, if I change the Vagrantfile, I can rerun the provisioning with:

    vagrant reload --provision

That's it for now. I could try to add some of the plugins I use regularly in VS Code, but I would rather have a look at getting my non-preview ISO working, and installing some of those legacy systems that cause me trouble on a weekly basis.

Hint: It might also be practical to create a repository for base boxes: [How to set up a self-hosted "vagrant cloud" with versioned, self-packaged vagrant boxes](https://github.com/hollodotme/Helpers/blob/master/Tutorials/vagrant/self-hosted-vagrant-boxes-with-versioning.md)

<!-- https://scotch.io/tutorials/how-to-create-a-vagrant-base-box-from-an-existing-one -->
