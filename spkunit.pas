unit spkunit;

{$MODE OBJFPC}
{$ASMMODE INTEL}
{$LONGSTRINGS ON}
{$RANGECHECKS ON}
{$SMARTLINK ON}
{$INLINE ON}

{
    Unit for playing melodys on PC-Speaker.
    For GNU/Linux 64 bit version. Root priveleges needed.
    Version: 3.
    Written on FreePascal (https://freepascal.org/).
    Copyright (C) 2000-2024  Artyomov Alexander
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

interface

uses X86;

procedure spk(b : word); register; procedure spkon; procedure spkoff;
function spkf(tone : Word) : Word; register; inline;
function spkf(tone : extended) : Word; register; inline;

var
portserr : boolean = false;
val1, val2 : Int64;

implementation

procedure spkon; assembler;
asm
push	rax
in	al, 61h
or	al, 03h
out	61h, al
pop	rax
end;
procedure spkoff; assembler;
asm
push	rax
in	al, 61h
or	al, 03h
xor	al, 03h
out	61h, al
pop	rax
end;
procedure spk(b : word); assembler;
asm
push	rax
mov	al, 0B6h
out	43h, al
mov	ax, b
out	42h, al
shr	ax, 8
out	42h, al
pop	rax
end;

// Установить частоту воспроизведения. Частота 1193280 div tone.
// 1193181
// 1193182
function spkf(tone : Word) : Word;
var
  tmp : Int64;
begin
if tone < 1 then Exit(0);
tmp := 1193182 div tone;
if tmp > $FFFF then tmp := $FFFF;
Exit(tmp);
end;
function spkf(tone : extended) : Word;
var
  tmp : Int64;
begin
if tone < 1 then Exit(0);
tmp := round(1193280 / tone);
if tmp > $FFFF then tmp := $FFFF;
Exit(tmp);
end;

initialization
val1 := fpioperm($42, 2, 1);
val2 := fpioperm($61, 1, 1);
if (val1 <> 0) or (val2 <> 0) then begin
WriteLn('Error get ports access. h42-43, h61 Ошибка открития портов.');
WriteLn('RetVal1=',val1,', RetVal2=',val2);
WriteLn('Need root access. Нужен режим   пользователя root.');
portserr := true;
end;
end.