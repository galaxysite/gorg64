unit msg;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$CODEPAGE UTF8}
{
    Alarm messages unit.
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
 mseforms,msedragglob,msegrids,msegridsglob,msesimplewidgets,msebitmap,mseimage,
 msetimer,algor;
type
 tmsgfo = class(tmseform)
   tstringgrid1: tstringgrid;
   timage1: timage;
   ttimer1: ttimer;
   trichstockglyphbutton1: trichstockglyphbutton;
   trichstockglyphbutton2: trichstockglyphbutton;
   tfacecomp1: tfacecomp;
   tfacecomp2: tfacecomp;
   tfacecomp3: tfacecomp;
   procedure ontimer(const sender: TObject);
   procedure bclose(const sender: TObject);
   procedure bok(const sender: TObject);
   procedure keyup(const sender: twidget; var ainfo: keyeventinfoty);
   procedure oncreate(const sender: TObject);
   procedure list;
   procedure onclose(const sender: TObject);
   procedure onresize(const sender: TObject);
   procedure Ok;
 end;
var
 msgfo: tmsgfo;
 efmsgfo : boolean = false;
implementation
uses
 msg_mfm,main;
procedure tmsgfo.ontimer(const sender: TObject);
begin
timage1.visible := not timage1.visible;
end;

procedure tmsgfo.bclose(const sender: TObject);
begin
StopSnd;
close;
end;

procedure tmsgfo.Ok;
begin
org.ClearHistory;
StopSnd;
close;
end;

procedure tmsgfo.bok(const sender: TObject);
begin
Ok;
end;

procedure tmsgfo.keyup(const sender: twidget; var ainfo: keyeventinfoty);
begin
  if ainfo.key = key_Escape then Close;
  if ainfo.key = key_Return then Ok;
end;

procedure tmsgfo.list;
var
   f : Int64;
begin
tstringgrid1.rowcount := Length(org.hst);
for f := 0 to High(org.hst) do begin
tstringgrid1[0].items[f] := org.hst[f];
end;
end;

procedure tmsgfo.oncreate(const sender: TObject);
begin
list;
end;

procedure tmsgfo.onclose(const sender: TObject);
begin
efmsgfo := false;
end;

procedure tmsgfo.onresize(const sender: TObject);
begin
//tstringgrid1[0].width := tstringgrid1.width - 30;
end;

end.
