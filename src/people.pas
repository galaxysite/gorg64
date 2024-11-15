unit people;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 unix,baseunix,msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,
 msemenus,msegui,msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,
 mseforms,mseedit,msestatfile,msestream,sysutils,msesimplewidgets,msekeyboard,
 mseact,msedataedits,msedropdownlist,mseificomp,mseificompglob,mseifiglob,
 msebitmap,msedatanodes,msedragglob,msefiledialog,msegrids,msegridsglob,
 mselistbrowser,msesys,mseimage,mseformatbmpicoread, mseformatjpgread,
 mseformatpngread,mseformatpnmread,mseformattgaread, mseformatxpmread,
 msefileutils,msethreadcomp;
type
 tpeoplefo = class(tmseform)
   displayas: tedit;
   namep: tedit;
   email: tedit;
   email1: tedit;
   trichstockglyphbutton1: trichstockglyphbutton;
   trichstockglyphbutton2: trichstockglyphbutton;
   email2: tedit;
   email3: tedit;
   site: tedit;
   site1: tedit;
   site2: tedit;
   site3: tedit;
   phone: tedit;
   phone1: tedit;
   phone2: tedit;
   phone3: tedit;
   address: tedit;
   address1: tedit;
   address2: tedit;
   address3: tedit;
   map: tedit;
   map1: tedit;
   map2: tedit;
   map3: tedit;
   postalindex: tedit;
   postalindex1: tedit;
   postalindex2: tedit;
   postalindex3: tedit;
   freearea: tedit;
   freearea1: tedit;
   freearea2: tedit;
   freearea3: tedit;
   surname: tedit;
   patronym: tedit;
   alias: tedit;
   birthday: tedit;
   deathday: tedit;
   group: tdropdownlistedit;
   group1: tdropdownlistedit;
   group2: tdropdownlistedit;
   group3: tdropdownlistedit;
   photo: tfilenameedit;
   video: tfilenameedit;
   gender: tdropdownlistedit;
   workarea: tedit;
   tlabel1: tlabel;
   tlabel2: tlabel;
   tlabel3: tlabel;
   tlabel4: tlabel;
   dir: tdirdropdownedit;
   tlabel5: tlabel;
   tlabel6: tlabel;
   tlabel7: tlabel;
   tlabel8: tlabel;
   tlabel9: tlabel;
   tlabel10: tlabel;
   tlabel11: tlabel;
   tlabel12: tlabel;
   tlabel13: tlabel;
   tlabel14: tlabel;
   timage1: timage;
   FLoader: TMaskedBitmap;
   tlabel15: tlabel;
   tlabel16: tlabel;
   tlabel17: tlabel;
   tlabel18: tlabel;
   tlabel19: tlabel;
   tlabel20: tlabel;
   tthreadcomp1: tthreadcomp;
   trichstockglyphbutton3: trichstockglyphbutton;
   tbutton1: tbutton;
   tpopupmenu1: tpopupmenu;
   procedure LoadImage(const AFileName: msestring);
   procedure onclose(const sender: TObject);
   procedure oncreate(const sender: TObject);
   procedure onsave(const sender: TObject);
   procedure onbclose(const sender: TObject);
   procedure ok;
   procedure keyup(const sender: twidget; var ainfo: keyeventinfoty);
   procedure onphotochange(const sender: TObject);
   procedure onexepl(const sender: tthreadcomp);
   procedure playvideo;
   procedure onplayvideo(const sender: TObject);
   procedure oncase(const sender: TObject);
   procedure onnm1(const sender: TObject);
   procedure onnm2(const sender: TObject);
   procedure onnm3(const sender: TObject);
   procedure onnm4(const sender: TObject);
   procedure onnm5(const sender: TObject);
 end;
var
 peoplefo: tpeoplefo;
 efpeoplefo : boolean = false;
fullname1, fullname2, fullname3, fullname4, fullname5: msestring;
implementation
uses
 people_mfm,notebook,math,main;
procedure tpeoplefo.onclose(const sender: TObject);
begin
FLoader.Free;
efpeoplefo := false;
end;

procedure tpeoplefo.oncreate(const sender: TObject);
var f : Int64;
begin
displayas.text := edp.displayas;
namep.text := edp.name;
email.text := edp.email;
email1.text := edp.email1;
email2.text := edp.email2;
email3.text := edp.email3;
site.text := edp.site;
site1.text := edp.site1;
site2.text := edp.site2;
site3.text := edp.site3;
phone.text := edp.phone;
phone1.text := edp.phone1;
phone2.text := edp.phone2;
phone3.text := edp.phone3;
address.text := edp.address;
address1.text := edp.address1;
address2.text := edp.address2;
address3.text := edp.address3;
map.text := edp.map;
map1.text := edp.map1;
map2.text := edp.map2;
map3.text := edp.map3;
postalindex.text := edp.postalindex;
postalindex1.text := edp.postalindex1;
postalindex2.text := edp.postalindex2;
postalindex3.text := edp.postalindex3;
freearea.text := edp.freearea;
freearea1.text := edp.freearea1;
freearea2.text := edp.freearea2;
freearea3.text := edp.freearea3;
group.value := edp.group;
group1.value := edp.group1;
group2.value := edp.group2;
group3.value := edp.group3;
photo.value := edp.photo;
video.value := edp.video;
surname.text := edp.surname;
patronym.text := edp.patronym;
alias.text := edp.alias;
birthday.text := edp.birthday;
deathday.text := edp.deathday;
gender.value := edp.gender;
workarea.text := edp.workarea;
dir.value := edp.dir;
FLoader := TMaskedBitmap.Create(BMK_RGB);
LoadImage(photo.value);
group.dropdown.cols.rowcount := Length(ugroups);
for f := 0 to High(ugroups) do group.dropdown.cols[0].items[f] := ugroups[f];
group1.dropdown.cols := group.dropdown.cols;
group2.dropdown.cols := group.dropdown.cols;
group3.dropdown.cols := group.dropdown.cols;
gender.dropdown.cols.rowcount := Length(ugen);
for f := 0 to High(ugen) do gender.dropdown.cols[0].items[f] := ugen[f];
end;

procedure tpeoplefo.ok;
begin
edp.displayas := displayas.text;
edp.name := namep.text;
edp.email := email.text; edp.email1 := email1.text;
edp.email2 := email2.text; edp.email3 := email3.text;
edp.site := site.text; edp.site1 := site1.text;
edp.site2 := site2.text; edp.site3 := site3.text;
edp.phone := phone.text; edp.phone1 := phone1.text;
edp.phone2 := phone2.text; edp.phone3 := phone3.text;
edp.address := address.text; edp.address1 := address1.text;
edp.address2 := address2.text; edp.address3 := address3.text;
edp.map := map.text; edp.map1 := map1.text;
edp.map2 := map2.text; edp.map3 := map3.text;
edp.postalindex := postalindex.text; edp.postalindex1 := postalindex1.text;
edp.postalindex2 := postalindex2.text; edp.postalindex3 := postalindex3.text;
edp.freearea := freearea.text; edp.freearea1 := freearea1.text;
edp.freearea2 := freearea2.text; edp.freearea3 := freearea3.text;
edp.group := group.value; edp.group1 := group1.value;
edp.group2 := group2.value; edp.group3 := group3.value;
edp.photo := photo.value;
edp.video := video.value;
edp.surname := surname.text;
edp.patronym := patronym.text;
edp.alias := alias.text;
edp.birthday := birthday.text;
edp.deathday := deathday.text;
edp.gender := gender.value;
edp.workarea := workarea.text;
edp.dir := dir.value;
if pnum = -1 then begin
SetLength(peoples.a, Length(peoples.a)+1);
peoples.a[High(peoples.a)] := edp;
end else begin
peoples.a[pnum] := edp;
end;
peoples.Save;
if efnotebookfo then notebookfo.Display;
Close;
end;

procedure tpeoplefo.onsave(const sender: TObject);
begin
ok;
end;

procedure tpeoplefo.onbclose(const sender: TObject);
begin
Close;
end;

procedure tpeoplefo.keyup(const sender: twidget; var ainfo: keyeventinfoty);
begin
  if ainfo.key = key_Escape then Close;
  if ainfo.key = key_F2 then ok;
end;

procedure tpeoplefo.LoadImage(const AFileName: msestring);
var
  LSize: sizety;
  LXRatio, LYRatio, LRatio: double;
begin
if not fileexists(AFileName) then exit;
  FLoader.LoadFromFile(AFileName);
   LSize := FLoader.Size;
  LXRatio := TImage1.Size.cx / LSize.cx;
  LYRatio := TImage1.Size.cy / LSize.cy;
  if (LXRatio < 1) or (LYRatio < 1) then
  begin
    LRatio := Min(LXRatio, LYRatio);
    LSize.cx := Round(LRatio * LSize.cx);
    LSize.cy := Round(LRatio * LSize.cy);
  end;
  TImage1.Bitmap.Size := LSize;
  FLoader.Stretch(TImage1.Bitmap);
end;

procedure tpeoplefo.onphotochange(const sender: TObject);
begin
LoadImage(photo.value);
end;

procedure tpeoplefo.playvideo;
begin
tthreadcomp1.run;
end;
procedure tpeoplefo.onexepl(const sender: tthreadcomp);
begin
//if fpfork = 0 then
 fpSystem('gorg64_runner mplayer "' + video.value + '"');
end;
procedure tpeoplefo.onplayvideo(const sender: TObject);
begin
playvideo;
end;

procedure tpeoplefo.oncase(const sender: TObject);
var
po: pointty;
var fp : textfile;
n, s : msestring; 
begin
n := '-l ' + surname.text + ' -f ' + namep.text + ' -m ' + patronym.text;
{$ifdef ootb}
popen (fp, scriptdir + ' petrovich ' + n + ' -c genitive', 'r');
readln(fp, fullname1);
tpopupmenu1.menu.submenu[0].Caption := fullname1;
pclose(fp);
popen (fp, scriptdir + ' petrovich ' + n + ' -c dative', 'r');
readln(fp, fullname2);
tpopupmenu1.menu.submenu[1].Caption := fullname2;
pclose(fp);
popen (fp, scriptdir + ' petrovich ' + n + ' -c accusative', 'r');
readln(fp, fullname3);
tpopupmenu1.menu.submenu[2].Caption := fullname3;
pclose(fp);
popen (fp, scriptdir + ' petrovich ' + n + ' -c instrumental', 'r');
readln(fp, fullname4);
tpopupmenu1.menu.submenu[3].Caption := fullname4;
pclose(fp);
popen (fp, scriptdir + ' petrovich ' + n + ' -c prepositional', 'r');{$else}
popen (fp, scriptdir + ' petrovich ' + n + ' -c genitive', 'r');
readln(fp, fullname1);
tpopupmenu1.menu.submenu[0].Caption := fullname1;
pclose(fp);
popen (fp, scriptdir + ' petrovich ' + n + ' -c dative', 'r');
readln(fp, fullname2);
tpopupmenu1.menu.submenu[1].Caption := fullname2;
pclose(fp);
popen (fp, scriptdir + ' petrovich ' + n + ' -c accusative', 'r');
readln(fp, fullname3);
tpopupmenu1.menu.submenu[2].Caption := fullname3;
pclose(fp);
popen (fp, scriptdir + ' petrovich ' + n + ' -c instrumental', 'r');
readln(fp, fullname4);
tpopupmenu1.menu.submenu[3].Caption := fullname4;
pclose(fp);
popen (fp, scriptdir + ' petrovich ' + n + ' -c prepositional', 'r');
{$endif}


readln(fp, fullname5);
tpopupmenu1.menu.submenu[4].Caption := fullname5;
pclose(fp);
po.x := tbutton1.left;
po.y := tbutton1.top;
tpopupmenu1.show(self, po);
end;

procedure tpeoplefo.onnm1(const sender: TObject);
begin
msewidgets.copytoclipboard(fullname1);
end;
procedure tpeoplefo.onnm2(const sender: TObject);
begin
msewidgets.copytoclipboard(fullname2);
end;
procedure tpeoplefo.onnm3(const sender: TObject);
begin
msewidgets.copytoclipboard(fullname3);
end;
procedure tpeoplefo.onnm4(const sender: TObject);
begin
msewidgets.copytoclipboard(fullname4);
end;
procedure tpeoplefo.onnm5(const sender: TObject);
begin
msewidgets.copytoclipboard(fullname5);
end;

end.
