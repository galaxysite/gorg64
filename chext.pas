program chext;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$RANGECHECKS ON}
{$SMARTLINK ON}
{$codepage utf8}

{
    Change file extension.
    For GNU/Linux 64 bit version.
    Version: 1.
    Written on FreePascal (https://freepascal.org/).
    Copyright (C) 2024  Artyomov Alexander
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

uses sysutils;

var
s : utf8string;
l,f : Int64;

begin
if ParamCount < 2 then begin
WriteLn('Change file extension. Version 1');
WriteLn(stderr, 'Use: chext filename.ext newext [f]');
Halt;
end;

l := Length(ParamStr(1));
s := ParamStr(1);
for f := l downto 1 do begin
if s[f] = '.' then begin
if (ParamCount > 2) and (ParamStr(3) = 'f') then RenameFile(s,Copy(s, 1, f) + ParamStr(2))
else WriteLn(Copy(s, 1, f) + ParamStr(2));
Halt;
end;
end; {next f}

if (ParamCount > 2) and (ParamStr(3) = 'f') then RenameFile(s,s + '.' + ParamStr(2))
else WriteLn(s + '.' + ParamStr(2));

end.