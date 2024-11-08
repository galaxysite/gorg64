unit shutdown;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$CODEPAGE UTF8}
{
    Shutdown unit.
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
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,
 msesimplewidgets,msetimer,sysutils,unix;
type
 tshutdownfo = class(tmseform)
   tlabel1: tlabel;
   tlabel2: tlabel;
   trichstockglyphbutton1: trichstockglyphbutton;
   ttimer1: ttimer;
   procedure onclose(const sender: TObject);
   procedure ontimer(const sender: TObject);
   procedure oncreate(const sender: TObject);
   procedure bclose(const sender: TObject);
 end;
var
 shutdownfo: tshutdownfo;
 efshutdownfo : boolean = false;
 reboottrue : boolean;
 cnt : Int64;
implementation
uses
 shutdown_mfm,main,algor;
 
procedure tshutdownfo.onclose(const sender: TObject);
begin
 efshutdownfo := false;
end;

procedure tshutdownfo.ontimer(const sender: TObject);
begin
dec(cnt);
tlabel1.caption := inttostr(cnt);
if cnt = 0 then begin
Org.WorkGorgFile(true);
//fpSystem('sync');
//fpSystem('cp '+gorgfile+ ' '+gorgfile+'.back');
//if reboottrue then begin fpSystem('/sbin/reboot'); end else begin fpSystem('/sbin/poweroff'); end;
if reboottrue then begin fpSystem('dbus-send --system --print-reply --dest=org.freedesktop.login1 /org/freedesktop/login1 "org.freedesktop.login1.Manager.Reboot" boolean:true'); end else begin fpSystem('dbus-send --system --print-reply --dest=org.freedesktop.login1 /org/freedesktop/login1 "org.freedesktop.login1.Manager.PowerOff" boolean:true'); end;
end;
end;

procedure tshutdownfo.oncreate(const sender: TObject);
begin
case needshutdown of
1: begin reboottrue := false; tlabel2.caption := 'Выключить компьютер | Poweroff'; end;
2: begin reboottrue := true; tlabel2.caption := 'Перезагрузить компьютер | ReBoot'; end;
end;
needshutdown := 0;
end;

procedure tshutdownfo.bclose(const sender: TObject);
begin
Close;
end;

end.
