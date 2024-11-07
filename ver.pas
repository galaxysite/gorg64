{$H+}
{$MODE OBJFPC}

{
    Extract version from archive.
    For GNU/Linux 64 bit version.
    Version: 1.
    Written on FreePascal (https://freepascal.org/).
    Copyright (C) 1995-2023  Artyomov Alexander
    http://self-made-free.ru/ (Ex http://aralni.narod.ru/)
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

uses sysutils,unix;

  var
    fnd : Int64 = 0;
    r : TSearchRec;
    found : integer;
    fp : Text;

function Max(i1, i2 : Int64) : Int64;
begin
if i1 > i2 then exit(i1) else exit(i2);
end;

function ExtractFileVersion(s : utf8string) : Int64;
var
bl, dot : Int64;
begin
result := 0;
bl := Pos('_', s);
dot := Pos('.', s);
if (bl = 0) or (dot = 0) then exit;
Exit(StrToIntDef(Copy(s, bl + 1, dot - bl -1),0));
end;

begin

found := FindFirst('../' + 'GORG64_*.tar.xz', faAnyFile, r);
WHILE Found = 0 do begin
fnd := max(ExtractFileVersion(r.name), fnd);
Found := FindNext(r);
END; {wend}
FindClose(r);

if ParamStr(1) = 'ar' then begin
Inc(fnd);
fpSystem('make clean');
//fpSystem('cd .. && tar --exclude=''GORG64/fpc'' --exclude=''GORG64/mseide-msegui'' -c GORG64 | xz -e > GORG64_'+inttostr(fnd)+'.tar.xz && cd GORG64');
fpSystem('cd .. && tar --exclude=''GORG64/fpc'' -c GORG64 | xz -e > GORG64_'+inttostr(fnd)+'.tar.xz && cd GORG64');
end;

Assign(fp, 'ver.inc');
FileMode := 1;
ReWrite(fp);
writeln(fp, IntToStr(fnd));
Close(fp);

end.