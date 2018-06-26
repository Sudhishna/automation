import tarfile
import io
import os
import subprocess
import sys
import jinja2
import paramiko
import time
import re
import smtplib
from subprocess import call

class Helpers:
    """
    Collection of helper functions that will be used for
    CSO Installation 
    """

    def fetch_user_details(self):
        """
        Fetch the required details from the user by executing the 
        'cso-setup.sh' file
        """
        save = sys.stdout
        sys.stdout = open(os.devnull, 'w')
        proc = subprocess.Popen(['./cso-setup.sh'])
        proc.wait()
        sys.stdout = save

        data_file = "/root/data/cso-data.txt"
        with open(data_file) as f:
            lines = f.readlines()

        dict = {}
        for line in lines:
            if line.strip() != "" and line.strip() != "********************************************":
                print line
                key,val = line.strip().split(":")
                dict.update({key:val})

        return dict

    def untar(self, filename):
        """
        Untar the tar.gz file in the current directory
        """
        try:
            if (filename.endswith("tar.gz")):
                tar = tarfile.open(fname)
                tar.extractall()
                tar.close()
                print "Extracted in Current Directory"
            else:
                print "Not a tar.gz file: '%s '" % sys.argv[0]
                exit
        except:
            print('An error occurred trying to untar the file.')

        return 

    def load_template_config(self,dict,template_file):
        '''
        Render config based on variabled and template
        '''

        templateLoader = jinja2.FileSystemLoader(searchpath="/")
        templateEnv = jinja2.Environment(loader=templateLoader)
        template = templateEnv.get_template(template_file)

        print "Render the Configuration basd on auto-generated variables and the template"
        outputText = template.render(dict)

        return outputText

    def run_provision_vm(self):
        '''
        Run the provision_vm.sh script to provision all the CSO VMs
        '''
        save = sys.stdout
        sys.stdout = open(os.devnull, 'w')
        os.chdir('/root/Contrail_Service_Orchestration_3.3.1/')
        proc = subprocess.Popen(['./provision_vm.sh'])
        proc.wait()
        sys.stdout = save
        os.chdir('/root/')

        return


    def email_notification(self,to_email_address):

        gmail_user = 'junivator.cso@gmail.com'
        gmail_password = 'Juniper123!'

        sent_from = gmail_user
        to = [to_email_address]
        subject = 'OMG Super Important Message'
        body = 'Hey, whats up?\n\n- You'

        message = 'Subject: {}\n\n{}'.format(subject, body)

        try:
            server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
            server.ehlo()
            server.login(gmail_user, gmail_password)
            server.sendmail(sent_from, to, message)
            server.close()

            print 'Email sent!'
        except:
            print 'Something went wrong while trying to send Email!'
