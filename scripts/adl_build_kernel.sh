#!/bin/bash

# Copyright (C) 2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

sudo apt-get install -y flex bison kernel-wedge gcc libssl-dev libelf-dev quilt liblz4-tool
git clone https://github.com/intel/linux-kernel-overlay.git
cd linux-kernel-overlay
git checkout lts2022-ubuntu
./build.sh
