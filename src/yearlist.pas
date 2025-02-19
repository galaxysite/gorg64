unit yearlist;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedragglob,
 msegrids,msegridsglob,msekeyboard,sysutils,main,msestrings, msesimplewidgets;
type
 tyearlistfo = class(tmseform)
   tstringgrid1: tstringgrid;
   tbutton1: tbutton;
   tfacecomp1: tfacecomp;
   procedure keyup(const sender: twidget; var ainfo: keyeventinfoty);
   procedure onclose(const sender: TObject);
   procedure olc(const sender: tcustomgrid);
   procedure onl(const sender: TObject);
   procedure oncreate(const sender: TObject);
   procedure oact(const sender: TObject);
function Import : boolean;
function Load : boolean;
function Save : boolean;
   procedure onnow(const sender: TObject);
 end;

const
  md : array[1..12] of byte = (31,29,31,30,31,30,31,31,30,31,30,31);

var
yearlistfo: tyearlistfo;
efyearlistfo : boolean = false;
onetime : boolean;
 
implementation
uses
 yearlist_mfm, lng, time;
procedure tyearlistfo.keyup(const sender: twidget; var ainfo: keyeventinfoty);
begin
if ainfo.key = key_Escape then Close;
end;

procedure tyearlistfo.onclose(const sender: TObject);
begin
Save;
efyearlistfo := false;
end;

procedure tyearlistfo.olc(const sender: tcustomgrid);
  var
      w : LongInt;
begin
w := tstringgrid1.clientwidth;
dec(w, 28);
if w < 1 + tstringgrid1.fixcols[-1].width then w := 1 + tstringgrid1.fixcols[-1].width;
if tstringgrid1.datacols[0].width + tstringgrid1.fixcols[-1].width <> w then
tstringgrid1.datacols[0].width := w - tstringgrid1.fixcols[-1].width + 25;
end;

procedure tyearlistfo.onl(const sender: TObject);
  var
	f, ff, c : LongInt;
	d1 : byte;
	aDate : TDateTime;
	aYear, aMonth, aDay : Word; 
	day: string;
	OldShortDateFormat: string;
	OldDateSeparator: char;
	v:bytebool = false;
begin
c := 0;
{$WARNINGS OFF}
  if tun.p^.engtrue_calend_fmt then d1 := 1 else d1 := 2;
  OldShortDateFormat := ShortDateFormat;
  OldDateSeparator := DateSeparator;
  ShortDateFormat := 'ddmmyyyy'; 
  DateSeparator := '/'; 
  DecodeDate(now, aYear, aMonth, aDay);
  caption := str_yearlist + ' ' + inttostr(aYear);
  if DayOfWeek(now) = 1  then day := wdn2[7] else
   day := wdn2[DayOfWeek(now)-1];
  tbutton1.caption := day + ' ' + inttostr(aDay) + '/'+ inttostr(aMonth);
  v := vg(aYear);
  for f := 1 to 12 do
     for ff := 1 to md[f] do 
     begin
if (not v) and (f = 2) and (ff = 29) then begin
	day := 'n/a';
end else begin
        adate :=  StrToDate(inttostr(ff) + '/'+  IntToStr(f) + '/'+ inttostr(aYear));
        if DayOfWeek(aDate) = 1  then day := wdn2[7] else
        day := wdn2[DayOfWeek(aDate)-1];
        if DayOfWeek(aDate) = d1 then
        tstringgrid1.rowcolorstate[c]:= 0;
end;
        if ff = 1 then tstringgrid1.rowcolorstate[c]:= 1;
        tstringgrid1.fixcols[-1].captions[c] := day + ' ' +
        {IntToStr(c+1) + '  ' +} IntToStr(ff) + ' ' + mon_names3[f] + '(' + IntToStr(f) + ')';
        Inc(c);
    end;
  ShortDateFormat := OldShortDateFormat;
  DateSeparator := OldDateSeparator;
{$WARNINGS ON}
end;

procedure tyearlistfo.oncreate(const sender: TObject);
begin
onetime := false;
if fileexists(yearlistfile) then Load else Import;
end;

procedure tyearlistfo.oact(const sender: TObject);
  var
      f : LongInt;
      g : gridcoordty;
      YY,MM,DD : Word;
begin
if onetime then exit;
g.row := 0;
DeCodeDate(Date,YY,MM,DD); // Получаем текущую дату
for f := 1 to MM - 1 do g.row := g.row + md[f];
g.row := g.row + DD - 1;
    g.col := 0;
    tstringgrid1.showcell(g, cep_rowcentered, true);
        tstringgrid1.focuscell(g);
    tstringgrid1.datacols.selected[g] := true;
onetime := true;
end;

function tyearlistfo.Import : boolean;
var
    s  : msestring;
    be{, n} : boolean;
    f  : LongInt;
    fn : msestring = '.dr/status.sta';
    fp : TextFile;
begin 
{$ifdef ootb}
fn := ExtractFilePath(ParamStr(0)) + 'data/status.sta';
{$endif}
result := false;
fn := homedir + fn;
if not fileexists(fn) then exit;
AssignFile(fp, fn);
FileMode := 0;
ReSet(fp);

be := false;
while not eof(fp) do begin
 readln(fp, s);
// n := system.Pos('values0=366', s) <> 0;
 if system.Pos('values0=366', s) <> 0 then begin be := true; continue; end;
 if not be then continue;
 for f := 0 to 365 do begin
	tstringgrid1[0].items[f] := Copy(s, 2, High(s));
	ReadLn(fp, s);
 end;
 break;
end;
CloseFile(fp);
end;

function tyearlistfo.Load : boolean;
var
    f  : LongInt;
    s  : msestring;
begin
AssignFile(yearlistfp, yearlistfile);
FileMode := 0;
ReSet(yearlistfp);
for f := 0 to 365 do begin
if eof(yearlistfp) then break;
ReadLn(yearlistfp, s);
tstringgrid1[0].items[f] := s;
end; {next}
CloseFile(yearlistfp);
end;

function tyearlistfo.Save : boolean;
var
    f  : LongInt;
    s  : msestring;
begin
AssignFile(yearlistfp, yearlistfile);
FileMode := 1;
ReWrite(yearlistfp);
for f := 0 to 364 do WriteLn(yearlistfp, tstringgrid1[0].items[f]);
Write(yearlistfp, tstringgrid1[0].items[365]);
CloseFile(yearlistfp);
end;

procedure tyearlistfo.onnow(const sender: TObject);
begin
onetime := false;
oact(sender);
end;

end.