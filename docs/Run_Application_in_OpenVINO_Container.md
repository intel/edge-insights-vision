# How to run your application in OpenVINO container
This guide shows how to link your working directory in OpenVINO container. After install EIV, OpenVINO docker image is created.

![docker_image](/images/docker_images.png)

1. Run this command to launch docker container with OpenVINO image and link to your working directory.
     ```
    sudo docker run -t -d --name <docker_name> --net=host -v <local_source_directory>:<container_destination_directory> \
     -w <default_directory> -v /usr/bin:/usr/bin -v /tmp/.X11-unix:/tmp/.X11-unix -e \
     DISPLAY="$DISPLAY" -p 8888:8888 --device /dev/dri/renderD128 --group-add="$(stat -c "%g" /dev/dri/renderD128)" \
     openvino/ubuntu22_dev:eiv
     ```
     - --name: Docker container name
     - -v: mount from local source directory to container destination directory
     - -w: The default directory when login into docker container
   
      > If you are in proxy network, add additional this option: --env http_proxy="proxy_servername" --env https_proxy="proxy_servername"
      
      > If you have dGPU, add additional this option: --device /dev/dri/renderD129 --group-add="$(stat -c "%g" /dev/dri/renderD129)"

3. After you execute docker run command, the container is created. You can run "docker ps" command to see your container. 
![test_container](/images/test_container.png)

4. To login into your container, run this command.
   ```
   docker exec -it <container_id> /bin/bash
   ```
6. Now you can run your application with OpenVINO and directly edit your script in container. 
