unit time;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$RANGECHECKS ON}
{$SMARTLINK ON}
{$GOTO ON}
{$ASMMODE INTEL}
{$CODEPAGE UTF8}
{$ModeSwitch UnicodeStrings}

{
    Time unit.
    For GNU/Linux 64 bit version.
    Version: 1.
    Written on FreePascal (https://freepascal.org/).
    Copyright (C) 1995-2024  Artyomov Alexander
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

interface uses sysutils;

type
      TMonth = 1..12;
      TDay = 1..31;
      TTick = 0..59;
      THour = 0..23;
      TWeekDayRu = 1..7;
      
const
monlen : array [TMonth] of TDay = (31,28,31,30,31,30,31,31,30,31,30,31);

var
      wdn : array[1..7] of utf8string;
      wdn2 : array[1..7] of utf8string;
      mon_names : array[TMonth] of utf8string;
      mon_names3 : array[TMonth] of utf8string;

function vg(y : Int64) : boolean; register;
function WeekdayRu(y: Int64; m: TMonth; d: TDay) : TWeekDayRu; register;
function inttofix2str(i : Int64) : string;
function monthlen(y : Int64; m : TMonth) : TDay; register;
function MonthWithDay(y : Int64; m : TMonth) : boolean;
function Century(y : Int64) : Int64;

implementation

var
    f : Int64;
    
function inttofix2str(i : Int64) : string;
begin result := inttostr(i);if 10 > i then result := '0' + result; end;

function vg(y : Int64) : boolean;
begin
Exit( (((y and 3) = 0) and (((y mod 100) <> 0))) or ((y mod 400) = 0) );
end;

function WeekdayRu(y: Int64; m: TMonth; d: TDay) : TWeekDayRu;
var
  Era, Yoe, Doy, Doe, civ : Int64;
begin
if M <= 2 then Dec(Y);
if Y >= 0 then Era := Y div 400
          else Era := (Y - 399) div 400;
Yoe := Y - Era * 400;
if M > 2 then Doy := -3
         else Doy := 9;
Doy := (153 * (M + Doy) + 2) div 5 + D - 1;
Doe := Yoe * 365 + Yoe shr 2 - Yoe div 100 + Doy;
civ := Era * 146097 + Doe - 719468;
if civ >= -4 then Doe := (civ + 4) mod 7
else Doe := (civ + 5) mod 7 + 6;
if Doe = 0 then Doe := 7;
Exit(Doe);
end;

function monthlen(y : Int64; m : TMonth) : TDay;
begin
 if (m = 2) and vg(y) then Exit(29);
 Exit(monlen[m]);
end;

function MonthWithDay(y : Int64; m : TMonth) : boolean;
begin
case m of
2: Exit(vg(y));
else
Exit(monlen[m] = 31);
end;
end;

function Century(y : Int64) : Int64;
begin
Exit((Abs(y) + 99) div 100);
end;

initialization

wdn2[7] := DefaultFormatSettings.ShortDayNames[1];
for f := 2 to 7 do wdn2[f-1] := DefaultFormatSettings.ShortDayNames[f];
wdn[7] := DefaultFormatSettings.LongDayNames[1];
for f := 2 to 7 do wdn[f-1] := DefaultFormatSettings.LongDayNames[f];
for f := 1 to 12 do mon_names[f] := DefaultFormatSettings.LongMonthNames[f];
for f := 1 to 12 do mon_names3[f] := DefaultFormatSettings.ShortMonthNames[f];

end.