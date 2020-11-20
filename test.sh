#!/bin/bash

echo "download & install sfdx ...."
wget https://developer.salesforce.com/media/salesforce-cli/sfdx-linux-amd64.tar.xz
mkdir sfdx
tar xJf sfdx-linux-amd64.tar.xz -C sfdx --strip-components 1
./sfdx/install


rm -rf deployment temp
mkdir deployment temp

echo "prepare the files to be deployed..."
git diff --name-status $START_COMMIT HEAD | grep -v "^D" |  awk -F'\t' '{print $NF}' > temp/diff_raw.txt
sed -E -nf ./build/diff.sed temp/diff_raw.txt | sort | uniq > temp/changedFiles.txt

if [ ! -s temp/changedFiles.txt ]; then 
  echo "no deployment changes"
  exit 1;
fi
  

cp build/build.xml build.xml
ant copyFiles
ls -R deployment

echo $ORG_AUTH_URL > Temp_File
sfdx force:auth:sfdxurl:store --sfdxurlfile Temp_File --setalias $ORG_NAME
sfdx force:config:set defaultusername=$ORG_NAME
sfdx force:config:set defaultdevhubusername=$ORG_NAME
rm Temp_File
if [ $CHECK_ONLY = "true" ]; then
 sfdx force:source:deploy --targetusername $ORG_NAME --sourcepath deployment/force-app/main/default --testlevel $TEST_LEVEL --checkonly
else
 sfdx force:source:deploy --targetusername $ORG_NAME --sourcepath deployment/force-app/main/default --testlevel $TEST_LEVEL
fi
