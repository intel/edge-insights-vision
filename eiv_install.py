# Copyright (C) 2023 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

import subprocess
from tqdm import trange
from prettytable import PrettyTable
import urllib.request
import logging
 
# Create and configure logger
logging.basicConfig(filename="eiv_output.log",
                    format='%(asctime)s %(message)s',
                    filemode='w')
# Creating an object
log = logging.getLogger()
# Setting the threshold of logger to DEBUG
log.setLevel(logging.DEBUG)
cpu_model = ''
docker_vers = ''
gpu_dri_vers = ''
functions = ['install_deps', 'gpu_drivers_host_install', 'gpu_drivers_docker_install', 'ov_notebook_setup', 'ov_docker_setup', 'dock_ov_run', 'dock_gpu_check']
modules = {'Docker':'','Intel GPU Drivers':'', 'OpenVINO-2023.0 Notebooks':''}
table_display = PrettyTable(['Sl.NO', 'Modules', 'Status'])

def connect(host='http://google.com'):
    try:
        urllib.request.urlopen(host, timeout=3) 
        return True
    except:
        return False

if ( connect() == True ):
    print(f'\nInstallation Started, It may take few minutes Please Wait...')
    print('''
        Your System may restart in between installation,\n\
        If system reboots, please launch "eiv_install.py" again to complete installation.\n\
        Do not interrupt the installation process.\n\
        A system restart is recommended after the installation has completed.
        ''')

    print(f'\nInstallation Started, Please Wait...')

    for n in trange(len(functions), bar_format=" Installing: |{bar}| {percentage:3.0f}%  "):
        cmd = ['bash', '-c', '. eiv_install.sh; ' + functions[n]]
        result = subprocess.run(cmd, capture_output=True, text=True)
        if( result.returncode != 0 ):
            if(n == 2):
                modules['Intel GPU Drivers'] = 'Failed'
            elif(n == 4):
                modules['OpenVINO-2023.0 Notebooks'] = 'Failed'
            log.error(f'\ncmd - {result.args}   \noutput - {result.stdout}  \nError - {result.stderr}')
        else:
            if(n == 1):
                modules['Docker'] = 'Success'
            elif(n == 2):
                modules['Intel GPU Drivers'] = 'Success'
            elif(n == 4):
                modules['OpenVINO-2023.0 Notebooks'] = 'Success'
            log.info(f'\ncmd - {result.args}   \noutput - {result.stdout}')


    cmd_gpudriver = subprocess.run(['bash', '-c', '. eiv_install.sh; ' + 'get_gpu_driver_version'], capture_output=True, text=True)
    cmd_dockvers = subprocess.run(['bash', '-c', '. eiv_install.sh; ' + 'get_docker_version'], capture_output=True, text=True)

    try:
        docker_vers = ((cmd_dockvers.stdout.split())[2]).strip(',')
        gpu_dri_vers = (cmd_gpudriver.stdout.split())[2]
    except Exception as e:
        log.error(f'gpu_dri_vers = {e}')

    print(f'\nSuccessfully installed EIV 2.0 !!')

    table_display.add_row([1, list(modules.keys())[0]+' - '+docker_vers, list(modules.values())[0]])
    table_display.add_row([2, list(modules.keys())[1]+' - '+gpu_dri_vers, list(modules.values())[1]])
    table_display.add_row([3, list(modules.keys())[2], list(modules.values())[2]])
    print(table_display)
else:
    print("No Internet, please check for internet connection/ check for proxy settings !")
