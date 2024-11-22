unit lng;

{$MODE OBJFPC}
{$RANGECHECKS ON}
{$GOTO ON}
{$CODEPAGE UTF8}
{$ASMMODE INTEL}

interface

uses
sysutils;

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

str_sunday : utf8string = '';
str_monday : utf8string = '';
str_tuesday : utf8string = '';
str_wednesday : utf8string = '';
str_thursday : utf8string = '';
str_friday : utf8string = '';
str_saturday : utf8string = '';

str_january : utf8string = '';
str_february : utf8string = '';
str_march : utf8string = '';
str_april : utf8string = '';
str_may : utf8string = '';
str_june : utf8string = '';
str_july : utf8string = '';
str_august : utf8string = '';
str_september : utf8string = '';
str_october : utf8string = '';
str_november : utf8string = '';
str_december : utf8string = '';

str_about : utf8string = '';
str_emailtoauthor : utf8string = '';
str_visithomepage : utf8string = '';
str_mainpanel : utf8string = '';
str_firstweekdayissunday : utf8string = '';
str_12hoursformat : utf8string = '';
str_am : utf8string = '';
str_pm : utf8string = '';
str_doubleclickaction : utf8string = '';
str_lefttorightweekdaysorder : utf8string = '';
str_language : utf8string = '';

str_sound : utf8string = '';
str_turnonvolumecontrolformplayer : utf8string = '';
str_deletenotusedsoundfiles : utf8string = '';
str_inhz : utf8string = '';
str_inspeakerunits : utf8string = '';
str_speakeroff : utf8string = '';
str_speakeron : utf8string = '';
str_soundgenerator : utf8string = '';

str_smallscreen : utf8string = '';
str_stopplaying : utf8string = '';

str_people : utf8string = '';
str_organizations : utf8string = '';

str_group : utf8string = '';
str_displayas : utf8string = '';
str_name : utf8string = '';
str_alias : utf8string = '';
str_email : utf8string = '';
str_site : utf8string = '';
str_phone : utf8string = '';
str_address : utf8string = '';
str_map : utf8string = '';
str_postalindex : utf8string = '';
str_freearea : utf8string = '';
str_surname : utf8string = '';
str_patronym : utf8string = '';
str_birthday : utf8string = '';
str_deadday : utf8string = '';
str_photo : utf8string = '';
str_video : utf8string = '';
str_gender : utf8string = '';
str_workarea : utf8string = '';
str_dir : utf8string = '';
str_account : utf8string = '';
str_hoursofoperation : utf8string = '';

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
s := n;
If not fileexists(s) then exit;
Assign(fp, s);
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

if t.a = 'p_sunday' then str_sunday := t.v;
if t.a = 'p_monday' then str_monday := t.v;
if t.a = 'p_tuesday' then str_tuesday := t.v;
if t.a = 'p_wednesday' then str_wednesday := t.v;
if t.a = 'p_thursday' then str_thursday := t.v;
if t.a = 'p_friday' then str_friday := t.v;
if t.a = 'p_saturday' then str_saturday := t.v;

if t.a = 'p_january' then str_january := t.v;
if t.a = 'p_february' then str_february := t.v;
if t.a = 'p_march' then str_march := t.v;
if t.a = 'p_april' then str_april := t.v;
if t.a = 'p_may' then str_may := t.v;
if t.a = 'p_june' then str_june := t.v;
if t.a = 'p_july' then str_july := t.v;
if t.a = 'p_august' then str_august := t.v;
if t.a = 'p_september' then str_september := t.v;
if t.a = 'p_october' then str_october := t.v;
if t.a = 'p_november' then str_november := t.v;
if t.a = 'p_december' then str_december := t.v;


if t.a = 'about' then str_about := t.v;
if t.a = 'emailtoauthor' then str_emailtoauthor := t.v;
if t.a = 'visithomepage' then str_visithomepage := t.v;
if t.a = 'mainpanel' then str_mainpanel := t.v;
if t.a = 'firstweekdayissunday' then str_firstweekdayissunday := t.v;
if t.a = '12hoursformat' then str_12hoursformat := t.v;
if t.a = 'am' then str_am := t.v;
if t.a = 'pm' then str_pm := t.v;
if t.a = 'doubleclickaction' then str_doubleclickaction := t.v;
if t.a = 'lefttorightweekdaysorder' then str_lefttorightweekdaysorder := t.v;
if t.a = 'language' then str_language := t.v;

if t.a = 'sound' then str_sound := t.v;
if t.a = 'turnonvolumecontrolformplayer' then str_turnonvolumecontrolformplayer := t.v;
if t.a = 'deletenotusedsoundfiles' then str_deletenotusedsoundfiles := t.v;
if t.a = 'inhz' then str_inhz := t.v;
if t.a = 'inspeakerunits' then str_inspeakerunits := t.v;
if t.a = 'speakeroff' then str_speakeroff := t.v;
if t.a = 'speakeron' then str_speakeron := t.v;
if t.a = 'soundgenerator' then str_soundgenerator := t.v;
if t.a = 'smallscreen' then str_smallscreen := t.v;
if t.a = 'stopplaying' then str_stopplaying := t.v;

if t.a = 'n_people' then str_people := t.v;
if t.a = 'n_organizations' then str_organizations := t.v;

if t.a = 'n_group' then str_group := t.v;
if t.a = 'n_displayas' then str_displayas := t.v;
if t.a = 'n_name' then str_name := t.v;
if t.a = 'n_alias' then str_alias := t.v;
if t.a = 'n_email' then str_email := t.v;
if t.a = 'n_site' then str_site := t.v;
if t.a = 'n_phone' then str_phone := t.v;
if t.a = 'n_address' then str_address := t.v;
if t.a = 'n_map' then str_map := t.v;
if t.a = 'n_postalindex' then str_postalindex := t.v;
if t.a = 'n_freearea' then str_freearea := t.v;
if t.a = 'n_surname' then str_surname := t.v;
if t.a = 'n_patronym' then str_patronym := t.v;
if t.a = 'n_birthday' then str_birthday := t.v;
if t.a = 'n_deadday' then str_deadday := t.v;
if t.a = 'n_photo' then str_photo := t.v;
if t.a = 'n_video' then str_video := t.v;
if t.a = 'n_gender' then str_gender := t.v;
if t.a = 'n_workarea' then str_workarea := t.v;
if t.a = 'n_dir' then str_dir := t.v;
if t.a = 'n_account' then str_account := t.v;
if t.a = 'n_hoursofoperation' then str_hoursofoperation := t.v;

end; {wend}
{$I-}
Close(fp);
{$I+}  if IOResult <> 0 then Exit(true);
Exit(false);
end;

end.