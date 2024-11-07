program gorg64_runner;

{
    GALAXY ORGANIZER Runner.
    For GNU/Linux.
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

{$MODE OBJFPC}
{$H+}
//{$RANGECHECK ON}
{$SMARTLINK ON}

uses unix,baseunix;

var
 f : Int64;
 s :utf8string = '';

begin

if ParamCount < 1 then Halt;

for f := 2 to ParamCount do s := s + ' ' + ParamStr(f);

if fpfork = 0 then
fpSystem(ParamStr(1) +  s);

end.