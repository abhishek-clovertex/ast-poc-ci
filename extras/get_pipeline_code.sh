#!/bin/bash
## Author : Abhishek Rana @ Clovertex (https://github.com/tech-alchemist)
## Description : Script to Read Code of Pipeline ##

source /opt/ast-poc-ci/config.ini || { echo "[-] Config File not found, See ReadMe.md" ; exit 1 ; }

PROJECT="Get_All_Pipelines"

echo "[+] Jenkins Controller = [${JENKINS_URL}], Pipeline Code for Project [${PROJECT}] is :"
echo ""
curl -sSLk  -u "${JENKINS_USR}:${JENKINS_KEY}" "${JENKINS_URL}/job/${PROJECT}/config.xml" | sed -e "s|ersion='1.1'|ersion='1.0'|g" -e "/actions/d"| xq -x "//script"
