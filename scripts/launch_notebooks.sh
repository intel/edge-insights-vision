#!/bin/bash

# Copyright (C) 2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

sudo docker kill notebooks
xhost +
dGPU="$(lspci | grep VGA | grep Intel | wc -l)"

sudo docker run -t -u root -d --rm --name notebooks --net=host --env http_proxy=$http_proxy --env https_proxy=$https_proxy \
--device /dev/dri:/dev/dri -v $HOME:/mnt -w /mnt/openvino_notebooks -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY="$DISPLAY" -p 8888:8888 \
openvino/ubuntu22_dev:eiv

sudo docker exec notebooks bash -c "cd /mnt/openvino_notebooks"
sudo docker exec notebooks bash -c "/home/openvino/.local/bin/jupyter-lab --allow-root --ip=0.0.0.0 --no-browser --NotebookApp.iopub_data_rate_limit=10000000"
