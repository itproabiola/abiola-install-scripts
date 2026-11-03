#!/bin/bash
sudo apt-get update
sudo apt install openjdk-8-jdk #install java jdk.
cd /opt || exit 1
 sudo wget https://cdn.download.sonatype.com/repository/downloads-prod-group/3/nexus-3.86.0-08-linux-x86_64.tar.gz
 sudo tar -zvxf nexus-3.86.0-08-linux-x86_64.tar.gz
 sudo mv   nexus-3.86.0-08 /opt/nexus
sudo adduser nexus
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work
sudo chmod -R 775 /opt/nexus
#nexus configurations.
#sudo vi /opt/nexus/bin/nexus.rc
#run_as_user="nexus"
#starting nexus
#sudo su  -nexus

#7 CONFIGURE NEXUS TO RUN AS A SERVICE
# sudo ln -s /opt/nexus/bin/nexus /etc/init.d/nexus
# #9 Enable and start the nexus services
# sudo systemctl enable nexus
# sudo systemctl start nexus
# sudo systemctl status nexus
# echo "end of nexus installation"
#/opt/nexus/bin/nexus status
  # <server>
  #     <id>nexus</id>
     #  <username>admin</username>
 ## </server>


 #  https://www.sonatype.com/thanks/nexus-repo-download?utm_campaign=2024%3A%20Repo%20Trial%20Nurture%20-%20Post%20Form%20Fill&utm_medium=email&_hsenc=p2ANqtz-_ZTSd6g127pJVdmCL8kiCVLgU2VuPXk2i3czrh__J0WTTCU_rLoFZ2GeYqOFsExLSbgB6MLfR78GZi0dQ0Ppw3mcG6mQ&_hsmi=361072078&utm_content=361072078&utm_source=hs_automation
