#!/bin/bash
## Sonar Scan Script 
## Author : Abhishek Rana (TechAlchemist) ##

##### Settings #####
source /home/ubuntu/Scripts/KEYS.ini

scanner="/home/ubuntu/Scripts/sonar-scanner-cli/bin/sonar-scanner"
space="/home/ubuntu/Projects/"
LOG_DIR="/home/ubuntu/Scripts/logs"

##### Mains #####
helpy2(){ echo "[+] Usage: $0 <language> <repo name>" ; echo "    Where <language> == js , python , php" ; }

[[ -z "$1" ]] || [[ -z "$2" ]] && helpy2 && exit 1

dirpath="$2"
LANG="${1,,}"

PROJECT="$(basename ${dirpath})"

let cnt

[[ ! -f "${scanner}" ]] && { echo "[-] Scanner wasn't found." ; exit 1 ; }

[[ ${LANG} == "js" ]] && {
 INC="**.js,**.css,**.ejs,**.html,**.sh,**.md,**.less,**.sass"
 EXC="**/node_modules/**,**/bower_components/***"
}
[[ ${LANG} == "php" ]] && {
 INC="**.js,**.css,**.ejs,**.html,**.sh,**.md,**.less,**.sass"
 EXC="**/node_modules/**,**/bower_components/***"
}
[[ ${LANG} == "python" ]] && {
 INC="**.js,**.css,**.ejs,**.html,**.sh,**.md,**.less,**.sass"
 EXC="**/node_modules/**,**/bower_components/***"
}

[[ ! -d "${space}/${PROJECT}" ]] && { echo "[-] No Such Project @ ${space}/${PROJECT}." ; exit 1 ; } || {
	pushd ${space}/${PROJECT}
	repo="$(git config remote.origin.url|head -1|rev|cut -d '/' -f1|rev|sed 's|.git||g')"
	branch="$(git branch | grep "*"| awk '{print $2}')"
	[[ -z "$repo" ]] && [[ -z "$branch" ]] && { 
		echo "[+] [$project] is not a cloned Project"
		echo "    Clone this properly via git & run this utility from repository directory."
		exit 1
	}

}

git pull

${scanner} \
  -Dsonar.projectKey="${PROJECT}" \
  -Dsonar.projectName="${PROJECT} [${branch}]" \
  -Dsonar.sources=. \
  -Dsonar.host.url=${SONAR_URL} \
  -Dsonar.login=${SONAR_KEY} \
  -Dsonar.inclusions="${INC}" \
  -Dsonar.exclusions="${EXC}" \
  -Dsonar.buildString="${cnt}" \
  -Dsonar.sourceEncoding="UTF-8" && echo "[+] Report ${cnt} Submitted to : ${SONAR_URL}/dashboard/index/${PROJECT}" 

sleep 10

ISSUES=$(curl -sSLk -u "${SONAR_KEY}:" "${SONAR_URL}/api/issues/search?componentKeys=${PROJECT}&severities=${CVE_BLOCKER}&ps=100&p=1" | jq -r .total)
[[ ${ISSUES} != 0 ]] && { 
echo "[-] AST Stage triggering Pipeline FAILURE, Found ${ISSUES} ${CVE_BLOCKER} Security Vulnerabilities" 
curl -sSLk -H "Content-Type: application/xml" -H "X-Redmine-API-Key: ${REDMINE_KEY}" -X POST ${REDMINE_URL}/issues.xml --data "<?xml version='1.0' ?> <issue>
<project_id>${PROJECT}</project_id>
<status_id>1</status_id>
<priority_id>3</priority_id>
<tracker_id>1</tracker_id>
<subject>AST Pipeline Failed | Found Open ${ISSUES} ${CVE_BLOCKER} Vulnerabilities, Deployment Failed</subject>
<description>We Have Found ${ISSUES} ${CVE_BLOCKER} Vulnerabilities in open stage. Please get Them fixed with the team. You can view all details of vulnerabilities at ${SONAR_URL}/project/issues?resolved=false&amp;severities=${CVE_BLOCKER}&amp;id=${PROJECT}</description>
<estimated_hours>33</estimated_hours>
</issue>"
exit 1 
} || {
echo "[+] AST Stage PASSED, Found ${ISSUES} ${CVE_BLOCKER} Security Vulnerabilities" 
exit 0
}

# EOF #
