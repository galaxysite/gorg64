unit inputbox;
{$ifdef FPC}{$mode objfpc}{$h+}{$endif}
interface
uses
 msetypes,mseglob,mseguiglob,mseguiintf,mseapplication,msestat,msemenus,msegui,
 msegraphics,msegraphutils,mseevent,mseclasses,msewidgets,mseforms,msedragglob,
 mseedit,mseeditglob,msegrids,msegridsglob,mserichstring,msestatfile,msestream,
 msetextedit,sysutils,msesimplewidgets,msekeyboard, msebitmap;
type
 tinputboxfo = class(tmseform)
   ttextedit1: ttextedit;
   trichbutton3: trichbutton;
   trichbutton4: trichbutton;
   trichbutton5: trichbutton;
   trichbutton6: trichbutton;
   trichbutton7: trichbutton;
   trichbutton8: trichbutton;
   trichbutton9: trichbutton;
   trichbutton10: trichbutton;
   trichbutton11: trichbutton;
   trichbutton12: trichbutton;
   trichbutton13: trichbutton;
   trichbutton14: trichbutton;
   trichbutton15: trichbutton;
   trichbutton16: trichbutton;
   trichstockglyphbutton1: trichstockglyphbutton;
   trichbutton17: trichbutton;
   trichbutton18: trichbutton;
   trichbutton19: trichbutton;
   trichbutton20: trichbutton;
   trichbutton21: trichbutton;
   trichbutton22: trichbutton;
   trichbutton23: trichbutton;
   trichbutton24: trichbutton;
   trichbutton25: trichbutton;
   trichbutton26: trichbutton;
   trichbutton27: trichbutton;
   trichbutton28: trichbutton;
   trichbutton29: trichbutton;
   trichbutton30: trichbutton;
   trichbutton31: trichbutton;
   trichbutton32: trichbutton;
   trichbutton33: trichbutton;
   trichbutton34: trichbutton;
   trichbutton35: trichbutton;
   trichbutton36: trichbutton;
   trichbutton37: trichbutton;
   trichbutton38: trichbutton;
   trichbutton39: trichbutton;
   trichbutton40: trichbutton;
   trichbutton41: trichbutton;
   trichbutton42: trichbutton;
   trichbutton43: trichbutton;
   trichbutton44: trichbutton;
   trichbutton45: trichbutton;
   trichbutton46: trichbutton;
   trichbutton47: trichbutton;
   trichbutton48: trichbutton;
   trichbutton49: trichbutton;
   trichbutton50: trichbutton;
   trichbutton51: trichbutton;
   trichbutton52: trichbutton;
   trichbutton53: trichbutton;
   trichbutton54: trichbutton;
   trichbutton55: trichbutton;
   trichbutton56: trichbutton;
   trichbutton57: trichbutton;
   trichbutton58: trichbutton;
   trichbutton59: trichbutton;
   trichbutton60: trichbutton;
   trichbutton61: trichbutton;
   trichbutton62: trichbutton;
   trichbutton63: trichbutton;
   trichbutton64: trichbutton;
   trichbutton65: trichbutton;
   trichbutton66: trichbutton;
   trichbutton67: trichbutton;
   trichbutton68: trichbutton;
   trichbutton69: trichbutton;
   trichbutton70: trichbutton;
   trichbutton71: trichbutton;
   trichbutton72: trichbutton;
   trichbutton73: trichbutton;
   trichbutton74: trichbutton;
   trichbutton75: trichbutton;
   trichbutton76: trichbutton;
   trichbutton77: trichbutton;
   trichbutton78: trichbutton;
   trichbutton79: trichbutton;
   trichbutton80: trichbutton;
   trichbutton81: trichbutton;
   trichbutton82: trichbutton;
   trichbutton83: trichbutton;
   trichbutton84: trichbutton;
   trichbutton85: trichbutton;
   trichbutton86: trichbutton;
   trichbutton87: trichbutton;
   trichbutton88: trichbutton;
   trichbutton89: trichbutton;
   trichbutton90: trichbutton;
   trichbutton91: trichbutton;
   trichbutton92: trichbutton;
   trichbutton93: trichbutton;
   trichbutton94: trichbutton;
   trichbutton95: trichbutton;
   trichbutton96: trichbutton;
   trichbutton97: trichbutton;
   trichbutton98: trichbutton;
   trichbutton99: trichbutton;
   trichbutton100: trichbutton;
   trichbutton101: trichbutton;
   trichbutton102: trichbutton;
   trichbutton103: trichbutton;
   trichbutton104: trichbutton;
   trichbutton105: trichbutton;
   trichbutton106: trichbutton;
   trichbutton107: trichbutton;
   trichbutton108: trichbutton;
   trichbutton109: trichbutton;
   trichbutton110: trichbutton;
   trichbutton111: trichbutton;
   trichbutton112: trichbutton;
   trichbutton113: trichbutton;
   trichbutton114: trichbutton;
   trichbutton115: trichbutton;
   trichbutton116: trichbutton;
   trichbutton117: trichbutton;
   trichbutton118: trichbutton;
   trichbutton119: trichbutton;
   trichbutton120: trichbutton;
   trichbutton121: trichbutton;
   trichbutton122: trichbutton;
   trichbutton123: trichbutton;
   trichbutton124: trichbutton;
   trichbutton125: trichbutton;
   trichbutton126: trichbutton;
   trichbutton127: trichbutton;
   trichbutton128: trichbutton;
   trichbutton129: trichbutton;
   trichbutton130: trichbutton;
   trichbutton131: trichbutton;
   trichbutton132: trichbutton;
   trichbutton133: trichbutton;
   trichbutton134: trichbutton;
   trichbutton135: trichbutton;
   trichbutton136: trichbutton;
   trichbutton137: trichbutton;
   trichbutton138: trichbutton;
   trichbutton139: trichbutton;
   trichbutton140: trichbutton;
   trichbutton141: trichbutton;
   trichbutton142: trichbutton;
   trichbutton143: trichbutton;
   trichbutton144: trichbutton;
   trichbutton145: trichbutton;
   trichbutton146: trichbutton;
   trichbutton147: trichbutton;
   trichbutton148: trichbutton;
   trichbutton149: trichbutton;
   trichbutton150: trichbutton;
   trichbutton151: trichbutton;
   trichbutton152: trichbutton;
   trichbutton153: trichbutton;
   trichbutton154: trichbutton;
   trichbutton155: trichbutton;
   trichbutton156: trichbutton;
   trichbutton157: trichbutton;
   trichbutton158: trichbutton;
   trichbutton159: trichbutton;
   trichbutton160: trichbutton;
   trichbutton161: trichbutton;
   trichbutton162: trichbutton;
   trichbutton163: trichbutton;
   tlabel1: tlabel;
   tframecomp2: tframecomp;
   trichstockglyphbutton3: trichstockglyphbutton;
   trichstockglyphbutton2: trichstockglyphbutton;
   procedure ok;
   procedure onok(const sender: TObject);
   procedure oncancel(const sender: TObject);
   procedure oncreate(const sender: TObject);
   procedure onscrkey(const sender: TObject);
   procedure onback(const sender: TObject);
   procedure keyup(const sender: twidget; var ainfo: keyeventinfoty);
 end;

procedure input; 
 
var
 inputboxfo: tinputboxfo;
 inputboxstr : msestring;
implementation
uses
 inputbox_mfm,ee;

procedure tinputboxfo.ok;
begin
inputboxstr := ttextedit1.text;
Close;
end; 
 
procedure tinputboxfo.onok(const sender: TObject);
begin
ok;
end;

procedure tinputboxfo.oncancel(const sender: TObject);
begin
Close;
end;

procedure tinputboxfo.oncreate(const sender: TObject);
begin
ttextedit1.text := inputboxstr;
end;

procedure tinputboxfo.onscrkey(const sender: TObject);
begin
ttextedit1.text := ttextedit1.text + trichbutton(sender).caption;
end;

procedure tinputboxfo.onback(const sender: TObject);
var s : msestring;
l : Int64;
begin
s := ttextedit1.text;
l := Length(s);
if l > 0 then SetLength(s, l-1);
ttextedit1.text := s;
end;

procedure tinputboxfo.keyup(const sender: twidget; var ainfo: keyeventinfoty);
begin
if ainfo.key = key_Escape then Close;
if ainfo.key = key_Return then Ok;
end;

procedure input;
begin
inputboxfo := tinputboxfo.Create(nil);
end;

end.
