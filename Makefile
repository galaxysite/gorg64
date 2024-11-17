PATH := $(PATH):/usr/local/sbin:/usr/sbin:/sbin

gorg64:
	cd src && $(MAKE)

ootb:
	-rm -f -r ./gorg64
	-mkdir ./gorg64/
	-mkdir ./gorg64/data/
	-mkdir ./gorg64/bin/
	-mkdir ./gorg64/music/
	-mkdir ./gorg64/sound/
	-mkdir ./gorg64/lang_s/
	-mkdir ./gorg64/script/
	cd src && $(MAKE) ootb
	cd ../
	cp ./src/gorg64 ./gorg64/
	cp LICENSE ./gorg64/
	cp ./src/gorg64_spkplay ./src/gorg64_spktone ./src/gorg64_spkon ./src/gorg64_spkoff ./src/gorg64_runner ./gorg64/bin/
	cp ./lang_s/*.txt ./gorg64/lang_s/
	cp ./music/*.* ./gorg64/music/
	cp ./sound/*.* ./gorg64/sound/
	cp ./script/*.* ./gorg64/script/
	tar -zcvf gorg64_2.0.0-1_amd64.tar.gz ./gorg64/
	-rm -f -r ./gorg64

clean:
	cd src && $(MAKE) clean
	-rm -f gorg64*.deb
	-rm -r -f ./usr

source:
	dpkg-source -b .

archive:
	fpc -Cg -k-pie -k-znow -O4 -CX -XX ver.pas
	-rm -f ver.o
	-sstrip ver
	./ver ar

install:
	dpkg -i gorg64_2.0.0-1_amd64.deb

deb:
	-rm -r -f usr
	-mkdir -m =00755 ./usr/ ./usr/bin/ ./usr/share/ ./usr/share/doc/ ./usr/share/doc/gorg64/ ./usr/share/applications/ ./usr/share/man/ ./usr/share/man/man1/ ./usr/share/pixmaps/ ./usr/share/man/ru/ ./usr/share/man/ru/man1/
	cp ./src/gorg64 ./src/gorg64_spkplay ./src/gorg64_spktone ./src/gorg64_spkon ./src/gorg64_spkoff ./src/gorg64_runner ./usr/bin/
	strip ./usr/bin/*
	cp ./debian/*.desktop ./usr/share/applications/
	cp ./debian/*.png ./usr/share/pixmaps/
	cp ./debian/copyright ./usr/share/doc/gorg64/
	cp ./lang_s/*.txt ./usr/share/doc/gorg64/
	gzip -n -9 -c ./debian/changelog > ./usr/share/doc/gorg64/changelog.gz
	tar -c --xz sound music script > ./usr/share/doc/gorg64/files.tar.xz
	find ./man/ -maxdepth 1 -name "*.1" -type f -exec gzip -f -n -9 -k '{}' \;
	mv ./man/*.1.gz ./usr/share/man/man1/
	find ./usr/ -type d -exec chmod =00755 '{}' \;
	find ./usr/ -type f -exec chmod =00644 '{}' \;
	find usr/ -type f -exec md5sum \{\} \; > md5sums
	chmod =00644 md5sums usr/share/doc/gorg64/* usr/share/man/man1/*
	chmod =00755 usr/bin/* debian/post*
	chmod =00644 ./debian/control
	-rm -f control.tar.xz data.tar.zst data.tar.xz data.tar data.tar.bz2
	cd debian && tar -c --owner=root --group=root -f ../control.tar postinst postrm control ../md5sums
	xz -e control.tar
	tar -c --owner=root --group=root -f data.tar usr
	xz -e data.tar
	-rm -r -f usr
	-rm -f gorg64_2.0.0-1_amd64.deb
	mv control.tar.xz data.tar.xz ./debian/
	cd debian && ar q ../gorg64_2.0.0-1_amd64.deb debian-binary control.tar.xz data.tar.xz
	-rm -f ./debian/control.tar.xz ./debian/data.tar.xz data.tar md5sums
	-lintian --tag-display-limit 0 gorg64_2.0.0-1_amd64.deb
