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
 msepointer,msemenus,msegui,msegraphics,msegraphutils,mseevent,mseclasses,
 msewidgets,mseforms,msedragglob,msegrids,msegridsglob,msesimplewidgets,
 msebitmap,mseimage,msetimer,algor, msedispwidgets, mserichstring, math;
type
 tmsgfo = class(tmseform)
   tstringgrid1: tstringgrid;
   timage1: timage;
   ttimer1: ttimer;
   tfacecomp1: tfacecomp;
   tfacecomp2: tfacecomp;
   tfacecomp3: tfacecomp;
   tfacecomp4: tfacecomp;
   tfacecomp5: tfacecomp;
   tstringdisp1: tstringdisp;
   trichstockglyphbutton2: trichstockglyphbutton;
   trichstockglyphbutton1: trichstockglyphbutton;
   trichstockglyphbutton3: trichstockglyphbutton;
   tpaintbox1: tpaintbox;
   procedure ontimer(const sender: TObject);
   procedure bclose(const sender: TObject);
   procedure bok(const sender: TObject);
   procedure keyup(const sender: twidget; var ainfo: keyeventinfoty);
   procedure oncreate(const sender: TObject);
   procedure list;
   procedure onclose(const sender: TObject);
   procedure onresize(const sender: TObject);
   procedure Ok;
   procedure onminimize(const sender: TObject);
   procedure onmouseev(const sender: twidget; var ainfo: mouseeventinfoty);
   procedure onpaintev(const sender: twidget; const acanvas: tcanvas);
   end;
var
 msgfo: tmsgfo;
 efmsgfo : boolean = false;
 
implementation
uses
 msg_mfm,main;

var
 ispressed : boolean = false;
 oripoint: pointty; 
 
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
   i: integer;
begin
tstringgrid1.rowcount := Length(org.hst);
tstringgrid1.fixcols[-1].captions.Count := tstringgrid1.rowCount;
for f := 0 to High(org.hst) do begin
i := system.pos('|',org.hst[f]);
tstringgrid1.fixcols[-1].captions[f] := system.copy(org.hst[f], 1, i -1);
tstringgrid1[0].items[f] := system.copy(org.hst[f], i + 1 , length(org.hst[f]));
end;
options := options - [fo_minimized];
show;
tstringgrid1.setfocus;
tstringgrid1.invalidatewidget;
end;

procedure tmsgfo.oncreate(const sender: TObject);
begin
SetExceptionMask(GetExceptionMask + [exZeroDivide] + [exInvalidOp] +
    [exDenormalized] + [exOverflow] + [exUnderflow] + [exPrecision]);
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

procedure tmsgfo.onminimize(const sender: TObject);
begin
options := options - [fo_minimized];
invalidatewidget;
options := options + [fo_minimized];
end;

procedure tmsgfo.onmouseev(Const Sender: twidget; Var ainfo: mouseeventinfoty);
begin
  if ainfo.eventkind = ek_buttonpress then
    begin
      ispressed := True;
      oripoint  := ainfo.pos;
      tpaintbox1.cursor := cr_pointinghand;
    end;
  if ainfo.eventkind = ek_buttonrelease then
    begin
      tpaintbox1.cursor := cr_default;
      ispressed := False;
    end;
  if (ispressed = True) and (ainfo.eventkind = ek_mousemove) then
    begin
      left := left + ainfo.pos.x - oripoint.x;
      top  := top + ainfo.pos.y - oripoint.y;
    end;
end;

procedure tmsgfo.onpaintev(const sender: twidget; const acanvas: tcanvas);
begin
   acanvas.linewidth:= 1;
   acanvas.drawrect(mr(0,0,Width-1,Height-1),cl_gray);
   acanvas.drawarc(mp(15,15), 15,  pi, -pi/2, cl_gray);
   acanvas.drawarc(mp(width - 15,15), 15, 0, pi / 2, cl_gray );
  if not (sender is tpaintbox) then
  begin
   acanvas.drawarc(mp(15, Height - 16), 15, pi, pi/2 , cl_gray );
   acanvas.drawarc(mp(width - 15, Height - 16), 15, 0, -pi/2 , cl_gray );
  end; 
end;

end.
