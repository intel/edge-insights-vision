# Edge Insights for Vision (EIV)
EIV from Intel features a set of pre-integrated ingredients designed for computer vision and deep-learning inference for applications at the edge, optimized for Intel® architecture. It is implemented as containerized architecture or a stand-alone runtime.

This package contains the scripts to install Intel® Graphics drivers and set up the environment for OpenVINO™ inferencing on Intel® Processor and Intel® Graphics devices.

## How it Works
EIV is a set of pre-validated modules, implemented as a containerized architecture or a stand-alone runtime, for deploying computer vision and deep learning workloads at the edge. The package features the Intel® Distribution of OpenVINO™ toolkit for computer vision and deep learning applications optimized for Intel® architecture.

![Architecture](/images/Architecture.png)
*Figure 1: Edge Insights for Vision Module*

## Modules
* Docker
* Intel® GPU drivers
* The Intel® Distribution of OpenVINO™ toolkit (OpenVINO™) - 2023.0
* The Intel® Distribution of OpenVINO™ toolkit (OpenVINO™) Docker image 2023.0


## Get Started Guide
Follow this step-by-step guide to install Intel® EIV on Linux* for your target system. After completing this guide, you will be ready to try out sample applications on Intel® Processor, iGPU and Intel® Arc™ Graphics cards.

### Pre-requisites
#### Recommended System Requirements
- Processors:
  -  12th - 13th generation Intel® Core™ processors
  -  Intel® Processor N-series
  -  Intel® Core™ i3 Processor N-series
  -  Intel® Arc™ A-Series Graphics
- At least 8GB RAM
- At least 64GB Hard drive
- Internet Connection
- Ubuntu* 20.04 intel-iot or Ubuntu* 22.04 intel-iot

#### Prepare the Target System
>**Note:**
>Ubuntu 22.04 installation will freeze if the primary display is set to dGPU. Some devices, for instance Asus IoT PE3000G has the default dGPU as the primary display. In the BIOS menu, select Advanced -> Graphic Configuration -> Primary Display, and select 'IGFX'. Save changes and reboot the system. Next, proceed with the installation of Ubuntu 22.04 and EIV. After the EIV installation is done, go to the BIOS and switch back to 'PEG Slot' if you wish to use dGPU as the primary display.
>
>If you are using Intel® NUC 12 Enthusiast Kit (Serpent Canyon), click [here](/Serpent_Canyon.md)
>
>If you are using an Intel® Arc™ Graphics card, set up the device using the instructions [here](https://www.intel.in/content/www/in/en/support/articles/000091128/graphics.html?erpm_id=1886163_ts1684118208092)

Ensure your target system has a fresh Operating System installation. Follow these steps to install the Ubuntu operating system:
1. Download [Ubuntu v20.04-IoT or Ubuntu v22.04-IoT Desktop ISO file](https://ubuntu.com/download/iot/intel-iot) for your Intel hardware to your developer workstation.
2. Create a bootable flash drive using an imaging application such as the [balenaEtcher](https://etcher.balena.io/) application.
3. After flashing the USB flash drive, power off your target system, insert the USB flash drive, and power on the target system. If the target system doesn't boot from the USB flash drive, change the boot priority in the system BIOS.
4. Follow the prompts to install the OS with default configurations. For detailed instructions, see this [guide](https://ubuntu.com/tutorials/tutorial-install-ubuntu-desktop#1-overview).
5. After Ubuntu has been successfully installed, install git and git clone the EIV repository into your Ubuntu system.
    ```
    sudo apt -y install git
    git clone https://github.com/intel-innersource/applications.services.esh.eiv.git
    ```
6. In the proxy environment, make sure that you have set the proxy in /etc/environment.

### EIV Installation
Run the following commands on the target system to install EIV.
1. Update the package on the system.
    ```
    sudo apt-get update
    ```
2. Install python3-pip.
    ```
    sudo apt-get -y install python3-pip
    ```
3. Change the directory into applications.services.esh.eiv and install the requirements package.
    ```
    cd applications.services.esh.eiv
    pip3 install -r requirements.txt
    ```
    ![install requirement](/images/install_requirement.png)
    *Figure 2: Installing requirements package*
    
4. Install EIV. If your system has a dGPU, it will upgrade your kernel to 6.2.8 and your system will reboot during installation. Please save your work before starting the installation.
    ```
    python3 eiv_install.py
    ```
5. Restart your system after the installation is complete.
    ![eiv](/images/install_successfull.png)
    *Figure 3: Successfully installed EIV*
    
   > If GPU Drivers do not show the version, reboot your system and run this command to view the driver version.
   ```shell
   clinfo | grep 'Driver Version'
   ```   
### Run Jupyter Notebook Tutorials
Follow these steps to launch Jupyter Notebook and run basic tutorials to verify that the target system is working correctly. 

1. After successful installation, change the launch_notebooks.sh script to executable and run the launcher script as shown here:
   ```shell
   cd applications.services.esh.eiv
   chmod +x launch_notebooks.sh
   ./launch_notebooks.sh
   ```
2. Open your browser and paste the URL highlighted below to open the Jupyter Notebook. 

    ![jupyter](/images/example_jupyter.png)
    *Figure 4: Output of launch_notebooks.sh*

    ![browser](/images/jupyter_browser.png)
    *Figure 5: Jupyter Notebook in the browser*

3. A snapshot of hello-world samples are available in OpenVINO™ Notebooks. Use the OpenVINO™ Notebook provided here to learn more about the samples.

    | Notebook | Description | Preview |
    | -------- | ----------- | ------- |
    | 001-hello-world | Basic introduction to OpenVino on CPU | ![Dog1](/images/Dog_Sample_1.png) |
    | 108-gpu-device | High-level overview of working with Intel® GPU in OpenVINO™ | ![Dog2](/images/Dog_Sample_2.png) |
    > **Note:** 
    > If you have any issues with the installation, report your issues in this github repository.

## Summary and Next Step:
You have successfully installed EIV and used OpenVINO™ to perform inferencing on the CPU and GPU of your target system. 
Next, you can explore the sample script models in the Jupyter notebooks and learn more about how to develop your application with OpenVINO™ Toolkit. For more information, see [OpenVINO™ Notebooks](https://github.com/openvinotoolkit/openvino_notebooks). 
