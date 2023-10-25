# Run Jupyter Notebook Tutorials
Follow these steps to launch Jupyter Notebook and run basic tutorials to verify that the target system is working correctly. 
> **Note**
> Make sure to launch the Jupyter Notebook in the target system's browser. The link will not work if you are remotely connected to the target system using SSH as it is local host address. 

1. After successful installation, change the launch_notebooks.sh script to executable and run the launcher script as below
   ```shell
   cd edge-insights-vision/scripts
   ./launch_notebooks.sh
   ```
2. Open your browser and paste the URL highlighted below to open the Jupyter notebook. 

    ![jupyter](/images/example_jupyter.png)
    *Figure 4: Output of launch_notebooks.sh*

    ![browser](/images/jupyter_browser.png)
    *Figure 5: Jupyter notebook in browser*

3. A snapshot of hello-world samples available in openvino notebooks, use link given in below section to see more about samples.

    | Notebook | Description | Preview |
    | -------- | ----------- | ------- |
    | 001-hello-world | Basic introduction to OpenVino on CPU | ![Dog1](/images/Dog_Sample_1.png) |
    | 108-gpu-device | High-level overview of working with Intel® GPU in OpenVINO | ![Dog2](/images/Dog_Sample_2.png) |
    > **Note** 
    > If you have any issues with installation, please report in this github issues.
