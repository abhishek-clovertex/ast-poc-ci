#!/bin/bash
## Author : Abhishek Rana @ Clovertex (https://github.com/tech-alchemist)
## Description : Script to Fetch List of Pipelines ##

source /opt/ast-poc-ci/config.ini || { echo "[-] Config File not found, See ReadMe.md" ; exit 1 ; }

echo "[+] Jenkins Controller = [${JENKINS_URL}], List of Pipelines Are:"
echo ""

curl -sSLk  -u "${JENKINS_USR}:${JENKINS_KEY}" "${JENKINS_URL}/api/xml?tree=jobs\[name\]" | xq  -x "//name"

