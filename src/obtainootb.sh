#! /bin/bash

if [ -e ../bin/ootb/ ]
then
 echo "OOTB Already downloaded."
 exit
fi

mkdir -p ../bin/
pushd ../bin/
echo "- Downloading OOTB..."
wget https://github.com/fredvs/freepascal-ootb/releases/download/3.2.2/fpc-ootb-324-x86_64-linux_glibc225.zip
echo "- Unpack..."
unzip fpc-ootb-324-x86_64-linux_glibc225
echo "- Rename..."
mv fpc-ootb-324-x86_64-linux_glibc225 ootb
echo "- Remove .zip"
rm -f fpc-ootb-324-x86_64-linux_glibc225.zip
echo "Ok. OOTB Ready to use."
popd