#!/bin/bash

# Copyright (C) 2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

sudo dpkg -i linux-headers-6.1.38--000_6.1.38-0_amd64.deb
sudo dpkg -i linux-image-6.1.38--000_6.1.38-0_amd64.deb
sudo dpkg -i linux-libc-dev_6.1.38-0_amd64.deb

sudo update-grub
sudo reboot
