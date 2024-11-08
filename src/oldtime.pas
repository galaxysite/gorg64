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

interface uses sysutils, ddateprimitives;

type
      TMonth = 1..12;
      TDay = 1..31;
      TTick = 0..59;
      THour = 0..23;
      TQuartal = 1..4;
//      TWeekDay = 0..6;
      TWeekDayRu = 1..7;
      
const
monlen : array [TMonth] of TDay = (31,28,31,30,31,30,31,31,30,31,30,31);

var
      wdn : array[0..7] of utf8string;
      wdn2 : array[0..7] of utf8string;
      mon_names : array[TMonth] of utf8string;
      mon_names3 : array[TMonth] of utf8string;

function vg(y : Int64) : boolean; // finding bissextile from known year.
//function Weekday(year: Int64; month: TMonth; day: TDay): TWeekday; // finding weekday number by known year, month, day.
function WeekdayRu(y: Int64; m: TMonth; d: TDay) : TWeekDayRu;
function inttofix2str(i : Int64) : string;
function monthlen(y : Int64; m : TMonth) : TDay;
function fdnd(y : Int64; m : TMonth; d : TDay) : Int64;
{
function f0(m : TMonth; d : TDay) : byte;
function Gauss(y : Int64) : Int64;
function gaussedfdnd(y : Int64; m : TMonth; d : TDay) : Int64;
}

implementation

var
    f : Int64;
    
function inttofix2str(i : Int64) : string;
begin result := inttostr(i);if 10 > i then result := '0' + result; end;

//function Gauss(y : Int64) : Int64; // 1... y
//var
// Aminus1: Int64;
//begin
//Aminus1 := y - 1;
//result := (1 + 5*(Aminus1 mod 4) + 4*(Aminus1 mod 100) + 6*(Aminus1 mod 400)) mod 7;
//if result = 0 then result := 7; // ru
//end;

function vg(y : Int64) : boolean;
begin
vg := ((int(y / 4) = y / 4) and (not(int(y / 100) = y / 100))) or (int(y / 400) = y / 400);
end;

{
function Weekday(year: Int64; month: TMonth; day: TDay): TWeekDay;
begin
if year = 0 then Exit(f0(month,day));
if year < 0 then Exit(fdnd(year, month, day));
    if month < 3 then  begin
	year := year - 1;
	month := month + 10;
    end  else month := month - 2;
    Weekday := (day + 31 * month div 12 + year + year div 4 - year div 100 + year div 400) mod 7;
end;
function WeekdayRu(year: Int64; month: TMonth; day: TDay) : TWeekDayRu;
var tmp : byte;
begin
tmp := WeekDay(year, month, day);
if tmp = 0 then Exit(7) else Exit(tmp);
end;
}

{
function Weekday(year: Int64; month: TMonth; day: TDay) : TWeekDay;
begin
Exit(weekday_from_days(days_from_civil(Year, Month, Day)));
end;
}

function WeekdayRu(y: Int64; m: TMonth; d: TDay) : TWeekDayRu;
var
  Era, // 400 years time period
       // (the civil calendar exactly repeats itself every 400 years)
  Yoe, // Year of the era
  Doy,
  Doe, // Day of the era
  civ,
  tmp : Int64; 
begin // Internally, we suppose that a year starts at 1 march
if M <= 2 then Dec(Y);
if Y >= 0 then Era := Y div 400
          else Era := (Y - 399) div 400;
Yoe := Y - Era * 400; // [0, 399]
if M > 2 then Doy := -3
         else Doy := 9;
Doy := (153 * (M + Doy) + 2) div 5 + D - 1;       // [0, 365]
Doe := Yoe * 365 + Yoe div 4 - Yoe div 100 + Doy; // [0, 146096]
civ := Era * 146097 + Doe - 719468;
if civ >= -4 then tmp := (civ + 4) mod 7
else tmp := (civ + 5) mod 7 + 6;
if tmp = 0 then tmp := 7; // ru
Exit(tmp);
end;

function monthlen(y : Int64; m : TMonth) : TDay;
begin
 if (m = 2) and vg(y) then Exit(29);
 Exit(monlen[m]);
end;

{
function f0(m : TMonth; d : TDay) : byte;
label ex;
const
monl : array [TMonth] of TDay =(31,29,31,30,31,30,31,31,30,31,30,31);
var    f,fm : QWord;
 begin
result := 6;
  for fm := 1 to 12 do begin
    for f := 1 to monl[fm] do begin
      if fm = m then if f = d then goto ex;
      inc(result); if result = 8 then result := 1;
    end;
  end;
ex:
if result = 7 then result := 0; // to eng
end;
}

function fdnd(y : Int64; m : TMonth; d : TDay) : Int64;
var f,fy,fm : Int64;
 begin
 fy := 2019; result := 2;
 if y > fy then begin while y <> fy do begin
   if vg(fy) then inc(result);
   inc(fy); inc(result);
   if result = 8 then result := 1; if result = 9 then result := 2;
 end; end else begin
 if y < fy then while y <> fy do begin
   dec(fy);
   if vg(fy) then begin
   dec(result); if result = 0 then result := 7; end;
   dec(result);
   if result = 0 then result := 7;
 end; end;
  for fm := 1 to 12 do begin
    for f := 1 to monthlen(y, fm) do begin
      if fm = m then if f = d then exit;
      inc(result); if result = 8 then result := 1;
    end;
  end;  
end;

{
function gaussedfdnd(y : Int64; m : TMonth; d : TDay) : Int64;
var f,fy,fm : Int64;
 begin
 if y > 0 then begin
  result := Gauss(y); 
 end else begin
 fy := 2019; result := 2;
 if y > fy then begin while y <> fy do begin
   if vg(fy) then inc(result);
   inc(fy); inc(result);
   if result = 8 then result := 1; if result = 9 then result := 2;
 end; end else begin
 if y < fy then while y <> fy do begin
   dec(fy);
   if vg(fy) then begin
   dec(result); if result = 0 then result := 7; end;
   dec(result);
   if result = 0 then result := 7;
 end; end;
 end;
  for fm := 1 to 12 do begin
    for f := 1 to monthlen(y, fm) do begin
      if fm = m then if f = d then exit;
      inc(result); if result = 8 then result := 1;
    end;
  end;  
end;
}

initialization

for f := 1 to 7 do wdn2[f-1] := DefaultFormatSettings.ShortDayNames[f]; wdn2[7] := wdn2[0];
for f := 1 to 7 do wdn[f-1] := DefaultFormatSettings.LongDayNames[f]; wdn[7] := wdn[0];
for f := 1 to 12 do mon_names[f] := DefaultFormatSettings.LongMonthNames[f];
for f := 1 to 12 do mon_names3[f] := DefaultFormatSettings.ShortMonthNames[f];

end.