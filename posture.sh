#!/bin/bash
## Author : Abhishek Rana @ Clovertex (https://github.com/tech-alchemist)
## Description : Script to Evaluate Security Posture ##

source /opt/ast-poc-ci/config.ini || { echo "[-] Config File not found, See ReadMe.md" ; exit 1 ; }
PROJECT="${1}" ; [[ -z "${PROJECT}" ]] && { echo "Usage : $0 <repo name>" ; exit 1 ; }

ISSUES=$(curl -sSLk -u "${SONAR_KEY}:" "${SONAR_URL}/api/issues/search?componentKeys=${PROJECT}&severities=${CVE_BLOCKER}&ps=100&p=1" | jq -r .total)
echo "Found ${ISSUES} ${CVE_BLOCKER} Vulnerabilities for ${PROJECT}"

## E O F ##