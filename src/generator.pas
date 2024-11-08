unit generator;

{
    Program for playing tones on PC-Speaker output.
    For GNU/Linux 64 bit version. Root priveleges or kernel patch needed.
    Version: 3.
    Written on FreePascal (https://freepascal.org/).
    Copyright (C) 2021-2023  Artyomov Alexander
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

{$RANGECHECKS ON}
{$GOTO ON}
{$CODEPAGE UTF8}
{$ASMMODE INTEL}

interface

uses spkunit;

procedure gspkon;
procedure gspkoff;
procedure gspk(w : Qword);

implementation

procedure kspkon; assembler;
asm
 mov rax, 1000
 syscall
end;
procedure kspkoff; assembler;
asm
 mov rax, 1001
 syscall
end;
procedure kspk(w : Qword); assembler;
asm
 mov rax, 1002
 mov rdi, w
 syscall
end;
function kspkpatchexists : boolean;
var tmp : Int64;
begin
asm
 mov rax, 1003
 syscall
 mov tmp, rax;
end;
Exit(tmp = 123);
end;

var
  spkpatch : boolean;

procedure gspkon;
begin
if spkpatch then kspkon else spkon;
end;
procedure gspkoff;
begin
if spkpatch then kspkoff else spkoff;
end;
procedure gspk(w : Qword);
begin
if spkpatch then kspk(w) else spk(w);
end;

begin
spkpatch := kspkpatchexists;
if (not spkpatch) and portserr then halt;
end.