#!/bin/bash
## Author : Abhishek Rana @ Clovertex (https://github.com/tech-alchemist)
## Description : Sonar Server Reload Script ##

[[ "$(id -u)" == "0" ]] || { echo "Run with sudo" ; exit 1 ; }
sudo -u sonar bash /opt/sonarqube/bin/linux-x86-64/sonar.sh stop
sleep 4
sudo -u sonar bash /opt/sonarqube/bin/linux-x86-64/sonar.sh start
sleep 1
sudo -u sonar bash /opt/sonarqube/bin/linux-x86-64/sonar.sh status
exit 0
## E O F ##
