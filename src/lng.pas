unit lng;

{$MODE OBJFPC}
{$RANGECHECKS ON}
{$GOTO ON}
{$CODEPAGE UTF8}
{$ASMMODE INTEL}


interface

type
ts2 = record
a, v : utf8string;
end;

const
str_event : utf8string = '';
str_mute : utf8string = 'Выключить звук | Mute';
str_noact : utf8string = 'Выключить действия | Turn off actions';
str_fixation : utf8string = 'Фиксация | Fixation';
str_disable : utf8string = '';
str_deleteafteruse : utf8string = '';
str_realtime : utf8string = '';
str_showmessage : utf8string = '';
str_system : utf8string = '';
str_poweroff : utf8string = '';
str_reboot : utf8string = '';
str_clockpanel : utf8string = '';
str_show : utf8string = '';
str_hide : utf8string = '';
str_shutdown : utf8string = '';
str_quit : utf8string = '';
str_help : utf8string = '';
str_flash : utf8string = '';
str_settings : utf8string = '';
str_yearlist : utf8string = '';
str_addorganization : utf8string = '';
str_addpeople : utf8string = '';
str_notebook : utf8string = '';
str_editevents : utf8string = '';
str_addevent : utf8string = '';
c_oneshot = 0;
c_hourly = 1;
c_daily = 2;
c_weekdays = 3;
c_dayofmonth = 4;
c_oneven = 5;
c_onuneven = 6;
c_annually = 7;
c_jubilee = 8;
c_days = 9;
c_hours = 10;
c_minutes = 11;
c_monthly = 12;

var
str_per : array[0..12] of utf8string;

function strto2(s : utf8string) : ts2;
function LoadLng(n : utf8string) : boolean;

implementation

function strto2(s : utf8string) : ts2;
var
l, f : int64;
begin
l := Length(s);
for f := 1 to l do begin
if s[f] = '=' then begin
result.a := Copy(s, 1, f-1);
result.v := Copy(s, f+1, l-f);
break;
end;
end;
end;

function LoadLng(n : utf8string) : boolean;
var
fp : Text;
s : utf8string;
t : ts2;
begin
Assign(fp, n);
FileMode := 0;
{$I-}
ReSet(fp);
{$I+} if IOResult <> 0 then Exit(true);
while not eof(fp) do begin
{$I-}
ReadLn(fp, s);
{$I+}  if IOResult <> 0 then Exit(true);
t := strto2(s);
if t.a = 'event' then str_event := t.v;
if t.a = 'mute' then str_mute := t.v;
if t.a = 'noact' then str_noact := t.v;
if t.a = 'fixation' then str_fixation := t.v;
if t.a = 'disable' then str_disable := t.v;
if t.a = 'deleteafteruse' then str_deleteafteruse := t.v;
if t.a = 'realtime' then str_realtime := t.v;
if t.a = 'showmessage' then str_showmessage := t.v;
if t.a = 'clockpanel' then str_clockpanel := t.v;
if t.a = 'show' then str_show := t.v;
if t.a = 'hide' then str_hide := t.v;
if t.a = 'system' then str_system := t.v;
if t.a = 'shutdown' then str_shutdown := t.v;
if t.a = 'poweroff' then str_poweroff := t.v;
if t.a = 'reboot' then str_reboot := t.v;
if t.a = 'quit' then str_quit := t.v;
if t.a = 'settings' then str_settings := t.v;
if t.a = 'yearlist' then str_yearlist := t.v;
if t.a = 'help' then str_help := t.v;
if t.a = 'flash' then str_flash := t.v;
if t.a = 'addpeople' then str_addpeople := t.v;
if t.a = 'addevent' then str_addevent := t.v;
if t.a = 'addorganization' then str_addorganization := t.v;
if t.a = 'editevents' then str_editevents := t.v;
if t.a = 'notebook' then str_notebook := t.v;
if t.a = 'p_oneshot' then str_per[c_oneshot] := t.v;
if t.a = 'p_hourly' then str_per[c_hourly] := t.v;
if t.a = 'p_daily' then str_per[c_daily] := t.v;
if t.a = 'p_weekdays' then str_per[c_weekdays] := t.v;
if t.a = 'p_dayofmonth' then str_per[c_dayofmonth] := t.v;
if t.a = 'p_oneven' then str_per[c_oneven] := t.v;
if t.a = 'p_onuneven' then str_per[c_onuneven] := t.v;
if t.a = 'p_annually' then str_per[c_annually] := t.v;
if t.a = 'p_jubilee' then str_per[c_jubilee] := t.v;
if t.a = 'p_days' then str_per[c_days] := t.v;
if t.a = 'p_hours' then str_per[c_hours] := t.v;
if t.a = 'p_minutes' then str_per[c_minutes] := t.v;
if t.a = 'p_monthly' then str_per[c_monthly] := t.v;
end; {wend}
{$I-}
Close(fp);
{$I+}  if IOResult <> 0 then Exit(true);
Exit(false);
end;

end.