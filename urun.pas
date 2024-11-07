unit urun;

{
    Run unique unit (system-wide).
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

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$SMARTLINK ON}

interface

uses sysutils,baseunix;

implementation

var
LRec: TSearchRec;
s, s1, e : string;
fp : Text;

initialization
s := IntToStr(fpgetpid);
e := ExtractFileName(ParamStr(0));
    if FindFirst('/proc/*',faDirectory,LRec) = 0 then
    begin
      repeat
if LRec.Name = s then continue;
        if LRec.Name[1] in ['0','1','2','3','4','5','6','7','8','9'] then begin
Assign(fp, '/proc/'+LRec.Name+'/comm'); FileMode := 0; ReSet(fp);
ReadLn(fp, s1);
Close(fp);
if s1 = e then begin
WriteLn('Already running. Exit.');
Halt;
end;
        end;
      until FindNext(LRec) <> 0; FindClose(LRec);
    end;
end.