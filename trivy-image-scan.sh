#!/bin/bash
#author: metbell
# trivy image scans
 #imageName="metbell/numeric-app:${GIT_COMMIT}"

echo "##############This script will be scanning the images from the build##############"
echo $imageName

docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 0 --severity LOW,MEDIUM,HIGH --light $imageName
docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 1 --severity CRITICAL --light $imageName


exit_code=$?
echo $exit_code

if [[ ${exit_code} == 1 ]]; then
    echo "Image scan failed, a vulnerability has been found"
    exit 1;
else
   echo "Image scan passed, vulnerability not found"

fi
   
   