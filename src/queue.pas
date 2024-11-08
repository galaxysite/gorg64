unit queue;

{$MODE OBJFPC}
{$LONGSTRINGS ON}

interface

uses sysutils, unix, baseunix, linux, msetypes;

type
tqueue = class
a : array of msestring;
protected
adding,getting : boolean;
public
fvalid : boolean;
fstr : msestring;
procedure Add(s : msestring);
procedure Get;
procedure Zero;
end;

implementation

procedure tqueue.Add(s : msestring);
begin
adding := true;
while getting do Sleep(0);
SetLength(a, Length(a) + 1);
a[High(a)] := s;
adding := false;
end;

procedure tqueue.Get;
var
l, f : Int64;
begin
getting := true;
while adding do Sleep(0);
l := Length(a);
if l = 0 then begin
fvalid := false;
fstr := '';
end else begin
fvalid := true;
fstr := a[0];
for f := 1 to High(a) do a[f-1] := a[f];
SetLength(a, l - 1);
end;
getting := false;
end;

procedure tqueue.Zero;
begin
SetLength(a, 0);
end;

end.