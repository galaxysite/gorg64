#! /bin/bash

#exit

# User must be member of "src" group

mseroot=./mseide-msegui
mseurl=https://github.com/mse-org/mseide-msegui

git clone $mseurl $mseroot

if [ "$?" != "0" ]
then
pushd $mseroot
G_RESULT=`LANG=en_US.UTF8 git pull | grep "Already up to date"`
popd
    if [ "$G_RESULT" != "" ]
    then
    echo $G_RESULT
    exit
    fi
fi

echo "Update Ok :)"