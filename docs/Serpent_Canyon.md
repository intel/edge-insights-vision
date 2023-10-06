## Serpent Canyon pre-setup
In this device, the BIOS does not have option to change display to iGPU. There are additional steps require to do to install Ubuntu 22.04-IoT because it does not have dGPU driver installed.

1. Go to grub menu
   
   a. you need to press esc button twice to get this menu if you have already installed Ubuntu 22.04 LTS and trying to boot  [Info : if you press esc more it will take you to grub menu]
    ![grub menu](/images/Grub_Menu_1.jpg)
3. Select the first option "Ubuntu". Press 'e' button to edit commands before booting
4. In the editor, locate the end of the line that starts with "linux", enter "nomodeset" line option into behind "splash"
    ![grub menu](/images/Grub_Menu_2.jpg)
5. Press "Ctrl+X" and your system should boot into normal Ubuntu installation.
6. After Ubuntu installation completed, it will ask you to unplug your usb and restart your system. Then you will need to repeat step 1-4 again to enter "nomodeset".
7. Once you are inside the Ubuntu, you can follow below steps before installing EIV package.
```
   wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.2.8/amd64/linux-headers-6.2.8-060208-generic_6.2.8-060208.202303220943_amd64.deb
   wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.2.8/amd64/linux-headers-6.2.8-060208_6.2.8-060208.202303220943_all.deb
   wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.2.8/amd64/linux-image-unsigned-6.2.8-060208-generic_6.2.8-060208.202303220943_amd64.deb
   wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.2.8/amd64/linux-modules-6.2.8-060208-generic_6.2.8-060208.202303220943_amd64.deb
   sudo dpkg -i ./linux-*.deb
   sudo update-grub
   sudo reboot
```
10. Follow [EIV installation steps](https://github.com/intel-innersource/applications.services.esh.eiv/tree/2023.0-github#eiv-installation)
