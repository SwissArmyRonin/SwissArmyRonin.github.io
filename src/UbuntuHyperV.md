# Ubuntu in Hyper-V

note: Don't do this. Just use WSL2. Hyper-V is unstable.

Setup a quick Ubuntu workstation with support for extended sessions.

* Quick-Create an Ubuntu 20 machine
  * _Don't_ enable auto-login
  * Keyboard should be win-keys

* Run in the VM:

  ```shell
  # wget https://raw.githubusercontent.com/Microsoft/linux-vm-tools/master/ubuntu/18.04/install.sh
  wget https://tinyurl.com/linuxvmtoools 
  sudo chmod +x linuxvmtoools
  sudo ./linuxvmtoools
  sudo apt install vim
  ```

* Edit `/etc/xrdp/xrdp.ini` to add:

  ​```ini
  port=vsock://-1:3389
  use_vsock=false
  ```

* Shutdown VM and admin Powershell
* Run in PS:

  ```powershell
  Set-VM -VMName <your_vm_name>  -EnhancedSessionTransportType HvSocket
  ```

Source: [How to install Ubuntu 20.04 on Hyper-V with enhanced session](https://medium.com/@francescotonini/how-to-install-ubuntu-20-04-on-hyper-v-with-enhanced-session-b20a269a5fa7)

## “Authentication required to refresh system repositories”

If this pops up constantly, create a file "/etc/polkit-1/localauthority/50-local.d/46-allow-update-repo.pkla":

```ini
[Allow Package Management all Users]
Identity=unix-user:*
Action=org.freedesktop.packagekit.system-sources-refresh
ResultAny=yes
ResultInactive=yes
ResultActive=yes
```
