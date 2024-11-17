gorg64: obtainmse
	-rm -r -f ./units/
	mkdir -p ./units/
	fpc -B -Cg -k-pie -k-znow -k-lc -gl -O2 -XX -CX ver.pas
	./ver
	fpc -B -Cg -k-pie -k-znow -gl -FU./units/ -Fu./  -Fu./mseide-msegui/lib/common/* -Fu./mseide-msegui/lib/common/kernel/linux -CX -XX -O2 -Mobjfpc gorg64.pas
	fpc -B -Cg -k-pie -k-znow -k-lc -gl -CX -XX -O2 -Mobjfpc gorg64_spktone.pas
	fpc -B -Cg -k-pie -k-znow -k-lc -gl -CX -XX -O2 -Mobjfpc gorg64_runner.pas
	fpc -B -Cg -k-pie -k-znow -k-lc -gl -CX -XX -O2 -Mobjfpc gorg64_spkplay.pas
	fpc -B -Cg -k-pie -k-znow -k-lc -gl -CX -XX -O2 -Mobjfpc gorg64_spkon.pas
	fpc -B -Cg -k-pie -k-znow -k-lc -gl -CX -XX -O2 -Mobjfpc gorg64_spkoff.pas

ootb: obtainmse
	-rm -r -f ./units/
	mkdir -p ./units/
	fpc -B -dootb -ogorg64 -FU./units/ -Fu./  -Fu./mseide-msegui/lib/common/* -Fu./mseide-msegui/lib/common/kernel/linux -XX -Xs -CX -O2 -Mobjfpc gorg64.pas
	fpc -B -ogorg64_spktone -FU./units/ -XX -Xs -CX -O2 -Mobjfpc gorg64_spktone.pas
	fpc -B -ogorg64_runner -FU./units/ -XX -Xs -CX -O2 -Mobjfpc gorg64_runner.pas
	fpc -B -ogorg64_spkplay -FU./units/ -XX -Xs -CX -O2 -Mobjfpc gorg64_spkplay.pas
	fpc -B -ogorg64_spkon -FU./units/ -XX -Xs -CX -O2 -Mobjfpc gorg64_spkon.pas
	fpc -B -ogorg64_spkoff -FU./units/ -XX -Xs -CX -O2 -Mobjfpc gorg64_spkoff.pas


spkplay:
	fpc -B -Cg -k-pie -k-znow -k-lc -gl -CX -XX -O2 gorg64_spkplay.pas
	fpc -B -Cg -k-pie -k-znow -k-lc -gl -CX -XX -O2 gorg64_spkplay_syscalls.pas
	fpc -B -Cg -k-pie -k-znow -k-lc -gl -CX -XX -O2 gorg64_spktone.pas

clean:
	-rm -f *.o *.a *.ppu *.bak gorg64_spkplay gorg64 gorg64_spkoff link*.res *.rsj gorg64_spkplay_syscalls core gorg64_spktone gorg64_spkon gorg64_runner ver *.bak1 msepatch mseguiintf.pas o.opt
	-rm -r -f ./units/
	-find ./ \( -name "o.opt" -o -name "link*.res" -o -name "*~" -o -name "*.ppu" -o -name "*.o" -o -name "*.a" -o -name "*.bak" -o -name "*.bak1" \)  -delete

suidroot:
	chown root:root gorg64_spkplay gorg64_spktone gorg64_spkon gorg64_spkoff
	chmod =04755 gorg64_spkplay gorg64_spktone gorg64_spkon gorg64_spkoff

drstatotxt:
	fpc -B -Cg -k-pie -k-znow -k-lc -XX -CX drstatotxt.pas

obtainmse:
	chmod =00755 ./obtainmse.sh ./compile_mse.sh
	./obtainmse.sh

compilemse:
	chmod =00755 ./obtainmse.sh ./compile_mse.sh
	./compile_mse.sh
