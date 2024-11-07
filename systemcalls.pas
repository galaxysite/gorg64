unit systemcalls;

{
    Unit for Linux system calls. 64 bits.
    Version: 1.
    Written on FreePascal (https://freepascal.org/).
    Copyright (C) 2022  Artyomov Alexander
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

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$CODEPAGE UTF8}
{$ASMMODE INTEL}

interface

const
STDIN=0;STDOUT=1;STDERR=2;

procedure quit(retval : word = 0); assembler;
function wrt(s : utf8string; fd : QWord = STDOUT) : QWord;
function wrtln(s : utf8string = ''; fd : QWord = STDOUT) : QWord;

function opn(PathName: utf8string; Flags: QWord = &0102; Mode: QWord = &0644): QWord;
function clos(Fd: QWord): QWord; assembler;

procedure sys_spkon; assembler;
procedure sys_spkoff; assembler;
procedure sys_spkplay(w : Qword);  assembler;

implementation

procedure quit(retval : word = 0); assembler; asm
  mov rax, 60
  mov di, retval
  syscall
end;

function opn(PathName: utf8string; Flags: QWord = &0102; Mode: QWord = &0644): QWord;
var tmp : QWord;
begin tmp :=QWord(Pointer(@PathName[1]));
asm
  mov rax, 2;
  mov rdi, tmp;
  mov rsi, Flags;
  mov rdx, Mode;
  syscall;
  mov result, rax
end;
end;

function clos(Fd: QWord): QWord; assembler; asm
  mov rax, 3;
  mov rdi, Fd;
  syscall
  mov result, rax
end;

function wrt(s : utf8string; fd : QWord = STDOUT) : QWord;
var
p, l :QWord;
begin
l := Length(s); if l = 0 then exit;
p := QWord(Pointer(@s[1]));
asm
  mov  rax, 1
  mov  rdi, fd
  mov  rsi, p
  mov  rdx, l
  syscall
  mov result, rax
end;
end;
function wrtln(s : utf8string = ''; fd : QWord = STDOUT) : QWord;
var tmp : utf8string;
begin
tmp := s + #10;
result := wrt(tmp, fd);
end;

procedure sys_spkon; assembler;
asm
 mov rax, 1000
 syscall
end;
procedure sys_spkoff; assembler;
asm
 mov rax, 1001
 syscall
end;
procedure sys_spkplay(w : Qword);  assembler;
asm
 mov rax, 1002
 mov rdi, w
 syscall
end;

end.