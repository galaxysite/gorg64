unit notebook;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
{$RANGECHECK ON}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedragglob,
 msescrollbar,msetabs,msegrids,msegridsglob,msesimplewidgets,msekeyboard,sysutils,
 msebitmap,unix;
type
 tnotebookfo = class(tmseform)
   ttabwidget1: ttabwidget;
   ttabpage1: ttabpage;
   ttabpage2: ttabpage;
   tstringgrid1: tstringgrid;
   tstringgrid2: tstringgrid;
   trichbutton1: trichbutton;
   trichbutton2: trichbutton;
   trichbutton3: trichbutton;
   trichbutton4: trichbutton;
   trichbutton5: trichbutton;
   trichbutton6: trichbutton;
   trichbutton7: trichbutton;
   timagelist1: timagelist;
   trichstockglyphbutton1: trichstockglyphbutton;
   procedure onclose(const sender: TObject);
   procedure keyup(const sender: twidget; var ainfo: keyeventinfoty);
   function Focus : Int64;
   procedure oncreate(const sender: TObject);
   procedure Display;
   procedure Del;
   procedure Add;
   procedure Edit;
   procedure ondel(const sender: TObject);
   procedure onadd(const sender: TObject);
   procedure onedit(const sender: TObject);
   procedure oncl(const sender: TObject);
   procedure onopenmap(const sender: TObject);
   procedure onopensite(const sender: TObject);
   procedure onemail(const sender: TObject);
   procedure ontel(const sender: TObject);
   procedure oncelev(const sender: TObject; var info: celleventinfoty);
   procedure onloadlang();
 end;
 
 tnbcommon = object
 displayas : msestring;
 name : msestring;
 email, email1, email2, email3 : msestring;
 site, site1, site2, site3 : msestring;
 phone, phone1, phone2, phone3 : msestring;
 address, address1, address2, address3 : msestring;
 map, map1, map2, map3 : msestring;
 postalindex, postalindex1, postalindex2, postalindex3 : msestring;
 photo : filenamety;
 video : filenamety;
 dir : filenamety;
 freearea, freearea1, freearea2, freearea3 :  msestring;
 group, group1, group2, group3 :  msestring;
 procedure ReSet;
 procedure OpenMap(i : byte);
 procedure OpenSite(i : byte);
 procedure WriteEmail(i : byte);
 procedure Tel(i : byte);
 end;
 tpeople = object(tnbcommon)
 surname : msestring;
 patronym : msestring;
 alias : msestring;
 birthday : msestring;
 deathday : msestring;
 gender : msestring;
 workarea : msestring;
 function GetString : msestring;
 procedure SetString(value : msestring);
 property iostring : msestring read GetString write SetString;
 procedure ReSet;
 end;
 torganization = object(tnbcommon)
 hoursofoperation : msestring;
 account : msestring;
 function GetString : msestring;
 procedure SetString(value : msestring);
 property iostring : msestring read GetString write SetString;
 procedure ReSet;
 end;
 tpeoples = object
 a : array of tpeople;
 procedure Load;
 procedure Save;
 procedure Delete(n : Int64);
 end;
 torganizations = object
 a : array of torganization;
 procedure Load;
 procedure Save;
 procedure Delete(n : Int64);
 end;
 taos = array of msestring;

var
 notebookfo: tnotebookfo;
 efnotebookfo : boolean = false;
 pnum : Int64 = -1;
 onum : Int64 = -1;
 edp : tpeople;
 edo : torganization;
 peoples : tpeoples;
 organizations : torganizations;
 ugroups,ugen : taos;
 
procedure LoadUnique;
 
implementation
uses
 notebook_mfm,main, lng;
 
procedure LoadUnique;
 procedure SetUniq(var a : taos; const s : msestring);
 var i : Int64;
 begin
 if s = '' then exit;
 for i := 0 to High(a) do if a[i] = s then Exit;
 SetLength(a, Length(a) + 1);
 a[High(a)] := s;
 end;
var f, ff : Int64;
begin
SetLength(ugroups, 0);
SetLength(ugen, 0);
for f := 0 to High(peoples.a) do begin
for ff := 0 to 3 do case ff of
0:SetUniq(ugroups,peoples.a[f].group);
1:SetUniq(ugroups,peoples.a[f].group1);
2:SetUniq(ugroups,peoples.a[f].group2);
3:SetUniq(ugroups,peoples.a[f].group3);
end;
end;
for f := 0 to High(organizations.a) do begin
for ff := 0 to 3 do case ff of
0:SetUniq(ugroups,organizations.a[f].group);
1:SetUniq(ugroups,organizations.a[f].group1);
2:SetUniq(ugroups,organizations.a[f].group2);
3:SetUniq(ugroups,organizations.a[f].group3);
end;
end;
for f := 0 to High(peoples.a) do SetUniq(ugen,peoples.a[f].gender);
end;
 
function strtoaos(s : msestring) : taos;
  var
    f, l, m1, m2 : Int64;
    tmp : msestring;
begin
SetLength(result, 0);
m1 := 0; m2 := 0; tmp := '';
l := length(s);
if l < 1 then begin exit; end;
 for f := 1 to l do begin
  if (s[f] = #9) or (f = l) then begin
   m2 := f;
   if (f = l) and (s[f] <> #9) then inc(m2);
   if m2 > (m1 + 1) then tmp := copy(s, m1 + 1, m2 - m1 - 1);
   m1 := m2;
   SetLength(result, Length(result)+1);
   result[High(result)] := tmp;
   tmp := '';
  end;
 end;
end;
 
procedure tnotebookfo.onclose(const sender: TObject);
begin
efnotebookfo := false;
end;

procedure tnotebookfo.keyup(const sender: twidget; var ainfo: keyeventinfoty);
begin
  if ainfo.key = key_Escape then Close;
end;

procedure tpeoples.Load;
var tmp : msestring;
begin
SetLength(a,0);
{$I-}
ReSet(peoplesfp);
{$I+} if IOResult <> 0 then Exit;
while not eof(peoplesfp) do begin
{$I-}
ReadLn(peoplesfp, tmp);
{$I+} if IOResult <> 0 then Exit;
SetLength(a, Length(a) + 1);
a[High(a)].iostring := tmp;
end;
{$I-}
Close(peoplesfp);
{$I+} if IOResult <> 0 then Exit;
end;

procedure torganizations.Load;
var tmp : msestring;
begin
SetLength(a,0);
{$I-}
ReSet(organizationsfp);
{$I+} if IOResult <> 0 then Exit;
while not eof(organizationsfp) do begin
{$I-}
ReadLn(organizationsfp, tmp);
{$I+} if IOResult <> 0 then Exit;
SetLength(a, Length(a) + 1);
a[High(a)].iostring := tmp;
end;
{$I-}
Close(organizationsfp);
{$I+} if IOResult <> 0 then Exit;
end;

procedure tpeoples.Save;
var f : Int64;
begin
ReWrite(peoplesfp);
for f := 0 to High(a) do WriteLn(peoplesfp, a[f].iostring);
Close(peoplesfp);
LoadUnique;
end;

procedure torganizations.Save;
var f : Int64;
begin
ReWrite(organizationsfp);
for f := 0 to High(a) do WriteLn(organizationsfp, a[f].iostring);
Close(organizationsfp);
LoadUnique;
end;

function torganization.GetString : msestring;
begin
result := displayas + #9 +
name + #9 +
email + #9 + email1 + #9 + email2 + #9 + email3 + #9 +
site + #9 + site1 + #9 + site2 + #9 + site3 + #9 +
phone + #9 + phone1 + #9 + phone2 + #9 + phone3 + #9 +
address + #9 + address1 + #9 + address2 + #9 + address3 + #9 +
map + #9 + map1 + #9 + map2 + #9 + map3 + #9 +
postalindex + #9 + postalindex1 + #9 + postalindex2 + #9 + postalindex3 + #9 +
photo + #9 +
video + #9 +
dir + #9 +
freearea + #9 + freearea1 + #9 + freearea2 + #9 + freearea3 + #9 +
group + #9 + group1 + #9 + group2 + #9 + group3 + #9 +
hoursofoperation + #9 +
account;
end;
procedure torganization.SetString(value : msestring);
var
aos : taos;
begin
aos := strtoaos(value);
SetLength(aos, 39);
displayas := aos[0];
name := aos[1];
email := aos[2]; email1 := aos[3]; email2 := aos[4]; email3 := aos[5];
site := aos[6]; site1 := aos[7]; site2 := aos[8]; site3 := aos[9];
phone := aos[10]; phone1 := aos[11]; phone2 := aos[12]; phone3 := aos[13];
address := aos[14]; address1 := aos[15]; address2 := aos[16]; address3 := aos[17];
map := aos[18]; map1 := aos[19]; map2 := aos[20]; map3 := aos[21];
postalindex := aos[22]; postalindex1 := aos[23];
postalindex2 := aos[24]; postalindex3 := aos[25];
photo := aos[26];
video := aos[27];
dir := aos[28];
freearea := aos[29]; freearea1 := aos[30];
freearea2 := aos[31]; freearea3 := aos[32];
group := aos[33]; group1 := aos[34]; group2 := aos[35]; group3 := aos[36];
hoursofoperation := aos[37];
account := aos[38];
end;
function tpeople.GetString : msestring;
begin
result := displayas + #9 +
name + #9 +
email + #9 + email1 + #9 + email2 + #9 + email3 + #9 +
site + #9 + site1 + #9 + site2 + #9 + site3 + #9 +
phone + #9 + phone1 + #9 + phone2 + #9 + phone3 + #9 +
address + #9 + address1 + #9 + address2 + #9 + address3 + #9 +
map + #9 + map1 + #9 + map2 + #9 + map3 + #9 +
postalindex + #9 + postalindex1 + #9 + postalindex2 + #9 + postalindex3 + #9 +
photo + #9 +
video + #9 +
dir + #9 +
freearea + #9 + freearea1 + #9 + freearea2 + #9 + freearea3 + #9 +
group + #9 + group1 + #9 + group2 + #9 + group3 + #9 +
surname + #9 +
patronym + #9 +
alias + #9 +
birthday + #9 +
deathday + #9 +
gender + #9 +
workarea;
end;
procedure tpeople.SetString(value : msestring);
var
aos : taos;
begin
aos := strtoaos(value);
SetLength(aos,44);
displayas := aos[0];
name := aos[1];
email := aos[2]; email1 := aos[3]; email2 := aos[4]; email3 := aos[5];
site := aos[6]; site1 := aos[7]; site2 := aos[8]; site3 := aos[9];
phone := aos[10]; phone1 := aos[11]; phone2 := aos[12]; phone3 := aos[13];
address := aos[14]; address1 := aos[15]; address2 := aos[16]; address3 := aos[17];
map := aos[18]; map1 := aos[19]; map2 := aos[20]; map3 := aos[21];
postalindex := aos[22]; postalindex1 := aos[23];
postalindex2 := aos[24]; postalindex3 := aos[25];
photo := aos[26];
video := aos[27];
dir := aos[28];
freearea := aos[29]; freearea1 := aos[30];
freearea2 := aos[31]; freearea3 := aos[32];
group := aos[33]; group1 := aos[34]; group2 := aos[35]; group3 := aos[36];
surname := aos[37];
patronym := aos[38];
alias := aos[39];
birthday := aos[40];
deathday := aos[41];
gender := aos[42];
workarea := aos[43];
end;

function tnotebookfo.Focus : Int64;
var
g : gridcoordty;
f : int64;
begin
result := -1;
g.col := 0;
case ttabwidget1.activepageindex of
0: begin
for f := 0 to High(peoples.a) do begin
g.row := f;
if tstringgrid1.datacols.selected[g] then Exit(f);
end;
end;
1: begin
for f := 0 to High(organizations.a) do begin
g.row := f;
if tstringgrid2.datacols.selected[g] then Exit(f);
end;
end;
end;
//writeln(tstringgrid1.datacols.selected[g]);  // := true;
//tstringgrid1.datacols.selected[g] := true;
//tstringgrid1.datacols.rowselected[f] := true;
//tstringgrid1.focuscell(g);
end;

procedure tnotebookfo.oncreate(const sender: TObject);
begin
Display;
onloadlang();
//tstringgrid1.optionsgrid :=  tstringgrid1.optionsgrid + [og_sorted];
end;

procedure tnotebookfo.onloadlang();
begin
caption := str_notebook;
ttabpage1.caption := str_people;
ttabpage2.caption := str_organizations;
end;

procedure tnotebookfo.Display;
var f : int64;
begin
tstringgrid1.optionsgrid :=  tstringgrid1.optionsgrid - [og_sorted];
tstringgrid1.rowcount := Length(peoples.a);
for f := 0 to High(peoples.a) do begin
tstringgrid1[0].items[f] := peoples.a[f].displayas;
tstringgrid1[1].items[f] := inttostr(f);
end;
tstringgrid1.optionsgrid :=  tstringgrid1.optionsgrid + [og_sorted];

tstringgrid2.optionsgrid :=  tstringgrid2.optionsgrid - [og_sorted];
tstringgrid2.rowcount := Length(organizations.a);
for f := 0 to High(organizations.a) do begin
tstringgrid2[0].items[f] := organizations.a[f].displayas;
tstringgrid2[1].items[f] := inttostr(f);
end;
tstringgrid2.optionsgrid :=  tstringgrid2.optionsgrid + [og_sorted];
end;

procedure tpeoples.Delete(n : Int64);
var hw : Int64;
begin
hw := High(a); if hw < 0 then exit;
a[n] := a[hw];
SetLength(a, hw);
Save;
if efnotebookfo then notebookfo.Display;
//if efeefo and (eefoindex = n) then needeefoclose := true;
end;
procedure torganizations.Delete(n : Int64);
var hw : Int64;
begin
hw := High(a); if hw < 0 then exit;
a[n] := a[hw];
SetLength(a, hw);
Save;
if efnotebookfo then notebookfo.Display;
//if efeefo and (eefoindex = n) then needeefoclose := true;
end;

procedure tnotebookfo.Del;
var foc : Int64;
begin
foc := Focus;
if foc > -1 then
case ttabwidget1.activepageindex of
0: begin
peoples.Delete(Foc);
end;
1: begin
organizations.Delete(Foc);
end;
end;
end;
procedure tnotebookfo.ondel(const sender: TObject);
begin
Del;
end;

procedure tnotebookfo.Add;
begin
case ttabwidget1.activepageindex of
0: begin
mainfo.ShowP(-1);
end;
1: begin
mainfo.ShowO(-1);
end;
end;
end;

procedure tnotebookfo.onadd(const sender: TObject);
begin
Add;
end;

procedure tnotebookfo.Edit;
var foc : Int64;
begin
foc := Focus;
if foc > -1 then
case ttabwidget1.activepageindex of
0: begin
mainfo.ShowP(strtoint(tstringgrid1[1].items[tstringgrid1.focusedcell.row]));
end;
1: begin
mainfo.ShowO(strtoint(tstringgrid2[1].items[tstringgrid2.focusedcell.row]));
end;
end;
end;
procedure tnotebookfo.onedit(const sender: TObject);
begin
Edit;
end;

procedure tnotebookfo.oncl(const sender: TObject);
begin
Close;
end;

procedure tnotebookfo.onopenmap(const sender: TObject);
var foc : Int64;
begin
foc := Focus;
if foc > -1 then
case ttabwidget1.activepageindex of
0: begin
 peoples.a[foc].OpenMap(0);
end;
1: begin
 organizations.a[foc].OpenMap(0);
end;
end;
end;

procedure tnotebookfo.onopensite(const sender: TObject);
var foc : Int64;
begin
foc := Focus;
if foc > -1 then
case ttabwidget1.activepageindex of
0: begin
 peoples.a[foc].OpenSite(0);
end;
1: begin
 organizations.a[foc].OpenSite(0);
end;
end;
end;

procedure tnotebookfo.onemail(const sender: TObject);
var foc : Int64;
begin
foc := Focus;
if foc > -1 then
case ttabwidget1.activepageindex of
0: begin
 peoples.a[foc].WriteEmail(0);
end;
1: begin
 organizations.a[foc].WriteEmail(0);
end;
end;
end;

procedure tnotebookfo.ontel(const sender: TObject);
var foc : Int64;
begin
foc := Focus;
if foc > -1 then
case ttabwidget1.activepageindex of
0: begin
 peoples.a[foc].Tel(0);
end;
1: begin
 organizations.a[foc].Tel(0);
end;
end;
end;

procedure tnotebookfo.oncelev(const sender: TObject; var info: celleventinfoty);
begin
 if (info.eventkind = cek_buttonrelease) and
     (ss_double in info.mouseeventinfopo^.shiftstate) then edit;
end;

procedure tnbcommon.ReSet;
begin
displayas := '';
name := '';
email := ''; email1 := ''; email2 := ''; email3 := '';
site := ''; site1 := ''; site2 := ''; site3 := '';
phone := ''; phone1 := ''; phone2 := ''; phone3 := '';
address := ''; address1 := ''; address2 := ''; address3 := '';
map := ''; map1 := ''; map2 := ''; map3 := '';
postalindex := ''; postalindex1 := '';
postalindex2 := ''; postalindex3 := '';
photo := '';
video := '';
dir := '';
freearea := ''; freearea1 := ''; freearea2 := ''; freearea3 := '';
group := ''; group1 := ''; group2 := ''; group3 := '';
end;
procedure tpeople.ReSet;
begin
inherited;
surname := '';
patronym := '';
alias := '';
birthday := '';
deathday := '';
gender := '';
workarea := '';
end;
procedure torganization.ReSet;
begin
inherited;
hoursofoperation := '';
account := '';
end;

procedure tnbcommon.OpenMap(i : byte);
var tmp : msestring;
begin
if (i < 0) or (i > 3) then exit;
case i of
0: tmp := map;
1: tmp := map1;
2: tmp := map2;
3: tmp := map3;
end;
if tmp = '' then exit;
fpSystem('open https://www.google.com/maps/search/?api=1\&query=' + tmp);
end;

procedure tnbcommon.OpenSite(i : byte);
var tmp : msestring;
begin
if (i < 0) or (i > 3) then exit;
case i of
0: tmp := site;
1: tmp := site1;
2: tmp := site2;
3: tmp := site3;
end;
if tmp = '' then exit;
fpSystem('open ' + tmp);
end;

procedure tnbcommon.WriteEmail(i : byte);
var tmp : msestring;
begin
if (i < 0) or (i > 3) then exit;
case i of
0: tmp := email;
1: tmp := email1;
2: tmp := email2;
3: tmp := email3;
end;
if tmp = '' then exit;
fpSystem('open mailto:' + tmp);
end;

procedure tnbcommon.Tel(i : byte);
var tmp : msestring;
begin
if (i < 0) or (i > 3) then exit;
case i of
0: tmp := phone;
1: tmp := phone1;
2: tmp := phone2;
3: tmp := phone3;
end;
if tmp = '' then exit;
fpSystem('open tel:' + tmp);
end;

end.
