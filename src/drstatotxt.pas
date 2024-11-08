program drstatotxt;

{
    Birthdays reminder file export.
    Copyright (C) 2021  Artyomov Alexander

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

var
    s  : utf8string;
    be : boolean;
    f  : LongInt;

begin

be := false;

while not eof do begin
 readln(s);
 if Pos('values0=366', s) <> 0 then begin be := true; continue; end;
 if not be then continue;
  for f := 1 to 366 do begin
    if f = 366 then Write(s) else WriteLn(s);
    ReadLn(s);
  end;
 Halt;
end;

end.