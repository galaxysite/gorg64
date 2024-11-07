program fpcpiepatch;

{
    FPC PIE patch.
    For GNU/Linux 64 bit version.
    Version: 1.
    Written on FreePascal (https://freepascal.org/).
    Copyright (C) 2023-2024  Artyomov Alexander
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

{$MODE OBJFPC}
{$H+}
{$RANGECHECKS ON}
{$SMARTLINK ON}

uses sysutils, unix;

var
m : utf8string = './fpc/Makefile.fpc';
p : utf8string = './fpc/fpcpiepatch.txt';
t : utf8string = './fpc/compiler/systems/t_linux.pas';
i : utf8string = './fpc/compiler/systems/i_linux.pas';
fpm, fpt, fpi, fptm : Text;
s : utf8string;
f : Int64;
n : boolean = false;

begin
if FileExists(p) then begin writeln('Already patched'); Halt; end;
Assign(fpm, m); Assign(fpt, t); Assign(fpi, i); Assign(fptm, p);
FileMode:=0;
ReSet(fpm); ReSet(fpt); ReSet(fpi);
FileMode:=1;
ReWrite(fptm);

while not eof(fpm) do begin // Ok
ReadLn(fpm, s);
WriteLn(fptm, s);
if s = 'PPSUF=x64' then WriteLn(fptm, 'OPT+=-Cg');
end; {wend}
Close(fpm);
Close(fptm);
fpSystem('cp ' + p + ' ' + m);
ReWrite(fptm);

while not eof(fpt) do begin
ReadLn(fpt, s);
if Pos('ExeCmd[1]:=LdProgram', s) <> 0 then begin WriteLn(fptm, 'ExeCmd[1]:=LdProgram+'' -lc --pie --dynamic-linker=/lib64/ld-linux-x86-64.so.2 ''+target_opt+emulation_opt+platformopt+'' $OPT $DYNLINK $STATIC $GCSECTIONS $STRIP $MAP $LTO $RPATH -L. -o $EXE'';'); continue; end;
if Pos('DllCmd[1]:=LdProgram', s) <> 0 then begin WriteLn(fptm, 'DllCmd[1]:=LdProgram+'' -lc --pie --dynamic-linker=/lib64/ld-linux-x86-64.so.2 ''+target_opt+emulation_opt+platformopt+'' $OPT $INIT $FINI $SONAME $MAP $LTO $RPATH -shared $GCSECTIONS -L. -o $EXE'';'); continue; end;
WriteLn(fptm, s);
end; {wend}
Close(fpt);
Close(fptm);
fpSystem('cp ' + p + ' ' + t);
ReWrite(fptm);

while not eof(fpi) do begin // Ok
ReadLn(fpi, s);
if Pos('tf_library_needs_pic' ,s) <> 0 then WriteLn(fptm, s + ' tf_pic_default,') else WriteLn(fptm, s);
if Pos('system_x86_64_linux_info', s) <> 0 then n := true;
end; {wend}
Close(fpi);
Close(fptm);
fpSystem('cp ' + p + ' ' + i);
ReWrite(fptm);

end.