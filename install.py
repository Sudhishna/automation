import tarfile
import io
import os
import subprocess
import sys
import jinja2
import paramiko
import time
import re
from subprocess import call
from paramiko_helpers import Paramiko_Helpers
from helpers import Helpers

"""
This simple script calls functions written in the helper module
"""
helpers = Helpers()
paramiko_helpers = Paramiko_Helpers()

# Fetch the user details
dict = helpers.fetch_user_details()
print dict

# Extract the CSO tar file
print "Extracting file from the CSO tar file..."
helpers.untar("/root/Contrail_Service_Orchestration_3.3.1.tar.gz")

# Build the provisio_vm.conf for the first run
installerip = dict['csoip'].split("/")[0]
dict.update({'installerip':installerip})
template_file = "/root/template/provision-vm.j2"
provision_config = helpers.load_template_config(dict,template_file)
with open('/root/Contrail_Service_Orchestration_3.3.1/confs/provision_vm.conf','w') as f:
    f.write(provision_config)

# Run the provision_vm.sh script
helpers.run_provision_vm()

# Create Paramiko Client
paramiko_helpers.create_paramiko_client(installervmip)

# Copy the CSO-3.3.1.tar.gz to the installer vm
paramiko_helpers.copy_file(client,'/root/Contrail_Service_Orchestration_3.3.1.tar.gz',installervmip)

# Untar the CSO-3.3.1.tar.gz
command = "tar xvzf /root/Contrail_Service_Orchestration_3.3.1.tar.gz"
paramiko_helpers.execute_command(client,command)

# Build the provision_vm.conf for the installer vm
installervmip = dict['installervmip'].split("/")[0]
dict.update({'installerip':installervmip})
template_file = "/root/template/provision-vm.j2"
provision_config = helpers.load_template_config(dict,template_file)
with open('/root/Contrail_Service_Orchestration_3.3.1/confs/provision_vm.conf','w') as f:
    f.write(provision_config)

# Copy the new provisio_vm.conf to the confs folder in installer vm
paramiko_helpers.copy_file(client,'/root/Contrail_Service_Orchestration_3.3.1/confs/provision_vm.conf',installervmip)

# Run the interactive setup_assist
paramiko_helpers.run_interactive_setup_assist(client,dict)

# Run the micro/infra services scripts
paramiko_helpers.run_micro_infra_services()

# Send Email Notification that the CSO Installation is COMPLETE
helpers.email_notification(email_address)


