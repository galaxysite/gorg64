unit organization;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 unix,baseunix,msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,
 msemenus,msegui,msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,
 mseforms,mseedit,msestatfile,msestream,sysutils,msekeyboard,msesimplewidgets,
 mseact,msedataedits,msedatanodes,msedragglob,msedropdownlist,msegrids,
 msegridsglob,mseificomp,mseificompglob,mseifiglob,mselistbrowser,msefoldedit,
 msebitmap,msefiledialog,msesys,msethreadcomp,mseimage,math,classes;
type
 torganizationfo = class(tmseform)
   displayas: tedit;
   nameo: tedit;
   trichstockglyphbutton1: trichstockglyphbutton;
   trichstockglyphbutton2: trichstockglyphbutton;
   email: tedit;
   email1: tedit;
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
   hoursofoperation: tedit;
   account: tedit;
   photo: tfilenameedit;
   group: tdropdownlistedit;
   group1: tdropdownlistedit;
   group2: tdropdownlistedit;
   group3: tdropdownlistedit;
   dir: tdirdropdownedit;
   video: tfilenameedit;
   trichstockglyphbutton3: trichstockglyphbutton;
   tthreadcomp1: tthreadcomp;
   timage1: timage;
   FLoader: TMaskedBitmap;
   procedure LoadImage(const AFileName: msestring);
   procedure onclose(const sender: TObject);
   procedure oncreate(const sender: TObject);
   procedure ok;
   procedure keyup(const sender: twidget; var ainfo: keyeventinfoty);
   procedure onok(const sender: TObject);
   procedure oncl(const sender: TObject);
   procedure playvideo;
   procedure onplayvideo(const sender: TObject);
   procedure onexepl(const sender: tthreadcomp);
   procedure onphotochange(const sender: TObject);
   procedure onexeph(const sender: tthreadcomp);
   procedure onloadlang();
 end;
var
 organizationfo: torganizationfo;
 eforganizationfo : boolean = false;
 photoview : boolean = false;
implementation
uses
 organization_mfm,notebook, main, lng;
procedure torganizationfo.onclose(const sender: TObject);
begin
FLoader.Free;
eforganizationfo := false;
end;

procedure torganizationfo.onloadlang();
begin
caption := str_organizations;
freearea1.frame.caption := str_group;
displayas.frame.caption := str_displayas;
nameo.frame.caption := str_name;
email.frame.caption := str_email;
site.frame.caption := str_site;
phone.frame.caption := str_phone;
address.frame.caption := str_address;
map.frame.caption := str_map;
postalindex.frame.caption := str_postalindex;
freearea.frame.caption := str_freearea;
account.frame.caption := str_account;
hoursofoperation.frame.caption := str_hoursofoperation;
photo.frame.caption := str_photo;
video.frame.caption := str_video;
dir.frame.caption := str_dir;
end;

procedure torganizationfo.oncreate(const sender: TObject);
var f : Int64;
begin
displayas.text := edo.displayas;
nameo.text := edo.name;
email.text := edo.email;
email1.text := edo.email1;
email2.text := edo.email2;
email3.text := edo.email3;
site.text := edo.site;
site1.text := edo.site1;
site2.text := edo.site2;
site3.text := edo.site3;
phone.text := edo.phone;
phone1.text := edo.phone1;
phone2.text := edo.phone2;
phone3.text := edo.phone3;
address.text := edo.address;
address1.text := edo.address1;
address2.text := edo.address2;
address3.text := edo.address3;
map.text := edo.map;
map1.text := edo.map1;
map2.text := edo.map2;
map3.text := edo.map3;
postalindex.text := edo.postalindex;
postalindex1.text := edo.postalindex1;
postalindex2.text := edo.postalindex2;
postalindex3.text := edo.postalindex3;
freearea.text := edo.freearea;
freearea1.text := edo.freearea1;
freearea2.text := edo.freearea2;
freearea3.text := edo.freearea3;
hoursofoperation.text := edo.hoursofoperation;
account.text := edo.account;
group.value := edo.group;
group1.value := edo.group1;
group2.value := edo.group2;
group3.value := edo.group3;
photo.value := edo.photo;
video.value := edo.video;
dir.value := edo.dir;
FLoader := TMaskedBitmap.Create(BMK_RGB);
LoadImage(photo.value);
group.dropdown.cols.rowcount := Length(ugroups);
for f := 0 to High(ugroups) do begin
group.dropdown.cols[0].items[f] := ugroups[f];
end;
group1.dropdown.cols := group.dropdown.cols;
group2.dropdown.cols := group.dropdown.cols;
group3.dropdown.cols := group.dropdown.cols;
onloadlang();
end;

procedure torganizationfo.keyup(const sender: twidget;
               var ainfo: keyeventinfoty);
begin
  if ainfo.key = key_Escape then Close;
  if ainfo.key = key_F2 then ok;
end;

procedure torganizationfo.ok;
begin
edo.displayas := displayas.text;
edo.name := nameo.text;
edo.email := email.text; edo.email1 := email1.text;
edo.email2 := email2.text; edo.email3 := email3.text;
edo.site := site.text; edo.site1 := site1.text;
edo.site2 := site2.text; edo.site3 := site3.text;
edo.phone := phone.text; edo.phone1 := phone1.text;
edo.phone2 := phone2.text; edo.phone3 := phone3.text;
edo.address := address.text; edo.address1 := address1.text;
edo.address2 := address2.text; edo.address3 := address3.text;
edo.map := map.text; edo.map1 := map1.text;
edo.map2 := map2.text; edo.map3 := map3.text;
edo.postalindex := postalindex.text; edo.postalindex1 := postalindex1.text;
edo.postalindex2 := postalindex2.text; edo.postalindex3 := postalindex3.text;
edo.freearea := freearea.text; edo.freearea1 := freearea1.text;
edo.freearea2 := freearea2.text; edo.freearea3 := freearea3.text;
edo.hoursofoperation := hoursofoperation.text;
edo.account := account.text;
edo.group := group.value; edo.group1 := group1.value;
edo.group2 := group2.value; edo.group3 := group3.value;
edo.photo := photo.value;
edo.video := video.value;
edo.dir := dir.value;
if onum = -1 then begin
SetLength(organizations.a, Length(organizations.a)+1);
organizations.a[High(organizations.a)] := edo;
end else begin
organizations.a[onum] := edo;
end;
organizations.Save;
if efnotebookfo then notebookfo.Display;
Close;
end;

procedure torganizationfo.onok(const sender: TObject);
begin
ok;
end;

procedure torganizationfo.oncl(const sender: TObject);
begin
Close;
end;

procedure torganizationfo.playvideo;
begin
tthreadcomp1.run;
end;
procedure torganizationfo.onplayvideo(const sender: TObject);
begin
playvideo;
end;

procedure torganizationfo.onexepl(const sender: tthreadcomp);
begin
//if fpfork = 0 then
{$ifdef ootb}
 fpSystem(bindir + 'gorg64_runner mplayer "' + video.value + '"');
{$else}
 fpSystem('gorg64_runner mplayer "' + video.value + '"');
{$endif}
end;

procedure torganizationfo.onphotochange(const sender: TObject);
begin
LoadImage(photo.value);
end;

procedure torganizationfo.onexeph(const sender: tthreadcomp);
begin
fpSystem('gorg64_runner open "' + photo.value + '"');
photoview := false;
end;

procedure torganizationfo.LoadImage(const AFileName: msestring);
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

end.
