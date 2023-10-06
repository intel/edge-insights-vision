# MIPI AR0234 Setup Guide
This is setup guide for enabling MIPI AR0234 for Intel® Alder-Lake N processor.

## Build the Kernel
   ### Hardware Requirements to build the kernel
      Intel® CPU -> 8 core and above
      RAM: >=16GB
1. Run below script to build the kernel
   NOTE: make sure internet is working
   ```
   cd scripts
   chmod 755 ./*
   ./adl_build_kernel.sh
   ```
   Once the kernel is built, below 3 files will be created in linux-kernel-overlay directory.
    - linux-headers-6.1.38--000_6.1.38-0_amd64.deb
    - linux-image-6.1.38--000_6.1.38-0_amd64.deb
    - linux-libc-dev_6.1.38-0_amd64.deb
   
## Replace the kernel on the target system 
1. Run below script to replace kernel, the system reboots after this command
   ```
   cd linux-kernel-overlay
   ../adl_replace_kernel.sh
   ```
## Install IPU libraries
1. Run below script to install userspace IPU libraries. the system reboots after this command
   ```
   cd frameworks.ai.eiv/scripts
   ./adl_install_ipu.sh
   ```
2. To ensure IPU FW is probed and loaded properly, run this command.
   ```
   dmesg
   ```
   ![dmesg](/images/dmesg_IPU.png)
3. Lastly check if AR0234 sensor(s) are detected.
   ```
   media-ctl -p
   ```
   ![detect_sensor](/images/Detect_sensor.png)

### Video Loopback Setup
1. In order to use v412 API with AR0234 MIPI camera, run following commands.
   ```
   sudo apt-get install v4l2loopback-dkms
   sudo apt-get install v4l2loopback-utils
   sudo modprobe v4l2loopback devices=1
   ```
   > devices=x (number of AR0234 cameras connected)
2. You will get the video device name by running following command.
   ```
   ls -1 /sys/devices/virtual/video4linux
   ```
   > Take note the device name
3. Change to root mode and set environment variables with following commands.
   ```
   sudo bash
   export GST_PLUGIN_PATH=/usr/lib/gstreamer-1.0
   export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib
   export LIBVA_DRIVER_NAME=iHD
   export GST_GL_PLATFORM=egl
   ```
4. Launch following command to see the AR0234 camera stream.
   ```
   gst-launch-1.0 icamerasrc device-name=ar0234 ! video/xraw,format=NV12,width=1280,height=960 ! v4l2sink /dev/<device name>
   ```
5. For single camera, use MIPI camera as usual from v412 API.
   ```
   gst-launch-1.0 v4l2src device=/dev/<device name> ! videoconvert ! xvimagesink
   ```
### Resume Install EIV
1. To resume EIV installation, run following command. When it ask whether you want to enable the feature, select 'NO' because you already follow above steps to install. 
   ```
   cd frameworks.ai.eiv
   ./esh_install.sh
   ```
