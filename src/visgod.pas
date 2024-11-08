unit visgod;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$RANGECHECKS ON}
{$SMARTLINK ON}
{$ASMMODE INTEL}
{$CODEPAGE UTF8}
{$ModeSwitch UnicodeStrings}

{
    Unit for finding bissextile from known year.
    For GNU/Linux 64 bit version.
    Version: 2.
    Written on FreePascal (https://freepascal.org/).
    Copyright (C) 1995-2019  Artyomov Alexander
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

interface

function vg(y : QWord) : boolean;

implementation

{    определение високосного года
     год считается високосным, если:
     (делится нацело на 4, но не делится
     нацело на 100) или делится нацело на 400 }

function vg(y : Int64) : boolean;
begin
Exit( (((y mod 4) = 0) and (((y mod 100) <> 0))) or ((y mod 400) = 0) );
end;

end.