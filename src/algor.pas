unit algor;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$RANGECHECKS ON}
{$CODEPAGE UTF8}
{$ASMMODE INTEL}

{
    Algorithm unit.
    For GNU/Linux 64 bit version.
    Version: 1.
    Written on FreePascal (https://freepascal.org/).
    Copyright (C) 1995-2024  Artyomov Alexander
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

uses sysutils, classes, time, msetypes,
msepointer, mseglob, mseguiglob, mseguiintf, msethread,
 mseapplication, msegui,msegraphutils,mseevent, mseclasses, mseforms,
 msesimplewidgets, msewidgets, msebitmap,msegraphics, msemenus,
 msethreadcomp, msestrings, mseact,unix,baseunix,linux,msetraywidget,systemcalls,lng;

type
TAoInt64 = array of int64;

const
am_hour_pm : array[false..true] of msestring = ('a','p');
ado : array[1..12] of Integer = (0, 31, 61, 92, 122, 153, 184, 214, 245, 275, 306, 337); // day_offset = (153 * month + 2) / 5;
mess_jubilee = 'завтра юбилей | tomorrow jubilee : ';

       gorg1_year           = 'gorg1_year';
       gorg1_month          = 'gorg1_month';
       gorg1_day            = 'gorg1_day';
       gorg1_hour           = 'gorg1_hour';
       gorg1_minute         = 'gorg1_minute';
       gorg1_period         = 'gorg1_period';
       gorg1_cycle          = 'gorg1_cycle';
       gorg1_filename       = 'gorg1_filename';
       gorg1_message        = 'gorg1_message';
       gorg1_showmessage    = 'gorg1_showmessage';
       gorg1_deleteafteruse = 'gorg1_deleteafteruse';
       gorg1_realtime       = 'gorg1_realtime';
       gorg1_disable        = 'gorg1_disable';
       gorg1_week           = 'gorg1_week';
       gorg2_music          = 'gorg2_music';
       gorg2_sound          = 'gorg2_sound';
       gorg2_script         = 'gorg2_script';
       gorg2_clockpanel     = 'gorg2_clockpanel';
       gorg2_shutdown       = 'gorg2_shutdown';

type
    tclockpanelaction = 0..2;
    TGORG64Event  = object
    year     : Int64;
    month    : TMonth;
    day      : TDay;
    hour     : THour;
    minute   : TTick;
    wd       : byte;                     // weekdays
    period   : byte;                     // periodicity
    cycle    : dword;                    // cycle
    mess     : msestring;
    sounds,musics,scripts : filenamearty; // filenames
    remove   : bytebool;            // remove after using
    realtime : bytebool;            // real time only
    disable  : bytebool;            // off
    display  : bytebool;            // display message
    clockpanel, shutdown : tclockpanelaction; // show/hide clock panel 0-inactive,1-show,2-hide
                // 0-inactive, 1-poweroff, 2-reboot
    protected
    function  GetHrMn : word;
    procedure SetHrMn(Value : word);
    public
	function MToInt : Int64;
	function HToInt : Int64;
	function DToInt : Int64;
    function  weekday : byte;
    function  TryPutData(yr, mn, dt : longint) : boolean;
    property  HrMn : word read GetHrMn write SetHrMn;
    function  TryPutTime(hr, min : longint) : boolean;
    function  TryPutDataAndTime(yr, mn, dt, hr, min : longint) : boolean;
    procedure GetCurrentTime;
    procedure ForNew;
    function SelfDataStarshe(m : TGORG64Event) : boolean;
    function SelfTimeStarshe(m : TGORG64Event) : boolean;
    function SelfDataAndTimeStarshe(m : TGORG64Event) : boolean;
    function SelfDataRavno(m : TGORG64Event) : boolean;
    function SelfTimeRavno(m : TGORG64Event) : boolean;
    function SelfDataAndTimeRavno(m : TGORG64Event) : boolean;
    function SelfDataStarsheNoYear(m : TGORG64Event) : boolean;
    function SelfDataAndTimeStarsheNoYear(m : TGORG64Event) : boolean;
    function SelfDataRavnoNoYear(m : TGORG64Event) : boolean;
    function SelfDataAndTimeRavnoNoYear(m : TGORG64Event) : boolean;
    procedure PlusMinute;
    procedure PlusMinutes(m : Int64);
    procedure PlusHours(h : Int64);
    procedure PlusDays(d : Int64);
    procedure PlusHour;
    procedure PlusDay;
    procedure PlusMonth;
    procedure MinusMinute;
    procedure MinusHour;
    procedure MinusDay;
    procedure MinusMonth;
    function Activate(var m : TGORG64Event; const InitTrueRtmFalse, Jubilee : boolean) : boolean;
    function ActivateInDay(m : TGORG64Event) : boolean;
    function ActivateIn12p(m : TGORG64Event) : boolean;
    procedure Run;
    function ExportString : msestring;
    function ImportString(s : msestring) : boolean;
    function OutDated : boolean;
    function DisplayString : msestring;
	function isRunLess : boolean;
    end;
    
    TOrg = class(TThread)
    w     : array of TGORG64Event;
    hst   : array of msestring;
    orgtodaycount  : qword;
    protected
    private
    public
      procedure AddEvent(e : TGORG64Event);
      //procedure DeleteOld;
      procedure AddHistory(s : msestring);
      procedure ClearHistory;
      function Delete(n : Int64) : boolean;
      function Delete(var a : TAoInt64) : boolean;
      procedure WorkGorgFile(SaveTrue : boolean);
      procedure WorkHistoryFile(SaveTrue : boolean);
      procedure SetEventsCount;
      procedure AfterConstruction; override;
      procedure Execute; override;
      procedure DelSndFiles;
    end;

var
    org : TOrg;

function BooleanToLongint(b : boolean) : longint;
function uStrToInt(s : msestring) : Int64; register;
function LongintToBoolean(l : longint) : boolean;
function ExtractFileNameNoExt(const FileName : msestring) : msestring;
function IntToHour(h : byte) : msestring;

implementation

uses main,clockpanel,ee,ele,msg;

function BooleanToLongint(b : boolean) : longint;
begin if b then result := 1 else result := 0; end;
function LongintToBoolean(l : longint) : boolean;
begin result := l <> 0; end;
function IntToHour(h : byte) : msestring;
begin
if tun.p^.engtrue_hour_fmt then begin
  if h > 11 then begin
            if h = 12 then result := tun.p^.am_pm[true] + '12'
            else result := tun.p^.am_pm[true] + inttostr(h - 12);
  end else begin
            if h = 0 then result := tun.p^.am_pm[false] + '12'
            else result := tun.p^.am_pm[false] + inttostr(h);
                 end;
end else result := inttostr(h);
end;

function ExtractFileNameNoExt(const FileName : msestring) : msestring;
  var
   f, l, lt, ls : longint;
begin
      l := Length(FileName); lt := l + 1; ls := 0;
 if l > 0 then begin
  for f := l downto 1 do begin
    if (lt = l + 1) and (FileName[f] = '.') then lt := f;
    if FileName[l] = '/' then begin ls := f; break; end;
  end;
 Result := Copy(FileName, ls + 1, l - (l - (lt - 1)) - ls );
 end else result := '';
end;

function TGORG64Event.weekday : byte; begin result := WeekdayRu(year, month, day); end;

function TGORG64Event.MToInt : Int64;
var
	y, m : int64;
begin // http://we.easyelectronics.ru/Soft/konvertaciya-vremeni.html
	if month < 3 then begin  y := year - 2001; m := month + 9; end else begin  y := year - 2000; m := month - 3; end;
	result := (day - 1 + ado[m+1] + y * 365 + y  shr  2 - y div  100 + y div 400) * 1440 + hour * 60 + minute;
end;
function TGORG64Event.HToInt : Int64;
var
	y, m : int64;
begin
	if month < 3 then begin  y := year - 2001; m := month + 9; end else begin  y := year - 2000; m := month - 3; end;
	result := (day - 1 + ado[m+1] + y * 365 + y  shr  2 - y div  100 + y div 400) * 24 + hour ;
end;
function TGORG64Event.DToInt : Int64;
var
	y, m : int64;
begin
	if month < 3 then begin  y := year - 2001; m := month + 9; end else begin  y := year - 2000; m := month - 3; end;
	result := day - 1 + ado[m+1] + y * 365 + y  shr  2 - y div  100 + y div 400;
end;

function TGORG64Event.GetHrMn : word; begin result := hour * 60 + minute end;
procedure TGORG64Event.SetHrMn(Value : word); begin hour := Value div 60; minute := Value mod 60; end;

procedure TGORG64Event.GetCurrentTime;
begin
year    := main.year;
month   := main.month;
day     := main.day;
hour    := main.hour;
minute  := main.minute;
end;

procedure TGORG64Event.ForNew;
begin
year    := main.year;
month   := main.month;
day     := main.day;
hour    := main.hour;
minute  := main.minute;
wd := 0;
period := 0;
cycle := 2;
mess := '';
remove := true;
realtime := false;
disable := false;
display := false;
SetLength(musics, 0);
SetLength(sounds, 0);
SetLength(scripts, 0);
clockpanel := 0;
shutdown := 0;
end;


function TGORG64Event.SelfDataStarshe(m : TGORG64Event) : boolean;
begin
  result := (m.year > year) or
   ((m.year = year) and (m.month > month)) or
    ((m.year = year) and (m.month = month) and (m.day > day));
end;

function TGORG64Event.SelfTimeStarshe(m : TGORG64Event) : boolean; begin result := (m.hour > hour) or ((m.hour = hour) and (m.minute > minute)); end;

function TGORG64Event.SelfDataAndTimeStarshe(m : TGORG64Event) : boolean;
begin
  result := (m.year > year) or
   ((m.year = year) and (m.month > month)) or
    ((m.year = year) and (m.month = month) and (m.day > day)) or
     ((m.year = year) and (m.month = month) and (m.day = day) and (m.hour > hour)) or
      ((m.year = year) and (m.month = month) and (m.day = day) and (m.hour = hour) and (m.minute > minute));
end;

function TGORG64Event.SelfDataRavno(m : TGORG64Event) : boolean; begin result := (m.year = year) and (m.month = month) and (m.day = day); end;

function TGORG64Event.SelfTimeRavno(m : TGORG64Event) : boolean; begin result := (m.hour = hour) and (m.minute = minute); end;

function TGORG64Event.SelfDataAndTimeRavno(m : TGORG64Event) : boolean; begin result := (m.year = year) and (m.month = month) and (m.day = day) and (m.hour = hour) and (m.minute = minute); end;

function TGORG64Event.SelfDataStarsheNoYear(m : TGORG64Event) : boolean;
begin
  result := (m.month > month) or
   (m.month = month) and (m.day > day);
end;

function TGORG64Event.SelfDataAndTimeStarsheNoYear(m : TGORG64Event) : boolean;
begin
  result := (m.month > month) or
   (m.month = month) and (m.day > day) or
    (m.month = month) and (m.day = day) and (m.hour > hour) or
     (m.month = month) and (m.day = day) and (m.hour = hour) and (m.minute > minute);
end;

function TGORG64Event.SelfDataRavnoNoYear(m : TGORG64Event) : boolean; begin result := (m.month = month) and (m.day = day); end;

function TGORG64Event.SelfDataAndTimeRavnoNoYear(m : TGORG64Event) : boolean; begin result := (m.month = month) and (m.day = day) and (m.hour = hour) and (m.minute = minute); end;

procedure TGORG64Event.PlusMinute;
  var
    m,d,h,mi : Int64;    
begin
m := month; d := day; h := hour; mi := minute;
  inc(mi);
 if mi = 60 then begin
    mi := 0;
    inc(h);
   if h = 24 then begin
      h := 0;
      inc(d);
     if d > monthlen(year, m) then begin
        d := 1;
        inc(m);
       if m > 12 then begin
          m := 1;
          inc(year);
       end;
     end;
   end;
 end;
month := m; day := d; hour := h; minute := mi;
end;

procedure TGORG64Event.PlusMinutes(m : Int64);
var
f : Int64;
begin
if m < 1 then exit;
for f := 1 to m do PlusMinute;
end;
procedure TGORG64Event.PlusHours(h : Int64);
var
f : Int64;
begin
if h < 1 then exit;
for f := 1 to h do PlusHour;
end;
procedure TGORG64Event.PlusDays(d : Int64);
var
f : Int64;
begin
if d < 1 then exit;
for f := 1 to d do PlusDay;
end;

procedure TGORG64Event.PlusHour;
  var
    m,d,h : Int64;    
begin
m := month; d := day; h := hour;
    inc(h);
   if h = 24 then begin
      h := 0;
      inc(d);
     if d > monthlen(year, m) then begin
        d := 1;
        inc(m);
       if m > 12 then begin
          m := 1;
          inc(year);
       end;
     end;
   end;
month := m; day := d; hour := h;
end;

procedure TGORG64Event.PlusDay;
  var
    m,d : Int64;
begin
m := month; d := day;
      inc(d);
     if d > monthlen(year, m) then begin
        d := 1;
        inc(m);
       if m > 12 then begin
          m := 1;
          inc(year);
       end;
     end;
month := m; day := d;
end;

procedure TGORG64Event.PlusMonth;
  var
    m : Int64;
begin
m := month;  
        inc(m);
       if m > 12 then begin
          m := 1;
          inc(year);
       end;
month := m;
end;

procedure TGORG64Event.MinusMinute;
  var
    m,d : Int64;    
begin
m := month; d := day;
  if minute = 0 then begin
     minute := 59;
     if hour = 0 then begin
        hour := 23;
        dec(d);
       if d = 0 then begin
          dec(m);
         if m = 0 then begin
            m := 12;
            dec(year);
         end;
       d := monthlen(year, m);
       end;
     end else dec(hour);
  end else dec(minute);
month := m; day := d;
end;

procedure TGORG64Event.MinusHour;
  var
    m,d : Int64;
begin
m := month; d := day;
     if hour = 0 then begin
        hour := 23;
        dec(d);
       if d = 0 then begin
          dec(m);
         if m = 0 then begin
            m := 12;
            dec(year);
         end;
       d := monthlen(year, m);
       end;
     end else dec(hour);
month := m; day := d;
end;

procedure TGORG64Event.MinusDay;
  var
    m, d : Int64;
begin
m := month; d := day;
       dec(d);
       if d = 0 then begin
          dec(m);
         if m = 0 then begin
            m := 12;
            dec(year);
         end;
       d := monthlen(year, m);
       end;
month := m; day := d;
end;

procedure TGORG64Event.MinusMonth;
  var
    m : Int64;
begin
m := month;
     dec(m);
        if m = 0 then begin
           m := 12;
           dec(year);
        end;
month := m;        
end;

function TGORG64Event.isRunLess : boolean;
begin
if (not display) and (clockpanel = 0) and  (shutdown = 0) and (Length(sounds) = 0) and (Length(musics) = 0) and (Length(scripts) = 0) then begin
if not askyesno('Событию не назначено действие. Всё равно продолжить ? | RunLess. Add ?','GALAXY ORGANIZER') then Exit(true);
end; {end if}
Exit(false);
end;

function TGORG64Event.Activate(var m : TGORG64Event; const InitTrueRtmFalse, Jubilee : boolean) : boolean;
  var
    cnt : dword = 0;
    tmp : TGORG64Event;
begin if disable then Exit(false);
result := false;
   case period of
      0: result := SelfDataAndTimeRavno(m); // one
      1: result := m.minute = self.minute; // hourly
      2: result := SelfTimeRavno(m); // daily
      3: result := ((self.wd and (1 shl (m.weekday - 1))) <> 0); // w  d
      4: result := self.day = m.day; // day of month
      5: result := ((m.day mod 2) = 0); // chot
      6: result := ((m.day mod 2) <> 0); // nechot
      7: result := SelfDataAndTimeRavnoNoYear(m); // eer
      8: result := SelfDataAndTimeRavnoNoYear(m); // jubilee
      9: begin  // dni
         if m.SelfDataStarshe(self) then exit;
         result := ((m.DToInt - self.DToInt) mod self.cycle) = 0;
      end;
     10: begin // chasy
         if (self.minute <> m.minute)
           or m.SelfDataAndTimeStarshe(self) then exit;
         result := ((m.HToInt - self.HToInt) mod self.cycle) = 0;
      end;
     11: begin // minutes
         if m.SelfDataAndTimeStarshe(self) then exit;
         result := ((m.MToInt - self.MToInt) mod self.cycle) = 0;
      end;
     12: Exit(true); // every minutes
   end;

 if InitTrueRtmFalse then begin
   case period of
   0: result := SelfDataAndTimeStarshe(m) and not realtime;  //  one
   2: result := SelfTimeStarshe(m) and not realtime; // daily
   3..6: result := SelfTimeStarshe(m) and result and not realtime;
   7: result := SelfDataRavnoNoYear(m) and SelfTimeStarshe(m) and not realtime;  // Y
   8: begin // j
     if Jubilee then begin
      tmp := self; tmp.MinusDay;
      result := m.SelfDataRavnoNoYear(tmp);
     end else begin
      result := (SelfDataRavnoNoYear(m) and SelfTimeStarshe(m)) and not realtime;
     end;
   end;
   9: result := SelfTimeStarshe(m) and result and not realtime;
   end;
 end else begin
   case self.period of
     3..6: if result then result := SelfTimeRavno(m);
     9   : if result then result := SelfTimeRavno(m);
   end;
 end;
end;

function TGORG64Event.ActivateInDay(m : TGORG64Event) : boolean;
  var
    f : dword;
    a : TGORG64Event;
begin if disable then Exit(false);
  a := m; result := false;
  for f := 0 to 1439 do begin
    a.HrMn := f;
    result := self.Activate(a, false, false);
   if result then break;
  end;
end;

function TGORG64Event.ActivateIn12p(m : TGORG64Event) : boolean;
var tmp : TGORG64Event;
begin if disable then Exit(false);
result := false;
tmp := self;
tmp.MinusDay;
if self.period = 8 then result := m.SelfDataRavnoNoYear(tmp);
end;

function  TGORG64Event.TryPutData(yr, mn, dt : longint) : boolean;
  var
    l : longint;
begin result := false;
result := (yr < 1) or (mn > 12) or (mn < 1) or (dt < 1);
if result then exit;
l := monthlen(yr, mn);
if dt > l then exit(true);
year := yr;
month := mn;
day := dt;
end;
function TGORG64Event.TryPutTime(hr, min : longint) : boolean;
begin
 result := (hr < 0) or (hr > 23) or (min < 0) or (min > 59);
 if result then exit;
 hour := hr;
 minute := min;
end;
function TGORG64Event.TryPutDataAndTime(yr, mn, dt, hr, min : longint) : boolean;
begin result := TryPutTime(hr, min); if result then exit;
result := TryPutData(yr, mn, dt); end;

function TGORG64Event.DisplayString : msestring;
function fts : msestring;
var f : Int64;
begin
result := '';
for f := 0 to High(musics) do result := result + musics[f] + ',';
for f := 0 to High(sounds) do result := result +  sounds[f] + ',';
for f := 0 to High(scripts) do result := result + scripts[f] + ',';
if result <> '' then result := 'ФАЙЛЫ: ' + result + ' ';
end;
begin
result := '';
if disable then result := str_disable + ', ';
if mess <> '' then result := mess + ', ';
result := result + inttostr(year) + '/' + inttostr(month) + '/' + inttostr(day) + ', ' + inttostr(hour) + ':' + inttostr(minute) + ', ' +
fts +
str_realtime + '=' + inttostr(BooleanToLongint(realtime)) + ', ' +
str_deleteafteruse + '=' + inttostr(BooleanToLongint(remove)) + ', ' +
str_showmessage + '=' + inttostr(BooleanToLongint(display)) + ', ' +
'ДНИ НЕДЕЛИ=' + inttostr(wd) + ', ' +
str_per[period] + ', ' +
'=' + inttostr(cycle) + ', ' +
'ПАНЕЛЬ ЧАСОВ=' + inttostr(clockpanel) + ', ' + 
'ЗАВЕРШЕНИЕ РАБОТЫ КОМП.=' + inttostr(shutdown);
end;

function TGORG64Event.ExportString : msestring;
function fts : msestring;
var f : Int64;
begin result := '';
for f := 0 to High(musics) do result := result + gorg2_music + ':' + musics[f] + #9;
for f := 0 to High(sounds) do result := result + gorg2_sound + ':' + sounds[f] + #9;
for f := 0 to High(scripts) do result := result + gorg2_script + ':' + scripts[f] + #9;
end;
begin
 result :=
 gorg1_disable + ':' + inttostr(BooleanToLongint(disable)) + #9 +
 gorg1_realtime + ':' + inttostr(BooleanToLongint(realtime)) + #9 +
 gorg1_deleteafteruse + ':' + inttostr(BooleanToLongint(remove)) + #9 +
 gorg1_showmessage + ':' + inttostr(BooleanToLongint(display)) + #9 +
 gorg1_week + ':' + inttostr(wd) + #9 +
 gorg1_message + ':' + mess + #9 +
 fts +
 gorg1_cycle + ':' + inttostr(cycle) + #9 +
 gorg1_period + ':' + inttostr(period) + #9 +
 gorg2_clockpanel + ':' + inttostr(clockpanel) + #9 + 
 gorg2_shutdown + ':' + inttostr(shutdown) + #9 + 
 gorg1_minute + ':' + inttostr(minute) + #9 +
 gorg1_hour + ':' + inttostr(hour) + #9 +
 gorg1_day + ':' + inttostr(day) + #9 +
 gorg1_month + ':' + inttostr(month) + #9 +
 gorg1_year + ':' + inttostr(year){ + #9}
 ;
end;

function uStrToInt(s : msestring) : Int64; register;
var f : Int64;
begin
result := 0;
if s[1] = '-' then begin
  for f := 2 to Length(s) do begin
  Result := Result * 10 + (byte(s[f])  - 48);
  end;
Exit(-Result);
end else begin
  for f := 1 to Length(s) do begin
  Result := Result * 10 + (byte(s[f])  - 48);
  end;
end;
end;

function StrToTwoStr(Var s, sl, sr : msestring; br : char) : boolean;
  var
    f, l, fnd : longint;
begin result := false; fnd := 0;  l := length(s);
if l < 1 then begin result := true; exit; end;

for f := 1 to l do
 if s[f] = br then begin
   fnd := f;
   break;
 end;

if (fnd > 1) and (fnd <= l) then begin
 sl := copy(s, 1, fnd - 1);
 if fnd <> l then sr := copy(s, fnd + 1, l - fnd) else sr := '';
end else result := true;
end;

function TGORG64Event.ImportString(s : msestring) : boolean;
  var
    f, l, m1, m2 : longint;
    tmp, strl, strr : msestring;
procedure AddMusic; begin
SetLength(musics, Length(musics) + 1);
musics[High(musics)] := strr;
end;
procedure AddSound; begin
SetLength(sounds, Length(sounds) + 1);
sounds[High(sounds)] := strr;
end;
procedure AddScript; begin
SetLength(scripts, Length(scripts) + 1);
scripts[High(scripts)] := strr;
end;
begin strr := ''; strl := strr;
result := false; m1 := 0; m2 := 0; tmp := '';
    l := length(s);
if  l < 1 then begin result := true; exit; end;
fornew;
 for f := 1 to l do begin
  if (s[f] = #9) or (f = l) then begin

   m2    := f;
   if (f = l) and (s[f] <> #9) then inc(m2);
   if m2 > (m1 + 1) then tmp := copy(s, m1 + 1, m2 - m1 - 1);
   m1    := m2;

   if not StrToTwoStr(tmp, strl, strr, ':') then begin

      if strl = gorg1_disable then begin
         disable := LongintToBoolean(uStrToInt(strr)); continue;
      end;
      if strl = gorg2_clockpanel then begin
         clockpanel := uStrToInt(strr); continue;
      end;
      if strl = gorg2_shutdown then begin
         shutdown := uStrToInt(strr); continue;
      end;
      if strl = gorg1_realtime then begin
         realtime := LongintToBoolean(uStrToInt(strr)); continue;
      end;
      if strl = gorg1_deleteafteruse then begin
         remove := LongintToBoolean(uStrToInt(strr)); continue;
      end;
      if strl = gorg1_showmessage then begin
         display := LongintToBoolean(uStrToInt(strr)); continue;
      end;
      if strl = gorg1_week then begin
         wd := uStrToInt(strr); continue;
      end;
      if strl = gorg1_message then begin
         mess := strr; continue;
      end;
      if strl = gorg1_filename then begin
         strr := strr + '.wav';
         AddSound; continue;
      end;
      if strl = gorg2_music then begin
         AddMusic; continue;
      end;
      if strl = gorg2_sound then begin
         AddSound; continue;
      end;
      if strl = gorg2_script then begin
         AddScript; continue;
      end;
      if strl = gorg1_cycle then begin
         cycle := uStrToInt(strr); continue;
      end;
      if strl = gorg1_period then begin
         period := uStrToInt(strr); continue;
      end;
      if strl = gorg1_minute then begin
        minute := uStrToInt(strr);
        continue;
      end;
      if strl = gorg1_hour then begin
        hour := uStrToInt(strr); continue;
      end;
      if strl = gorg1_day then begin
        day := uStrToInt(strr); continue;
      end;
      if strl = gorg1_month then begin
        month := uStrToInt(strr); continue;
      end;
      if strl = gorg1_year then begin
        year :=  uStrToInt(strr); continue;
      end;
   end;
  end;
 end;
end;

procedure TGORG64Event.Run;
begin
if tun.NoAct then exit;
//PlayMusic(musics);
PlaySound(musics);
PlaySound(sounds);
RunScript(scripts);
if clockpanel > 0 then needclockpanel := clockpanel;
if shutdown > 0 then needshutdown := shutdown;
end;

function TGORG64Event.OutDated : boolean;
var
mev : TGORG64Event;
begin
mev.GetCurrentTime;
if (self.period = 0) and (self.SelfDataAndTimeStarshe(Mev) or self.SelfDataAndTimeRavno(Mev)) then begin
 if not askyesno('Событие просрочено. Всё равно продолжить ? | Outdated. Add ?','GALAXY ORGANIZER') then Exit(true);
end; {end if}
Exit(false);
end;

procedure TOrg.AddHistory(s : msestring);
  var f   : word; tmp : msestring;
begin
SetLength(hst, Length(hst) + 1);
for f := High(hst) downto 1 do hst[f] := hst[f - 1];
hst[0] := inttostr(year) + '/'
 + inttostr(month) + '/' +
  inttofix2str(day) + ' '
   + IntToHour(hour) + ':' + inttofix2str(minute) + ' | ' + s;
org.WorkHistoryFile(true);
needalarm := true;
end;
    
function TOrg.Delete(n : Int64) : boolean;
var hw : Int64;
begin
hw := High(w);
if hw < 0 then exit;
w[n] := w[hw];
SetLength(w, hw);
WorkGorgFile(true);
if efelefo then elefo.Display;
if efeefo and (eefoindex = n) then needeefoclose := true;
end;

function TOrg.Delete(var a : TAoInt64) : boolean;
var hw : Int64;
f : Int64;
begin
if Length(a) = 0 then Exit;
for f := High(a) downto 0 do begin
  if efeefo and (eefoindex = a[f]) then needeefoclose := true;
  hw := High(w);
  if hw < 0 then exit;
  w[a[f]] := w[hw];
  SetLength(w, hw);
end;
WorkGorgFile(true);
SetLength(a, 0);
if efelefo then elefo.Display;
end;

procedure TOrg.AddEvent(e : TGORG64Event);
begin
SetLength(w, Length(w) + 1);
w[High(w)] := e;
WorkGorgFile(true);
if efelefo then elefo.Display;
end;

procedure TOrg.ClearHistory;
begin
SetLength(hst, 0);
org.WorkHistoryFile(true);
end;

procedure TOrg.WorkHistoryFile(SaveTrue : boolean);
var f : Int64;
    s : msestring;
begin
if savetrue then begin
{$I-}
 rewrite(historyfp);
{$I+} FilErr(IOResult, '[Rewrite History File]', false);
for f := 0 to High(hst) do begin
{$I-}
 writeln(historyfp, hst[f]);
{$I+} FilErr(IOResult, '[Write History File]', false);
end;
end else begin
{$I-}
 reset(historyfp);
{$I+} if IOResult <> 0 then begin
 exit;
 end;
while not eof(historyfp) do begin
{$I-}
readln(historyfp, s);
{$I+} if FilErr(IOResult, '[Read History File]', false) then break;
SetLength(hst, Length(hst) + 1);
hst[High(hst)] := s;
end;
end;
{$I-}
closefile(historyfp);
{$I+} FilErr(IOResult, '[Close History File]', false);
end;

procedure TOrg.WorkGorgFile(SaveTrue : boolean);
var f : Int64;
    s : msestring;
begin
if savetrue then begin
{$I-}
 rewrite(gorgfp);
{$I+} FilErr(IOResult, '[Rewrite Work File]', false);
for f := 0 to High(w) do begin
{$I-}
 writeln(gorgfp, w[f].ExportString);
{$I+} FilErr(IOResult, '[Write Work File]', false);
end;
end else begin
{$I-}
 reset(gorgfp);
{$I+} if IOResult <> 0 then begin
 exit;
 end;
while not eof(gorgfp) do begin
{$I-}
readln(gorgfp, s);
{$I+} if FilErr(IOResult, '[Read Work File]', false) then break;
SetLength(w, Length(w) + 1);
if w[High(w)].ImportString(s) then SetLength(w, Length(w) - 1);
end;
end;
{$I-}
 closefile(gorgfp);
{$I+} FilErr(IOResult, '[Close Work File]', false);
SetEventsCount;
end;

procedure TOrg.SetEventsCount;
var  f : Int64; tmp : TGORG64Event;
begin orgtodaycount := 0; tmp.GetCurrentTime;
for f := 0 to High(w) do begin
 if w[f].period <> 1 then
  if w[f].activateinday(tmp) then
   begin inc(orgtodaycount); end; end;
mainfo.Display;
end;

procedure TOrg.AfterConstruction;
begin
  inherited AfterConstruction;
  FreeOnTerminate := True;
end;

procedure TOrg.Execute;
var
f : Int64;
tmp : TGORG64Event;
del : TAoInt64;
procedure Initial;
var
f : Int64;
begin
tmp.fornew;
SetLength(del, 0);
    for f := 0 to High(w) do begin
      if w[f].activate(tmp, true, false) then begin
      if w[f].display then AddHistory(w[f].mess);
      w[f].run;
      if (w[f].period = 0) and w[f].remove then begin SetLength(del, Length(del)+1); del[High(del)] := f; end;
      end;
if w[f].period = 8 then begin
      if w[f].activate(tmp, true, true) then begin
        if w[f].display then AddHistory(mess_jubilee + w[f].mess);
      w[f].run;
      end;
end;
    end;
Delete(del);
end;
  procedure Init12p;
    var f : Int64;
  begin
      for f := 0 to High(org.w) do begin
        if org.w[f].activatein12p(tmp) then begin
          if org.w[f].display then AddHistory(org.w[f].mess);
          org.w[f].run;
        end;
      end;
      Org.SetEventsCount;
  end;
begin
org.WorkGorgFile(false);
org.WorkHistoryFile(false);
Initial;
while not application.terminated do begin
//writeln('begin while');
GetLocalTime(t);
if firstrun or (year <> t.Year) or (month <> t.Month) or (day <> t.Day) or (hour <> t.Hour) or (minute <> t.Minute) then begin
year := t.Year; month := t.Month; day := t.Day;
hour := t.Hour; minute := t.Minute;
firstrun := false;
mainfo.Display;
if efclockpanel then begin clockpanelfo.Display; end;
tmp.GetCurrentTime;
if (hour = 0) and (minute = 0) then begin Init12p; end;
setlength(del,0);
for f := 0 to High(org.w) do begin
try
 if org.w[f].activate(tmp, false, false) then begin
      if org.w[f].display then AddHistory(org.w[f].mess);
      org.w[f].run;
      if (org.w[f].period = 0) and org.w[f].remove then begin SetLength(del, Length(del)+1); del[High(del)] := f; end;
 end;
except end;
end;

Delete(del);

end;
    if NeedDelSndFil then begin
    DelSndFiles;
    NeedDelSndFil := false;
    end; {end if}
//writeln('end while');
sleep(1000);
end;
end;

procedure TOrg.DelSndFiles;
label break2;
  var
    f, ff : Int64;
    r : TSearchRec;
    found : integer;
begin
found := FindFirst(sounddir + 'V*.tta', faAnyFile, r);
WHILE Found = 0 do begin
for f := 0 to High(w) do begin
 for ff := 0 to High(w[f].sounds) do begin
  if (Length(w[f].sounds) > 0) and (w[f].sounds[ff] = r.Name) then
   goto break2;
 end; {next ff}
end; {next f}
DeleteFile(sounddir + r.Name);
break2:
Found := FindNext(r);
END; {wend}
FindClose(r);
end;

end.