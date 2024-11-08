program untar;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$RANGECHECKS ON}
{$SMARTLINK ON}
{$codepage utf8}

{
    AutoUntar archives.
    For GNU/Linux 64 bit version.
    Version: 1.
    Written on FreePascal (https://freepascal.org/).
    Copyright (C) 2022-2024  Artyomov Alexander
    http://self-made-free.ru/
    aralni@mail.ru

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
}

uses Unix;

const
MAX_ARCS=9;
a : array[0..MAX_ARCS] of string = ('application/x-tar',
'application/x-gzip','application/x-bzip2','application/x-lzip',
'application/x-xz','application/zstd','application/x-lzma','application/x-lzop','application/x-7z-compressed','application/zip');

a2 : array[0..MAX_ARCS] of string = ('POSIX tar archive (GNU)',
'gzip compressed data','bzip2 compressed data','lzip compressed data',
'XZ compressed data','Zstandard compressed data','LZMA compressed data','lzop compressed data','7-zip archive data','Zip archive data');

var
f, i : LongInt;
s : utf8string = '';
n, n2 : utf8string;
tar : boolean;
var fp : textfile;

begin

for f := 1 to ParamCount do begin

popen(fp, 'file -b -i -z '+ParamStr(f), 'r');
readln(fp, n);
pclose(fp);

tar := Pos(a[0], n) <> 0;

popen(fp, 'file -b -z '+ParamStr(f), 'r');
readln(fp, n2);
pclose(fp);

for i := 1 to High(a) do begin
if (Pos(a[i], n) <> 0) or (Pos(a2[i], n2) <> 0) then begin
if tar then begin
  case i of
       1: s := 'tar -xvzf ' + ParamStr(f);
       2: s := 'tar -xvjf ' + ParamStr(f);
       3: s := 'tar --lzip -xvf ' + ParamStr(f);
       4: s := 'tar -xvJf ' + ParamStr(f);
       5: s := 'tar --zstd -xvf ' + ParamStr(f);
       6: s := 'tar --lzma -xvf ' + ParamStr(f);
       7: s := 'tar --lzop -xvf ' + ParamStr(f);
  end;
end else begin
  case i of
       1: s := 'gunzip -k -f ' + ParamStr(f);
       2: s := 'bunzip2 -k -f ' + ParamStr(f);
       3: s := 'lzip -k -d -f ' + ParamStr(f);
       4: s := 'unxz -k -f ' + ParamStr(f);
       5: s := 'unzstd -k -f ' + ParamStr(f);
       6: s := 'unlzma -k -f ' + ParamStr(f);
       7: s := 'lzop -d -f ' + ParamStr(f);
       8: s := '7z x ' + ParamStr(f);
       9: s := 'unzip ' + ParamStr(f);
  end;
end; {end if}
end; {end if}
end; {next i}
if s = '' then begin if tar then fpSystem('tar -xvf ' + ParamStr(f)) end else fpSystem(s);
s := '';
end; {next f}

end.