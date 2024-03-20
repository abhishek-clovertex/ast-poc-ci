#!/bin/bash
source /home/ubuntu/Scripts/KEYS.ini
PROJECT="${1}"
[[ -z "${PROJECT}" ]] && { echo "Usage : $0 <repo name>" ; exit 1 ; }
curl -sSLk -u "${SONAR_KEY}:" -X POST "${SONAR_URL}/api/projects/delete?project=${PROJECT}"
curl -sSLk -H "Content-Type: application/xml" -H "X-Redmine-API-Key: ${REDMINE_KEY}" -X DELETE ${REDMINE_URL}/projects/${PROJECT}.xml
rm -rf /home/ubuntu/Projects/${PROJECT}

#curl -sSLk -u "${SONAR_KEY}:" -X POST "${SONAR_URL}/api/projects/create?name=${PROJECT}&project=${PROJECT}&visibility=private"
#curl -sSLk -H "Content-Type: application/xml" -H "X-Redmine-API-Key: ${REDMINE_KEY}" -X POST ${REDMINE_URL}/projects.xml --data "<project>
#  <name>${PROJECT}</name>
#  <identifier>${PROJECT}</identifier>
#  <enabled_module_names>time_tracking</enabled_module_names>
#  <enabled_module_names>issue_tracking</enabled_module_names>
#</project>"

## E O F ##

