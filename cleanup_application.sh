#!/bin/bash
## Author : Abhishek Rana @ Clovertex (https://github.com/tech-alchemist)
## Description : Script to cleanUp AST env for specific repo ##

source /opt/ast-ci-poc/config.ini
PROJECT="${1}" ; [[ -z "${PROJECT}" ]] && { echo "Usage : $0 <repo name>" ; exit 1 ; }

echo "[-] Deleting ${PROJECT} From SonarQube"
curl -sSLk -u "${SONAR_KEY}:" -X POST "${SONAR_URL}/api/projects/delete?project=${PROJECT}"
echo "[-] Deleting ${PROJECT} from Task Mgmt System"
curl -sSLk -H "Content-Type: application/xml" -H "X-Redmine-API-Key: ${REDMINE_KEY}" -X DELETE ${REDMINE_URL}/projects/${PROJECT}.xml
echo "[-] Deleting ${PROJECT} from AST Space"
rm -rf ${PROJECT_DIR}/${PROJECT}

## E O F ##

