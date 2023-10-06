#!/bin/bash

# Copyright (C) 2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0 

# Install gstreamer packages
sudo apt-get -y install libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-base \
gstreamer1.0-plugins-good \
libgstreamer-plugins-good1.0-dev gstreamer1.0-plugins-bad-apps gstreamer1.0-plugins-bad \
libgstreamer-plugins-bad1.0-0 gstreamer1.0-plugins-ugly

# Dependancies for userspace libraries
sudo apt-get -y install cmake build-essential pkg-config libexpat1-dev rpm autoconf libtool

# Build ipu6-camera-bins
git clone https://github.com/intel/ipu6-camera-bins.git
cd ipu6-camera-bins/
git checkout rpl-pv-v2
cd ipu6ep
sudo cp -rf lib/* /usr/lib
sudo cp -rf include/* /usr/include/
sudo cp -rf lib/firmware/intel/ipu6ep_fw.bin /lib/firmware/intel/
cd ../../

# Build ipu6-camera-hal
git clone https://github.com/intel/ipu6-camera-hal.git
cd ipu6-camera-hal/
git checkout rpl-pv-v2
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release -DIPU_VER=ipu6ep -DUSE_PG_LITE_PIPE=ON -DCMAKE_INSTALL_PREFIX=/usr ../
make -j8
make package
sudo rpm -ivh --force --nodeps libcamhal-0.1.1-Linux.rpm
cd ../../

# Build icamerasrc
sudo apt-get install libdrm-dev
git clone https://github.com/intel/icamerasrc.git
cd icamerasrc/
git checkout rpl-pv-v2
export CHROME_SLIM_CAMHAL=ON
export STRIP_VIRTUAL_CHANNEL_CAMHAL=ON
export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig"
./autogen.sh
make -j4
make rpm
sudo rpm -ivh --force --nodeps rpm/icamerasrc-*.rpm

# Reboot system
sudo reboot
