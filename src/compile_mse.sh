#!/bin/bash

mseroot=./mseide-msegui
funits=`readlink -n -f -s ./units/`
exeout=`readlink -n -f -s ./`

     pushd $mseroot
     fpc -B -Xs- -Ow -FWo.opt -OWAll -CfSSE64 -Cg -FU$funits -Fu./lib/common/* -Fu./lib/common/kernel/linux -CX -XX -O2 -Mobjfpc ./apps/ide/mseide.pas -FE$exeout
#fpc -Xs- -Ow -FWo.opt -OWAll -CfSSE64 -Cg -FU$funits  -dmse_no_db -Fu./lib/common/* -Fu./lib/common/ifi/* -Fu./lib/common/kernel/linux -CX -XX -O2 -Mobjfpc ./apps/ide/mseide.pas -FE$exeout
     if [ "$?" != "0" ]
     then
          echo 'Compiling error - update FAILED :('
          popd
          exit
     fi
     popd

echo 'All OK :)'
