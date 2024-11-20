unit main;

{
    Main unit.
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

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

{$RANGECHECKS ON}
{$GOTO ON}
{$CODEPAGE UTF8}
{$ASMMODE INTEL}

interface

uses
 msekeyboard, algor, classes, SysUtils, mselibc, msepointer, mseglob,mseguiglob,
 mseguiintf,mseapplication, msegui,msegraphutils,mseevent,mseclasses, mseforms,
 msesimplewidgets, msewidgets, msebitmap,msegraphics,time,msemenus,
 msethreadcomp, msestrings, msetypes, mseact,unix,baseunix,linux,msetimer,
 msedock,msedragglob,msewidgetgrid,msesyntaxedit,x,xlib,keysym,queue,
 ttafunctions,syscall,lng,math;

procedure clipmon;

type 
  tmainfo = class(tmainform)
    tbutton1: TButton;
   tthreadcomp3: tthreadcomp;
   tthreadcomp4: tthreadcomp;
   tthreadcomp5: tthreadcomp;
   ttimer1: ttimer;
   tfacecomp1: tfacecomp;
   tbutton2: tbutton;
   timagelist5: timagelist;
   tframecomp2: tframecomp;
   tpopupmenu1: tpopupmenu;
   tfacecomp2: tfacecomp;
   tfacecomp3: tfacecomp;
   timagelist2: timagelist;
   tpaintbox1: tpaintbox;
   tlabel2: tlabel;
   tpaintbox3: tpaintbox;
   tpaintbox2: tpaintbox;
   tfacecomp4: tfacecomp;
   tfacecomp5: tfacecomp;
   tfacecomp6: tfacecomp;
    procedure onquit(Const Sender: TObject);
    procedure oncreate(Const Sender: TObject);
    procedure onmouseev(Const Sender: twidget; Var ainfo: mouseeventinfoty);
   procedure menuexit(const sender: TObject);
   procedure onmute(const sender: TObject);
   procedure soundplay(const sender: tthreadcomp);
   procedure scriptrun(const sender: tthreadcomp);
   procedure onfixation(const sender: TObject);
   procedure onnoact(const sender: TObject);
   procedure ShowP(a : Int64);
   procedure ShowO(a : Int64);
   procedure ShowEE(a : Int64);
   procedure ShowELE;
   procedure ShowFlash;
   procedure ShowClockPanel;
   procedure ShowAlarm;
   procedure ShowShutdown;
   procedure ShowSettings;
   procedure ShowNotebook;
   procedure ShowYearList;
   procedure ShowHelp;
   procedure onflash(const sender: TObject);
   procedure soundrec(const sender: tthreadcomp);
   procedure DisplayMuteNoact;
   procedure Display;
   procedure ChangeLang;
   procedure doubleclick_action;
   procedure onclockpanel(const sender: TObject);
   procedure onneeds(const sender: TObject);
   procedure onele(const sender: TObject);
   procedure onsettings(const sender: TObject);
   procedure onaddev(const sender: TObject);
   procedure onnotebook(const sender: TObject);
   procedure onaddo(const sender: TObject);
   procedure onaddp(const sender: TObject);
   procedure onhelp(const sender: TObject);
   procedure onyearlist(const sender: TObject);
   procedure onbutton(const sender: TObject);
   procedure onpaintev(const sender: twidget; const acanvas: tcanvas);
   procedure onloopev(const sender: TObject);
   procedure updatelang();
  end;

  TTW = packed record
   tone, duration : Word;
  end;
  PTW=^TTW;
  
type
tvolume = 0..100;
TTu = packed record
    fmute, fnoact       : bytebool;
    al_dlg_mem_action   : byte;
    clip_mon, sync_snd  : bytebool;
    record_prog : byte;
    engtrue_hour_fmt    : bytebool;
    engtrue_calend_fmt  : bytebool;
    flash_accmulate     : bytebool;
    main_left, main_top : integer;
    ee_left, ee_top, ee_width, ee_height : integer;
    ee_maximize : bytebool;
    book_left, book_top, book_width, book_height : integer;
    book_maximize : bytebool;
    lang_code : shortstring;
    f_force_off, engtrue_calend_layout{f_pwr_off} : bytebool;
    main_fixation : bytebool;
    main_doubleclick_action : Int64;
    flash_left, flash_top, flash_width, flash_height : SmallInt;
    flash_maximize : bytebool;
    siz_clock      : SmallInt;  // width of clock panel
    am_pm : array[false..true] of string[255];
    small_screen : bytebool;
    volume : tvolume;
    volumeon : bytebool;
end;
PTu = ^TTu;
    TTun = packed object
	p : PTu;
  a : Int64;
  fFileName: utf8string;
  fs : Int64;
    protected
	procedure SetMute(Value : bytebool);
	procedure SetNoAct(Value : bytebool);
	procedure SetFixation(Value : bytebool);
	procedure SetLangCode(Value : shortstring);
	function GetLangCode : shortstring;
function r_m : bytebool;
function r_n : bytebool;
function r_f : bytebool;
    private
    public
	function map : boolean;
	function unmap : boolean;
	function Load : boolean;
	property Mute : bytebool read r_m write SetMute;
	property NoAct : bytebool read r_n write SetNoAct;
	property Fixation : bytebool read r_f write SetFixation;
	property LangCode : shortstring read GetLangCode write SetLangCode;	
    end;  
  
var
  mainfo: tmainfo;
  gt  : TThread;
  ispressed: Boolean = False;
  oripoint: pointty;
  year, month, day, hour, minute : LongInt;
  t : TSystemTime;
  firstrun : boolean = true;
  needclockpanel : tclockpanelaction = 0;
  needshutdown : tclockpanelaction = 0;
  needalarm : boolean = false;
  needeefoclose : boolean = false;
  NeedDelSndFil : boolean = false;
  tun : TTun;
  mfiles,rfile : msestring;
  sf_queue : tqueue;
  shfiles : filenamearty;
  homedir : msestring;
  lang : msestring;
  ruenv : bytebool = false;
  {$ifdef ootb}
  workdir : msestring = '';
  bindir : msestring = 'bin';
  {$else}
  workdir : msestring = '.gorg64';
  {$endif}
  musicdir : msestring = 'music';
  sounddir : msestring = 'sound';
  flashdir : msestring = 'flash';
  flashfile : msestring = 'flash.txt';
  langdir : msestring = 'lang_s';
  flashfp : Text;
  flashhotlistfile : msestring = 'flashhotlist.txt';
  flashhotlistfp : Text;
  flashstrdividerfile : msestring = 'flash_str_divider.txt';
  scriptdir : msestring = 'script';
  tunfile : msestring = 'tun.bin';
  gorgfile : msestring = 'gorg.txt';
  gorgfp : Text;
  hotlistfile : msestring = 'gorghotlist.txt';
  hotlistfp : Text;
  historyfile : msestring = 'gorghistory.txt';
  historyfp : Text;
  peoplesfile : msestring = 'peoples.txt';
  peoplesfp : Text;
  organizationsfile : msestring = 'organizations.txt';
  organizationsfp : Text;
  yearlistfile : msestring = 'yearlist.txt';
  yearlistfp : Text;
  processrecord : boolean = false;
  canspkplay : boolean = true;
  playsoundstate : Int64 = 0;
  mfilesar : filenamearty;
  arecord_cl : utf8string = '';
  arecord_fn : utf8string = 'arecord_commandline.txt';
  rec_cl : utf8string = '';
  rec_fn : utf8string = 'rec_commandline.txt';
  xmp_cl : utf8string = '';
  xmp_fn : utf8string = 'xmp_commandline.txt';
  mplayer_cl : utf8string = '';
  mplayer_fn : utf8string = 'mplayer_commandline.txt';
  tunfileok : boolean = false;

procedure PlaySound(s : filenamearty);
procedure StopSnd;
function FilErr(I : integer; s : string; fhalt : boolean) : boolean;
procedure RecordSound(s : filenamety);
procedure RunScript(s : filenamearty);
procedure AppClose;
function inttomonth(y : Int64; m : TMonth) : string;
function LoadClFile(fn : utf8string; var cl : utf8string) : boolean;
procedure SaveClFile(fn, cl : utf8string);

implementation

uses 
main_mfm,ee,flash,msg,clockpanel,ele,shutdown,settings,notebook,people,organization,yearlist;

function TTun.r_m : bytebool;
begin
Exit(p^.fmute);
end;
function TTun.r_n : bytebool;
begin
Exit(p^.fnoact);
end;
function TTun.r_f : bytebool;
begin
Exit(p^.main_fixation);
end;

function LoadClFile(fn : utf8string; var cl : utf8string) : boolean;
var
  fp : Text;
begin
Assign(fp, fn);
FileMode := 0;
{$I-}
ReSet(fp);
{$I+} if IOResult <> 0 then Exit(false);
{$I-}
ReadLn(fp, cl);
{$I+} if IOResult <> 0 then Exit(true);
{$I-}
Close(fp);
{$I+} if IOResult <> 0 then Exit(true);
Exit(false);
end;

procedure SaveClFile(fn, cl : utf8string);
var
  fp : Text;
begin
Assign(fp, fn);
FileMode := 1;
{$I-}
 rewrite(fp);
{$I+} FilErr(IOResult, '[Rewrite CL File]', false);
{$I-}
 write(fp, cl);
{$I+} FilErr(IOResult, '[Write CL File]', false);
 closefile(fp);
{$I+} FilErr(IOResult, '[Close CL File]', false);
end;

procedure StopSnd;
var tmp : filenamearty;
begin
sf_queue.Zero;
try
case playsoundstate of

{$ifdef ootb}
2 : fpSystem( bindir + 'gorg64_spkplay --stop');
{$else}
2 : fpSystem('gorg64_spkplay --stop');
{$endif}

3 : fpSystem('killall -s KILL xmp');
4 : fpSystem('killall -s KILL timidity');
5 : fpSystem('killall -s KILL mplayer');
end;
except end;
if processrecord then begin
try
case tun.p^.record_prog of
0: fpSystem('killall -s KILL arecord');
1: fpSystem('killall -s KILL rec');
end; {select}
except end;
end;
end;

procedure PlaySound(s : filenamearty);
var
  f : Int64;
begin
if tun.mute then exit;
if Length(s) < 1 then exit;
for f := 0 to High(s) do sf_queue.add(s[f]);
end;

procedure RunScript(s : filenamearty);
var
  f : Int64;
  tmp : msestring;  
begin
if tun.noact then exit;
if Length(s) > 0 then begin
SetLength(shfiles, Length(s));
for f := 0 to High(s) do shfiles[f] := expandfilename(scriptdir + '"' + s[f] + '" ');
end else begin exit; end;
mainfo.tthreadcomp4.run;
end;

procedure RecordSound(s : filenamety);
begin
if processrecord then exit;
processrecord := true;
rfile := s;
mainfo.tthreadcomp5.run;
end;

procedure AppClose;
begin
StopSnd;
//  application.ProcessMessages;
  mainfo.Close;
end;

function FilErr(I : integer; s : string; fhalt : boolean) : boolean;
begin result := i <> 0;
 if not result then exit;
 askok(PCHar('IOResult=' + IntToStr(i) + ' Error in file: ' + s), PCHar('GORG64'));
 if fhalt then halt;
end;

procedure TTun.SetFixation(Value : bytebool);
begin p^.main_fixation := value;
if p^.main_fixation then begin
   mainfo.tpopupmenu1.menu.items[2].caption := '[v] ' + str_fixation;
   end else begin
   mainfo.tpopupmenu1.menu.items[2].caption := str_fixation;
   end;
end;

procedure tmainfo.onquit(Const Sender: TObject);
begin
AppClose;
end;

function DetectLang : shortstring;
var
i,i2,i3 : integer;
SR : TSearchRec;
l, langsys, langdef : msestring;
begin
l := GetEnvironmentVariable('LANG');
l := system.copy(l,1,2);

i := 0;
i2 := 0;
i3 := 0;

if FindFirst(langdir + '*.txt', faArchive, SR) = 0 then
   begin
     repeat
      if l = copy(SR.Name,1,2) then
      begin
      langsys := SR.Name;
      i2 := i;
      end;      
      if 'en' = copy(SR.Name,1,2) then
      begin
      langdef := SR.Name;
      i3 := i;
      end; 
      inc(i); 
      until FindNext(SR) <> 0;
    FindClose(SR);
   end;   
   
   if langsys <> '' then result := system.copy(langsys,1,2)
   else result := system.copy(langdef,1,2);
  
end;

procedure tmainfo.ChangeLang;
var f : Int64;
i : integer = 0;
SR : TSearchRec;
begin
 if tunfileok = false then
 tun.LangCode := DetectLang;
 tunfileok := true;

if FindFirst(langdir + '*.txt', faArchive, SR) = 0 then
   begin
     repeat
      if system.copy(SR.Name,1,2) = tun.LangCode then
      lang := SR.Name;
      inc(i); 
      until FindNext(SR) <> 0;
    FindClose(SR);
   end;   
   
 tbutton2.left := 698;
 tbutton2.width := 40;

if  system.copy(lang,1,2) = 'ru' then begin
 ruenv := true;
 tbutton2.left := tbutton2.left - 20;
 tbutton2.width := tbutton2.width + 20;
 for f := 1 to 12 do 
 case f of
  1: mon_names[f] := 'ЯНВАРЬ';
  2: mon_names[f] := 'ФЕВРАЛЬ';
  3: mon_names[f] := 'МАРТ';
  4: mon_names[f] := 'АПРЕЛЬ';
  5: mon_names[f] := 'МАЙ';
  6: mon_names[f] := 'ИЮНЬ';
  7: mon_names[f] := 'ИЮЛЬ';
  8: mon_names[f] := 'АВГУСТ';
  9: mon_names[f] := 'СЕНТЯБРЬ';
  10: mon_names[f] := 'ОКТЯБРЬ';
  11: mon_names[f] := 'НОЯБРЬ';
  12 : mon_names[f] := 'ДЕКАБРЬ';
 end; 
 end else
 begin
  ruenv := false;
  for f := 1 to 12 do mon_names[f] := DefaultFormatSettings.LongMonthNames[f];
 end;

lang := langdir + lang;

LoadLng(lang);

if str_editevents <> '' then mainfo.tpopupmenu1.menu.items[3].caption := str_editevents;
if str_addevent <> '' then mainfo.tpopupmenu1.menu.items[4].caption := str_addevent;
if str_notebook <> '' then mainfo.tpopupmenu1.menu.items[5].caption := str_notebook;
if str_addpeople <> '' then mainfo.tpopupmenu1.menu.items[6].caption := str_addpeople;
if str_addorganization <> '' then mainfo.tpopupmenu1.menu.items[7].caption := str_addorganization;
if str_help <> '' then mainfo.tpopupmenu1.menu.items[8].caption := str_help;
if str_settings <> '' then mainfo.tpopupmenu1.menu.items[9].caption := str_settings;
if str_flash <> '' then mainfo.tpopupmenu1.menu.items[10].caption := str_flash;
if str_clockpanel <> '' then mainfo.tpopupmenu1.menu.items[11].caption := str_clockpanel;
if str_yearlist <> '' then mainfo.tpopupmenu1.menu.items[12].caption := str_yearlist; 
if str_quit <> '' then mainfo.tpopupmenu1.menu.items[13].caption := str_quit;
end;

procedure tmainfo.oncreate(Const Sender: TObject);
var f : Int64;
begin

SetExceptionMask(GetExceptionMask + [exZeroDivide] + [exInvalidOp] +
    [exDenormalized] + [exOverflow] + [exUnderflow] + [exPrecision]);

mse_radiuscorner := 30;

{$ifdef ootb}
homedir := ExtractFilePath(ParamStr(0)) + 'data/';
workdir := ExtractFilePath(ParamStr(0))  + 'data/';
musicdir := ExtractFilePath(ParamStr(0)) + 'music/';
sounddir := ExtractFilePath(ParamStr(0)) + 'sound/';
flashdir := ExtractFilePath(ParamStr(0)) + 'flash/';
scriptdir := ExtractFilePath(ParamStr(0)) + 'script/';
bindir := ExtractFilePath(ParamStr(0)) + 'bin/';
langdir := ExtractFilePath(ParamStr(0)) + 'lang_s/';
{$else}
homedir := GetEnvironmentVariable('HOME') + '/';
workdir := homedir + workdir + '/';
musicdir := workdir + musicdir + '/';
sounddir := workdir + sounddir + '/';
flashdir := workdir + flashdir + '/';
scriptdir := workdir + scriptdir + '/';
langdir := '/usr/share/doc/gorg64/';
{$endif}

try
MkDir(workdir);MkDir(musicdir);MkDir(sounddir);MkDir(flashdir);MkDir(scriptdir);
{$ifdef ootb}
MkDir(bindir);
MkDir(langdir);
if FileExists(ExtractFilePath(ParamStr(0)) + 'files.tar.xz') then
fpSystem('tar -C ' + workdir + ' -xvJf ' + ExtractFilePath(ParamStr(0)) + 'files.tar.xz');
{$else}
if FileExists('/usr/share/doc/gorg64/files.tar.xz') then
fpSystem('tar -C ' + workdir + ' -xvJf /usr/share/doc/gorg64/files.tar.xz');
{$endif}
except
end;

tunfile := workdir + tunfile;
flashfile := workdir + flashfile; AssignFile(flashfp, flashfile);
flashhotlistfile := workdir + flashhotlistfile;
flashstrdividerfile := workdir + flashstrdividerfile;
gorgfile := workdir + gorgfile; AssignFile(gorgfp, gorgfile);
hotlistfile := workdir + hotlistfile; AssignFile(hotlistfp, hotlistfile);
flashhotlistfile := workdir + flashhotlistfile; AssignFile(flashhotlistfp, flashhotlistfile);
historyfile := workdir + historyfile; AssignFile(historyfp, historyfile);
peoplesfile := workdir + peoplesfile; AssignFile(peoplesfp, peoplesfile);
organizationsfile := workdir + organizationsfile; AssignFile(organizationsfp, organizationsfile);
yearlistfile := workdir + yearlistfile;
arecord_fn := workdir + arecord_fn;
rec_fn := workdir + rec_fn;
xmp_fn := workdir + xmp_fn;
mplayer_fn := workdir + mplayer_fn;
LoadClFile(arecord_fn, arecord_cl);
LoadClFile(rec_fn, rec_cl);
LoadClFile(xmp_fn, xmp_cl);
LoadClFile(mplayer_fn, mplayer_cl);

if fileexists(tunfile) then
 tunfileok := true;

Tun.Load;

ChangeLang;

DisplayMuteNoact;
Tun.SetFixation(Tun.fixation);
left := tun.p^.main_left;
top := tun.p^.main_top;

//if tun.p^.clip_mon then clipboardcopymonitor := @clipmon;

peoples.Load;
organizations.Load;
LoadUnique;

mainfo.tthreadcomp3.run;

Org := TOrg.Create(True);
Org.Start;
end;

function inttomonth(y : Int64; m : TMonth) : string;
begin
if MonthWithDay(y, m) then Exit('{'+IntToStr(month)+'}') else Exit('('+IntToStr(month)+')');
end;

procedure tmainfo.Display;
begin
mainfo.tlabel2.Caption := IntToHour(hour) + ':' + IntToFix2Str(minute) + ' ' + mon_names3[month] + IntToMonth(year,month) + ' ' +
wdn2[WeekdayRu(year, month, day)] + ' ' + IntToStr(day) + ' ' + IntToStr(year) + ' [' + IntToStr(org.orgtodaycount) + ']';
end;

procedure tmainfo.doubleclick_action;
begin
case tun.p^.main_doubleclick_action of
0: ShowEE(-1);
1: StopSnd;
2: tun.mute := not tun.mute;
3: tun.noact := not tun.noact;
4: ShowELE;
5: ShowFlash;
6: ShowClockPanel;
7: menuexit(self);
end;
end;

procedure tmainfo.onmouseev(Const Sender: twidget; Var ainfo: mouseeventinfoty);
begin
  if ainfo.eventkind = ek_buttonpress then
    begin
    if ss_double in ainfo.shiftstate then
    begin
    doubleclick_action;
    Exit;
    end;
      ispressed := True;
      oripoint  := ainfo.pos;
      tpaintbox3.cursor := cr_pointinghand;
    end;
  if ainfo.eventkind = ek_buttonrelease then
    begin
      ispressed := False;
      tpaintbox3.cursor := cr_default;
      if ainfo.button = mb_right then begin
      tpopupmenu1.Show(self, ainfo);
      end;
    end;
  if (ispressed = True) and (ainfo.eventkind = ek_mousemove) and (not tun.fixation) then
    begin
      left := left + ainfo.pos.x - oripoint.x;
      top  := top + ainfo.pos.y - oripoint.y;
      tun.p^.main_left := left; tun.p^.main_top := top;
    end;
end;

procedure tmainfo.menuexit(const sender: TObject);
begin
 AppClose;
end;

procedure tmainfo.onmute(const sender: TObject);
begin
tun.mute := not tun.mute;
end;

procedure tmainfo.updatelang();
begin
DisplayMuteNoact;
Tun.SetFixation(Tun.fixation);
end;

procedure tmainfo.soundplay(const sender: tthreadcomp);
function vol : msestring;
begin
if not tun.p^.volumeon then Exit('');
result := '-volume ' + IntToStr(tun.p^.volume) + ' ';
end;
var
ext : msestring;
begin
while not application.terminated do begin
sf_queue.get;
if sf_queue.fvalid then begin
ext := mselowercase(ExtractFileExt(sf_queue.fstr));
if (ext = '.speaker') then begin
playsoundstate := 2;

{$ifdef ootb}
fpSystem( bindir + 'gorg64_spkplay ' + musicdir + '"' +  sf_queue.fstr + '"');
{$else}
fpSystem('gorg64_spkplay ' + musicdir + '"' +  sf_queue.fstr + '"');
{$endif}

end else begin
 if (ext = '.mod') or (ext = '.xm') or (ext = '.it') or (ext = '.s3m') then begin
playsoundstate := 3;
  fpSystem('xmp ' + xmp_cl + ' ' + sounddir + '"' +  sf_queue.fstr + '"');
 end else begin
  if (ext = '.mid') then begin
playsoundstate := 4;
   fpSystem('timidity ' + sounddir + '"' +  sf_queue.fstr + '"');
  end else begin
playsoundstate := 5;
   fpSystem('mplayer ' + vol + ' ' + mplayer_cl + ' ' + sounddir + '"' +  sf_queue.fstr + '"');
  end;
 end; 
end;
end;
playsoundstate := 0;
Sleep(800);
end;
end;

procedure tmainfo.scriptrun(const sender: tthreadcomp);
var f : Int64;
begin
for f := 0 to High(shfiles) do fpSystem('/bin/bash ' + shfiles[f]);
end;

procedure tmainfo.onfixation(const sender: TObject);
begin
tun.fixation := not tun.fixation;
end;

procedure tmainfo.onnoact(const sender: TObject);
begin
tun.noact := not tun.noact;
end;

procedure TTun.SetMute(Value : bytebool);
begin
with p^ do begin
fmute := value;
//if fnoact and (not fmute) then begin SetNoAct(false); exit; end;
if fmute then StopSnd;
end;
mainfo.DisplayMuteNoact;
end;

procedure TTun.SetNoact(Value : bytebool);
begin 
with p^ do begin
fnoact := value;
//SetMute(fnoact);
end;
mainfo.DisplayMuteNoact;  
end;

procedure tmainfo.DisplayMuteNoact;
begin
if tun.p^.fmute then
  begin
  tpopupmenu1.menu.items[0].caption := '[v] ' + str_mute;
  tpaintbox1.face.template := tfacecomp4;
  end else
  begin
  tpopupmenu1.menu.items[0].caption := str_mute;
  tpaintbox1.face.template := tfacecomp6;
  end;
  
if tun.p^.fnoact then
  begin
  tpopupmenu1.menu.items[1].caption := '[v] ' + str_noact;
  tpaintbox2.face.template := tfacecomp5;
  end else
  begin
  tpopupmenu1.menu.items[1].caption := str_noact;
  tpaintbox2.face.template := tfacecomp6;    
  end;
  
  tpaintbox1.invalidatewidget;
  tpaintbox2.invalidatewidget;
end;

procedure tmainfo.ShowP(a : Int64);
begin
if efpeoplefo then begin
peoplefo.bringtofront;
exit;
end else begin
pnum := a;
if pnum > -1 then edp := peoples.a[pnum] else edp.ReSet;
peoplefo := tpeoplefo.Create(nil);
efpeoplefo := true;
end;
end;
procedure tmainfo.ShowO(a : Int64);
begin
if eforganizationfo then begin
organizationfo.bringtofront;
exit;
end else begin
onum := a;
if onum > -1 then edo := organizations.a[onum] else edo.ReSet;
organizationfo := torganizationfo.Create(nil);
eforganizationfo := true;
end;
end;

procedure tmainfo.ShowEE(a : Int64);
begin
if efEEfo then begin
eefo.bringtofront;
exit;
end else begin
eefoindex := a;
eefo := teefo.Create(nil);
efEEfo := true;
end;
end;

procedure tmainfo.ShowELE;
begin
if efelefo then begin
elefo.bringtofront;
exit;
end else begin
elefo := telefo.Create(nil);
efelefo := true;
end;
end;

procedure tmainfo.ShowNotebook;
begin
if efnotebookfo then begin
notebookfo.bringtofront;
exit;
end else begin
notebookfo := tnotebookfo.Create(nil);
efnotebookfo := true;
end;
end;

procedure tmainfo.ShowSettings;
begin
if efsettingsfo then begin
settingsfo.bringtofront;
exit;
end else begin
settingsfo := tsettingsfo.Create(nil);
efsettingsfo := true;
end;
end;

procedure tmainfo.ShowShutdown;
begin
needclockpanel := 2;
if efshutdownfo then begin
shutdownfo.bringtofront;
exit;
end else begin
shutdownfo := tshutdownfo.Create(nil);
efshutdownfo := true;
end;
end;

procedure tmainfo.ShowFlash;
var
 str1: msestring;
begin
msewidgets.pastefromclipboard(str1);
if efFlash then begin
 if tun.p^.flash_accmulate then begin
 flashfo.ttextedit2.beginupdate;
flashfo.ttextedit2.settext(flashfo.ttextedit2.gettext + str_divider + str1);
 flashfo.ttextedit2.endupdate;
 exit;
 end else flashfo.bringtofront;
end else begin
flashfo := tflashfo.Create(nil);
efFlash := true;end;
flashfo.ttextedit2.beginupdate;
flashfo.ttextedit2.settext(str1);
flashfo.ttextedit2.endupdate;
end;
procedure tmainfo.onflash(const sender: TObject);
begin
ShowFlash;
end;

procedure tmainfo.ShowClockPanel;
begin
if tun.noact then exit;
if not efclockpanel then begin
clockpanelfo := tclockpanelfo.Create(nil);
efclockpanel := true;
end;
end;

procedure tmainfo.ShowHelp;
begin
{$ifdef ootb}
fpSystem(bindir + 'gorg64_runner xdg-open "man:gorg64 >/dev/null 2>/dev/null" 2>/dev/null');
{$else}
fpSystem('gorg64_runner xdg-open "man:gorg64 >/dev/null 2>/dev/null" 2>/dev/null');
{$endif}
end;

procedure tmainfo.soundrec(const sender: tthreadcomp);
var tmp : filenamearty;
    stmp, noext : filenamety;
begin
if efeefo then eefo.trichbutton6.visible := false;
	if Length(rfile) > 4 then begin
noext := rfile; SetLength(noext, Length(rfile)-4);
try
//fpSystem('arecord -t wav  -f S16_LE -c1 -r44100 ' + rfile);
//fpSystem('arecord -t wav -f S16_LE -c2 -D hw:CARD=SB,DEV=0 ' + rfile);
case tun.p^.record_prog of
0: fpSystem('arecord -t wav ' + arecord_cl + ' ' + rfile);
//1: fpSystem('rec -c 1 ' + rfile);
1: fpSystem('rec ' + rec_cl + ' ' + rfile);
end; {select}
except end;
try fpSystem('wavfix ' + rfile); except end;
stmp := rfile + '.tmp.wav';
try fpSystem('mv ' + noext + '_REPAIRED.wav' + ' ' + rfile); except end;
try fpSystem('sox --norm ' + rfile + ' ' + stmp); except end;
try fpSystem('mv ' + stmp + ' ' + rfile); except end;
stmp := rfile;
rfile := noext + '.tta';
//try fpSystem('ttaenc -e ' + stmp + ' '  + sounddir); except end;
compress(stmp, rfile);
try fpSystem('rm ' + stmp); except end;
//if efEEfo then begin
//eefo.tfilelistview1.path := sounddir;
SetLength(tmp, 1);
tmp[0] := ExtractFileName(rfile);
//try  eefo.tfilelistview1.selectednames := tmp; except end;
 gev.sounds := tmp;
// end;
	end;
processrecord := false;
if efeefo then eefo.trichbutton6.visible := true;
end;

procedure tmainfo.onclockpanel(const sender: TObject);
begin
ShowClockPanel;
end;

procedure tmainfo.ShowAlarm;
begin
if efmsgfo then begin
msgfo.list;
end else begin
msgfo := tmsgfo.Create(nil);
efmsgfo := true;
end;
end;

procedure tmainfo.ShowYearList;
begin
if efyearlistfo then begin
end else begin
yearlistfo := tyearlistfo.Create(nil);
efyearlistfo := true;
end;
end;

procedure tmainfo.onneeds(const sender: TObject);
begin
if tun.noact then exit;
case needclockpanel of
1: begin ShowClockPanel; needclockpanel := 0; end;
2: begin if efclockpanel then clockpanelfo.close; needclockpanel := 0; end;
end;
if needalarm then begin ShowAlarm; needalarm := false; end;
if needshutdown > 0 then begin shutdown.cnt := 10; ShowShutdown; end;
if needeefoclose then begin eefo.Close; needeefoclose := false; end;
{
if scroll_pressed then begin
case tun.p^.main_doubleclick_action of
0: ShowEE(-1);
1: StopSnd;
2: tun.mute := not tun.mute;
3: tun.noact := not tun.noact;
4: ShowELE;
5: ShowFlash;
6: ShowClockPanel;
7: menuexit(self);
end;
scroll_pressed := false;
end;
}
end;

procedure tmainfo.onele(const sender: TObject);
begin
ShowELE;
end;

procedure tmainfo.onsettings(const sender: TObject);
begin
ShowSettings;
end;

procedure tmainfo.onaddev(const sender: TObject);
begin
ShowEE(-1);
end;

procedure tmainfo.onnotebook(const sender: TObject);
begin
ShowNotebook;
end;

procedure tmainfo.onaddo(const sender: TObject);
begin
ShowO(-1);
end;
procedure tmainfo.onaddp(const sender: TObject);
begin
ShowP(-1);
end;

procedure tmainfo.onhelp(const sender: TObject);
begin
ShowHelp;
end;

procedure tmainfo.onyearlist(const sender: TObject);
begin
ShowYearList;
end;

procedure TTun.SetLangCode(Value : shortstring);
begin
if assigned(p) then p^.lang_code := Value;
end;

function TTun.GetLangCode : shortstring;
begin
if assigned(p) then result := p^.lang_code;
end;

function TTun.map : boolean;
var h : Int64;
begin
fFileName := tunfile;
h := do_SysCall(2 {Open}, Int64(PChar(fFileName)),2 {R W old 2}); if h < 0 then begin Exit(true); end;
fs  := do_SysCall(8 {GET LEN}, h,0{from begin},2{SEEK_END});
a := do_SysCall(9 {FILEMAP}, 0{from begin},fs,2{PROT_},1{MAP_},h,0{from begin file});
p := PTu(a);
if (do_SysCall(3 {Close}, h) < 0)  then begin WriteLn(stderr, 'Error: can''t map input file'); Exit(true); end;
if fs <> sizeof(TTu) then Exit(true);
Exit(false);
end;
function TTun.unmap : boolean;
begin
Exit(do_SysCall(11 {Unmap}, a,fs) <> 0);
end;

function TTun.Load : boolean;
var
fp : file of TTu;
tbool : boolean = false;
t : TTu;
begin
if fileexists(tunfile) then tbool := true;
if map then begin
	AssignFile(fp, fFileName);
	FileMode := 2;
	{$I-}
	ReWrite(fp, 1);
	{$I+} FilErr(IOResult, '[Rewrite Tun File]', false);
	{$I-}
with t do begin
 fmute := false;
 al_dlg_mem_action := 0;
 clip_mon          := false;
 sync_snd          := false;
 record_prog      := 0;
 engtrue_hour_fmt    := false;
 engtrue_calend_fmt := Byte(PChar(nl_langinfo(_NL_TIME_FIRST_WEEKDAY))^) <> 2; // false;
 engtrue_calend_layout := false;
 lang_code := DetectLang;
 if not tbool then
 begin
  main_fixation := false;
  fnoact := false;
  main_left := 100;  
  main_top := 10;  
 end; 
 flash_accmulate := false;
 main_doubleclick_action := 0;
 am_pm[true] := am_hour_pm[true];
 am_pm[false] := am_hour_pm[false];
 volume := 60;
 volumeon := false;
end;
	 blockwrite(fp, t, sizeof(t));
	{$I+} FilErr(IOResult, '[Write Tun File]', false);
	{$I-}
	Close(fp);
	{$I+} FilErr(IOResult, '[Close Tun File]', false);
if map then FilErr(IOResult, '[Map Tun File]', false);
end;
end;

procedure clipmon;
begin
mainfo.ShowFlash;
end;

procedure tmainfo.onbutton(const sender: TObject);
begin
doubleclick_action;
end;

procedure tmainfo.onpaintev(const sender: twidget; const acanvas: tcanvas);
begin
   acanvas.linewidth:= 1;
   acanvas.drawrect(mr(0,0,Width-1,Height-1),cl_gray);
   acanvas.drawarc(mp(15,15), 15,  pi, -pi/2, cl_gray);
   acanvas.drawarc(mp(15, Height - 16), 15, pi, pi/2 , cl_gray );
   acanvas.drawarc(mp(width - 15,15), 15, 0, pi / 2, cl_gray );
   acanvas.drawarc(mp(width - 15, Height - 16), 15, 0, -pi/2 , cl_gray );   
end;

procedure tmainfo.onloopev(const sender: TObject);
begin
if tun.p^.main_doubleclick_action = 0 then
mainfo.tbutton2.imagenr := 0 else
if tun.p^.main_doubleclick_action = 1 then
mainfo.tbutton2.imagenr := 5 else
if tun.p^.main_doubleclick_action = 2 then
mainfo.tbutton2.imagenr := 5 else
if tun.p^.main_doubleclick_action = 3 then
mainfo.tbutton2.imagenr := 6 else
if tun.p^.main_doubleclick_action = 4 then
mainfo.tbutton2.imagenr := 9 else
if tun.p^.main_doubleclick_action = 5 then
mainfo.tbutton2.imagenr := 4 else
if tun.p^.main_doubleclick_action = 6 then
mainfo.tbutton2.imagenr := 1 else
if tun.p^.main_doubleclick_action = 7 then
mainfo.tbutton2.imagenr := 2;
end;

initialization
GetLocalTime(t);
year := t.Year; month := t.Month; day := t.Day;
hour := t.Hour; minute := t.Minute;
sf_queue := tqueue.Create;
end.
