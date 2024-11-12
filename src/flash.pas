unit flash;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$CODEPAGE UTF8}
{
    Flash unit.
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
    kjaaaaaaaaaaaaaaihaoiha

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
}
interface
uses
 unix,baseunix,msetypes,msekeyboard,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,
 msemenus,msegui,msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,
 mseforms,msedragglob,mseedit,mseeditglob,msegrids,msegridsglob,mserichstring,
 msestatfile,msestream,msetextedit,sysutils,msesimplewidgets,mseact,
 msedataedits,msedropdownlist,mseificomp,mseificompglob,mseifiglob,
 msegraphedits,msescrollbar,msesyntaxedit,mseimage,msewidgetgrid;
type
 tflashfo = class(tmseform)
   trichbutton1: trichbutton;
   tbutton1: tbutton;
   tbutton2: tbutton;
   tbutton3: tbutton;
   tbutton5: tbutton;
   tbooleanedit1: tbooleanedit;
   tdropdownlistedit1: tdropdownlistedit;
   trichstockglyphbutton1: trichstockglyphbutton;
   timage1: timage;
   twidgetgrid1: twidgetgrid;
   ttextedit2: ttextedit;
   be_clip_mon: tbooleanedit;
   procedure oncreate(const sender: TObject);
   procedure onclose(const sender: TObject);
   procedure keyup(const sender: twidget; var ainfo: keyeventinfoty);
   procedure bclose(const sender: TObject);
   procedure viewfile(const sender: TObject);
   procedure save1(const sender: TObject);
   procedure onacc(const sender: TObject);
   procedure SetStrDivider;   
   procedure save(const sender: TObject);
   procedure LoadHotlist;
   procedure SaveHotlist;
   procedure onsavehotlist(const sender: TObject);
   procedure viewdir(const sender: TObject);
   procedure onlisten(const sender: TObject);
   procedure keydown(const sender: twidget; var ainfo: keyeventinfoty);
 end;
var
 flashfo: tflashfo;
 efFlash : boolean = false;
 str_divider : msestring = #10#10;  
implementation
uses
 flash_mfm, main;
 
procedure tflashfo.oncreate(const sender: TObject);
begin
tbooleanedit1.value := tun.p^.flash_accmulate;
be_clip_mon.value := tun.p^.clip_mon;
SetStrDivider;
LoadHotlist;
end;

procedure tflashfo.onclose(const sender: TObject);
begin
efFlash := false;
end;

procedure tflashfo.keydown(const sender: twidget; var ainfo: keyeventinfoty);
begin
  if ainfo.key = key_Escape then Close;
end;

procedure tflashfo.keyup(const sender: twidget; var ainfo: keyeventinfoty);
begin
  if ainfo.key = key_F3 then viewfile(self);
  if ainfo.key = key_F4 then tbooleanedit1.value := not tbooleanedit1.value;
  if ainfo.key = key_F5 then save1(self);
end;

procedure tflashfo.bclose(const sender: TObject);
begin
Close;
end;

procedure tflashfo.viewfile(const sender: TObject);
begin
fpSystem('gorg64_runner leafpad ' + flashfile);
end;

procedure tflashfo.save1(const sender: TObject);
begin
{$I-}
Append(flashfp);
{$I+} if IOResult <> 0 then ReWrite(flashfp);
WriteLn(flashfp, ttextedit2.gettext);
CloseFile(flashfp);
end;

procedure tflashfo.onacc(const sender: TObject);
begin
tun.p^.flash_accmulate := tbooleanedit1.value;
end;
procedure tflashfo.onlisten(const sender: TObject);
begin
tun.p^.clip_mon := be_clip_mon.value;
//if tun.p^.clip_mon then clipboardcopymonitor := @clipmon else clipboardcopymonitor := nil;
end;

procedure tflashfo.SetStrDivider;
  var
       fp : file;
       p  : pointer;
       fs : Int64;
begin
if not(FileExists(flashstrdividerfile)) then exit;
FileMode := 0; p := nil;
AssignFile(fp, flashstrdividerfile);
{$I-}
ReSet(fp, 1);
{$I+} if IOResult = 0 then begin
fs := FileSize(fp);
GetMem(p, fs);
{$I-}
BlockRead(fp, p^, fs);
{$I+} if IOResult = 0 then begin
str_divider := String(PCHar(p)); SetLength(str_divider, fs);
end; {end if BlockRead Ok}
{$I-}
CloseFile(fp);
{$I+} IOResult;
end; {end if ReSet Ok}
if p <> nil then FreeMem(p);
end;

procedure tflashfo.save(const sender: TObject);
var fp : Text;
begin
AssignFile(fp, flashdir + tdropdownlistedit1.value + '.txt');
{$I-}
Append(fp);
{$I+} if IOResult <> 0 then ReWrite(fp);
WriteLn(fp, ttextedit2.gettext);
CloseFile(fp);
end;

procedure tflashfo.LoadHotlist;
var s : msestring;
begin
tdropdownlistedit1.dropdown.cols.rowcount := 0;
{$I-}
ReSet(flashhotlistfp);
{$I+} if IOResult <> 0 then exit;
while not eof(flashhotlistfp) do begin
ReadLn(flashhotlistfp, s);
tdropdownlistedit1.dropdown.cols.rowcount := tdropdownlistedit1.dropdown.cols.rowcount + 1;
tdropdownlistedit1.dropdown.cols[0].items[tdropdownlistedit1.dropdown.cols.rowcount - 1] := s;
end;
CloseFile(flashhotlistfp);
end;
procedure tflashfo.SaveHotlist;
var f : Int64;
begin
if tdropdownlistedit1.value = '' then exit;
ReWrite(flashhotlistfp);
WriteLn(flashhotlistfp, tdropdownlistedit1.value);
for f := 0 to tdropdownlistedit1.dropdown.cols.rowcount - 1 do begin
WriteLn(flashhotlistfp, tdropdownlistedit1.dropdown.cols[0].items[f]);
if f > 200 then break;
end;
CloseFile(flashhotlistfp);
LoadHotlist;
end;
procedure tflashfo.onsavehotlist(const sender: TObject);
begin
SaveHotlist;
end;

// xdg-mime default caja.desktop inode/directory
// xdg-mime query default inode/directory

procedure tflashfo.viewdir(const sender: TObject);
begin
fpSystem('gorg64_runner xdg-open ' + flashdir);
end;

end.