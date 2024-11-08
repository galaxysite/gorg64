unit clockpanel;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$CODEPAGE UTF8}
{
    Clock panel unit.
    For GNU/Linux 64 bit version.
    Version: 1.
    Written on FreePascal (https://freepascal.org/).
    Copyright (C) 1995-2021  Artyomov Alexander
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
 msetypes,msekeyboard,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,
 msemenus,msegui,msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,
 mseforms,msesimplewidgets,sysutils,algor,time,msetimer;
type
 tclockpanelfo = class(tmseform)
   tlabel1: tlabel;
   tlabel2: tlabel;
   tlabel3: tlabel;
   trichstockglyphbutton1: trichstockglyphbutton;
   ttimer1: ttimer;
   tpaintbox1: tpaintbox;
   procedure bclose(const sender: TObject);
   procedure keyup(const sender: twidget; var ainfo: keyeventinfoty);
   procedure onclose(const sender: TObject);
   procedure Display;
   procedure oncreate(const sender: TObject);
   procedure onmouseev(const sender: twidget; var ainfo: mouseeventinfoty);
   procedure ontimer(const sender: TObject);
 end;
const
 slice = 5;
var
 clockpanelfo: tclockpanelfo;
 efclockpanel : boolean = false;
 marquee : msestring = '--:--';
 caret : Int64 = 1;
 len : Int64;
implementation
uses
 clockpanel_mfm,main;
 
procedure tclockpanelfo.Display;
begin
if tun.p^.small_screen then begin
//marquee := IntToHour(hour) + ':' + IntToFix2Str(minute) + ' ' + IntToStr(day) + ' ' + mon_names[month] + ' (' + IntToStr(month) + ')' + wdn[WeekdayRu(year, month, day)] + ' ' + IntToStr(year);
//caret := 1; len := Length(marquee);
tlabel1.caption := IntToHour(hour) + ':' + IntToFix2Str(minute);
tlabel2.caption := mon_names3[month];
tlabel3.caption := wdn2[WeekdayRu(year, month, day)] + ' ' + IntToStr(day); // + '(' + IntToStr(month) + ')';
end else begin
tlabel1.caption := IntToStr(year) + '  ' + IntToHour(hour) + ':' + IntToFix2Str(minute);
tlabel2.caption := IntToStr(day) + ' ' + mon_names3[month] + IntToMonth(year,month);
tlabel3.caption := wdn[WeekdayRu(year, month, day)];
end;
end;
 
procedure tclockpanelfo.bclose(const sender: TObject);
begin
close;
end;
procedure tclockpanelfo.keyup(const sender: twidget; var ainfo: keyeventinfoty);
begin
  if ainfo.key = key_Escape then Close;
end;
procedure tclockpanelfo.onclose(const sender: TObject);
begin
efclockpanel := false;
end;

procedure tclockpanelfo.oncreate(const sender: TObject);
begin
//ttimer1.enabled := tun.small_screen;
//tlabel2.visible := not tun.small_screen;
//tlabel3.visible := not tun.small_screen;
if tun.p^.small_screen then begin
tlabel1.top := 0;
tlabel2.top := 210;
tlabel3.top := 450;
end;
Display;
end;

procedure tclockpanelfo.onmouseev(const sender: twidget;
               var ainfo: mouseeventinfoty);
begin
  if ainfo.eventkind = ek_buttonrelease then
    begin
      if ainfo.button = mb_right then begin
      mainfo.tpopupmenu1.Show(self, ainfo);
      end;
    end;
end;

procedure tclockpanelfo.ontimer(const sender: TObject);
var f : Int64;
    tmp : msestring;
begin
for f := caret to len do begin
tmp := tmp + marquee[f];
if Length(tmp) = slice then break;
end;
//inc(caret); if caret > len then caret := 1;
//tlabel1.caption := tmp;
if trichstockglyphbutton1.caption = '/' then begin
 trichstockglyphbutton1.caption := '\';
 trichstockglyphbutton1.captionrich := '\';
 end else begin
 trichstockglyphbutton1.caption := '/';
 trichstockglyphbutton1.captionrich := '/';
 end;
end;

end.

