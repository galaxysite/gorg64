program gorg64_spkplay;

{$MODE OBJFPC}
{$RANGECHECKS ON}
{$LONGSTRINGS ON}
{$SMARTLINK ON}
{$ASMMODE INTEL}

{
    Program for playing melodys on PC-Speaker.
    For GNU/Linux 64 bit version.
    Version: 3.
    Written on FreePascal (https://freepascal.org/).
    Copyright (C) 2021,2022,2024  Artyomov Alexander
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

uses sysutils,unix,baseunix,linux,spkunit,urunspk,alsa_sound;

type
      TTW = packed record
       tone, duration : Word;
      end;
      PTW=^TTW;

const
	vol=30;

var
	f, ff : Int64;
	oa,na : PSigActionRec;
	fs : Int64 = 0;
	a :  PTW = nil;
	fFileName : utf8string = '';
	f_uid, f_euid : Int64;

function LoadFromFile(fn : utf8string) : boolean;
var
  fp : File of TTW;
begin
Assign(fp, fn);
FileMode := 0;
{$I-}
ReSet(fp);
{$I+} if IOResult <> 0 then Exit(true);
{$I-}
fs := FileSize(fp);
{$I+} if IOResult <> 0 then Exit(true);
GetMem(a, fs*SizeOf(TTW));
{$I-}
BlockRead(fp, a[0], fs);
{$I+} if IOResult <> 0 then Exit(true);
{$I-}
Close(fp);
{$I+} if IOResult <> 0 then Exit(true);
fFileName := fn;
Exit(false);
end;

Procedure DoSig(sig : cint);cdecl;
begin
   writeln('Receiving signal: ',sig);
   if portserr then ALSAsilence(0, false) else spkoff;
   halt(0);
end;

begin
WriteLn('GALAXY ORGANIZER SPEAKER PLAYER Version 3');
WriteLn('Artyomov Alexander 2024  License: GNU AGPLv3 and above');
WriteLn('Use: gorg64_spkplay or gorg64_spkplay somemusic.speaker somemusic2.speaker ...');

f_uid := fpGetUID;
f_euid := fpGetEUID;
WriteLn('UID=',f_uid,' EUID=',f_euid);
if f_euid = 0 then begin
if fpSetUID(0) <> 0 then begin WriteLn('Error set UID'); Halt; end;
end;
f_uid := fpGetUID;
f_euid := fpGetEUID;
WriteLn('Now UID=',f_uid,' EUID=',f_euid);

if (ParamCount > 0) and (ParamStr(1) = '--stop') then begin fpSystem('killall gorg64_spkplay'); Halt; end;

if alreadyrunning then begin
WriteLn('Already running. Exit.');
Halt;
end;

fpSystem('renice -n -20 -p ' + inttostr(fpgetpid));

   new(na);
   new(oa);
   na^.sa_Handler:=SigActionHandler(@DoSig);
   fillchar(na^.Sa_Mask,sizeof(na^.sa_mask),#0);
   na^.Sa_Flags:= SA_RESTART;
   na^.Sa_Restorer:=Nil;
   if fpSigAction(SigTerm,na,oa)<>0 then
     begin
     writeln('Error: ',fpgeterrno,'.');
     halt(1);
     end;
   if fpSigAction(SigHup,na,oa)<>0 then
     begin
     writeln('Error: ',fpgeterrno,'.');
     halt(1);
     end;
   if fpSigAction(SigInt,na,oa)<>0 then
     begin
     writeln('Error: ',fpgeterrno,'.');
     halt(1);
     end;
   if fpSigAction(SigQuit,na,oa)<>0 then
     begin
     writeln('Error: ',fpgeterrno,'.');
     halt(1);
     end;
   if fpSigAction(SigTStp,na,oa)<>0 then
     begin
     writeln('Error: ',fpgeterrno,'.');
     halt(1);
     end;

if not FileExists('/dev/input/by-path/platform-pcspkr-event-spkr') then begin writeln('May be running on notebook ? File platform-pcspkr-event-spkr not exists.'); portserr := true; end;

if portserr then begin WriteLn('Not access to PC-Speaker. Use ALSA.');

if ParamCount = 0 then begin
ALSAbeep(spkf(1000), 1000, vol, False, 0, true);
Halt;
end;

for ff := 1 to ParamCount do begin
if LoadFromFile(ParamStr(ff)) then begin
 WriteLn('Err');
 ALSAbeep(spkf(300), 1000, vol, False, 0, false);
 Halt(2);
end;
WriteLn('* Playing file: ' + fFileName);

for f := 0 to fs-1 do begin
 if a[f].duration < 1 then continue;
 if a[f].tone < 1 then begin
   sleep(a[f].duration);
 end else begin
   ALSAbeep(spkf(a[f].tone), a[f].duration, vol, False, 0, false);
 end;
end;
FreeMem(a);
end;

end else begin WriteLn('Use I/O ports');

if ParamCount = 0 then begin
 spkon; spk(1000); sleep(1000); spkoff;
 Halt;
end;

for ff := 1 to ParamCount do begin
if LoadFromFile(ParamStr(ff)) then begin
 WriteLn('Err');  spkon; spk(300); sleep(1000); spkoff;
Halt(2);
end;
WriteLn('* Playing file: ' + fFileName);
spkon;
for f := 0 to fs-1 do begin
 if a[f].duration < 1 then continue;
 if a[f].tone < 1 then begin
   spkoff;
   sleep(a[f].duration);
   spkon;
 end else begin
   spk(a[f].tone);
   sleep(a[f].duration);
 end;
end;

spkoff;
FreeMem(a);
end;

end;

end.