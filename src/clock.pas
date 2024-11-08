
unit clock;

{$ifdef FPC}{$mode objfpc}{$h+}{$endif}

interface

uses 
SysUtils, msepointer, mseglob, mseguiglob, mseguiintf, mseapplication, msegui, msegraphutils, 
mseevent, mseclasses, mseforms, msesimplewidgets, msebitmap, msegraphics;

type 
  tclockfo = class(tmainform)

    tlabel1: tlabel;
    tbutton1: TButton;
    tpaintbox1: tpaintbox;
    tlabel2: tlabel;
    procedure onquit(Const Sender: TObject);
    procedure oncreate(Const Sender: TObject);
    procedure onmouseev(Const Sender: twidget; Var ainfo: mouseeventinfoty);
  end;

var 
  clockfo: tclockfo;
  ispressed: Boolean = False;
  oripoint: pointty;

implementation

uses 
main_mfm;

procedure tclockfo.onquit(Const Sender: TObject);
begin
  application.ProcessMessages;
  Close;
end;

procedure tclockfo.oncreate(Const Sender: TObject);
begin
  {$ifdef windows}
  mse_radiuscorner := 40;
  tlabel2.caption := 'Hello I am a borderless rounded always on top MSE-form.';
  {$endif}
end;

procedure tclockfo.onmouseev(Const Sender: twidget; Var ainfo: mouseeventinfoty);
begin
  if ainfo.eventkind = ek_buttonpress then
    begin
      ispressed := True;
      oripoint  := ainfo.pos;
      tpaintbox1.cursor := cr_pointinghand;
    end;
  if ainfo.eventkind = ek_buttonrelease then
    begin
      ispressed := False;
      tpaintbox1.cursor := cr_default;
    end;
  if (ispressed = True) and (ainfo.eventkind = ek_mousemove) then
    begin
      left := left + ainfo.pos.x - oripoint.x;
      top  := top + ainfo.pos.y - oripoint.y;
    end;
end;

end.
