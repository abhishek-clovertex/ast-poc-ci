#!/bin/bash
## Author : Abhishek Rana @ Clovertex (https://github.com/tech-alchemist)
## Description : Script to cleanUp AST env for specific repo ##

source /opt/ast-poc-ci/config.ini || { echo "[-] Config File not found, See ReadMe.md" ; exit 1 ; }
PROJECT="${1,,}" ; [[ -z "${PROJECT}" ]] && { echo "Usage : $0 <repo name>" ; exit 1 ; }

cleanup_project(){
    PROJECT_NAME="${1}"
    echo "[-] Deleting ${PROJECT_NAME} From SonarQube"
    curl -sSLk -u "${SONAR_KEY}:" -X POST "${SONAR_URL}/api/projects/delete?project=${PROJECT_NAME}"
    echo "[-] Deleting ${PROJECT_NAME} from Task Mgmt System"
    curl -sSLk -H "Content-Type: application/xml" -H "X-Redmine-API-Key: ${REDMINE_KEY}" -X DELETE ${REDMINE_URL}/projects/${PROJECT_NAME}.xml
    echo "[-] Deleting ${PROJECT_NAME} from AST Space"
    rm -rf ${PROJECT_DIR}/${PROJECT_NAME}
}

[[ "${PROJECT}" == "csv" ]] && {
  echo "[+] Parsing XLS/CSV"
	for i in $(cat ${ONBOARD_CSV} | sed '/^REPO/d')
	do 
    cleanup_project ${i}
  done
} || { 
  cleanup_project ${PROJECT}
}


## Cleaning Up Scanner ##

rm -rf ${AST_CI_DIR}/tools/sonar-scanner-cli/
## E O F ##
