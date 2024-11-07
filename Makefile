gorg64:
	chmod =00755 ./compile_gorg64.sh postinst postrm
	./compile_gorg64.sh

spkplay:
	fpc -CX -XX -Cg -O2 gorg64_spkplay.pas
	fpc -CX -XX -Cg -O2 gorg64_spkplay_syscalls.pas
	fpc -CX -XX -Cg -O2 gorg64_spktone.pas

clean:
	-rm -f *.o *.a *.ppu *.bak gorg64_spkplay gorg64 gorg64_spkoff link*.res *.rsj gorg64*.deb gorg64_spkplay_syscalls core gorg64_spktone gorg64_spkon gorg64_runner ver *.bak1 msepatch mseguiintf.pas o.opt
	-rm -r -f ./units/
	-rm -r -f ./usr/
	-find ./ \( -name "o.opt" -o -name "link*.res" -o -name "*~" -o -name "*.ppu" -o -name "*.o" -o -name "*.a" -o -name "*.bak" -o -name "*.bak1" \)  -delete
	-mkdir ./units/
	-rm -f ./ttaenc-3.4.1-src/ttaenc ./ttaenc-3.4.1-src/ttaenc.o

suidroot:
	chown root:root gorg64_spkplay gorg64_spktone gorg64_spkon gorg64_spkoff
	chmod =04755 gorg64_spkplay gorg64_spktone gorg64_spkon gorg64_spkoff

drstatotxt:
	fpc drstatotxt.pas

obtainmse:
	./obtainmse.sh

compilemse:
	./compile_mse.sh

source:
	dpkg-source -b .

archive:
	fpc -Cg -O4 -CX -XX ver.pas
	-rm -f ver.o
	-sstrip ver
	./ver ar

deb :
	-rm -r -f usr
	-mkdir -m =00755 ./usr/ ./usr/bin/ ./usr/src/ ./usr/src/lazarus/ ./usr/share/ ./usr/share/doc/ ./usr/share/doc/gorg64/ ./usr/share/applications/ ./usr/share/man/ ./usr/share/man/man1/ ./usr/share/pixmaps/ ./usr/share/man/ru/ ./usr/share/man/ru/man1/
	cp gorg64 gorg64_spkplay gorg64_spktone gorg64_spkon gorg64_spkoff gorg64_runner ./usr/bin/
	strip ./usr/bin/*
	cp *.desktop ./usr/share/applications/
	cp *.png ./usr/share/pixmaps/
	cp copyright ./usr/share/doc/gorg64/
	cp ./lang_s/*.txt ./usr/share/doc/gorg64/
	gzip -n -9 -c changelog > ./usr/share/doc/gorg64/changelog.gz
	tar -c --xz sound music script > ./usr/share/doc/gorg64/files.tar.xz
	find ./ -maxdepth 1 -name "*.1" -type f -exec gzip -f -n -9 -k '{}' \;
	mv *.1.gz ./usr/share/man/man1/
	find ./usr/ -type d -exec chmod =00755 '{}' \;
	find ./usr/ -type f -exec chmod =00644 '{}' \;
	find usr/ -type f -exec md5sum \{\} \; > md5sums
	chmod =00644 md5sums usr/share/doc/gorg64/* usr/share/man/man1/*
	chmod =00755 usr/bin/*
	chmod =00644 control
	-rm -f control.tar.xz data.tar.zst data.tar.xz data.tar data.tar.bz2
	tar -c --owner=root --group=root -f control.tar postinst postrm control md5sums
	xz -e control.tar
	tar -c --owner=root --group=root -f data.tar usr
	xz -e data.tar
	-rm -r -f usr
	-rm -f gorg64_2.0.0-1_amd64.deb
	ar q gorg64_2.0.0-1_amd64.deb debian-binary control.tar.xz data.tar.xz
	-rm -f control.tar.xz data.tar.zst data.tar.xz data.tar data.tar.bz2 md5sums
	-lintian --tag-display-limit 0 gorg64_2.0.0-1_amd64.deb
