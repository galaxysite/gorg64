#!/bin/bash

mkdir -p ./units/
fpc -O2 -XX -CX -Cg ver.pas
./ver

fpc -B -Xs- -Ow -FWo.opt -OWAll -Cg -CfSSE64 -FU./units/ -Fu./  -Fu./mseide-msegui/lib/common/* -Fu./mseide-msegui/lib/common/kernel/linux -CX -XX -O2 -Mobjfpc gorg64.pas
fpc -Xs- -Ow -FWo.opt -OWAll -Cg -CfSSE64 -CX -XX -O2 -Mobjfpc gorg64_spktone.pas
fpc -B -Xs- -Ow -FWo.opt -OWAll -Cg -CfSSE64 -CX -XX -O2 -Mobjfpc gorg64_runner.pas
fpc -Xs- -Ow -FWo.opt -OWAll -Cg -CfSSE64 -CX -XX -O2 -Mobjfpc gorg64_spkplay.pas
fpc -Xs- -Ow -FWo.opt -OWAll -Cg -CfSSE64 -CX -XX -O2 -Mobjfpc gorg64_spkon.pas
fpc -Xs- -Ow -FWo.opt -OWAll -Cg -CfSSE64 -CX -XX -O2 -Mobjfpc gorg64_spkoff.pas