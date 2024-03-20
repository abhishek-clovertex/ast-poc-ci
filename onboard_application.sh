#!/bin/bash
## Author : Abhishek Rana @ Clovertex (https://github.com/tech-alchemist)
## Description : Script to Onboard AST for speciifc repo or csv based repos ##

source /opt/ast-poc-ci/config.ini || { echo "[-] Config File not found, See ReadMe.md" ; exit 1 ; }
PROJECT="${1}" ; [[ -z "${PROJECT}" ]] && { echo "Usage : $0 <repo name>" ; exit 1 ; }

onboard_project(){
  PROJECT_NAME="${1}"
  echo "[+] Onboarding ${PROJECT_NAME}"
  REPO_URL="git@github.com:abhishek-clovertex/${PROJECT_NAME}.git"
  echo "[+] Cloning ${PROJECT_NAME} into AST Space from ${REPO_URL}"
  cd ${PROJECT_DIR} && git clone ${REPO_URL} ${PROJECT_NAME}
  echo "[+] Creating Sonarqube Project for ${PROJECT_NAME}"
  curl -sSLk -u "${SONAR_KEY}:" -X POST "${SONAR_URL}/api/projects/create?name=${PROJECT_NAME}&project=${PROJECT_NAME}&visibility=private"
  echo "[+] Creating Tasks Project for ${PROJECT_NAME}"
  curl -sSLk -H "Content-Type: application/xml" -H "X-Redmine-API-Key: ${REDMINE_KEY}" -X POST ${REDMINE_URL}/projects.xml --data "<project>
    <name>${PROJECT_NAME}</name>
    <identifier>${PROJECT_NAME}</identifier>
    <enabled_module_names>time_tracking</enabled_module_names>
    <enabled_module_names>issue_tracking</enabled_module_names>
  </project>"
}

[[ "${PROJECT,,}" == "csv" ]] && {
  echo "[+] Parsing XLS/CSV"
	for i in $(cat ${ONBOARD_CSV} | sed '/^REPO/d')
	do 
    onboard_project ${i}
  done
} || { 
  onboard_project ${PROJECT}
}

## E O F ##


