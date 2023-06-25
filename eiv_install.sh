#!/bin/bash

# Copyright (C) 2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

DISTRO="$(grep -m1 'DISTRIB_ID' /etc/lsb-release | cut -d '=' -f 2)"
RELEASE="$(grep -m1 'DISTRIB_RELEASE' /etc/lsb-release | cut -d '=' -f 2)"
dGPU="$(lspci | grep VGA | grep Intel | wc -l)"
igpu_stat="$(ls /dev/dri | grep 'renderD128' | wc -l)"

is_proxy=$(env | grep -i proxy | wc -l)

install_deps(){
    sudo -E apt-get update
    sudo apt-get -y install python3-venv build-essential python3-pip git clinfo
    sudo apt-get -y install curl wget gpg-agent ffmpeg software-properties-common docker.io
    sudo groupadd docker
    sudo usermod -aG docker $USER
    
    mkdir -p $HOME/intel_models/neo
    printf "Dependancies Installed.....!!\n";
}

docker_proxy(){
    if [ $is_proxy -ge 2 ]; then
        sudo mkdir -p /etc/systemd/system/docker.service.d
        sudo touch /etc/systemd/system/docker.service.d/proxy.conf

        sudo bash -c "echo '[Service]' > /etc/systemd/system/docker.service.d/proxy.conf"
        sudo bash -c "echo 'Environment=\"http_proxy=$http_proxy\"' >> /etc/systemd/system/docker.service.d/proxy.conf"
        sudo bash -c "echo 'Environment=\"https_proxy=$https_proxy\"' >> /etc/systemd/system/docker.service.d/proxy.conf"

        sudo systemctl daemon-reload
        sudo systemctl restart docker.service
    else
        printf "No Proxy detected !";
    fi
}

kern_upgrade_dgpu(){
    if [ $RELEASE == "22.04" ]; then
        if dpkg --compare-versions "$(uname -r | cut -d'-' -f1)" lt 6.2.8 ; then
            sudo apt-get update
            cd $HOME
            wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.2.8/amd64/linux-headers-6.2.8-060208-generic_6.2.8-060208.202303220943_amd64.deb
            wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.2.8/amd64/linux-headers-6.2.8-060208_6.2.8-060208.202303220943_all.deb
            wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.2.8/amd64/linux-image-unsigned-6.2.8-060208-generic_6.2.8-060208.202303220943_amd64.deb
            wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.2.8/amd64/linux-modules-6.2.8-060208-generic_6.2.8-060208.202303220943_amd64.deb
            sudo dpkg -i $HOME/linux-*.deb
            sudo update-grub
            rm $HOME/linux-*.deb
            sudo reboot
        else
            wget -qO - https://repositories.intel.com/graphics/intel-graphics.key | sudo gpg --dearmor --yes --output /usr/share/keyrings/intel-graphics.gpg

            echo "deb [arch=amd64,i386 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/graphics/ubuntu jammy arc" | \
            sudo tee /etc/apt/sources.list.d/intel-gpu-jammy.list

            sudo apt-get update

            sudo apt-get install -y \
            intel-opencl-icd intel-level-zero-gpu level-zero \
            intel-media-va-driver-non-free libmfx1 libmfxgen1 libvpl2 \
            libegl-mesa0 libegl1-mesa libegl1-mesa-dev libgbm1 libgl1-mesa-dev libgl1-mesa-dri \
            libglapi-mesa libgles2-mesa-dev libglx-mesa0 libigdgmm12 libxatracker2 mesa-va-drivers \
            mesa-vdpau-drivers mesa-vulkan-drivers va-driver-all vainfo hwinfo clinfo

            sudo usermod -a -G video,render ${USER}
        fi
     elif [ $RELEASE == "20.04" ]; then
        if dpkg --compare-versions "$(uname -r | cut -d'-' -f1)" lt 5.14 ; then 
            sudo apt-get update && sudo apt-get install -y linux-image-5.14.0-1034-oem
            sudo sed -i "s/GRUB_DEFAULT=.*/GRUB_DEFAULT=\"1> $(echo $(($(awk -F\' '/menuentry / {print $2}' /boot/grub/grub.cfg \
            | grep -no '5.14.0-1034' | sed 's/:/\n/g' | head -n 1)-2)))\"/" /etc/default/grub
            sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=\"$(echo $(awk -F'="' '$1  == "GRUB_CMDLINE_LINUX_DEFAULT" {print $2}'  \
            /etc/default/grub | tr -d '"') | sed 's/pci=realloc=off//g') pci=realloc=off\"/" /etc/default/grub
            sudo  update-grub
            sudo reboot
        else 
            sudo apt-get install -y gpg-agent wget
            wget -qO - https://repositories.intel.com/graphics/intel-graphics.key | sudo gpg --dearmor --yes --output /usr/share/keyrings/intel-graphics.gpg
            echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/graphics/ubuntu focal main' | sudo tee -a /etc/apt/sources.list.d/intel.list
            
            sudo apt-get update
            sudo apt-get install -y \
            dkms \
            linux-headers-$(uname -r) \
            libc-dev \
            intel-i915-dkms
            
            sudo apt-get update
            
            sudo apt-get install -y \
            intel-opencl-icd \
            intel-level-zero-gpu level-zero \
            intel-media-va-driver-non-free libmfx1 libmfxgen1 
            
            sudo usermod -a -G video,render ${USER} 
        fi
    elif [ $RELEASE == "23.04" ]; then
        printf "Kernel upgrade not required !\n"
    else
        printf "Kernel upgrade not required !\n"
    fi
}

#function to download latest intel opencl compute libraries to install inside OV docker
download_drivers(){
    wget -N -P $HOME/intel_models/neo https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.13700.14/intel-igc-core_1.0.13700.14_amd64.deb
    wget -N -P $HOME/intel_models/neo https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.13700.14/intel-igc-opencl_1.0.13700.14_amd64.deb
    wget -N -P $HOME/intel_models/neo https://github.com/intel/compute-runtime/releases/download/23.13.26032.30/intel-level-zero-gpu-dbgsym_1.3.26032.30_amd64.ddeb
    wget -N -P $HOME/intel_models/neo https://github.com/intel/compute-runtime/releases/download/23.13.26032.30/intel-level-zero-gpu_1.3.26032.30_amd64.deb
    wget -N -P $HOME/intel_models/neo https://github.com/intel/compute-runtime/releases/download/23.13.26032.30/intel-opencl-icd-dbgsym_23.13.26032.30_amd64.ddeb
    wget -N -P $HOME/intel_models/neo https://github.com/intel/compute-runtime/releases/download/23.13.26032.30/intel-opencl-icd_23.13.26032.30_amd64.deb
    wget -N -P $HOME/intel_models/neo https://github.com/intel/compute-runtime/releases/download/23.13.26032.30/libigdgmm12_22.3.0_amd64.deb
}

install_igpu_drivers(){
    if [ $igpu_stat -lt 1 ]; then
        sudo apt-get update && sudo apt-get install  -y --install-suggests  linux-image-5.19.0-41-generic
        sudo update-grub
        sudo reboot
    else
        download_drivers
        sudo dpkg -i $HOME/intel_models/neo/*.deb
        sudo usermod -a -G video,render ${USER}
    fi
}

#driver function to install gpu drivers and related packages
gpu_drivers_host_install(){
    if [ $RELEASE == "22.04" ]; then
        if [ $dGPU -ge 2 ]; then
            kern_upgrade_dgpu
        else
            install_igpu_drivers        
        fi
        printf "$Intel GPU drivers installed successfully !!\n"
    elif [ $RELEASE == "20.04" ]; then
        if [ $dGPU -ge 2 ]; then
            kern_upgrade_dgpu
        else
            install_igpu_drivers        
        fi
        printf "$Intel GPU drivers installed successfully !!\n"
    fi
}

#function to install gpu drivers inside ov docker and save as new image with tag:ov
gpu_drivers_docker_install(){
    docker_proxy
    sudo docker pull openvino/ubuntu22_dev:latest
    # if (( $(sudo docker image ls openvino/ubuntu22_dev:latest | wc -l)>=2 )); then
    #     echo "Updated docker image already exists"
    # else
    #     download_drivers

    #     sudo docker run -t -d -u root --rm --name eiv --env http_proxy=$http_proxy --env https_proxy=$https_proxy -v "$HOME"/intel_models:/mnt openvino/ubuntu20_runtime:latest
    #     sudo docker exec eiv bash -c "apt-get update"
    #     sudo docker exec eiv bash -c "apt-get install -y ffmpeg git"
    #     sudo docker exec eiv bash -c "dpkg -i /mnt/neo/*deb"
    #     sudo docker commit eiv openvino/ubuntu_dev:ov
    #     sudo docker stop eiv
    # fi
}

# #function to create python virtual env for OV on host and install openvino dev package
# ov_python_setup(){
#     python3 -m venv $HOME/openvino_env
#     source $HOME/openvino_env/bin/activate
#     python -m pip install --upgrade pip
#     pip install openvino-dev[ONNX,pytorch]==2022.3.0
#     deactivate
# }

#function to setup ov notebooks
ov_notebook_setup(){
    cd $HOME
    rm -rf openvino_notebooks
    git clone --depth=1 https://github.com/openvinotoolkit/openvino_notebooks.git

}

#function to setup and install notebook dependencies
ov_docker_setup(){
    doc_size="$(sudo docker images openvino/ubuntu22_dev:eiv --format '{{.Size}}')"
    if(( $(echo "$doc_size > 5.8" |bc -l) )); then
        echo "OV Setup done and updated image seems to be available"
    else
        sudo docker run -t -d --rm --name eiv --env http_proxy=$http_proxy --env https_proxy=$https_proxy -v "$HOME":/mnt openvino/ubuntu22_dev:latest
        sudo docker exec -u root eiv bash -c "apt update && apt install -y ffmpeg"
        sudo docker exec eiv bash -c "cd /mnt/openvino_notebooks; pip install wheel setuptools; pip install -r requirements.txt"
        sudo docker commit eiv openvino/ubuntu22_dev:eiv
        sudo docker stop eiv
    fi
}

#function to download sample model for inference testing
download_models(){
    curl -o $HOME/intel_models/face.xml https://storage.openvinotoolkit.org/repositories/open_model_zoo/2022.1/models_bin/3/face-detection-retail-0004/FP16/face-detection-retail-0004.xml
    curl -o $HOME/intel_models/face.bin https://storage.openvinotoolkit.org/repositories/open_model_zoo/2022.1/models_bin/3/face-detection-retail-0004/FP16/face-detection-retail-0004.bin
    curl -o $HOME/intel_models/people.jpg https://storage.openvinotoolkit.org/data/test_data/images/person_detection.png
}

#function to launch ov docker
dock_ov_run(){
        sudo docker container prune -f
        sudo docker run -t -d --rm --name eiv -v "$HOME"/intel_models:/mnt --device /dev/dri:/dev/dri openvino/ubuntu22_dev:latest
}

#function to check inference on iGPU/dGPU
dock_gpu_check(){
    download_models
    if [ $dGPU -ge 2 ]; then
        sudo docker exec eiv bash -c "python3 /opt/intel/openvino/samples/python/hello_reshape_ssd/hello_reshape_ssd.py /mnt/face.xml /mnt/people.jpg GPU.0"
        sudo docker exec eiv bash -c "python3 /opt/intel/openvino/samples/python/hello_reshape_ssd/hello_reshape_ssd.py /mnt/face.xml /mnt/people.jpg GPU.1"
        sudo docker stop eiv
    else
        sudo docker exec eiv bash -c "python3 /opt/intel/openvino/samples/python/hello_reshape_ssd/hello_reshape_ssd.py /mnt/face.xml /mnt/people.jpg GPU"
        sudo docker stop eiv
    fi
}

#function to test cpu ang gpu inference
sanity_cpu_gpu(){
    download_models
    if [ $dGPU -ge 2 ]; then
        sudo docker exec eiv bash -c "python3 /opt/intel/openvino/samples/python/hello_reshape_ssd/hello_reshape_ssd.py /mnt/face.xml /mnt/people.jpg $1"
        sudo docker exec eiv bash -c "python3 /opt/intel/openvino/samples/python/hello_reshape_ssd/hello_reshape_ssd.py /mnt/face.xml /mnt/people.jpg GPU.1"
        sudo docker stop eiv
    else
        sudo docker exec eiv bash -c "python3 /opt/intel/openvino/samples/python/hello_reshape_ssd/hello_reshape_ssd.py /mnt/face.xml /mnt/people.jpg $1"
        sudo docker stop eiv
    fi
}

get_cpu_model(){
    lscpu | grep 'Model name'
}

get_gpu_driver_version(){
    clinfo | grep 'Driver Version'
}

get_docker_version(){
    sudo docker --version
}

#function to remove docker images
remove_ov_docker(){
    if (( $(sudo docker image ls openvino/ubuntu_dev:ov | wc -l)>=2 )); then
        sudo docker rmi openvino/ubuntu_dev:ov
    else
        echo "No image found by name"
    fi

    if (( $(sudo docker ps | grep eiv | wc -l)>=1 )); then
        sudo docker stop eiv
    else
        echo "No container running by this name"
    fi
}
