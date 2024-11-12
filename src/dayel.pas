unit dayel;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,sysutils,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedragglob,
 msegrids,msegridsglob,msekeyboard;
type
 tdayelfo = class(tmseform)
   tstringgrid1: tstringgrid;
   procedure Display;
   procedure oncreate(const sender: TObject);
   procedure keyup(const sender: twidget; var ainfo: keyeventinfoty);
   procedure onclose(const sender: TObject);
 end;
var
 dayelfo: tdayelfo;
 efdayelfo : boolean = false;
implementation
uses
 dayel_mfm, ee, algor;
 
procedure tdayelfo.Display;
var
a : array of msestring;
f : int64;
 i, i2 : integer;
 str: msestring;
begin
for f := 0 to High(org.w) do begin
if org.w[f].ActivateInDay(gev) then begin
SetLength(a, Length(a) + 1);
a[High(a)] := org.w[f].DisplayString;
end;
end;
tstringgrid1.rowcount := Length(a);

for f := 0 to High(a) do begin
tstringgrid1[0].items[f] := IntToStr(f + 1);

str := a[f];

i2 := 1;
while (system.pos(',',str) > 0) and (i2 <11) do
begin
i := system.pos(',',str);
tstringgrid1[i2].items[f] := system.copy(str, 1, i -1);
//writeln(tstringgrid1[0].items[f]);
str := system.copy(str, i+1,length(str));
inc(i2);
end;

tstringgrid1[11].items[f] := system.copy(str, 1, i -1);

end;
end; 

procedure tdayelfo.oncreate(const sender: TObject);
begin
Display;
end;

procedure tdayelfo.keyup(const sender: twidget; var ainfo: keyeventinfoty);
begin
  if ainfo.key = key_Escape then Close;
end;

procedure tdayelfo.onclose(const sender: TObject);
begin
efdayelfo := false;
end;

end.
