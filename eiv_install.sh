#!/bin/bash

# Copyright (C) 2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

sudo apt-get update
sudo apt-get -y -q install python3-pip

pip3 install -r requirements.txt

python3 scripts/eiv_setup.py
