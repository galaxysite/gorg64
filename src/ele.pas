unit ele;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$CODEPAGE UTF8}
{
    Events editor unit.
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
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedragglob,
 msegrids,msegridsglob,algor,msesimplewidgets,msekeyboard,sysutils;
type
 telefo = class(tmseform)
   tstringgrid1: tstringgrid;
   tbutton1: tbutton;
   tbutton2: tbutton;
   trichstockglyphbutton1: trichstockglyphbutton;
   procedure onclose(const sender: TObject);
   procedure oncreate(const sender: TObject);
   procedure butex(const sender: TObject);
   procedure oneditbut(const sender: TObject);
   procedure keyup(const sender: twidget; var ainfo: keyeventinfoty);
   procedure bclose(const sender: TObject);
 public
   procedure Display;
   function Focus : Int64;
 end;
var
 elefo: telefo;
 efelefo : boolean = false;
implementation
uses
 ele_mfm,main;
procedure telefo.onclose(const sender: TObject);
begin
efelefo := false;
end;
procedure telefo.Display;
var f : int64;
begin
tstringgrid1.rowcount := Length(org.w);
for f := 0 to High(org.w) do begin
//tstringgrid1[0].items[f] := IntToStr(f + 1) + '. ' +   org.w[f].DisplayString;
tstringgrid1[0].items[f] := IntToStr(f + 1) + '. ' +   org.w[f].DisplayString;
////tstringgrid1[0].items[f] := org.w[f].ExportString;
end;
end;

procedure telefo.oncreate(const sender: TObject);
begin
Display;
end;

function telefo.Focus : Int64;
var
g : gridcoordty;
f : int64;
begin
result := -1;
g.col := 0;
for f := 0 to High(org.w) do begin
g.row := f;
if tstringgrid1.datacols.selected[g] then Exit(f);
end;
//writeln(tstringgrid1.datacols.selected[g]);  // := true;
//tstringgrid1.datacols.selected[g] := true;
//tstringgrid1.datacols.rowselected[f] := true;
//tstringgrid1.focuscell(g);
end;

procedure telefo.butex(const sender: TObject);
var sel : Int64;
begin
sel := Focus; if sel > -1 then org.Delete(sel);
end;

procedure telefo.oneditbut(const sender: TObject);
begin
mainfo.ShowEE(Focus);
end;

procedure telefo.keyup(const sender: twidget; var ainfo: keyeventinfoty);
begin
  if ainfo.key = key_Escape then Close;
end;

procedure telefo.bclose(const sender: TObject);
begin
Close;
end;

end.
