# (WIP) Virtual developer environment with Vagrant 

In my work, I unfortunately have to maintain some legacy applications that don't play nice with
newer version of Visual Studio and MSSQL. An obvious solution was to use virtual machines for each
environment, and after 5 minutes of Googling for things like "vagrant windows development" I came
across this two part article: [Virtualize Your Windows Development Environments with Vagrant, Packer, and Chocolatey](http://www.developer.com/net/virtualize-your-windows-development-environments-with-vagrant-packer-and-chocolatey-part-1.html).

## The goal

I need a machine running: 

* Windows 10
* MSSQL 2008 Reporting Server
* Visual Studio 10
* Git

If possible I'd like to make a prebaked box with those things, and then make derrived boxes with
solutions and datasets for specific customers.

[gimmick:Disqus](swissarmyronin-github-io)
