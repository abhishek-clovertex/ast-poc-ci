#!/bin/bash

source /home/ubuntu/Scripts/KEYS.ini

PROJECT="${1}"
[[ -z "${PROJECT}" ]] && { echo "Usage : $0 <repo name>" ; exit 1 ; }

MAJOR=$(curl -sSLk -u "${SONAR_KEY}:" "${SONAR_URL}/api/issues/search?componentKeys=${PROJECT}&severities=MAJOR&ps=100&p=1" | jq -r .total)
echo $MAJOR
