program gorg64_spktone;

{
    Program for playing tones on PC-Speaker output. Adjust speaker tone.
    For GNU/Linux 64 bit version. Root priveleges or kernel patch needed.
    Version: 4.
    Written on FreePascal (https://freepascal.org/).
    Copyright (C) 2021-2024  Artyomov Alexander
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

{$MODE OBJFPC}
{$ASMMODE INTEL}
{$CODEPAGE UTF8}
{$RANGECHECKS ON}
uses spkunit,generator,sysutils,unix,baseunix,linux;
var p1, p2 : string;
pc, f,p2i :  Int64;
oa,na : PSigActionRec;
Procedure DoSig(sig : cint);cdecl;
begin
   writeln('Receiving signal: ',sig);
   gspkoff;
   halt(0);
end;
begin
new(na);
new(oa);
na^.sa_Handler:=SigActionHandler(@DoSig);
fillchar(na^.Sa_Mask,sizeof(na^.sa_mask),#0);
na^.Sa_Flags:= SA_RESTART;
na^.Sa_Restorer:=Nil;
if fpSigAction(SigTerm,na,oa)<>0 then begin writeln('Error: ',fpgeterrno,'.'); halt; end;
if fpSigAction(SigHup,na,oa)<>0 then begin writeln('Error: ',fpgeterrno,'.'); halt; end;
if fpSigAction(SigInt,na,oa)<>0 then begin writeln('Error: ',fpgeterrno,'.'); halt; end;
if fpSigAction(SigQuit,na,oa)<>0 then begin writeln('Error: ',fpgeterrno,'.'); halt; end;
if fpSigAction(SigTStp,na,oa)<>0 then begin writeln('Error: ',fpgeterrno,'.'); halt; end;
pc := ParamCount;
if pc < 2 then begin WriteLn('Use: gorg64_spktone [f|t|d] [freq (in Hz)|tone (in speaker unit)]|delay in diapason in ms'); Halt; end;
p1 :=ParamStr(1);
p2 :=ParamStr(2);
case p1[1] of
't':begin
p2i := StrToInt(p2);
gspk(p2i);
end;
'f':begin
gspk(spkf(StrToFloat(p2)));
end;
'd': begin
p2i := StrToInt(p2);
gspkon;
for f := 0 to 8000 do begin
gspk(f);
Sleep(p2i);
end;
gspkoff;
end;
end;
end.