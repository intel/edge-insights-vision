# Edge Insights for Vision (EIV)
EIV from Intel features a set of pre-integrated ingredients designed for computer vision and deep-learning inference for applications at the edge, optimized for Intel® architecture. It can be implemented as a containerized architecture or a stand-alone runtime.

This package contains the scripts to install Intel® Graphics drivers and setup the environment for OpenVINO™ inference on CPU and Intel® Graphics devices.<br>
**In order to run inference on GPU you need graphics driver to be installed on host even if you are using docker container as runtime.<br>
However EIV helps you to seamlessly install right graphics drivers with just one script [here](https://github.com/intel-innersource/frameworks.ai.eiv/blob/release-2.1/README.md#eiv-installation) and help developers to run OpenVINO inference on Intel® CPU and iGPU/dGPU using OpenVINO docker image as runtime.<br>**


Here is the architecture diagram for EIV
![Architecture](/images/Architecture.png)
*Figure 1: Edge insights for Vision Module*

## Modules
* Docker
* Intel® Graphics drivers 
* The Intel® Distribution of OpenVINO™ toolkit (OpenVINO™) docker image 2023.1

### System Requirements
#### Recommended System Requirements
- Processors:
  -  12th or 13th generation Intel® Core™ processors
  -  Intel® N-series Processors
  -  Intel® Core™ i3 Processor N-series
  -  Intel® Arc™ A-Series Graphics
- At least 8GB of system RAM
- At least 64GB of available hard drive space
- Internet Connection
- Ubuntu 20.04-IoT or Ubuntu 22.04-IoT

#### Validated Devkits
The following devkits has been validated with EIV 2.1
| Devkit | Processor | dGPU | 
| ------ | --------- | ---- | 
| IEI TANK-XM811 | Intel® Core™ i7-12700E | Intel® Arc™ Pro A40 Graphics | 
| Seavo ADI-V51 AIoT | Intel® Core™ i7-1270PE | - | 
| Asus PE3000G | Intel® Core™ i7-12800HE | Intel® Arc™ A370M Graphics |
| Intel NUC 12 Enthusiast Kit | Intel® Core™ i7-12700H | Intel® Arc™ A770M Graphics |
| AAEON UP SQUARED PRO 7000 EDGE | Intel® Atom™ x7425E | - |
| Seavo Intel Rock Island Reference Design Board | Intel® Core™ i7-1370PE | - |

#### Prepare the Target System
>**Note**
>Ubuntu 22.04 installation process may freeze if the primary display is set to dGPU. Some devices for example, the Asus IoT PE3000G, has the default dGPU set as the primary display. To solve this, go to the BIOS menu, select Advanced -> Graphic Configuration -> Primary Display, select 'IGFX'. Save changes and reboot the system. Then, you can proceed to install Ubuntu 22.04 and EIV. After the EIV installation has completed, go to the BIOS and switch the selection back to 'PEG Slot' if you wish to use the dGPU as the primary display.
>
>If you are using the Intel® NUC 12 Enthusiast Kit (Serpent Canyon), refer to [here](docs/Serpent_Canyon.md)
>
>If you have the Intel® Arc™ series GPU, follow this link to setup the device [here](https://www.intel.in/content/www/in/en/support/articles/000091128/graphics.html?erpm_id=1886163_ts1684118208092)

Make sure your target system has a fresh installation of the operating system. If you need help installing Ubuntu, follow these steps:
1. Download [Ubuntu v20.04-IoT or Ubuntu v22.04-IoT Desktop ISO file](https://ubuntu.com/download/iot/intel-iot) for your Intel hardware to your developer workstation.
2. Create a bootable flash drive using an imaging application.
3. After flashing the USB drive, power off your target system, insert the USB drive, and power on the target system. If the target system doesn't boot from the USB drive, change the boot order in the system BIOS.
4. Follow the prompts to install the OS with the default configurations. For detailed instructions, see the [Ubuntu guide](https://ubuntu.com/tutorials/tutorial-install-ubuntu-desktop#1-overview)
5. If you are in proxy environment, make sure you have set the proxy in /etc/environment
6. After successfully installing Ubuntu, refer to the "EIV Installation" section below.

NOTE: If your system has a dGPU, the kernel wil be upgraded to 6.2.8 and your system will auto reboot during installation. Please save your work before starting installation. After the reboot, launch "eiv_install.sh" again to complete the installation.

## Get Started Guide
Follow this step-by-step guide to install Intel® EIV on Linux* for your target system. After completing this guide, you will be ready to try out sample applications on Intel processors, iGPUs, and Intel® Arc™ series GPUs.

### EIV Installation
Run the following commands on the target system to install EIV.

Before running these commands, refer to [System Requirements](https://github.com/intel-innersource/frameworks.ai.eiv/blob/release-2.1/README.md#system-requirements) and the [Prepare the Target System](https://github.com/intel-innersource/frameworks.ai.eiv/blob/release-2.1/README.md#prepare-the-target-system) sections above.

1. clone the git repo and run the script as shown below
   
   ```
   sudo apt -y install git
   git clone https://github.com/intel/edge-insights-vision.git
   cd frameworks.ai.eiv
   ./eiv_install.sh
   ```
3. Restart your system after installation is complete.

![eiv](/images/install_successfull.png)
*Figure 3: Successfully install EIV*

> If the graphics driver does not show the version number, reboot your system and run this command to view driver version
```shell
clinfo | grep 'Driver Version'
```   
The next step is to launch the OpenVINO™ Jupyter Notebook. Go to this [link](/docs/Run_Jupyter_Notebook_Tutorials.md) to begin.

To learn how to use OpenVINO™ on the dGPU, go to this [link](/docs/How_to_use_OpenVINO_on_dGPU.md)

To learn how to run applications in the OpenVINO™ container, go to this [link](/docs/Run_Application_in_OpenVINO_Container.md)

## Summary and Next Step:
You have successfully installed EIV and use OpenVINO™ to perform inference on the CPU and GPU on your target system. 
For next steps, explore other sample scripts models in the Jupyter notebooks and learn more on how to develop your applications with OpenVINO™. For more information, refer to [OpenVINO™ Notebooks](https://github.com/openvinotoolkit/openvino_notebooks) 

If you need any further information, contact foundational.developer.kit@intel.com

--------------------------------------------------------------------------
Notices and Disclaimers

The code names presented in this document are only for use by Intel to identify products, technologies, or services in development, that have not been made commercially available to the public, i.e., announced, launched or shipped. They are not "commercial" names for products or services and are not intended to function as trademarks.  
                   
© Intel Corporation.  Intel, the Intel logo, OpenVINO, Arc, and other Intel marks are trademarks of Intel Corporation or its subsidiaries.  Other names and brands may be claimed as the property of others.

