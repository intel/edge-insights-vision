# How to use OpenVINO on dGPU
We will using sample 003-hello-segmentation notebook to show how to use OpenVINO on dGPU. During EIV installation, it has automatically installed drivers for dGPU.
1. Launch the sample 003-hello-segmentation.ipynb script and run code in section "Imports" and "Download model weights"
2. Next is select device inference where you can select device from dropdown list for running inference using OpenVINO. You can add following code to ensure notebook able to detect your dGPU
   ```
   # print available devices
   for device in ie.available_devices:
   device_name = ie.get_property(device, "FULL_DEVICE_NAME")
   print(f"{device}: {device_name}")
   ```
3. Example what you can see. If it able to detect your dGPU, in the dropdown list it will show GPU.1

4. Select GPU.1 and you can now proceed to run the rest of the code. It will use dGPU to run OpenVINO Inference.
