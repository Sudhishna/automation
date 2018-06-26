#!/bin/bash
# CSO 3.3.1 INSTALLATION
# Command example ./cso-setup.sh

HOME_DIR=/root/
DATA_PATH=$HOME_DIR/data/cso-data.txt
echo "" > $DATA_PATH

echo ""
echo " **************************************************"
echo "          CSO SERVER DEPLOYMENT PROCESS"
echo " **************************************************"
echo ""
read -p "Enter CSO Host Server Name: " temphostname
hostname=${temphostname:-$hostname}
read -p "Enter CSO Host Server IP Address (x.x.x.x/x): " tempcsoip
csoip=${tempcsoip:-$csoip}
read -p "Enter DNS Server IP Address (x.x.x.x): " tempdns
dns=${tempdns:-$dns}
read -p "Enter NTP Server IP Address (x.x.x.x): " tempntp
ntp=${tempntp:-$ntp}
read -p "Enter Gateway IP Address (x.x.x.x): " tempgw
gw=${tempgw:-$gw}
read -p "Enter the subnet where all CSO VMs reside (x.x.x.x/x): " tempcso_vm_subnet
cso_vm_subnet=${tempcso_vm_subnet:-$cso_vm_subnet}
read -s -p "Enter CSO Host Server Password: " temppassword
password=${temppassword:-$password}
echo ""
read -p "Enter CSP Central Infravm IP Address (x.x.x.x/x): " tempcentralinfravmip
centralinfravmip=${tempcentralinfravmip:-$centralinfravmip}
read -p "Enter CSP Central Msvm IP Address (x.x.x.x/x): " tempcentralmsvmip
centralmsvmip=${tempcentralmsvmip:-$centralmsvmip}
read -p "Enter CSP Central k8mastervm IP Address (x.x.x.x/x): " tempcentralk8mastervmip
centralk8mastervmip=${tempcentralk8mastervmip:-$centralk8mastervmip}
read -p "Enter CSP Regional Infravm IP Address (x.x.x.x/x): " tempregionalinfravmip
regionalinfravmip=${tempregionalinfravmip:-$regionalinfravmip}
read -p "Enter CSP Regional Msvm IP Address (x.x.x.x/x): " tempregionalmsvmip
regionalmsvmip=${tempregionalmsvmip:-$regionalmsvmip}
read -p "Enter CSP Regional k8mastervm IP Address (x.x.x.x/x): " tempregionalk8mastervmip
regionalk8mastervmip=${tempregionalk8mastervmip:-$regionalk8mastervmip}
read -p "Enter CSP Installervm IP Address (x.x.x.x/x): " tempinstallervmip
installervmip=${tempinstallervmip:-$installervmip}
read -p "Enter CSP Regional Sblb IP Address (x.x.x.x/x): " tempregionalsblbip
regionalsblbip=${tempregionalsblbip:-$regionalsblbip}
read -p "Enter CSP Contrailanalytics IP Address (x.x.x.x/x): " tempcontrailanalyticsip
contrailanalyticsip=${tempcontrailanalyticsip:-$contrailanalyticsip}
read -p "Enter CSP Vrrvm IP Address (x.x.x.x/x): " tempvrrvmip
vrrvmip=${tempvrrvmip:-$vrrvmip}
echo ""

installervm_ip=$installervmip
deployment_environment="trial"
CSO_behind_NAT="n"
Timezone="America/Los_Angeles"
ntp_servers=$ntp
HA_deployment="n"
CSO_certificate_validity="999"
TLS_mode_of_authentication="y"
separate_VMs_for_kubernetes="y"
Email_Address_for_cspadmin_user="juniperse@juniper.net"
name_of_CSO_Customer_Portal="centralmsvm.example.net"
name_of_CSO_Admin_Portal="centralmsvm.example.net"
external_keystone="n"
Number_of_VRR="1"
VRR_behind_NA="n"
VRR_instances_use_the_same_username_and_password="y"
username_for_VRR="root"
password_for_VRR="passw0rd"
VRR_Public_IP=$vrrvmip
redundancy_group="0"
subnet_where_all_CSO_VMs_reside=$cso_vm_subnet
central_Number_of_replicas_of_each_microservice="1"
regional_Number_of_replicas_of_each_microservice="1"

while true; do
  echo ""
  echo ""
  echo " ********************************************"
  echo "           CSO HOST DETAILS"
  echo " ********************************************"
  echo ""
  echo " * CSO HOST NAME     : $hostname"
  echo ""
  echo " * CSO HOST IP       : $csoip"
  echo ""
  echo " * PASSWORD          : ************"
  echo ""
  echo " * DNS SERVER        : $dns"
  echo ""
  echo " * NTP SERVER        : $ntp"
  echo ""
  echo " * GATEWAY           : $gw"
  echo ""
  echo " * CSO_VM_SUBNET     : $cso_vm_subnet"
  echo ""
  echo ""
  echo " ********************************************"
  echo "           CSO VM DETAILS"
  echo " ********************************************"
  echo ""
  echo " * CENTRAL INFRAVM IP     : $centralinfravmip"
  echo ""
  echo " * CENTRAL MSVM IP        : $centralmsvmip"
  echo ""
  echo " * CENTRAL K8MASTERVM IP  : $centralk8mastervmip"
  echo ""
  echo " * REGIONAL INFRAVM IP    : $regionalinfravmip"
  echo ""
  echo " * REGIONAL MSVM IP       : $regionalmsvmip"
  echo ""
  echo " * REGIONAL K8MASTERVM IP : $regionalk8mastervmip"
  echo ""
  echo " * INSTALLER VM IP        : $installervmip"
  echo ""
  echo " * REGIONAL SBLB IP       : $regionalsblbip"
  echo ""
  echo " * CONTRAIL ANALYTICS IP  : $contrailanalyticsip"
  echo ""
  echo " * VRR VM IP              : $vrrvmip"
  echo ""
  echo ""
  echo " ********************************************"
  echo "           SETUP ASISST DETAILS"
  echo " ********************************************"
  echo ""
  echo " * INSTALLERVM_IP                                   : $installervm_ip"
  echo ""
  echo " * DEPLOYMENT_ENVIRONMENT                           : $deployment_environment"
  echo ""
  echo " * CSO_BEHIND_NAT                                   : $CSO_behind_NAT"
  echo ""
  echo " * TIMEZONE                                         : $Timezone"
  echo ""
  echo " * NTP_SERVERS                                      : $ntp_servers"
  echo ""
  echo " * HA_DEPLOYMENT                                    : $HA_deployment"
  echo ""
  echo " * CSO_CERTIFICATE_VALIDITY                         : $CSO_certificate_validity"
  echo ""
  echo " * TLS_MODE_OF_AUTHENTICATION                       : $TLS_mode_of_authentication" 
  echo ""
  echo " * SEPARATE_VMS_FOR_KUBERNETES                      : $separate_VMs_for_kubernetes" 
  echo ""
  echo " * EMAIL_ADDRESS_FOR_CSPADMIN_USER                  : $Email_Address_for_cspadmin_user" 
  echo ""
  echo " * NAME_OF_CSO_CUSTOMER_PORTAL                      : $name_of_CSO_Customer_Portal"
  echo ""
  echo " * NAME_OF_CSO_ADMIN_PORTAL                         : $name_of_CSO_Admin_Portal"
  echo ""
  echo " * EXTERNAL_KEYSTONE                                : $external_keystone"
  echo ""
  echo " * NUMBER_OF_VRR                                    : $Number_of_VRR"
  echo ""
  echo " * VRR_BEHIND_NA                                    : $VRR_behind_NA"
  echo ""
  echo " * VRR_INSTANCES_USE_THE_SAME_USERNAME_AND_PASSWORD : $VRR_instances_use_the_same_username_and_password"
  echo ""
  echo " * USERNAME_FOR_VRR                                 : $username_for_VRR"
  echo ""
  echo " * PASSWORD_FOR_VRR                                 : $password_for_VRR"
  echo ""
  echo " * VRR_PUBLIC_IP                                    : $VRR_Public_IP"
  echo ""
  echo " * REDUNDANCY_GROUP                                 : $redundancy_group"
  echo ""
  echo " * SUBNET_WHERE_ALL_CSO_VMS_RESIDE                  : $subnet_where_all_CSO_VMs_reside"
  echo ""
  echo " * CENTRAL_NUMBER_OF_REPLICAS_OF_EACH_MICROSERVICE  : $central_Number_of_replicas_of_each_microservice"
  echo ""
  echo " * REGIONAL_NUMBER_OF_REPLICAS_OF_EACH_MICROSERVICE : $regional_Number_of_replicas_of_each_microservice"
  echo ""

  read -p ' Confirm above details (Y?N) ? ' choice
  case $choice in
        [Yy]* ) break;;
        [Nn]* )
          echo ""
          echo ""
          echo "Enter new values, or press enter to accept default values"
          echo "********************************************************"
          echo "TARGET MACHINE DETAILS: "
          #read -p " Enter CSO Hostname ($hostname): " temp
          hostname=${temp:-$hostname}
          read -p " Enter CSO IP ($csoip): " temp
          csoip=${temp:-$csoip}
          read -p " Enter PASSWORD ($password): " temp
          password=${temp:-$password}
          read -p " Enter DNS SERVER ($dns): " temp
          dns=${temp:-$dns}
          read -p " Enter GATEWAY ($gw): " temp
          gw=${temp:-$gw}
          read -p " Enter NTP SERVER ($ntp): " temp
          ntp=${temp:-$ntp}
          read -p " Enter the subnet where all CSO VMs reside ($cso_vm_subnet): " temp
          cso_vm_subnet=${temp:-$cso_vm_subnet}
          echo ""
          read -p " Enter CENTRAL INFRAVM IP ($centralinfravmip): " temp
          centralinfravmip=${temp:-$centralinfravmip}
          read -p " Enter CENTRAL MSVM IP ($centralmsvmip): " temp
          centralmsvmip=${temp:-$centralmsvmip}
          read -p " Enter CENTRAL K8MASTERVM IP ($centralk8mastervmip): " temp
          centralk8mastervmip=${temp:-$centralk8mastervmip}
          read -p " Enter REGIONAL INFRAVM IP ($regionalinfravmip): " temp
          regionalinfravmip=${temp:-$regionalinfravmip}
          read -p " Enter REGIONAL MSVM IP ($regionalmsvmip): " temp
          regionalmsvmip=${temp:-$regionalmsvmip}
          read -p " Enter REGIONAL K8MASTERVM IP ($regionalk8mastervmip): " temp
          regionalk8mastervmip=${temp:-$regionalk8mastervmip}
          read -p " Enter INSTALLER VM IP ($installervmip): " temp
          installervmip=${temp:-$installervmip}
          read -p " Enter REGIONAL SBLB IP ($regionalsblbip): " temp
          regionalsblbip=${temp:-$regionalsblbip}
          read -p " Enter CONTRAIL ANALYTICS IP ($contrailanalyticsip): " temp
          contrailanalyticsip=${temp:-$contrailanalyticsip}
          read -p " Enter VRR VM IP ($vrrvmip): " temp
          vrrvmip=${temp:-$vrrvmip}
          echo ""
          read -p " Enter INSTALLERVM_IP ($installervm_ip): " temp
          installervm_ip=${temp:-$installervm_ip}
          read -p " Enter DEPLOYMENT_ENVIRONMENT  ($deployment_environment): " temp
          deployment_environment=${temp:-$deployment_environment}
          read -p " Enter CSO_BEHIND_NAT ($CSO_behind_NAT): " temp
          CSO_behind_NAT=${temp:-$CSO_behind_NAT}
          read -p " Enter TIMEZONE ($Timezone): " temp
          Timezone=${temp:-$Timezone}
          read -p " Enter NTP_SERVERS  ($ntp_servers): " temp
          ntp_servers=${temp:-$ntp_servers}
          read -p " Enter HA_DEPLOYMENT : ($HA_deployment): " temp
          HA_deployment=${temp:-$HA_deployment}
          read -p " Enter CSO_CERTIFICATE_VALIDITY  ($CSO_certificate_validity): " temp
          CSO_certificate_validity=${temp:-$CSO_certificate_validity}
          read -p " Enter TLS_MODE_OF_AUTHENTICATION  ($TLS_mode_of_authentication): " temp
          TLS_mode_of_authentication=${temp:-$TLS_mode_of_authentication}
          read -p " Enter SEPARATE_VMS_FOR_KUBERNETES ($separate_VMs_for_kubernetes): " temp
          separate_VMs_for_kubernetes=${temp:-$separate_VMs_for_kubernetes}
          read -p " Enter EMAIL_ADDRESS_FOR_CSPADMIN_USER  ($Email_Address_for_cspadmin_user): " temp
          Email_Address_for_cspadmin_user=${temp:-$Email_Address_for_cspadmin_user}
          read -p " Enter NAME_OF_CSO_CUSTOMER_PORTAL ($name_of_CSO_Customer_Portal): " temp
          name_of_CSO_Customer_Portal=${temp:-$name_of_CSO_Customer_Portal}
          read -p " Enter NAME_OF_CSO_ADMIN_PORTAL  ($name_of_CSO_Admin_Portal): " temp
          name_of_CSO_Admin_Portal=${temp:-$name_of_CSO_Admin_Portal}
          read -p " Enter EXTERNAL_KEYSTONE ($external_keystone): " temp
          external_keystone=${temp:-$external_keystone}
          read -p " Enter NUMBER_OF_VRR  ($Number_of_VRR): " temp
          Number_of_VRR=${temp:-$Number_of_VRR}
          read -p " Enter VRR_BEHIND_NA  ($VRR_behind_NA): " temp
          VRR_behind_NA=${temp:-$VRR_behind_NA}
          read -p " Enter VRR_INSTANCES_USE_THE_SAME_USERNAME_AND_PASSWORD  ($VRR_instances_use_the_same_username_and_password): " temp
          VRR_instances_use_the_same_username_and_password=${temp:-$VRR_instances_use_the_same_username_and_password}
          read -p " Enter USERNAME_FOR_VRR ($username_for_VRR): " temp
          username_for_VRR=${temp:-$username_for_VRR}
          read -p " Enter PASSWORD_FOR_VRR ($password_for_VRR): " temp
          password_for_VRR=${temp:-$password_for_VRR}
          read -p " Enter VRR_PUBLIC_IP  ($VRR_Public_IP): " temp
          VRR_Public_IP=${temp:-$VRR_Public_IP}
          read -p " Enter REDUNDANCY_GROUP ($redundancy_group): " temp
          redundancy_group=${temp:-$redundancy_group}
          read -p " Enter SUBNET_WHERE_ALL_CSO_VMS_RESIDE  ($subnet_where_all_CSO_VMs_reside): " temp
          subnet_where_all_CSO_VMs_reside=${temp:-$subnet_where_all_CSO_VMs_reside}
          read -p " Enter CENTRAL_NUMBER_OF_REPLICAS_OF_EACH_MICROSERVICE ($central_Number_of_replicas_of_each_microservice): " temp
          central_Number_of_replicas_of_each_microservice=${temp:-$central_Number_of_replicas_of_each_microservice}
          read -p " Enter REGIONAL_NUMBER_OF_REPLICAS_OF_EACH_MICROSERVICE  ($regional_Number_of_replicas_of_each_microservice): " temp
          regional_Number_of_replicas_of_each_microservice=${temp:-$regional_Number_of_replicas_of_each_microservice}

          clea_
          ;;
        * ) echo "Please answer y or n";;
    esac
done

echo "hostname:$hostname" >> $DATA_PATH
echo "csoip:$csoip" >> $DATA_PATH
echo "dns:$dns" >> $DATA_PATH
echo "ntp:$ntp" >> $DATA_PATH
echo "gw:$gw" >> $DATA_PATH
echo "password:$password" >> $DATA_PATH
echo "cso_vm_subnet:$cso_vm_subnet" >> $DATA_PATH
echo " ********************************************" >> $DATA_PATH
echo "centralinfravmip:$centralinfravmip" >> $DATA_PATH
echo "centralmsvmip:$centralmsvmip" >> $DATA_PATH
echo "centralk8mastervmip:$centralk8mastervmip" >> $DATA_PATH
echo "regionalinfravmip:$regionalinfravmip" >> $DATA_PATH
echo "regionalmsvmip:$regionalmsvmip" >> $DATA_PATH
echo "regionalk8mastervmip:$regionalk8mastervmip" >> $DATA_PATH
echo "installervmip:$installervmip" >> $DATA_PATH
echo "regionalsblbip:$regionalsblbip" >> $DATA_PATH
echo "contrailanalyticsip:$contrailanalyticsip" >> $DATA_PATH
echo "vrrvmip:$vrrvmip" >> $DATA_PATH
echo " ********************************************" >> $DATA_PATH
echo "installervm_ip:$installervmip" >> $DATA_PATH
echo "deployment_environment:$deployment_environment" >> $DATA_PATH
echo "CSO_behind_NAT:$CSO_behind_NAT" >> $DATA_PATH
echo "Timezone:$Timezone" >> $DATA_PATH
echo "ntp_servers:$ntp" >> $DATA_PATH
echo "HA_deployment:$HA_deployment" >> $DATA_PATH
echo "CSO_certificate_validity:$CSO_certificate_validity" >> $DATA_PATH
echo "TLS_mode_of_authentication:$TLS_mode_of_authentication" >> $DATA_PATH
echo "separate_VMs_for_kubernetes:$separate_VMs_for_kubernetes" >> $DATA_PATH
echo "Email_Address_for_cspadmin_user:$Email_Address_for_cspadmin_user" >> $DATA_PATH
echo "name_of_CSO_Customer_Portal:$name_of_CSO_Customer_Portal" >> $DATA_PATH
echo "name_of_CSO_Admin_Portal:$name_of_CSO_Admin_Portal" >> $DATA_PATH
echo "external_keystone:$external_keystone" >> $DATA_PATH
echo "Number_of_VRR:$Number_of_VRR" >> $DATA_PATH
echo "VRR_behind_NA:$VRR_behind_NA" >> $DATA_PATH
echo "VRR_instances_use_the_same_username_and_password:$VRR_instances_use_the_same_username_and_password" >> $DATA_PATH
echo "username_for_VRR:$username_for_VRR" >> $DATA_PATH
echo "password_for_VRR:$password_for_VRR" >> $DATA_PATH
echo "VRR_Public_IP:$vrrvmip" >> $DATA_PATH
echo "redundancy_group:$redundancy_group" >> $DATA_PATH
echo "subnet_where_all_CSO_VMs_reside:$cso_vm_subnet" >> $DATA_PATH
echo "central_Number_of_replicas_of_each_microservice:$central_Number_of_replicas_of_each_microservice" >> $DATA_PATH
echo "regional_Number_of_replicas_of_each_microservice:$regional_Number_of_replicas_of_each_microservice" >> $DATA_PATH

while true; do
echo ""
echo " ********************************************"
echo ""
read -p ' PROCEED WITH THE CSO SETUP?? (Y/n) ' choice
  case $choice in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y or n";;
    esac
done

echo ""
echo ""
echo "##############################################################"
echo "                     CSO INSTALLATION BEGINS"
echo "##############################################################"
echo ""
echo ""

