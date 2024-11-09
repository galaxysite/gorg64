unit ee;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$ASMMODE INTEL}
{$CODEPAGE UTF8}
{
    Event editor unit.
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
interface
uses
 linux,unix,baseunix,algor,msetypes,msekeyboard,mseglob,mseguiglob,mseguiintf,
 mseapplication,msestat,msemenus,msegui,msegraphics,msegraphutils,mseevent,
 mseclasses,msewidgets,mseforms,mseact,msebitmap,msedataedits,msedatanodes,
 msedragglob,msedropdownlist,mseedit,msefiledialog,msegrids,msegridsglob,
 mseificomp,mseificompglob,mseifiglob,mselistbrowser,msestatfile,msestream,
 msesys,sysutils,time,msesimplewidgets,msedispwidgets,mserichstring,
 msegraphedits,msescrollbar,msesplitter, lng;
type
 teefo = class(tmseform)
   tfilelistview1: tfilelistview;
   tlabel1: tlabel;
   tbutton5: tbutton;
   tbutton6: tbutton;
   tbutton7: tbutton;
   tbutton8: tbutton;
   tbutton9: tbutton;
   tbutton10: tbutton;
   tbutton11: tbutton;
   tbutton12: tbutton;
   tbutton13: tbutton;
   tbutton14: tbutton;
   tbutton15: tbutton;
   tbutton16: tbutton;
   tbutton17: tbutton;
   tbutton18: tbutton;
   tbutton19: tbutton;
   tbutton20: tbutton;
   tbutton21: tbutton;
   tbutton22: tbutton;
   tbutton23: tbutton;
   tbutton24: tbutton;
   tbutton25: tbutton;
   tbutton26: tbutton;
   tbutton27: tbutton;
   tbutton28: tbutton;
   tbutton29: tbutton;
   tbutton30: tbutton;
   tbutton31: tbutton;
   tbutton32: tbutton;
   tbutton33: tbutton;
   tbutton34: tbutton;
   tbutton35: tbutton;
   tbutton36: tbutton;
   tbutton37: tbutton;
   tbutton38: tbutton;
   tbutton39: tbutton;
   tbutton40: tbutton;
   tbutton41: tbutton;
   tbutton42: tbutton;
   tbutton43: tbutton;
   tdropdownlistedit1: tdropdownlistedit;
   trichbutton4: trichbutton;
   trichbutton5: trichbutton;
   trichbutton6: trichbutton;
   tbooleanedit8: tbooleanedit;
   beDisable: tbooleanedit;
   beRealTime: tbooleanedit;
   tbooleanedit12: tbooleanedit;
   tbutton1: tbutton;
   tbutton2: tbutton;
   trichbutton7: trichbutton;
   trichbutton8: trichbutton;
   tfilelistview2: tfilelistview;
   mo1: tbutton;
   mo2: tbutton;
   mo3: tbutton;
   mo4: tbutton;
   mo5: tbutton;
   mo6: tbutton;
   mo7: tbutton;
   mo8: tbutton;
   mo9: tbutton;
   mo10: tbutton;
   mo11: tbutton;
   mo12: tbutton;
   tfilelistview3: tfilelistview;
   tpopupmenu1: tpopupmenu;
   tpopupmenu2: tpopupmenu;
   tpopupmenu3: tpopupmenu;
   tbutton3: tbutton;
   wd1: tbutton;
   wd2: tbutton;
   wd3: tbutton;
   wd4: tbutton;
   wd5: tbutton;
   wd6: tbutton;
   wd7: tbutton;
   md1: tbutton;
   md2: tbutton;
   md3: tbutton;
   md4: tbutton;
   md5: tbutton;
   md6: tbutton;
   md7: tbutton;
   md8: tbutton;
   md9: tbutton;
   md10: tbutton;
   md11: tbutton;
   md12: tbutton;
   md13: tbutton;
   md14: tbutton;
   md15: tbutton;
   md16: tbutton;
   md17: tbutton;
   md18: tbutton;
   md19: tbutton;
   md20: tbutton;
   md21: tbutton;
   md22: tbutton;
   md23: tbutton;
   md24: tbutton;
   md25: tbutton;
   md26: tbutton;
   md27: tbutton;
   md28: tbutton;
   md29: tbutton;
   md30: tbutton;
   md31: tbutton;
   timagelist1: timagelist;
   timagelist2: timagelist;
   timagelist3: timagelist;
   timagelist4: timagelist;
   tbutton4: tbutton;
   tpopupmenu4: tpopupmenu;
   trichstockglyphbutton1: trichstockglyphbutton;
   trichstockglyphbutton2: trichstockglyphbutton;
   trichstockglyphbutton3: trichstockglyphbutton;
   trichstockglyphbutton4: trichstockglyphbutton;
   tbutton44: tbutton;
   cyc: tintegeredit;
   tsplitter1: tsplitter;
   tsplitter2: tsplitter;
   trichstockglyphbutton5: trichstockglyphbutton;
   trichstockglyphbutton6: trichstockglyphbutton;
   trichstockglyphbutton7: trichstockglyphbutton;
   trichstockglyphbutton8: trichstockglyphbutton;
   timagelist5: timagelist;
   tframecomp2: tframecomp;
   byear: tbutton;
   tstringdisp1: tstringdisp;
   tstringdisp2: tstringdisp;
   procedure oncr(const sender: TObject);
   procedure play(const sender: TObject);
   procedure stop(const sender: TObject);
   procedure can(const sender: TObject);
   procedure h0(const sender: TObject);
   procedure DisplayTime;
   procedure DisplayMonth;
   procedure DisplayDay;
   procedure DisplayCentury;
   procedure DisplayClockPanel;
   procedure DisplayShutdown;
   procedure DisplayPer;
   procedure h1(const sender: TObject);
   procedure h2(const sender: TObject);
   procedure h3(const sender: TObject);
   procedure h4(const sender: TObject);
   procedure h5(const sender: TObject);
   procedure h6(const sender: TObject);
   procedure h7(const sender: TObject);
   procedure h8(const sender: TObject);
   procedure h9(const sender: TObject);
   procedure h10(const sender: TObject);
   procedure h11(const sender: TObject);
   procedure h12(const sender: TObject);
   procedure h13(const sender: TObject);
   procedure h14(const sender: TObject);
   procedure h15(const sender: TObject);
   procedure h16(const sender: TObject);
   procedure h17(const sender: TObject);
   procedure h18(const sender: TObject);
   procedure h19(const sender: TObject);
   procedure h20(const sender: TObject);
   procedure h21(const sender: TObject);
   procedure h22(const sender: TObject);
   procedure h23(const sender: TObject);
   procedure m0(const sender: TObject);
   procedure m1(const sender: TObject);
   procedure m10(const sender: TObject);
   procedure m20(const sender: TObject);
   procedure m30(const sender: TObject);
   procedure m40(const sender: TObject);
   procedure m50(const sender: TObject);
   procedure m2(const sender: TObject);
   procedure m3(const sender: TObject);
   procedure m4(const sender: TObject);
   procedure m5(const sender: TObject);
   procedure m6(const sender: TObject);
   procedure m7(const sender: TObject);
   procedure m8(const sender: TObject);
   procedure m9(const sender: TObject);
   procedure keyup(const sender: twidget; var ainfo: keyeventinfoty);
   procedure onclose(const sender: TObject);
   procedure plusyear(const sender: TObject);
   procedure minusyear(const sender: TObject);
   procedure plusminute;
   procedure plusminutes;
   procedure plushours;
   procedure plusdays;
   procedure minusminute;
   procedure plushour;
   procedure minushour;
   procedure keydown(const sender: twidget; var ainfo: keyeventinfoty);
   procedure mo1e(const sender: TObject);
   procedure mo2e(const sender: TObject);
   procedure mo3e(const sender: TObject);
   procedure mo4e(const sender: TObject);
   procedure mo5e(const sender: TObject);
   procedure mo6e(const sender: TObject);
   procedure mo7e(const sender: TObject);
   procedure mo8e(const sender: TObject);
   procedure mo9e(const sender: TObject);
   procedure mo10e(const sender: TObject);
   procedure mo11e(const sender: TObject);
   procedure mo12e(const sender: TObject);
   procedure ondisable(const sender: TObject);
   procedure onrealtime(const sender: TObject);
   procedure ondelete(const sender: TObject);
   procedure onshowmessage(const sender: TObject);
   procedure ontextedited(const sender: tcustomedit; var atext: msestring);
   procedure ondeselectsound(const sender: TObject);
   procedure ondeselectmusic(const sender: TObject);
   procedure brec(const sender: TObject);
   procedure ondelwav(const sender: TObject);
   procedure bclockpanel(const sender: TObject);
   procedure bwd1(const sender: TObject);
   procedure bwd2(const sender: TObject);
   procedure bwd3(const sender: TObject);
   procedure bwd4(const sender: TObject);
   procedure bwd5(const sender: TObject);
   procedure bwd6(const sender: TObject);
   procedure bwd7(const sender: TObject);
   procedure d1(const sender: TObject);
   procedure d2(const sender: TObject);
   procedure d3(const sender: TObject);
   procedure d4(const sender: TObject);
   procedure d5(const sender: TObject);
   procedure d6(const sender: TObject);
   procedure d7(const sender: TObject);
   procedure d8(const sender: TObject);
   procedure d9(const sender: TObject);
   procedure d10(const sender: TObject);
   procedure d11(const sender: TObject);
   procedure d12(const sender: TObject);
   procedure d13(const sender: TObject);
   procedure d14(const sender: TObject);
   procedure d15(const sender: TObject);
   procedure d16(const sender: TObject);
   procedure d17(const sender: TObject);
   procedure d18(const sender: TObject);
   procedure d19(const sender: TObject);
   procedure d20(const sender: TObject);
   procedure d21(const sender: TObject);
   procedure d22(const sender: TObject);
   procedure d23(const sender: TObject);
   procedure d24(const sender: TObject);
   procedure d25(const sender: TObject);
   procedure d26(const sender: TObject);
   procedure d27(const sender: TObject);
   procedure d28(const sender: TObject);
   procedure d29(const sender: TObject);
   procedure d30(const sender: TObject);
   procedure d31(const sender: TObject);
   procedure onplusday(const sender: TObject);
   procedure onperiod(const sender: TObject);
   procedure pm0(const sender: TObject);
   procedure pm1(const sender: TObject);
   procedure pm2(const sender: TObject);
   procedure pm3(const sender: TObject);
   procedure pm4(const sender: TObject);
   procedure pm5(const sender: TObject);
   procedure pm6(const sender: TObject);
   procedure pm7(const sender: TObject);
   procedure pm8(const sender: TObject);
   procedure pm9(const sender: TObject);
   procedure pm10(const sender: TObject);
   procedure ondeselectscript(const sender: TObject);
   procedure ondeletescript(const sender: TObject);
   procedure onaddscript(const sender: TObject);
   procedure onscriptedit(const sender: TObject);
   procedure ok(const sender: TObject);
   procedure add(const sender: TObject);
	procedure plus(c : boolean);
   procedure onshch(const sender: tcustomlistview);
   procedure onmusch(const sender: tcustomlistview);
   procedure onsndch(const sender: tcustomlistview);
   procedure onchangecyc(const sender: TObject);
   procedure LoadHotlist;
   procedure SaveHotlist;
   procedure onsavehotlist(const sender: TObject);
   procedure onafterclosedropdown(const sender: TObject);
   procedure bshutdown(const sender: TObject);
   procedure MemWD;
   procedure DisplayWD;
   procedure DisplayEye;
   procedure SetYear;
   procedure onrename(const sender: TObject);
   procedure onskreenkeyboard(const sender: TObject);
   procedure onshrename(const sender: TObject);
   procedure pm11(const sender: TObject);
   procedure pm12(const sender: TObject);
   procedure eye(const sender: TObject);
   procedure onplushours(const sender: TObject);
   procedure onplusminutes(const sender: TObject);
   procedure onplusdays(const sender: TObject);
   procedure onyearclick(const sender: TObject);
   public
   listwd : array[0..6] of boolean;
 end;
var
 eefo: teefo;
 efeefo : boolean = false;
 eefoindex : Int64 = -1;
 gev : TGORG64Event;
implementation
uses
 ee_mfm,main,clockpanel,ele,inputbox,dayel;
 
procedure teefo.DisplayClockPanel;
begin
case gev.clockpanel of
0 : if str_clockpanel <> '' then tbutton3.caption := str_clockpanel else tbutton3.caption := 'Часы | Clockpanel';
1 : if str_show <> '' then tbutton3.caption := str_show else tbutton3.caption := 'Показать | Show';
2 : if str_hide <> '' then tbutton3.caption := str_hide else tbutton3.caption := 'Скрыть | Hide';
end;
end;
 
procedure teefo.DisplayShutdown;
begin 
case gev.shutdown of
0 : if str_system <> '' then tbutton44.caption := str_system else tbutton44.caption := 'Система | System';
1 : if str_poweroff <> '' then tbutton44.caption := str_poweroff else tbutton44.caption := 'Выключить | Poweroff';
2 : if str_reboot <> '' then tbutton44.caption := str_reboot else tbutton44.caption := 'Перезагрузить | Reboot';
end;
end;
 
procedure teefo.oncr(const sender: TObject);
var f, ff : LongInt;
s : msestringarty;
a : array[0..6] of Int64;
begin
if ruenv then begin font.height := 34; tlabel1.font.height := 40; end;
mo1.caption := '1 ' + mon_names[1];
mo2.caption := '2 ' + mon_names[2];
mo3.caption := '3 ' + mon_names[3];
mo4.caption := '4 ' + mon_names[4];
mo5.caption := '5 ' + mon_names[5];
mo6.caption := '6 ' + mon_names[6];
mo7.caption := '7 ' + mon_names[7];
mo8.caption := '8 ' + mon_names[8];
mo9.caption := '9 ' + mon_names[9];
mo10.caption := '10 ' + mon_names[10];
mo11.caption := '11 ' + mon_names[11];
mo12.caption := '12 ' + mon_names[12];

wd1.caption := wdn2[1];
wd2.caption := wdn2[2];
wd3.caption := wdn2[3];
wd4.caption := wdn2[4];
wd5.caption := wdn2[5];
wd6.caption := wdn2[6];
wd7.caption := wdn2[7];
if tun.p^.engtrue_calend_layout then begin
	wd1.caption := wd1.caption[1]; wd1.width := md1.width;
	wd2.caption := wd2.caption[1]; wd2.width := md1.width; wd2.top := wd1.top;
	wd3.caption := wd3.caption[1]; wd3.width := md1.width; wd3.top := wd1.top;
	wd4.caption := wd4.caption[1]; wd4.width := md1.width; wd4.top := wd1.top;
	wd5.caption := wd5.caption[1]; wd5.width := md1.width; wd5.top := wd1.top;
	wd6.caption := wd6.caption[1]; wd6.width := md1.width; wd6.top := wd1.top;
	wd7.caption := wd7.caption[1]; wd7.width := md1.width; wd7.top := wd1.top;
wd1.hint := wdn[1];wd2.hint := wdn[2];wd3.hint := wdn[3];wd4.hint := wdn[4];wd5.hint := wdn[5];wd6.hint := wdn[6];wd7.hint := wdn[7];
	if tun.p^.engtrue_calend_fmt then begin
wd1.left := wd1.left + wd1.width;
wd2.left := wd1.left + wd1.width;
wd3.left := wd2.left + wd1.width;
wd4.left := wd3.left + wd1.width;
wd5.left := wd4.left + wd1.width;
wd6.left := wd5.left + wd1.width;
	end else begin
wd2.left := wd1.left + wd1.width;
wd3.left := wd2.left + wd1.width;
wd4.left := wd3.left + wd1.width;
wd5.left := wd4.left + wd1.width;
wd6.left := wd5.left + wd1.width;
wd7.left := wd6.left + wd1.width;
	end;
end else begin
if tun.p^.engtrue_calend_fmt then begin
a[0] := wd1.top;
a[1] := wd2.top;
a[2] := wd3.top;
a[3] := wd4.top;
a[4] := wd5.top;
a[5] := wd6.top;
a[6] := wd7.top;
wd1.top := a[1];
wd2.top := a[2];
wd3.top := a[3];
wd4.top := a[4];
wd5.top := a[5];
wd6.top := a[6];
wd7.top := a[0];
end;
end;

tfilelistview1.path := sounddir;
tfilelistview2.path := musicdir;
tfilelistview3.path := scriptdir;

if eefoindex = -1 then gev.ForNew else gev := org.w[eefoindex];
byear.caption := IntToStr(gev.year);
DisplayCentury;
DisplayMonth;
DisplayClockPanel;
DisplayShutdown;
DisplayTime;
tdropdownlistedit1.value := gev.mess;
DisplayPer;
tbooleanedit12.value := gev.display;
tbooleanedit8.value := gev.remove;
cyc.value := gev.cycle;
beDisable.value := gev.disable;
beRealTime.value := gev.realtime;
LoadHotlist;
DisplayWD;
tfilelistview1.selectednames := gev.sounds;
tfilelistview2.selectednames := gev.musics;
tfilelistview3.selectednames := gev.scripts;

if str_event <> '' then Caption := str_event;
if str_disable <> '' then beDisable.hint := str_disable;
if str_deleteafteruse <> '' then tbooleanedit8.hint := str_deleteafteruse;
if str_realtime <> '' then beRealTime.hint := str_realtime;
if str_showmessage <> '' then tbooleanedit12.hint := str_showmessage;
if str_clockpanel <> '' then begin tbutton3.Hint := str_clockpanel; tbutton3.caption := str_clockpanel; end;
if str_shutdown <> '' then tbutton44.Hint := str_shutdown;
if str_per[c_oneshot] <> '' then tpopupmenu4.menu.submenu[c_oneshot].Caption := str_per[c_oneshot];
if str_per[c_hourly] <> '' then tpopupmenu4.menu.submenu[c_hourly].Caption := str_per[c_hourly];
if str_per[c_daily] <> '' then tpopupmenu4.menu.submenu[c_daily].Caption := str_per[c_daily];
if str_per[c_weekdays] <> '' then tpopupmenu4.menu.submenu[c_weekdays].Caption := str_per[c_weekdays];
if str_per[c_dayofmonth] <> '' then tpopupmenu4.menu.submenu[c_dayofmonth].Caption := str_per[c_dayofmonth];
if str_per[c_oneven] <> '' then tpopupmenu4.menu.submenu[c_oneven].Caption := str_per[c_oneven];
if str_per[c_onuneven] <> '' then tpopupmenu4.menu.submenu[c_onuneven].Caption := str_per[c_onuneven];
if str_per[c_annually] <> '' then tpopupmenu4.menu.submenu[c_annually].Caption := str_per[c_annually];
if str_per[c_jubilee] <> '' then tpopupmenu4.menu.submenu[c_jubilee].Caption := str_per[c_jubilee];
if str_per[c_days] <> '' then tpopupmenu4.menu.submenu[c_days].Caption := str_per[c_days];
if str_per[c_hours] <> '' then tpopupmenu4.menu.submenu[c_hours].Caption := str_per[c_hours];
if str_per[c_minutes] <> '' then tpopupmenu4.menu.submenu[c_minutes].Caption := str_per[c_minutes];
if str_per[c_monthly] <> '' then tpopupmenu4.menu.submenu[c_monthly].Caption := str_per[c_monthly];
if str_system <> '' then tbutton44.caption := str_system;
end;

procedure teefo.play(const sender: TObject);
begin
gev.run;
end;

procedure teefo.stop(const sender: TObject);
begin
StopSnd;
end;

procedure teefo.can(const sender: TObject);
begin
Close;
end;

procedure teefo.DisplayMonth;
begin
if gev.month = 1 then mo1.color := $EFEF00 else mo1.color := cl_white;
if gev.month = 2 then mo2.color := $EFEF00 else mo2.color := cl_white;
if gev.month = 3 then mo3.color := $EFEF00 else mo3.color := cl_white;
if gev.month = 4 then mo4.color := $EFEF00 else mo4.color := cl_white;
if gev.month = 5 then mo5.color := $EFEF00 else mo5.color := cl_white;
if gev.month = 6 then mo6.color := $EFEF00 else mo6.color := cl_white;
if gev.month = 7 then mo7.color := $EFEF00 else mo7.color := cl_white;
if gev.month = 8 then mo8.color := $EFEF00 else mo8.color := cl_white;
if gev.month = 9 then mo9.color := $EFEF00 else mo9.color := cl_white;
if gev.month = 10 then mo10.color := $EFEF00 else mo10.color := cl_white;
if gev.month = 11 then mo11.color := $EFEF00 else mo11.color := cl_white;
if gev.month = 12 then mo12.color := $EFEF00 else mo12.color := cl_white;
md29.visible := monthlen(gev.year, gev.month) > 28;
md30.visible := monthlen(gev.year, gev.month) > 29;
md31.visible := monthlen(gev.year, gev.month) > 30;
DisplayDay;
end;

procedure teefo.DisplayDay;
var offset, ret, col, f : Int64;
tmp : tbutton;
function dm(i : LongInt) : tbutton;
begin
case i of
1: Exit(md1); 2: Exit(md2); 3: Exit(md3); 4: Exit(md4);
5: Exit(md5); 6: Exit(md6); 7: Exit(md7); 8: Exit(md8);
9: Exit(md9); 10: Exit(md10); 11: Exit(md11); 12: Exit(md12);
13: Exit(md13); 14: Exit(md14); 15: Exit(md15); 16: Exit(md16);
17: Exit(md17); 18: Exit(md18); 19: Exit(md19); 20: Exit(md20);
21: Exit(md21); 22: Exit(md22); 23: Exit(md23); 24: Exit(md24);
25: Exit(md25); 26: Exit(md26); 27: Exit(md27); 28: Exit(md28);
29: Exit(md29); 30: Exit(md30); 31: Exit(md31);
end;
end;
begin // 24^ 32>
offset := weekdayru(gev.year, gev.month, 1) - 1;
if tun.p^.engtrue_calend_fmt then
    if offset < 6 then begin
       offset := offset + 1;
    end else begin
       offset := 0;
    end;
ret := 0;
col := 0; 
for f := 1 to monthlen(gev.year, gev.month) do begin
tmp := dm(f);
if gev.day = f then tmp.color := $EFEF00 else tmp.color := cl_white;

 {L} if tun.p^.engtrue_calend_layout then begin
if col = 0 then tmp.left := offset * 50 + 270 + (f-1) * 50 else begin
tmp.left := ret * 50 + 270;
if ret < 6 then inc(ret) else ret := 0;
end;
tmp.top := 48 + 48 * col;
 {L} end else begin
if col = 0 then tmp.top := offset * {24}48 + {32 +} (f-1) * {24}48 else begin
tmp.top := ret * {24}48 {+ 32};
if ret < 6 then inc(ret) else ret := 0;
end;
tmp.left := {144}368  + {32} 50 * col;
 {L} end;

if ((f+offset) mod 7) = 0 then inc(col);
end;
end;

procedure teefo.DisplayCentury;
var s : msestring;
begin
s := IntToStr(Century(gev.year)) + 'век | century';
if gev.year < 0 then s := s + ' до нашей эры | B.C.';
byear.hint := s;
end;

procedure teefo.mo1e(const sender: TObject); begin gev.month := 1; gev.day := 1; DisplayMonth; end;
procedure teefo.mo2e(const sender: TObject); begin gev.month := 2; gev.day := 1; DisplayMonth; end;
procedure teefo.mo3e(const sender: TObject); begin gev.month := 3; gev.day := 1; DisplayMonth; end;
procedure teefo.mo4e(const sender: TObject); begin gev.month := 4; gev.day := 1; DisplayMonth; end;
procedure teefo.mo5e(const sender: TObject); begin gev.month := 5; gev.day := 1; DisplayMonth; end;
procedure teefo.mo6e(const sender: TObject); begin gev.month := 6; gev.day := 1; DisplayMonth; end;
procedure teefo.mo7e(const sender: TObject); begin gev.month := 7; gev.day := 1; DisplayMonth; end;
procedure teefo.mo8e(const sender: TObject); begin gev.month := 8; gev.day := 1; DisplayMonth; end;
procedure teefo.mo9e(const sender: TObject); begin gev.month := 9; gev.day := 1; DisplayMonth; end;
procedure teefo.mo10e(const sender: TObject); begin gev.month := 10; gev.day := 1; DisplayMonth; end;
procedure teefo.mo11e(const sender: TObject); begin gev.month := 11; gev.day := 1; DisplayMonth; end;
procedure teefo.mo12e(const sender: TObject); begin gev.month := 12; gev.day := 1; DisplayMonth; end;

procedure teefo.DisplayTime;
begin
tlabel1.caption := IntToHour(gev.hour) + ':' + inttofix2str(gev.minute);
end;
procedure teefo.h0(const sender: TObject); begin gev.hour := 0; gev.minute := 0; DisplayTime; end;
procedure teefo.h1(const sender: TObject); begin gev.hour := 1; gev.minute := 0; DisplayTime; end;
procedure teefo.h2(const sender: TObject); begin gev.hour := 2; gev.minute := 0; DisplayTime; end;
procedure teefo.h3(const sender: TObject); begin gev.hour := 3; gev.minute := 0; DisplayTime; end;
procedure teefo.h4(const sender: TObject); begin gev.hour := 4; gev.minute := 0; DisplayTime; end;
procedure teefo.h5(const sender: TObject); begin gev.hour := 5; gev.minute := 0; DisplayTime; end;
procedure teefo.h6(const sender: TObject); begin gev.hour := 6; gev.minute := 0; DisplayTime; end;
procedure teefo.h7(const sender: TObject); begin gev.hour := 7; gev.minute := 0; DisplayTime; end;
procedure teefo.h8(const sender: TObject); begin gev.hour := 8; gev.minute := 0; DisplayTime; end;
procedure teefo.h9(const sender: TObject); begin gev.hour := 9; gev.minute := 0; DisplayTime; end;
procedure teefo.h10(const sender: TObject); begin gev.hour := 10; gev.minute := 0; DisplayTime; end;
procedure teefo.h11(const sender: TObject); begin gev.hour := 11; gev.minute := 0; DisplayTime; end;
procedure teefo.h12(const sender: TObject); begin gev.hour := 12; gev.minute := 0; DisplayTime; end;
procedure teefo.h13(const sender: TObject); begin gev.hour := 13; gev.minute := 0; DisplayTime; end;
procedure teefo.h14(const sender: TObject); begin gev.hour := 14; gev.minute := 0; DisplayTime; end;
procedure teefo.h15(const sender: TObject); begin gev.hour := 15; gev.minute := 0; DisplayTime; end;
procedure teefo.h16(const sender: TObject); begin gev.hour := 16; gev.minute := 0; DisplayTime; end;
procedure teefo.h17(const sender: TObject); begin gev.hour := 17; gev.minute := 0; DisplayTime; end;
procedure teefo.h18(const sender: TObject); begin gev.hour := 18; gev.minute := 0; DisplayTime; end;
procedure teefo.h19(const sender: TObject); begin gev.hour := 19; gev.minute := 0; DisplayTime; end;
procedure teefo.h20(const sender: TObject); begin gev.hour := 20; gev.minute := 0; DisplayTime; end;
procedure teefo.h21(const sender: TObject); begin gev.hour := 21; gev.minute := 0; DisplayTime; end;
procedure teefo.h22(const sender: TObject); begin gev.hour := 22; gev.minute := 0; DisplayTime; end;
procedure teefo.h23(const sender: TObject); begin gev.hour := 23; gev.minute := 0; DisplayTime; end;
procedure teefo.m0(const sender: TObject); begin gev.minute := 0; gev.minute := 0; DisplayTime; end;
procedure teefo.m10(const sender: TObject); begin gev.minute := 10; DisplayTime; end;
procedure teefo.m20(const sender: TObject); begin gev.minute := 20; DisplayTime; end;
procedure teefo.m30(const sender: TObject); begin gev.minute := 30; DisplayTime; end;
procedure teefo.m40(const sender: TObject); begin gev.minute := 40; DisplayTime; end;
procedure teefo.m50(const sender: TObject); begin gev.minute := 50; DisplayTime; end;
procedure teefo.m1(const sender: TObject); begin gev.minute := (gev.minute div 10) * 10 + 1; DisplayTime; end;
procedure teefo.m2(const sender: TObject); begin gev.minute := (gev.minute div 10) * 10 + 2; DisplayTime; end;
procedure teefo.m3(const sender: TObject); begin gev.minute := (gev.minute div 10) * 10 + 3; DisplayTime; end;
procedure teefo.m4(const sender: TObject); begin gev.minute := (gev.minute div 10) * 10 + 4; DisplayTime; end;
procedure teefo.m5(const sender: TObject); begin gev.minute := (gev.minute div 10) * 10 + 5; DisplayTime; end;
procedure teefo.m6(const sender: TObject); begin gev.minute := (gev.minute div 10) * 10 + 6; DisplayTime; end;
procedure teefo.m7(const sender: TObject); begin gev.minute := (gev.minute div 10) * 10 + 7; DisplayTime; end;
procedure teefo.m8(const sender: TObject); begin gev.minute := (gev.minute div 10) * 10 + 8; DisplayTime; end;
procedure teefo.m9(const sender: TObject); begin gev.minute := (gev.minute div 10) * 10 + 9; DisplayTime; end;

procedure teefo.keyup(const sender: twidget; var ainfo: keyeventinfoty);
begin
if ainfo.key = key_Escape then Close;
if (ainfo.key = key_F1) and (ss_ctrl in ainfo.shiftstate) then begin gev.month := 1; gev.day := 1; DisplayMonth; end;
if (ainfo.key = key_F2) then if (ss_ctrl in ainfo.shiftstate) then begin gev.month := 2; gev.day := 1; DisplayMonth; end else SaveHotlist;
if (ainfo.key = key_F3) and (ss_ctrl in ainfo.shiftstate) then begin gev.month := 3; gev.day := 1; DisplayMonth; exit; end;
if (ainfo.key = key_F4) and (ss_ctrl in ainfo.shiftstate) then begin gev.month := 4; gev.day := 1; DisplayMonth; end;
if (ainfo.key = key_F5) and (ss_ctrl in ainfo.shiftstate) then begin gev.month := 5; gev.day := 1; DisplayMonth; end;
if (ainfo.key = key_F6) and (ss_ctrl in ainfo.shiftstate) then begin gev.month := 6; gev.day := 1; DisplayMonth; end;
if (ainfo.key = key_F7) and (ss_ctrl in ainfo.shiftstate) then begin gev.month := 7; gev.day := 1; DisplayMonth; end;
if (ainfo.key = key_F8) and (ss_ctrl in ainfo.shiftstate) then begin gev.month := 8; gev.day := 1; DisplayMonth; end;
if (ainfo.key = key_F9) and (ss_ctrl in ainfo.shiftstate) then begin gev.month := 9; gev.day := 1; DisplayMonth; end;
if (ainfo.key = key_F10) and (ss_ctrl in ainfo.shiftstate) then begin gev.month := 10; gev.day := 1; DisplayMonth; end;
if (ainfo.key = key_F11) and (ss_ctrl in ainfo.shiftstate) then begin gev.month := 11; gev.day := 1; DisplayMonth; end;
if (ainfo.key = key_F12) and (ss_ctrl in ainfo.shiftstate) then begin gev.month := 12; gev.day := 1; DisplayMonth; end;
if ainfo.key = key_F3 then displayeye;
if (ainfo.key = key_Return) then plus(not(ss_ctrl in ainfo.shiftstate));
if (ainfo.key = key_PageUp) and (ss_ctrl in ainfo.shiftstate) and (ss_shift in ainfo.shiftstate) then plusminutes;
if (ainfo.key = key_Home) and (ss_ctrl in ainfo.shiftstate) and (ss_shift in ainfo.shiftstate) then plushours;
if (ainfo.key = key_T) and (ss_ctrl in ainfo.shiftstate) and (ss_shift in ainfo.shiftstate) then plusdays;
if (ainfo.key = key_Y) and (ss_ctrl in ainfo.shiftstate) and (ss_shift in ainfo.shiftstate) then setyear;
end;

procedure teefo.plusyear(const sender: TObject); begin gev.year := gev.year + 1; byear.caption := IntToStr(gev.year); gev.month := 1; gev.day := 1; DisplayCentury; DisplayMonth; end;
procedure teefo.minusyear(const sender: TObject); begin gev.year := gev.year - 1; byear.caption := IntToStr(gev.year); gev.month := 1; gev.day := 1; DisplayCentury; DisplayMonth; end;

procedure teefo.onclose(const sender: TObject);
begin
efeefo := false;
end;

procedure teefo.plusminute;
begin
//if gev.minute < 59 then inc(gev.minute) else gev.minute := 0;
gev.PlusMinute;
DisplayMonth;
DisplayTime;
byear.caption := IntToStr(gev.year);
end;
procedure teefo.minusminute;
begin
//if gev.minute > 0 then dec(gev.minute) else gev.minute := 59;
gev.MinusMinute;
DisplayMonth;
DisplayTime;
byear.caption := IntToStr(gev.year);
end;
procedure teefo.plushour;
begin
//if gev.hour < 23 then inc(gev.hour) else gev.hour := 0;
gev.plushour;
if gev.hour = 0 then begin DisplayMonth; byear.caption := IntToStr(gev.year); end;
DisplayTime;
end;
procedure teefo.minushour;
begin
//if gev.hour > 0 then dec(gev.hour) else gev.hour := 23;
gev.minushour;
if gev.hour = 23 then begin DisplayMonth; byear.caption := IntToStr(gev.year); end;
DisplayTime;
end;

procedure teefo.keydown(const sender: twidget; var ainfo: keyeventinfoty);
begin
  if (ainfo.key = key_PageUp) and (ss_ctrl in ainfo.shiftstate) and not(ss_shift in ainfo.shiftstate) then plusminute;
  if (ainfo.key = key_PageDown) and (ss_ctrl in ainfo.shiftstate) then minusminute;
  if (ainfo.key = key_Home) and (ss_ctrl in ainfo.shiftstate) and not(ss_shift in ainfo.shiftstate) then plushour;
  if (ainfo.key = key_End) and (ss_ctrl in ainfo.shiftstate) then minushour;
  if (ainfo.key = key_Insert) and (ss_ctrl in ainfo.shiftstate) and (ss_shift in ainfo.shiftstate) then plusyear(self);
  if (ainfo.key = key_Delete) and (ss_ctrl in ainfo.shiftstate) and (ss_shift in ainfo.shiftstate) then minusyear(self);
  if (ainfo.key = key_T) and (ss_ctrl in ainfo.shiftstate) and not(ss_shift in ainfo.shiftstate) then onplusday(self);
end;

procedure teefo.ondelete(const sender: TObject);
begin
gev.remove := tbooleanedit8.value;
end;
procedure teefo.ondisable(const sender: TObject);
begin
gev.disable := beDisable.value;
end;
procedure teefo.onrealtime(const sender: TObject);
begin
gev.realtime := beRealTime.value;
end;
procedure teefo.onshowmessage(const sender: TObject);
begin
gev.display := tbooleanedit12.value;
end;

procedure teefo.ontextedited(const sender: tcustomedit; var atext: msestring);
begin
gev.display := (Length(atext) > 0);
tbooleanedit12.value := gev.display;
gev.mess := atext;
end;

procedure teefo.ondeselectsound(const sender: TObject);
begin
tfilelistview1.path := sounddir;
SetLength(gev.sounds, 0);
end;

procedure teefo.ondeselectmusic(const sender: TObject);
begin
tfilelistview2.path := musicdir;
SetLength(gev.musics, 0);
end;

procedure teefo.ondeselectscript(const sender: TObject);
begin
tfilelistview3.path := scriptdir;
SetLength(gev.scripts, 0);
end;

procedure teefo.brec(const sender: TObject);
var
 f : Int64;
 fn, fntta : msestring;
begin
for f := 1 to 2000 do begin
fn := sounddir + 'V' + inttostr(f) + '.wav';
fntta := sounddir + 'V' + inttostr(f) + '.tta';
if not fileexists(fntta) then begin
RecordSound(fn);
exit;
end;
end;
end;

procedure teefo.ondelwav(const sender: TObject);
var
 s : filenamearty;
 f : Int64;
begin
s := tfilelistview1.selectednames;
for f := 0 to High(s) do deletefile(sounddir + extractfilename(s[f]));
tfilelistview1.path := sounddir;
end;

procedure teefo.bclockpanel(const sender: TObject);
begin
if gev.clockpanel < 2 then inc(gev.clockpanel) else gev.clockpanel := 0;
DisplayClockPanel;
end;

procedure teefo.bwd1(const sender: TObject);
begin
ListWD[0] := not ListWD[0];
MemWD;
DisplayWD;
end;
procedure teefo.bwd2(const sender: TObject);
begin
ListWD[1] := not ListWD[1];
MemWD;
DisplayWD;
end;
procedure teefo.bwd3(const sender: TObject);
begin
ListWD[2] := not ListWD[2];
MemWD;
DisplayWD;
end;
procedure teefo.bwd4(const sender: TObject);
begin
ListWD[3] := not ListWD[3];
MemWD;
DisplayWD;
end;
procedure teefo.bwd5(const sender: TObject);
begin
ListWD[4] := not ListWD[4];
MemWD;
DisplayWD;
end;
procedure teefo.bwd6(const sender: TObject);
begin
ListWD[5] := not ListWD[5];
MemWD;
DisplayWD;
end;
procedure teefo.bwd7(const sender: TObject);
begin
ListWD[6] := not ListWD[6];
MemWD;
DisplayWD;
end;

procedure teefo.d1(const sender: TObject); begin gev.day := 1; DisplayDay; end;
procedure teefo.d2(const sender: TObject); begin gev.day := 2; DisplayDay; end;
procedure teefo.d3(const sender: TObject); begin gev.day := 3; DisplayDay; end;
procedure teefo.d4(const sender: TObject); begin gev.day := 4; DisplayDay; end;
procedure teefo.d5(const sender: TObject); begin gev.day := 5; DisplayDay; end;
procedure teefo.d6(const sender: TObject); begin gev.day := 6; DisplayDay; end;
procedure teefo.d7(const sender: TObject); begin gev.day := 7; DisplayDay; end;
procedure teefo.d8(const sender: TObject); begin gev.day := 8; DisplayDay; end;
procedure teefo.d9(const sender: TObject); begin gev.day := 9; DisplayDay; end;
procedure teefo.d10(const sender: TObject); begin gev.day := 10; DisplayDay; end;
procedure teefo.d11(const sender: TObject); begin gev.day := 11; DisplayDay; end;
procedure teefo.d12(const sender: TObject); begin gev.day := 12; DisplayDay; end;
procedure teefo.d13(const sender: TObject); begin gev.day := 13; DisplayDay; end;
procedure teefo.d14(const sender: TObject); begin gev.day := 14; DisplayDay; end;
procedure teefo.d15(const sender: TObject); begin gev.day := 15; DisplayDay; end;
procedure teefo.d16(const sender: TObject); begin gev.day := 16; DisplayDay; end;
procedure teefo.d17(const sender: TObject); begin gev.day := 17; DisplayDay; end;
procedure teefo.d18(const sender: TObject); begin gev.day := 18; DisplayDay; end;
procedure teefo.d19(const sender: TObject); begin gev.day := 19; DisplayDay; end;
procedure teefo.d20(const sender: TObject); begin gev.day := 20; DisplayDay; end;
procedure teefo.d21(const sender: TObject); begin gev.day := 21; DisplayDay; end;
procedure teefo.d22(const sender: TObject); begin gev.day := 22; DisplayDay; end;
procedure teefo.d23(const sender: TObject); begin gev.day := 23; DisplayDay; end;
procedure teefo.d24(const sender: TObject); begin gev.day := 24; DisplayDay; end;
procedure teefo.d25(const sender: TObject); begin gev.day := 25; DisplayDay; end;
procedure teefo.d26(const sender: TObject); begin gev.day := 26; DisplayDay; end;
procedure teefo.d27(const sender: TObject); begin gev.day := 27; DisplayDay; end;
procedure teefo.d28(const sender: TObject); begin gev.day := 28; DisplayDay; end;
procedure teefo.d29(const sender: TObject); begin gev.day := 29; DisplayDay; end;
procedure teefo.d30(const sender: TObject); begin gev.day := 30; DisplayDay; end;
procedure teefo.d31(const sender: TObject); begin gev.day := 31; DisplayDay; end;

procedure teefo.onplusday(const sender: TObject);
begin
gev.plusday;
byear.caption := IntToStr(gev.year);
displaymonth;
end;

procedure teefo.onperiod(const sender: TObject);
var
po: pointty;
begin
po.x := tbutton4.left;
po.y := tbutton4.top;
tpopupmenu4.show(self, po);
end;
procedure teefo.DisplayPer;
begin
case gev.period of
0: tbutton4.caption := 'Однократно | One-shot';
1: tbutton4.caption := 'Ежечасно | Hourly';
2: tbutton4.caption := 'Ежедневно | Daily';
3: tbutton4.caption := 'Дни недели | Weekdays';
4: tbutton4.caption := 'Число месяца | Day of month';
5: tbutton4.caption := 'По чётным | On even';
6: tbutton4.caption := 'По нечётным | On uneven';
7: tbutton4.caption := 'Ежегодно | Annually';
8: tbutton4.caption := 'Юбилеи | Jubilee';
9: tbutton4.caption := 'Период дни | Period days';
10: tbutton4.caption := 'Период часы | Period hours';
11: tbutton4.caption := 'Период минуты | Period minutes';
12: tbutton4.caption := 'Ежеминутно | Monthly';
end;
if str_per[gev.period] <> '' then tbutton4.caption := str_per[gev.period];
case gev.period of
9,10,11: begin
cyc.visible := true;
//tlabel9.visible := true;
end;
else
cyc.visible := false;
//tlabel9.visible := false;
end;
end;
procedure teefo.pm0(const sender: TObject);
begin
gev.period := 0;
DisplayPer;
end;
procedure teefo.pm1(const sender: TObject);
begin
gev.period := 1;
DisplayPer;
end;
procedure teefo.pm2(const sender: TObject);
begin
gev.period := 2;
DisplayPer;
end;
procedure teefo.pm3(const sender: TObject);
begin
gev.period := 3;
DisplayPer;
end;
procedure teefo.pm4(const sender: TObject);
begin
gev.period := 4;
DisplayPer;
end;
procedure teefo.pm5(const sender: TObject);
begin
gev.period := 5;
DisplayPer;
end;
procedure teefo.pm6(const sender: TObject);
begin
gev.period := 6;
DisplayPer;
end;
procedure teefo.pm7(const sender: TObject);
begin
gev.period := 7;
DisplayPer;
end;
procedure teefo.pm8(const sender: TObject);
begin
gev.period := 8;
DisplayPer;
end;
procedure teefo.pm9(const sender: TObject);
begin
gev.period := 9;
DisplayPer;
end;
procedure teefo.pm10(const sender: TObject);
begin
gev.period := 10;
DisplayPer;
end;
procedure teefo.pm11(const sender: TObject);
begin
gev.period := 11;
DisplayPer;
end;
procedure teefo.pm12(const sender: TObject);
begin
gev.period := 12;
DisplayPer;
end;

procedure teefo.ondeletescript(const sender: TObject);
var
 s : filenamearty;
 f : Int64;
begin
s := tfilelistview3.selectednames;
for f := 0 to High(s) do deletefile(scriptdir + extractfilename(s[f]));
tfilelistview3.path := scriptdir;
end;
procedure teefo.onaddscript(const sender: TObject);
var
 f : Int64;
 fn : filenamety;
 fp : Text;
begin
for f := 1 to 2000 do begin
fn := scriptdir + 'S' + inttostr(f) + '.sh';
if not fileexists(fn) then begin
AssignFile(fp, fn);
ReWrite(fp);
WriteLn(fp, '#!/bin/bash');
WriteLn(fp);
CloseFile(fp);
FpChmod(fn, baseunix.S_IRUSR or baseunix.S_IWUSR or baseunix.S_IXUSR or baseunix.S_IXGRP or baseunix.S_IXOTH or baseunix.S_IRGRP or baseunix.S_IROTH);
tfilelistview3.path := scriptdir;
fpSystem('open ' + fn);
exit;
end;
end;
end;
procedure teefo.onscriptedit(const sender: TObject);
var
 s : filenamearty;
 f : Int64;
begin
s := tfilelistview3.selectednames;
for f := 0 to High(s) do fpSystem('open ' + scriptdir + extractfilename(s[f]));
end;

procedure teefo.ok(const sender: TObject);
begin
plus(true);
end;
procedure teefo.add(const sender: TObject);
begin
plus(false);
end;
procedure teefo.plus(c : boolean);
begin
if gev.outdated or gev.isRunLess then exit;
if eefoindex = -1 then org.AddEvent(gev)
   else begin org.w[eefoindex] := gev;
   org.WorkGorgFile(true);
   if efelefo then elefo.Display;
   end;
if c then Close;
end;

procedure teefo.onshch(const sender: tcustomlistview);
begin
gev.scripts := tfilelistview3.selectednames;
end;
procedure teefo.onmusch(const sender: tcustomlistview);
begin
gev.musics := tfilelistview2.selectednames;
end;
procedure teefo.onsndch(const sender: tcustomlistview);
begin
gev.sounds := tfilelistview1.selectednames;
end;

procedure teefo.onchangecyc(const sender: TObject);
begin
gev.cycle := cyc.value;
end;

procedure teefo.LoadHotlist;
var s : msestring;
begin
tdropdownlistedit1.dropdown.cols.rowcount := 0;
{$I-}
ReSet(hotlistfp);
{$I+} if IOResult <> 0 then exit;
while not eof(hotlistfp) do begin
ReadLn(hotlistfp, s);
tdropdownlistedit1.dropdown.cols.rowcount := tdropdownlistedit1.dropdown.cols.rowcount + 1;
tdropdownlistedit1.dropdown.cols[0].items[tdropdownlistedit1.dropdown.cols.rowcount - 1] := s;
end;
CloseFile(hotlistfp);
end;
procedure teefo.SaveHotlist;
var f : Int64;
begin
if gev.mess = '' then exit;
ReWrite(hotlistfp);
WriteLn(hotlistfp, gev.mess);
for f := 0 to tdropdownlistedit1.dropdown.cols.rowcount - 1 do begin
WriteLn(hotlistfp, tdropdownlistedit1.dropdown.cols[0].items[f]);
if f > 200 then break;
end;
CloseFile(hotlistfp);
LoadHotlist;
end;
procedure teefo.onsavehotlist(const sender: TObject);
begin
SaveHotlist;
end;

procedure teefo.onafterclosedropdown(const sender: TObject);
begin
gev.display := (Length(tdropdownlistedit1.value) > 0);
tbooleanedit12.value := gev.display;
gev.mess := tdropdownlistedit1.value;
end;

procedure teefo.bshutdown(const sender: TObject);
begin
if gev.shutdown < 2 then inc(gev.shutdown) else gev.shutdown := 0;
DisplayShutdown;
end;

procedure teefo.DisplayWD;
  var
    f : byte;
begin
for f := 0 to 6 do ListWD[f] := ((1 and (gev.wd shr f)) = 1);
if ListWD[0] then wd1.color := cl_red else wd1.color := cl_white;
if ListWD[1] then wd2.color := cl_red else wd2.color := cl_white;
if ListWD[2] then wd3.color := cl_red else wd3.color := cl_white;
if ListWD[3] then wd4.color := cl_red else wd4.color := cl_white;
if ListWD[4] then wd5.color := cl_red else wd5.color := cl_white;
if ListWD[5] then wd6.color := cl_red else wd6.color := cl_white;
if ListWD[6] then wd7.color := cl_red else wd7.color := cl_white;
end;
procedure teefo.MemWD;
  var
    f : byte;
begin gev.wd := 0;
for f := 0 to 6 do if ListWD[f] then gev.wd := gev.wd or (1 shl f);
end;

procedure teefo.onrename(const sender: TObject);
var
 s : filenamearty;
 tmp : msestring;
begin
s := tfilelistview1.selectednames;
tmp := extractfilename(s[0]);
inputboxstr := tmp;
input;
if tmp <> inputboxstr then begin
if FileExists(sounddir + inputboxstr) then begin
askok('Файл существует | File exists','');
exit;
end;
renamefile(sounddir + tmp, sounddir + inputboxstr);
tfilelistview1.path := sounddir;
SetLength(s, 1);
s[0] := inputboxstr;
tfilelistview1.selectednames := s;
gev.sounds := s;
end;
end;

procedure teefo.onskreenkeyboard(const sender: TObject);
begin
inputboxstr := tdropdownlistedit1.value;
input;
tdropdownlistedit1.value := inputboxstr;
gev.mess := inputboxstr;
gev.display := gev.mess <> '';
tbooleanedit12.value := gev.display;
end;

procedure teefo.onshrename(const sender: TObject);
var
 s : filenamearty;
 tmp : msestring;
begin
s := tfilelistview3.selectednames;
tmp := extractfilename(s[0]);
inputboxstr := tmp;
input;
if tmp <> inputboxstr then begin
if FileExists(scriptdir + inputboxstr) then begin
askok('Файл существует | File exists','');
exit;
end;
renamefile(scriptdir + tmp, scriptdir + inputboxstr);
tfilelistview3.path := scriptdir;
SetLength(s, 1);
s[0] := inputboxstr;
tfilelistview3.selectednames := s;
gev.scripts := s;
end;
end;

procedure teefo.eye(const sender: TObject);
begin
displayeye;
end;
procedure teefo.displayeye;
begin
if efdayelfo then begin
dayelfo.Display;
dayelfo.bringtofront;
end else begin
dayelfo := tdayelfo.Create(nil);
efdayelfo := true;
end;
end;

procedure teefo.onplusminutes(const sender: TObject);
begin
plusminutes;
end;

procedure teefo.onplushours(const sender: TObject);
begin
plushours;
end;

procedure teefo.onplusdays(const sender: TObject);
begin
plusdays;
end;

procedure teefo.plusminutes;
begin
inputboxstr :=  '';
input;
gev.PlusMinutes(StrToIntDef(inputboxstr, 0));
DisplayMonth;
DisplayTime;
byear.caption := IntToStr(gev.year);
end;

procedure teefo.plushours;
begin
inputboxstr :=  '';
input;
gev.PlusHours(StrToIntDef(inputboxstr, 0));
DisplayMonth;
DisplayTime;
byear.caption := IntToStr(gev.year);
end;

procedure teefo.plusdays;
begin
inputboxstr :=  '';
input;
gev.PlusDays(StrToIntDef(inputboxstr, 0));
DisplayMonth;
byear.caption := IntToStr(gev.year);
end;

procedure teefo.SetYear;
begin
inputboxstr := '';
input;
gev.year := StrToIntDef(inputboxstr, gev.year);
gev.month := 1; gev.day := 1;
DisplayMonth; byear.caption := IntToStr(gev.year);
DisplayCentury;
end;
procedure teefo.onyearclick(const sender: TObject);
begin
SetYear;
end;

end.