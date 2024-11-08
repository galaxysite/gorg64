program dclockpanel;

{
    Clock panel for X.Org.
    For GNU/Linux.
    Version: 2.
    Written on FreePascal (https://freepascal.org/).
    Copyright (C) 2021-2022  Artyomov Alexander
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
{$LONGSTRINGS ON}
{$RANGECHECKS ON}
{$SMARTLINK ON}
{$ASMMODE INTEL}
//{$CODEPAGE UTF8}
 
uses cthreads,classes,sysutils,x,xlib,xutil,xatom,strings,wdnrukoi, ctypes, urunu;

type
    TGt  = class(TThread)
    public
         procedure AfterConstruction; override;
         procedure Execute; override;
    end;

TMonth = 1..12;
TDay = 1..31;
TWeekDayRu = 1..7;
 
const
 
 WND_X=300;
 WND_Y=50;
 WND_WDT=800;
 WND_HGH=600;
 WND_MIN_WDT=50;
 WND_MIN_HGH=50;
 WND_BORDER_WDT=5;
 WND_TITLE='Clock panel';
 WND_ICON_TITLE='Clock panel';
 PRG_CLASS='ClockPanel';

monlen : array [TMonth] of TDay = (31,28,31,30,31,30,31,31,30,31,30,31);

var
    year : LongInt;
    month, day, hour, minute : byte;
    inittime : boolean = false;
a, prop3, wm_state_above : TAtom;
 atom1, atom2 : TAtom;

function WaitForNotify(d: PDisplay; e: PXEvent; w: TXPointer): LongBool; cdecl;
begin
Exit((e^._type = MapNotify) and (e^.xmap.window = TWindow(w)));
end;

function inttofix2str(i : integer) : string;
begin result := inttostr(i);if 10 > i then result := '0' + result; end;

function WeekdayRu(y: Int64; m: TMonth; d: TDay) : TWeekDayRu;
var
  Era, Yoe, Doy, Doe, civ, tmp : Int64; 
begin
if M <= 2 then Dec(Y);
if Y >= 0 then Era := Y div 400
          else Era := (Y - 399) div 400;
Yoe := Y - Era * 400;
if M > 2 then Doy := -3
         else Doy := 9;
Doy := (153 * (M + Doy) + 2) div 5 + D - 1;
Doe := Yoe * 365 + Yoe div 4 - Yoe div 100 + Doy;
civ := Era * 146097 + Doe - 719468;
if civ >= -4 then tmp := (civ + 4) mod 7
else tmp := (civ + 5) mod 7 + 6;
if tmp = 0 then tmp := 7;
Exit(tmp);
end;

function vg(y : Int64) : boolean;
begin
Exit( (((y mod 4) = 0) and (((y mod 100) <> 0))) or ((y mod 400) = 0) );
end;

function MonthWithDay(y : Int64; m : TMonth) : boolean;
begin
case m of
2: Exit(vg(y));
else
Exit(monlen[m] = 31);
end;
end;

(* SetWindowManagerHints - процедура передает информацию о свойствах программы менеджеру окон. *)
procedure SetWindowManagerHints(
 prDisplay: PDisplay; (*Указатель на структуру TDisplay *)
 psPrgClass: PChar; (*Класс программы *)
 argv: PPChar; (*Аргументы программы *)
 argc: integer; (*Число аргументов *)
 nWnd: TWindow; (*Идентификатор окна *)
  x, (*Координаты левого верхнего *)
  y, (*угла окна *)
  nWidth,
  nHeight, (*Ширина и высота окна *)
  nMinWidth,
  nMinHeight:integer; (*Минимальные ширина и высота окна *)
 psTitle: PChar; (*Заголовок окна *)
 psIconTitle: PChar; (*Заголовок пиктограммы окна *)
 nIconPixmap: TPixmap (*Рисунок пиктограммы *)
);
 
var
 rSizeHints: TXSizeHints; (*Рекомендации о размерах окна*)
 rWMHints: TXWMHints;
 rClassHint: TXClassHint;
 prWindowName, prIconName: TXTextProperty;

begin
 
if (XStringListToTextProperty(@psTitle, 1, @prWindowName)=0) or
    (XStringListToTextProperty(@psIconTitle, 1, @prIconName)=0) then
 begin
  writeln('No memory!');
  halt(1);
end;
 rSizeHints.flags:= PPosition OR PSize OR PMinSize;
 rSizeHints.min_width:= nMinWidth;
 rSizeHints.min_height:= nMinHeight;
 rWMHints.flags:= StateHint OR IconPixmapHint OR InputHint;
 rWMHints.initial_state:= NormalState;
 rWMHints.input:= 1; // True;
 rWMHints.icon_pixmap:= nIconPixmap;
 rClassHint.res_name:= argv[0];
 rClassHint.res_class:= psPrgClass;
 XSetWMProperties(prDisplay, nWnd, @prWindowName, @prIconName, argv, argc, @rSizeHints, @rWMHints, @rClassHint);
end;

var
 prDisplay: PDisplay; (* Указатель на структуру Display *)
 nScreenNum: integer; (* Номер экрана *)
 prGC: TGC;
 rEvent, sEvent: TXEvent;
 nWnd: TWindow;
 gt  : TThread;
  s : string;
Font : TFont;
FontBig : TFont;
FontSm : TFont;

procedure TGt.AfterConstruction;
begin
  inherited AfterConstruction;
  FreeOnTerminate := True;
end;

procedure TGt.Execute;
  var t : TSystemTime;
begin
while true do begin
GetLocalTime(t);
if (year <> t.Year) or (month <> t.Month) or (day <> t.Day) or (hour <> t.Hour) or (minute <> t.Minute) then begin
year := t.Year; month := t.Month; day := t.Day;
hour := t.Hour; minute := t.Minute;
inittime := true;
sevent.xexpose._type := Expose;
sevent.xexpose.x := 0;
sevent.xexpose.y := 0;
sevent.xexpose.width := 150;
sevent.xexpose.height := 150;
sevent.xexpose.count := 0;
XSendEvent(prdisplay, nwnd, true, 0, @sevent);
XFlush(prdisplay);
end;
sleep(1000);
end;
end;
 
begin

XInitThreads;
 
(* Устанавливаем связь с сервером *)
 prDisplay:= XOpenDisplay(nil);
if prDisplay = nil then begin
  writeln('Can not connect to the X server!');
  halt (1);
 end;

 (* Получаем номер основного экрана *)
 nScreenNum:= XDefaultScreen(prDisplay);

//font := XLoadFont(prdisplay, '-cronyx-times-bold-r-normal-*-32-*-*-*-*-*-koi8-r');
font := XLoadFont(prdisplay, '-*-helvetica-bold-r-normal-*-300-*-*-*-*-*-koi8-r');
fontsm := XLoadFont(prdisplay, '-*-helvetica-bold-r-normal-*-240-*-*-*-*-*-koi8-r');

fontbig := XLoadFont(prdisplay, '-*-helvetica-bold-r-normal-*-400-*-*-*-*-*-koi8-r');
//font := XLoadFont(prdisplay, '-*-courier-medium-r-normal-*-32-*-*-*-*-*-*-*');
 
 (* Создаем окно *)
 nWnd:= XCreateSimpleWindow(prDisplay, XRootWindow (prDisplay, nScreenNum), WND_X, WND_Y, WND_WDT, WND_HGH, WND_BORDER_WDT, XWhitePixel (prDisplay, nScreenNum),
 XWhitePixel (prDisplay, nScreenNum));
 (* Задаем рекомендации для менеджера окон *)
 SetWindowManagerHints(prDisplay, PRG_CLASS, argv, argc, nWnd, WND_X, WND_Y, WND_WDT, WND_HGH, WND_MIN_WDT, WND_MIN_HGH, WND_TITLE, WND_ICON_TITLE, 0);
 (* Выбираем события, обрабатываемые программой *)
 XSelectInput(prDisplay, nWnd, ExposureMask OR KeyPressMask OR ButtonPressMask OR StructureNotifyMask);

a := XInternAtom(prdisplay, '_NET_WM_STATE', True);
if (a <> None) then begin
prop3 := XInternAtom(prdisplay, '_NET_WM_STATE_FULLSCREEN', True);
XChangeProperty(prdisplay, nwnd, a, XA_ATOM, 32, PropModeAppend, @prop3, 1);
end;

atom1 := XInternAtom(prdisplay, 'WM_PROTOCOLS', 0);
atom2 := XInternAtom(prdisplay, 'WM_DELETE_WINDOW', 0);
XSetWMProtocols(prdisplay, nwnd, @atom2, 1);

wm_state_above := XInternAtom(prdisplay, '_NET_WM_STATE_ABOVE', False);

(* Показываем окно *)
XMapWindow(prDisplay, nWnd);

// input focus
XIfEvent(prdisplay, @revent, @WaitForNotify, TXPointer(nwnd));
XSetInputFocus(prdisplay, nwnd, RevertToNone, CurrentTime);

if (wm_state_above <> None) then begin
		fillbyte(revent, sizeof(txevent), 0);
		revent.xclient._type := ClientMessage;
		revent.xclient.window := nwnd;
		revent.xclient.serial := 0;
		revent.xclient.send_event := 1;
		revent.xclient.display := prdisplay;
		revent.xclient.message_type := a;//wm_state;
		revent.xclient.format := 32;
		revent.xclient.data.l[0] := 1;
		revent.xclient.data.l[1] := wm_state_above;
		revent.xclient.data.l[2] := 0;
		revent.xclient.data.l[3] := 0;
		revent.xclient.data.l[4] := 0;
		XSendEvent( prdisplay, DefaultRootWindow(prdisplay), False,
			SubstructureRedirectMask or SubstructureNotifyMask, @revent);
end;

xsync(prdisplay,true);

gt := TGt.Create(True);
gt.Start;

 (* Цикл получения и обработки событий *)
while (true) do begin
  XNextEvent(prDisplay, @rEvent);
case (rEvent._type) of
  Expose:
begin
   (* Запрос на перерисовку *)
if (rEvent.xexpose.count <> 0) then continue;
if inittime = false then continue;
XClearWindow(prdisplay, nwnd);
prGC:= XCreateGC (prDisplay, nWnd, 0, nil );
XSetForeground(prDisplay, prGC, XBlackPixel (prDisplay, 0));
XSetFont(prdisplay, prgc, fontbig);
s := IntToStr(hour) + ':' + IntToFix2Str(minute); // + '  ' + Copy(IntToStr(year), 3, 2);
XDrawString(prDisplay, nWnd, prGC, 0, 292, PChar(s), strlen(PChar(s)));
//s := Copy(mon_name[month],1,4);
XSetFont(prdisplay, prgc, font);
s := inttostr(month) + mon_name[month];
if MonthWithDay(year,month) then s := '+' + s;
XDrawString(prDisplay, nWnd, prGC, 0, 520, PChar(s), strlen(PChar(s)));
//s := Copy(wdn[WeekdayRu(year, month, day)], 1, 4) + ' ' + IntToStr(day);
s := IntToStr(day) + wdn[WeekdayRu(year, month, day)];
XDrawString(prDisplay, nWnd, prGC, 0, 750, PChar(s), strlen(PChar(s)));
XSetFont(prdisplay, prgc, fontsm);
s := IntToStr(year);
if vg(year) then s := '+' + s;
XDrawString(prDisplay, nWnd, prGC, 0, 930, PChar(s), strlen(PChar(s)));
   XFreeGC (prDisplay, prGC);
end;
ButtonPress: if revent.xkey.keycode = 3 then XDestroyWindow(prdisplay, nwnd);
DestroyNotify,
 KeyPress:
   begin
    (* Нажатие клавиши клавиатуры *)
    XCloseDisplay(prDisplay);
    halt(0);
   end;
 ClientMessage: begin
 if((revent.xclient.message_type = atom1) and (revent.xclient.data.l[0] = atom2))
      then begin
          XDestroyWindow(prdisplay, nwnd);
      end;
break;
 end;
end;
 end;
end.