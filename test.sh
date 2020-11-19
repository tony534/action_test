#!/bin/bash
echo "bash test...."
wget https://developer.salesforce.com/media/salesforce-cli/sfdx-linux-amd64.tar.xz
mkdir sfdx
tar xJf sfdx-linux-amd64.tar.xz -C sfdx --strip-components 1
./sfdx/install
sfdx help force

echo "######"
echo $FIRST_NAME

a1=zhangsan
zhangsan_a2=lisi
test_name=${a1}_a2
echo "$$$$$"
echo ${!test_name}