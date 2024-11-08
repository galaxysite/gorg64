program msepatch;

{$MODE OBJFPC}
{$H+}
{$RANGECHECKS ON}
{$SMARTLINK ON}

uses sysutils, unix;

var
m : utf8string = './mseide-msegui/lib/common/kernel/linux/mseguiintf.pas';
p : utf8string = './mseguiintf.pas';
fpm, fptm : Text;
s : utf8string;
f : Int64;
fixes : boolean = false;

begin
Assign(fpm, m); Assign(fptm, p);
FileMode:=0;
ReSet(fpm);
FileMode:=1;
ReWrite(fptm);

while not eof(fpm) do begin // Ok
ReadLn(fpm, s);

if s = 'implementation' then begin
WriteLn(fptm, 'var');
WriteLn(fptm, 'clipboardcopymonitor : procedure = nil;');
WriteLn(fptm, 'event_base, error_base : LongInt;');
WriteLn(fptm, 'scroll_keycode : Int64;');
WriteLn(fptm, 'scroll_pressed : bytebool = false;');
WriteLn(fptm, 'r : LongInt;');
end;

if s = ' if xev.xany.xwindow = appid then begin' then begin
WriteLn(fptm, 'if (xev.xtype = event_base + XFixesSelectionNotify) and (clipboardcopymonitor <> nil) and (DWord(PXFixesSelectionNotifyEvent(@xev)^.owner) >= 15000000) then clipboardcopymonitor;');
end;

if s = '  cardinalatom:= xinternatom(appdisp,''CARDINAL'',' then begin
WriteLn(fptm, 'XFixesSelectSelectionInput(Pointer(appdisp), gui_getrootwindow, clipboardbuffers[low(clipboardbuffers)].name, XFixesSetSelectionOwnerNotifyMask);');
WriteLn(fptm, 'XFixesQueryExtension(Pointer(appdisp), @event_base, @error_base);');
WriteLn(fptm, 'scroll_keycode := XKeysymToKeycode(Pointer(appdisp), XK_Scroll_Lock);');
WriteLn(fptm, '  aehandler:= xseterrorhandler({$ifdef FPC}@{$endif}aerrorhandler);');
WriteLn(fptm, 'r := XGrabKey(Pointer(appdisp), scroll_keycode, AnyModifier, gui_getrootwindow, 1, GrabModeAsync, GrabModeAsync);');
end;

if s = 'function gui_initcolormap: guierrorty;' then begin
WriteLn(fptm, 'function aerrorhandler(Display: PDisplay; ErrorEvent: PXErrorEvent):');
WriteLn(fptm, '    Longint; cdecl;');
WriteLn(fptm, 'const');
WriteLn(fptm, ' buflen = 256;');
WriteLn(fptm, 'var');
WriteLn(fptm, ' buffer: array[0..buflen] of char;');
WriteLn(fptm, 'begin');
WriteLn(fptm, ' if xlockerror = 0 then begin');
WriteLn(fptm, '  xgeterrortext(display,errorevent^.error_code,@buffer,buflen);');
WriteLn(fptm, '   sys_errorout(''A: X Error: ''+ pchar(@buffer) + ''  ''+inttostr(errorevent^.error_code)+');
WriteLn(fptm, '        lineend +''  Major opcode:  ''+inttostr(errorevent^.request_code)+lineend);');
WriteLn(fptm, ' end;');
WriteLn(fptm, ' result:= 0;');
WriteLn(fptm, 'end;');
end;

if s = '{$include ../mseguiintf.inc}' then begin
WriteLn(fptm, '{$include ./mseide-msegui/lib/common/kernel/mseguiintf.inc}');
continue;
end;

if (s = ' msestrings,mxft,mxrender,mxrandr,mshape;') and not fixes
 then begin WriteLn(fptm, ' msestrings,mxft,mxrender,mxrandr,mshape,xfixes;'); fixes := true; continue; end;

WriteLn(fptm, s);

if s = '  keypress: begin'
 then WriteLn(fptm, 'if xev.xkey.keycode = scroll_keycode then scroll_pressed := true;');
if s = ' convertselectionpropertyatom: atom;'
 then WriteLn(fptm, 'aehandler: xerrorhandler;');
end; {wend}
Close(fpm);
Close(fptm);
end.