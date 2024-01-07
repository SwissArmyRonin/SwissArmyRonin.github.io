# Converting an existing VM to Vagrant

Note: This is based off the article
"[Convert a VirtualBox .ova VM into a Vagrant box](http://ebarnouflant.com/posts/7-convert-a-virtualbox-ova-vm-into-a-vagrant-box)".

<!--
    Might be interesting ...
    http://pyfunc.blogspot.dk/2011/11/creating-base-box-from-scratch-for.html
-->

_The task: I have an existing VM that was not created from a Vagrant base box.
I want to turn it into a base box._

My base is an OVA file created by a colleague called
``RenovaWin10_20170907.ova``. First I import it into VirtualBox, overriding some
of its hardware settings in the process (this takes about 10 minutes). The image
has Virtual Box guest additions, but no SSH keys or Vagrant user account.

    $ VBoxManage import ../Downloads/RenovaWin10_20170907.ova --vsys 0 \
        --eula accept --ostype Windows10_64 --vmname RenovaWin10 --cpus 1 \
        --memory 4096

## Prep for packaging

I need to prep the image with the requirements for a Vagrant box ([Creating a Base Box](https://www.vagrantup.com/docs/boxes/base.html)):

* _VirtualBox Guest Additions_: these are already installed, but otherwise they are easy to add ([VirtualBox Guest Additions](https://www.virtualbox.org/manual/ch04.html))
* _"vagrant" user_
* _Admin account_
* _Turn off UAC_
* _Disable complex passwords_
* _WinRM configuration_

<!--
* _Disable "Shutdown Tracker"_: not used on windows 10, but otherwise check [here](http://www.thewindowsclub.com/how-to-enable-the-shutdown-event-tracker-in-windows-7).
* _Disable "Server Manager"_: Not used on windows 10.
-->

### Vagrant user

TODO: "vagrant" user with insecure key <https://github.com/hashicorp/vagrant/blob/master/keys/vagrant.pub>

### Admin account

"vagrant" pw for admin account

### Turn off UAC

Turn off UAC <https://articulate.com/support/article/how-to-turn-user-account-control-on-or-off-in-windows-10>

also

    reg add HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /d 0 /t REG_DWORD /f /reg:64

### Disable complex passwords

<https://www.askvg.com/how-to-disable-password-complexity-requirements-in-windows-server-2003-and-2008/>

### WinRM configuration

    winrm quickconfig -q
    winrm set winrm/config/winrs @{MaxMemoryPerShellMB="512"}
    winrm set winrm/config @{MaxTimeoutms="1800000"}
    winrm set winrm/config/service @{AllowUnencrypted="true"}
    winrm set winrm/config/service/auth @{Basic="true"}
    sc config WinRM start= auto

## Packaging

Next step is finding the UUID of the VM.

    $ VBoxManage list vms
      "RenovaWin10" {13b69d0a-bbf4-4f21-971c-5813c8037543}

From here I export the VM to a box.

    $ vagrant package --base 13b69d0a-bbf4-4f21-971c-5813c8037543 --output RenovaWin10.box
      ==> 13b69d0a-bbf4-4f21-971c-5813c8037543: Exporting VM...
      ==> 13b69d0a-bbf4-4f21-971c-5813c8037543: Compressing package to: /Users/mhv/Vagrant/RenovaWin10.box

This took more than an hour for a 60 gb image, and I left work before it was
done. The process also required _a lot_ of space. Something like twice the size
of the OVA file.

Since space was becoming an issue, i deleted the original OVA file. When you run
``vagrant up``, the box file is copied to the local Vagrant cache, so I actually
had to move the new box to a network share. Painful, since I then had to wait
for it to be copied back later.

Now I can test the box.

    $ mkdir RenovaWin10 && cd RenovaWin10
    $ vagrant init RenovaWin10 /Volumes/MHV/RenovaWin10.box
    $ vagrant up

    $ vagrant up
      Bringing machine 'default' up with 'virtualbox' provider...
      ==> default: Box 'RenovaWin10' could not be found. Attempting to find and install...
          default: Box Provider: virtualbox
          default: Box Version: >= 0
      ==> default: Box file was not detected as metadata. Adding it directly...
      ==> default: Adding box 'RenovaWin10' (v0) for provider: virtualbox
          default: Unpacking necessary files from: file:///Volumes/MHV/RenovaWin10.box
      ==> default: Successfully added box 'RenovaWin10' (v0) for 'virtualbox'!
      ==> default: Importing base box 'RenovaWin10'...
      ==> default: Matching MAC address for NAT networking...
      ==> default: Setting the name of the VM: renova_default_1506063597308_48918
      ==> default: Clearing any previously set network interfaces...
      ==> default: Preparing network interfaces based on configuration...
          default: Adapter 1: nat
      ==> default: Forwarding ports...
          default: 22 (guest) => 2222 (host) (adapter 1)
      ==> default: Booting VM...
      ==> default: Waiting for machine to boot. This may take a few minutes...
          default: SSH address: 127.0.0.1:2222
          default: SSH username: vagrant
          default: SSH auth method: private key
      Timed out while waiting for the machine to boot. This means that
      Vagrant was unable to communicate with the guest machine within
      the configured ("config.vm.boot_timeout" value) time period.
    
      If you look above, you should be able to see the error(s) that
      Vagrant had when attempting to connect to the machine. These errors
      are usually good hints as to what may be wrong.
    
      If you're using a custom box, make sure that networking is properly
      working and you're able to connect to the machine. It is a common
      problem that networking isn't setup properly in these boxes.
      Verify that authentication configurations are also setup properly,
      as well.
    
      If the box appears to be booting properly, you may want to increase
      the timeout ("config.vm.boot_timeout") value.

As mentioned, this copies the box image to Vagrant's cache and starts unpacking it. This also
adds a box definition so I can do ``vagrant init RenovaWin10`` later, without the URL.

Unfortunately, "``vagrant up``" stalls here, because there is no SSH key and vagrant account.
But the machine is up.
