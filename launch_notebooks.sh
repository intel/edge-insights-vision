#!/bin/bash

# Copyright (C) 2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

sudo docker kill notebooks
xhost +
dGPU="$(lspci | grep VGA | grep Intel | wc -l)"

if [ $dGPU -ge 2 ]; then
    sudo docker run -t -d --rm --name notebooks --net=host --env http_proxy=$http_proxy --env https_proxy=$https_proxy \
    -v $HOME:/mnt -w /mnt/openvino_notebooks -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY="$DISPLAY" -p 8888:8888 \
    --device /dev/dri/renderD128 --group-add="$(stat -c "%g" /dev/dri/renderD128)" --device /dev/dri/renderD129 --group-add="$(stat -c "%g" /dev/dri/renderD129)" \
    openvino/ubuntu22_dev:eiv
else
    sudo docker run -t -d --rm --name notebooks --net=host --env http_proxy=$http_proxy --env https_proxy=$https_proxy \
    -v $HOME:/mnt -w /mnt/openvino_notebooks -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY="$DISPLAY" -p 8888:8888 \
    --device /dev/dri/renderD128 --group-add="$(stat -c "%g" /dev/dri/renderD128)" \
    openvino/ubuntu22_dev:eiv
fi

sudo docker exec notebooks bash -c "cd /mnt/openvino_notebooks"
sudo docker exec notebooks bash -c "~/.local/bin/jupyter-lab --allow-root --ip=0.0.0.0 --no-browser --NotebookApp.iopub_data_rate_limit=10000000"
