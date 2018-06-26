import paramiko
import time
import re

class Paramiko_Helpers:
    """
    Collection of Paramiko Helper functions that will be used for
    CSO Installation
    """

    def create_paramiko_client(self,remote_ip):
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(remote_ip, username='root', password='passw0rd')

        return client

    def copy_file(self,clent,path_filename,remote_ip):
        print "Copying {} to {}".format(filename,remote_ip)
        source = path_filename
        destination = path_filename
        sftp = client.open_sftp()
        sftp.put(source,destination)
        sftp.close()
        print "Success"
        time.sleep(5)

    def execute_command(self,client,cmd):
        print "Extracting files from the tar file: "
        stdin, stdout, stderr = client.exec_command(cmd)
        print (stdout.read())
        print "Success"
        time.sleep(5)

    def run_interactive_setup_assist(self,client,dict):

        channel = client.invoke_shell()
        channel_data = str()
        full_data = str()

        print "Running ./setup_assist.sh script: ",

        complete = 0
        step1 = 0
        step2 = 0
        step3 = 0
        setup_assist_complete = 0
        while True:
            if channel.recv_ready():
                channel_data = channel.recv(9999)
                full_data += channel_data
                print channel_data
            else:
                continue


            ansi_escape = re.compile(r'\x1B\[[0-?]*[ -/]*[@-~]')
            channel_data = ansi_escape.sub('', channel_data)

            if channel_data.endswith('installervm:~# '):
                if step1 == 0:
                    channel.send('cd /root/Contrail_Service_Orchestration_3.3.1/\n')
                    time.sleep(2)
                    step1 += 1

            if channel_data.endswith('installervm:~/Contrail_Service_Orchestration_3.3.1# '):
                if step2 == 0:
                    channel.send('./setup_assist.sh\n')
                    time.sleep(2)
                    step2 += 1

            if re.search('Press any key to continue:$',channel_data):
                if step3 < 2:
                    channel.send('\n')
                    time.sleep(1)
                    step3 += 1

            if re.search('The installer machine IP: \[\w*.*?\]:$',channel_data):
                channel.send(dict['installervm_ip'].split("/")[0] + '\n')
                time.sleep(1)
            if re.search('The deployment environment that you want to setup. \(production/trial\) \[\w*.*?\]:$',channel_data):
                channel.send(dict['deployment_environment'] + '\n')
                time.sleep(1)
            if re.search('Is CSO behind NAT \(y/n\) \[\w*.*?\]:$',channel_data):
                channel.send(dict['CSO_behind_NAT'] + '\n')
                time.sleep(1)
            if re.search('Timezone for the servers in topology \[\w*.*?\]:$',channel_data):
                channel.send(dict['Timezone'] + '\n')
                time.sleep(1)
            if re.search('List of ntp servers \(comma seperated\) \[\w*.*?\]:$',channel_data):
                channel.send(dict['ntp_servers'] + '\n')
                time.sleep(1)
            if re.search('Do you need a HA deployment \(y/n\) \[\w*.*?\]:$',channel_data):
                channel.send(dict['HA_deployment'] + '\n')
                time.sleep(1)
            if re.search('Provide the regional region name\(s\) \(For centralized deployment,if more than one region, provide comma separated list of region names\) \[\w*.*?\]:$',channel_data):
                channel.send('\n')
                time.sleep(1)
            if re.search('CSO certificate validity \(in days\) \[\w*.*?\]:$',channel_data):
                channel.send(dict['CSO_certificate_validity'] + '\n')
                time.sleep(1)
            if re.search('Do you want to enable TLS mode of authentication between device to FMPM services\?\. \(y/n\) \[\w*.*?\]:$',channel_data):
                channel.send(dict['TLS_mode_of_authentication'] + '\n')
                time.sleep(1)
            if re.search('Do you want separate VMs for kubernetes master\? \(y/n\) \[\w*.*?\]:$',channel_data):
                channel.send(dict['separate_VMs_for_kubernetes'] + '\n')
                time.sleep(1)
            if re.search('Provide Email Address for cspadmin user \[\w*.*?\]:$',channel_data):
                channel.send(dict['Email_Address_for_cspadmin_user'] + '\n')
                time.sleep(1)
            if re.search('DNS name of CSO Customer Portal \[\w*.*?\]:$',channel_data):
                channel.send(dict['name_of_CSO_Customer_Portal'] + '\n')
                time.sleep(1)
            if re.search('DNS name of CSO Admin Portal \(can be same as Customer Portal\) \[\w*.*?\]:$',channel_data):
                channel.send(dict['name_of_CSO_Admin_Portal'] + '\n')
                time.sleep(1)


            if re.search('Do you have an external keystone \(centralized mode use case only\) \(y/n\) \[\w*.*?\]:$',channel_data):
                channel.send(dict['external_keystone'] + '\n')
                time.sleep(1)
            if re.search('Kubernetes overlay network cidr used by the microservices \[\w*.*?\]:$',channel_data):
                channel.send('\n')
                time.sleep(1)
            if re.search('Kubernetes Services overlay network range \(cidr\) used by the microservices \[\w*.*?\]:$',channel_data):
                channel.send('\n')
                time.sleep(1)
            if re.search('Kubernetes Service APIServer IP which is in above cidr range \[\w*.*?\]:$',channel_data):
                channel.send('\n')
                time.sleep(1)
            if re.search('Kubernetes Cluster DNS IP used by skydns which should be in Kubernetes Services overlay network range \[\w*.*?\]:$',channel_data):
                channel.send('\n')
                time.sleep(1)


            if re.search('Number of VRR instances \[\w*.*?\]:$',channel_data):
                channel.send(dict['Number_of_VRR'] + '\n')
                time.sleep(1)
            if re.search('Do you have VRR behind NAT \(y/n\) \[\w*.*?\]:$',channel_data):
                channel.send(dict['VRR_behind_NA'] + '\n')
                time.sleep(1)
            if re.search('Do all your VRR instances use the same username and password \[\w*.*?\]:$',channel_data):
                channel.send(dict['VRR_instances_use_the_same_username_and_password'] + '\n')
                time.sleep(1)
            if re.search('Enter the username for VRR \[\w*.*?\]:$',channel_data):
                channel.send(dict['username_for_VRR'] + '\n')
                time.sleep(1)
            if re.search('Enter the password for VRR:$',channel_data):
                channel.send(dict['password_for_VRR'] + '\n')
                time.sleep(1)
            if re.search('Confirm Password:$',channel_data):
                channel.send(dict['password_for_VRR'] + '\n')
                time.sleep(1)
            if re.search('VRR Public IP Address of instance 1 \[\w*.*?\]:$',channel_data):
                channel.send(dict['VRR_Public_IP'].split("/")[0] + '\n')
                time.sleep(1)
            if re.search('Please provide redundancy group \(0/1\) of instance 1 \[\w*.*?\]:$',channel_data):
                channel.send(dict['redundancy_group'] + '\n')
                time.sleep(1)
            if re.search('Kubernetes overlay network cidr used by the microservices \[\w*.*?\]:$',channel_data):
                channel.send('\n')
                time.sleep(1)
            if re.search('Kubernetes Services overlay network range \(cidr\) used by the microservices \[\w*.*?\]:$',channel_data):
                channel.send('\n')
                time.sleep(1)
            if re.search('Kubernetes Service APIServer IP which is in above cidr range \[\w*.*?\]:$',channel_data):
                channel.send('\n')
                time.sleep(1)
            if re.search('Kubernetes Cluster DNS IP used by skydns which should be in Kubernetes Services overlay network range \[\w*.*?\]:$',channel_data):
                channel.send('\n')
                time.sleep(1)


            if re.search('Enter the subnet where all CSO VMs reside \(network cidr\)\) \[\w*.*?\]:$',channel_data):
                channel.send(dict['subnet_where_all_CSO_VMs_reside'] + '\n')
                time.sleep(1)
            if re.search('Enter the tunnel interface unit range which can be used by cso \[\w*.*?\]:$',channel_data):
                channel.send('\n')
                time.sleep(1)
            if re.search('Enter the primary interface for all VMs \[\w*.*?\]:$',channel_data):
                channel.send('\n')
                time.sleep(1)


            if re.search('central:Number of replicas of each microservice \[\w*.*?\]:$',channel_data):
                channel.send(dict['central_Number_of_replicas_of_each_microservice'] + '\n')
                time.sleep(1)
            if re.search('regional:Number of replicas of each microservice \[\w*.*?\]:$',channel_data):
                channel.send(dict['regional_Number_of_replicas_of_each_microservice'] + '\n')
                time.sleep(1)
            if re.search('Done!',channel_data) and setup_assist_complete == 0:
                content = re.findall('PLEASE STORE ALL INFRA PASSWORDS GENERATED BELOW\w*.*?Done!',full_data,re.DOTALL)[0]
                setup_assist_complete = 1
                with open('/root/passwords.txt','w') as f:
                    f.write(content)
                break
        reuturn

    def run_micro_infra_services(self):

        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        client.connect('192.168.10.40', username='root', password='passw0rd')

        channel = client.invoke_shell()
        channel_data = str()
        full_data = str()

        print "Running services infra/micro script: "

        step1 = 0
        central_infra_services = 0
        regional_infra_services = 0
        central_micro_services = 0
        regional_micro_services = 0
        load_services_data = 0
        deployment_duration = 0
        while True:
            if channel.recv_ready():
                channel_data = channel.recv(9999)
                full_data += channel_data
                print channel_data
            else:
                continue

            ansi_escape = re.compile(r'\x1B\[[0-?]*[ -/]*[@-~]')
            channel_data = ansi_escape.sub('', channel_data)

            deployment_duration = full_data.count("Deployment duration")
            if channel_data.endswith('installervm:~# '):
                if step1 == 0:
                    channel.send('cd /root/Contrail_Service_Orchestration_3.3.1/\n')
                    step1 += 1

            if channel_data.endswith('installervm:~/Contrail_Service_Orchestration_3.3.1# '):
                if central_infra_services == 0 and deployment_duration == 0:
                    channel.send('DEPLOYMENT_ENV=central ./deploy_infra_services.sh\n')
                    central_infra_services += 1

            if channel_data.endswith('installervm:~/Contrail_Service_Orchestration_3.3.1# '):
                if central_infra_services == 1 and regional_infra_services == 0 and deployment_duration==1:
                    channel.send('DEPLOYMENT_ENV=regional ./deploy_infra_services.sh\n')
                    regional_infra_services += 1

            if channel_data.endswith('installervm:~/Contrail_Service_Orchestration_3.3.1# '):
                if central_infra_services == 1 and regional_infra_services == 1 and central_micro_services == 0 and deployment_duration ==2:
                    channel.send('DEPLOYMENT_ENV=central ./deploy_micro_services.sh\n')
                    central_micro_services += 1

            if channel_data.endswith('installervm:~/Contrail_Service_Orchestration_3.3.1# '):
                if central_infra_services == 1 and regional_infra_services == 1 and central_micro_services == 1 and regional_micro_services == 0 and deployment_duration == 3:
                    channel.send('DEPLOYMENT_ENV=regional ./deploy_micro_services.sh\n')
                    regional_micro_services += 1

            if channel_data.endswith('installervm:~/Contrail_Service_Orchestration_3.3.1# '):
                if central_infra_services == 1 and regional_infra_services == 1 and central_micro_services == 1 and regional_micro_services == 1 and load_services_data ==0 and deployment_duration == 4:
                    channel.send('./load_services_data.sh\n')
                    load_services_data += 1

            if load_services_data == 1:
                print load_services_data
                break

        reuturn

