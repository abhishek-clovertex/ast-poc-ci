#!/bin/bash
## Author : Abhishek Rana @ Clovertex (https://github.com/tech-alchemist)
## Description : Script to Scan a Repo From SonarQube ##

source /opt/ast-ci-poc/config.ini

LOG_DIR="${AST_CI_DIR}/logs"
helpy1(){ echo "[+] Usage: $0 <language> <repo name>" ; echo "    Where <language> == js , python , php, java" ; }
[[ -z "$1" ]] || [[ -z "$2" ]] && helpy1 && exit 1

DIR_PATH="$2"
LANG="${1,,}"

PROJECT="$(basename ${DIR_PATH})"

let CNT

[[ ! -f "${SONAR_SCANNER_CLI_PATH}" ]] && { 
  echo "[!] Scanner wasn't found." 
  echo "[+] Downloading & Configuring The Scanner in Build Environment..."
  wget -c "${SONAR_SCANNER_CLI_URL}" -O /tmp/sonar_scan.zip
  cd /tmp && unzip unzip sonar_scan.zip && rm -f sonar_scan.zip 
  sudo mv sonar-scanner-* ${AST_CI_DIR}/tools/sonar-scanner-cli
}

[[ ${LANG} == "js" ]] && {
 INC="**.js,**.css,**.ejs,**.html,**.sh,**.md,**.less,**.sass"
 EXC="**/node_modules/**,**/bower_components/***"
}
[[ ${LANG} == "php" ]] && {
 INC="**.js,**.css,**.ejs,**.html,**.sh,**.md,**.php**"
 EXC="**/vendor/**,**/cache/***"
}
[[ ${LANG} == "python" ]] && {
 INC="**.py,**.css,**,**.html,**.sh,**.md,**.less,**.sass"
 EXC="**/.pyc**,**/.venv/***"
}

[[ ! -d "${PROJECT_DIR}/${PROJECT}" ]] && { echo "[-] Project Not Onboarded @ ${PROJECT_DIR}/${PROJECT}." ; exit 1 ; } || { cd ${PROJECT_DIR}/${PROJECT} ; git pull ; }

${SONAR_SCANNER_CLI_PATH} \
  -Dsonar.projectKey="${PROJECT}" \
  -Dsonar.projectName="${PROJECT} [${branch}]" \
  -Dsonar.sources=. \
  -Dsonar.host.url=${SONAR_URL} \
  -Dsonar.login=${SONAR_KEY} \
  -Dsonar.inclusions="${INC}" \
  -Dsonar.exclusions="${EXC}" \
  -Dsonar.buildString="${CNT}" \
  -Dsonar.sourceEncoding="UTF-8" && echo "[+] Report ${CNT} Submitted to : ${SONAR_URL}/dashboard/index/${PROJECT}" 

sleep 10

ISSUES=$(curl -sSLk -u "${SONAR_KEY}:" "${SONAR_URL}/api/issues/search?componentKeys=${PROJECT}&severities=${CVE_BLOCKER}&ps=100&p=1" | jq -r .total)
HOURS="33"
[[ ${ISSUES} != 0 ]] && { 
echo "[-] AST Stage triggering Pipeline FAILURE, Found ${ISSUES} ${CVE_BLOCKER} Vulnerabilities" 
curl -sSLk -H "Content-Type: application/xml" -H "X-Redmine-API-Key: ${REDMINE_KEY}" -X POST ${REDMINE_URL}/issues.xml --data "<?xml version='1.0' ?> <issue>
<project_id>${PROJECT}</project_id>
<status_id>1</status_id>
<priority_id>3</priority_id>
<tracker_id>1</tracker_id>
<subject>AST Pipeline Failed | Found Open ${ISSUES} ${CVE_BLOCKER} Vulnerabilities | ${HOURS} Effort</subject>
<description>We Have Found ${ISSUES} ${CVE_BLOCKER} Vulnerabilities in open stage. Please get them fixed with the team. You can view all details of vulnerabilities at ${SONAR_URL}/project/issues?resolved=false&amp;severities=${CVE_BLOCKER}&amp;id=${PROJECT}</description>
<estimated_hours>${HOURS}</estimated_hours>
</issue>"
exit 1 
} || {
echo "[+] AST Stage PASSED, Found ${ISSUES} ${CVE_BLOCKER} Vulnerabilities" 
exit 0
}

# EOF #
