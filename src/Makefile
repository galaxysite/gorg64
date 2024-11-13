gorg64: obtainmse
	-rm -r -f ./units/
	mkdir -p ./units/
	fpc -B -gl -O2 -XX -CX ver.pas
	./ver
	fpc -B -gl -FU./units/ -Fu./  -Fu./mseide-msegui/lib/common/* -Fu./mseide-msegui/lib/common/kernel/linux -CX -XX -O2 -Mobjfpc gorg64.pas
	fpc -B -gl -CX -XX -O2 -Mobjfpc gorg64_spktone.pas
	fpc -B -gl -CX -XX -O2 -Mobjfpc gorg64_runner.pas
	fpc -B -gl -CX -XX -O2 -Mobjfpc gorg64_spkplay.pas
	fpc -B -gl -CX -XX -O2 -Mobjfpc gorg64_spkon.pas
	fpc -B -gl -CX -XX -O2 -Mobjfpc gorg64_spkoff.pas

spkplay:
	fpc -B -gl -CX -XX -O2 gorg64_spkplay.pas
	fpc -B -gl -CX -XX -O2 gorg64_spkplay_syscalls.pas
	fpc -B -gl -CX -XX -O2 gorg64_spktone.pas

clean:
	-rm -f *.o *.a *.ppu *.bak gorg64_spkplay gorg64 gorg64_spkoff link*.res *.rsj gorg64_spkplay_syscalls core gorg64_spktone gorg64_spkon gorg64_runner ver *.bak1 msepatch mseguiintf.pas o.opt
	-rm -r -f ./units/
	-find ./ \( -name "o.opt" -o -name "link*.res" -o -name "*~" -o -name "*.ppu" -o -name "*.o" -o -name "*.a" -o -name "*.bak" -o -name "*.bak1" \)  -delete

suidroot:
	chown root:root gorg64_spkplay gorg64_spktone gorg64_spkon gorg64_spkoff
	chmod =04755 gorg64_spkplay gorg64_spktone gorg64_spkon gorg64_spkoff

drstatotxt:
	fpc -B -XX -CX drstatotxt.pas

obtainmse:
	chmod =00755 ./obtainmse.sh ./compile_mse.sh
	./obtainmse.sh

compilemse:
	chmod =00755 ./obtainmse.sh ./compile_mse.sh
	./compile_mse.sh
