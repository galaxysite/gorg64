pathootb := $(shell readlink -n -f -s ../bin/ootb)
PATH := $(PATH):$(pathootb):$(pathootb)/tools
FPC := fpc-ootb-64 -Fu$(pathootb)/units/x86_64-linux/*
gorg64: obtainmse obtainootb
	-rm -r -f ./units/
	mkdir -p ./units/
	$(FPC) -B -Cg -k-pie -k-znow -k-lc -gl -O2 -XX -CX ver.pas
	./ver
	$(FPC) -B -Cg -k-pie -k-znow -gl -FU./units/ -Fu./  -Fu./mseide-msegui/lib/common/* -Fu./mseide-msegui/lib/common/kernel/linux -CX -XX -O2 -Mobjfpc gorg64.pas
	$(FPC) -B -Cg -k-pie -k-znow -k-lc -gl -CX -XX -O2 -Mobjfpc gorg64_spktone.pas
	$(FPC) -B -Cg -k-pie -k-znow -k-lc -gl -CX -XX -O2 -Mobjfpc gorg64_runner.pas
	$(FPC) -B -Cg -k-pie -k-znow -k-lc -gl -CX -XX -O2 -Mobjfpc gorg64_spkplay.pas
	$(FPC) -B -Cg -k-pie -k-znow -k-lc -gl -CX -XX -O2 -Mobjfpc gorg64_spkon.pas
	$(FPC) -B -Cg -k-pie -k-znow -k-lc -gl -CX -XX -O2 -Mobjfpc gorg64_spkoff.pas

ootb: obtainmse obtainootb
	-rm -r -f ./units/
	mkdir -p ./units/
	$(FPC) -B -dootb -ogorg64 -FU./units/ -Fu./  -Fu./mseide-msegui/lib/common/* -Fu./mseide-msegui/lib/common/kernel/linux -XX -Xs -CX -O2 -Mobjfpc gorg64.pas
	$(FPC) -B -ogorg64_spktone -FU./units/ -XX -Xs -CX -O2 -Mobjfpc gorg64_spktone.pas
	$(FPC) -B -ogorg64_runner -FU./units/ -XX -Xs -CX -O2 -Mobjfpc gorg64_runner.pas
	$(FPC) -B -ogorg64_spkplay -FU./units/ -XX -Xs -CX -O2 -Mobjfpc gorg64_spkplay.pas
	$(FPC) -B -ogorg64_spkon -FU./units/ -XX -Xs -CX -O2 -Mobjfpc gorg64_spkon.pas
	$(FPC) -B -ogorg64_spkoff -FU./units/ -XX -Xs -CX -O2 -Mobjfpc gorg64_spkoff.pas


spkplay:
	$(FPC) -B -Cg -k-pie -k-znow -k-lc -gl -CX -XX -O2 gorg64_spkplay.pas
	$(FPC) -B -Cg -k-pie -k-znow -k-lc -gl -CX -XX -O2 gorg64_spkplay_syscalls.pas
	$(FPC) -B -Cg -k-pie -k-znow -k-lc -gl -CX -XX -O2 gorg64_spktone.pas

clean:
	-rm -f *.o *.a *.ppu *.bak gorg64_spkplay gorg64 gorg64_spkoff link*.res *.rsj gorg64_spkplay_syscalls core gorg64_spktone gorg64_spkon gorg64_runner ver *.bak1 msepatch mseguiintf.pas o.opt
	-rm -r -f ./units/
	-find ./ \( -name "o.opt" -o -name "link*.res" -o -name "*~" -o -name "*.ppu" -o -name "*.o" -o -name "*.a" -o -name "*.bak" -o -name "*.bak1" \)  -delete

suidroot:
	chown root:root gorg64_spkplay gorg64_spktone gorg64_spkon gorg64_spkoff
	chmod =04755 gorg64_spkplay gorg64_spktone gorg64_spkon gorg64_spkoff

drstatotxt:
	$(FPC) -B -Cg -k-pie -k-znow -k-lc -XX -CX drstatotxt.pas

obtainmse:
	chmod =00755 ./obtainmse.sh
	./obtainmse.sh

obtainootb:
	chmod =00755 ./obtainootb.sh
	./obtainootb.sh

compilemse: obtainmse
	cd ./mseide-msegui/apps/ide/ && fpc -B -CfSSE64 -Cg -k-pie -k-znow -gl -FU$funits -Fu../../lib/common/* -Fu../../lib/common/kernel/linux -CX -XX -O2 -Mobjfpc mseide.pas