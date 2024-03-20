#!/bin/bash
source /home/ubuntu/Scripts/KEYS.ini

PROJECT="${1}"
[[ -z "${PROJECT}" ]] && { echo "Usage : $0 <repo name>" ; exit 1 ; }


[[ "${PROJECT,,}" == "csv" ]] && {


	for i in $(cat /home/ubuntu/OnBoarding.csv | sed '/^REPO/d')
	do 
		PROJECT="${i}"
		echo "Onboading From CSV/XLS"
		REPO_URL="git@github.com:abhishek-clovertex/${PROJECT}.git"
		cd /home/ubuntu/Projects && git clone ${REPO_URL} ${PROJECT}
curl -sSLk -u "${SONAR_KEY}:" -X POST "${SONAR_URL}/api/projects/create?name=${PROJECT}&project=${PROJECT}&visibility=private"
curl -sSLk -H "Content-Type: application/xml" -H "X-Redmine-API-Key: ${REDMINE_KEY}" -X POST ${REDMINE_URL}/projects.xml --data "<project>
  <name>${PROJECT}</name>
  <identifier>${PROJECT}</identifier>
  <enabled_module_names>time_tracking</enabled_module_names>
  <enabled_module_names>issue_tracking</enabled_module_names>
</project>"

done
} || { 

                REPO_URL="git@github.com:abhishek-clovertex/${PROJECT}.git"
                cd /home/ubuntu/Projects && git clone ${REPO_URL} ${PROJECT}

curl -sSLk -u "${SONAR_KEY}:" -X POST "${SONAR_URL}/api/projects/create?name=${PROJECT}&project=${PROJECT}&visibility=private"
curl -sSLk -H "Content-Type: application/xml" -H "X-Redmine-API-Key: ${REDMINE_KEY}" -X POST ${REDMINE_URL}/projects.xml --data "<project>
  <name>${PROJECT}</name>
  <identifier>${PROJECT}</identifier>
  <enabled_module_names>time_tracking</enabled_module_names>
  <enabled_module_names>issue_tracking</enabled_module_names>
</project>"

}

## E O F ##


