// http://howardhinnant.github.io/date_algorithms.html
{$MODE FPC}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}
unit ddateprimitives;

interface

type
  // You can change actual using type to whatever you want, but it must be
  // signed and at least 32-bit integral type. I assume that PtrInt is largest
  // still optimal integral type for target CPU.
  TDateInteger = PtrInt;

  // Static check :)
  {$IF SizeOf(TDateInteger) < 4}
    {$ERROR TDateInteger must be at least 32 bit}
  {$ENDIF}

const
  // For serial day number the library supports almost entire range of TDateInteger
  DATE_PRIMITIVES_DAYS_LOW  = Low(TDateInteger);
  DATE_PRIMITIVES_DAYS_HIGH = High(TDateInteger) - 719468;

  //  Range of supported years.
  //    For 32-bit signed TDateInteger the range is
  //      -5867441 .. 5867441
  //    For 64-bit signed TDateInteger the range is
  //      -25200470046051300 .. 25200470046051300
  //    So supported date range is actually colossal.
  DATE_PRIMITIVES_YEAR_LOW  = Low(TDateInteger)  div 366;
  DATE_PRIMITIVES_YEAR_HIGH = High(TDateInteger) div 366;

type
  TYearMonthDay = record
    Year:  TDateInteger;
    Month: TDateInteger; // 1..12
    Day:   TDateInteger; // 1..31
  end;

//
//  days_from_civil
//
//      Converts year,month,day triple to a serial day number.
//
//      Returns number of days since civil 1970-01-01. Negative values indicate
//      days prior to 1970-01-01.
//
//  Parameters:
//
//      Y-M-D represents a date in the civil (Gregorian) calendar
//
//      Y: year  is in range
//             DATE_PRIMITIVES_YEAR_LOW .. DATE_PRIMITIVES_YEAR_HIGH
//      M: month is in range 1..12
//      D: day   is in range 1..last_day_of_month(Y, M)
//
//      The function does not check ranges of input arguments.
//      Caller should check it by himself.
//
//  Returns:
//
//      Result: number of days from 1970-01-01 to Y-M-D
//              if some of Y, M, D are out of range, result is undefined
//
function days_from_civil(Y, M, D: TDateInteger): TDateInteger;

//
//  civil_from_days
//
//      Returns Year/Month/Day triple in civil calendar.
//
//      It is inverse function to the days_from_civil function.
//
//  Parameters:
//
//      Days: number of days since 1970-01-01 in range
//              DATE_PRIMITIVES_DAYS_LOW .. DATE_PRIMITIVES_DAYS_HIGH
//
//  Returns:
//
//      Civil or Result: structure for Year/Month/Day triple
//      Y, M, D: tiple as separated variables
//
procedure civil_from_days(Days: TDateInteger; out Civil: TYearMonthDay); overload;
function civil_from_days(Days: TDateInteger): TYearMonthDay; overload; inline;
procedure civil_from_days(Days: TDateInteger; out Y, M, D: TDateInteger); inline;

//
//  is_leap
//
//      Returns True if Y is a leap year in the civil calendar, false otherwise
//
//  Parameters:
//
//      Y: the year number (range is unlimited)
//
//  Returns:
//
//      Result: True if Y is a leap year in the civil calendar, else false
//
function is_leap(Y: TDateInteger): Boolean;

//
//  last_day_of_month_common_year
//
//      Returns the number of days in the month M of common (that is, not leap)
//      year. Or equivalently the day of the last day of the month.
//
//  Parameters:
//
//      M: month number in range 1..12
//
//  Returns:
//
//      Result: number of days in the month
//              if M is not in range 1..12, result is unspecified
//
function last_day_of_month_common_year(M: TDateInteger): TDateInteger; inline;

//
//  last_day_of_month_leap_year
//
//      Returns the number of days in the month M of leap year. Or equivalently
//      the day of the last day of the month.
//
//  Parameters:
//
//      M: month number in range 1..12
//
//  Returns:
//
//      Result: number of days in the month
//              if M is not in range 1..12, result is unspecified
//
function last_day_of_month_leap_year(M: TDateInteger): TDateInteger; inline;

//
//  last_day_of_month
//
//      Returns the number of days in the month M of the year Y. Or equivalently
//      the day of the last day of the month.
//
//  Parameters:
//
//      Y: the year number (range is unlimited)
//      M: the month number in range 1..12
//
//  Returns:
//
//      Result: number of days in the month
//              if M is not in range 1..12, result is unspecified
//
function last_day_of_month(Y: TDateInteger; M: TDateInteger): TDateInteger;

//
//  weekday_from_days
//
//      Returns day of the week by the serial date Days.
//
//  Parameters:
//
//      Days: number of days since 1970-01-01 in range
//          DATE_PRIMITIVES_DAYS_LOW .. DATE_PRIMITIVES_DAYS_HIGH
//
//  Returns:
//
//      Result: day of the week of the day number Days in range 0..6
//              0 represents Sun, 6 represents Sat
//
function weekday_from_days(Days: TDateInteger): TDateInteger;

//
//  weekday_difference
//
//      Returns the number of days from the weekday Y to the weekday X.
//      The result is always in the range 0..6.
//
//  Parameters:
//
//      X: first weekday in range 0..6 representing Sun..Sat
//      Y: second weekday in range 0..6 representing Sun..Sat
//
//  Returns:
//
//      Result: the number of days from Y to X in range 0..6
//
function weekday_difference(X: TDateInteger; Y: TDateInteger): TDateInteger;

//
//  next_weekday
//
//      Returns the weekday following the WeekDay.
//
//  Parameters:
//
//      WeekDay: the weekday in range 0..6 representing Sun..Sat
//
//  Returns:
//
//      Result: the following weekday in range 0..6 representing Sun..Sat
//              if WeekDay is out of range 0..6, result is unspecified
//
function next_weekday(WeekDay: TDateInteger): TDateInteger;

//
//  prev_weekday
//
//      Returns the weekday following the WeekDay.
//
//  Parameters:
//
//      WeekDay: the weekday in range 0..6 representing Sun..Sat
//
//  Returns:
//
//      Result: the following weekday in range 0..6 representing Sun..Sat
//              if WeekDay is out of range 0..6, result is unspecified
//
function prev_weekday(WeekDay: TDateInteger): TDateInteger;

implementation

function days_from_civil(Y, M, D: TDateInteger): TDateInteger;
var
  Era: TDateInteger; // 400 years time period
                 // (the civil calendar exactly repeats itself every 400 years)
  Yoe: TDateInteger; // Year of the era
  Doy: TDateInteger;
  Doe: TDateInteger; // Day of the era
begin
  // Internally, we suppose that a year starts at 1 march
  if M <= 2 then
    Dec(Y);
  if Y >= 0 then begin
    Era := Y div 400;
  end else
    Era := (Y - 399) div 400;
  Yoe := Y - Era * 400; // [0, 399]
  if M > 2 then begin
    Doy := -3
  end else
    Doy := 9;
  Doy := (153 * (M + Doy) + 2) div 5 + D - 1;       // [0, 365]
  Doe := Yoe * 365 + Yoe div 4 - Yoe div 100 + Doy; // [0, 146096]
  Result := Era * 146097 + Doe - 719468;
end;

procedure civil_from_days(Days: TDateInteger; out Civil: TYearMonthDay);
var
  Era: TDateInteger;
  Doe: TDateInteger;
  Yoe: TDateInteger;
  Doy: TDateInteger;
  Mp: TDateInteger;
begin
  Inc(Days, 719468);
  if Days >= 0 then begin
    Era := Days div 146097;
  end else
    Era := (Days - 146096) div 146097;
  Doe := Days - Era * 146097;                                           // [0, 146096]
  Yoe := (Doe - Doe div 1460 + Doe div 36524 - Doe div 146096) div 365; // [0, 399]
  Civil.Year := Yoe + Era * 400;
  Doy := Doe - (365 * Yoe + Yoe div 4 - Yoe div 100);                   // [0, 365]
  Mp := (5 * Doy + 2) div 153;                                          // [0, 11]
  Civil.Day := Doy - (153 * Mp + 2) div 5 + 1;                          // [1, 31]
  if Mp < 10 then begin
    Civil.Month := Mp + 3;
  end else
    Civil.Month := Mp - 9;                                              // [1, 12]
  if Civil.Month <= 2 then
    Inc(Civil.Year);
end;

function civil_from_days(Days: TDateInteger): TYearMonthDay;
begin
  civil_from_days(Days, Result);
end;

procedure civil_from_days(Days: TDateInteger; out Y, M, D: TDateInteger);
var
  Civil: TYearMonthDay;
begin
  civil_from_days(Days, Civil);
  Y := Civil.Year;
  M := Civil.Month;
  D := Civil.Day;
end;

function is_leap(Y: TDateInteger): Boolean;
begin
  Result := (Y mod 4 = 0) and ((Y mod 100 <> 0) or (Y mod 400 = 0));
end;

function last_day_of_month_common_year(M: TDateInteger): TDateInteger;
const
  TABLE: array[0 .. 15] of Byte = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 0, 0, 0, 0);
begin
  Result := TABLE[(M - 1) and $F];
end;

function last_day_of_month_leap_year(M: TDateInteger): TDateInteger;
const
  TABLE: array[0 .. 15] of Byte = (31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 0, 0, 0, 0);
begin
  Result := TABLE[(M - 1) and $F];
end;

function last_day_of_month(Y: TDateInteger; M: TDateInteger): TDateInteger;
begin
  if (M <> 2) or not is_leap(Y) then begin
    Exit(last_day_of_month_common_year(M));
  end else
    Exit(29);
end;

function weekday_from_days(Days: TDateInteger): TDateInteger;
begin
  if Days >= -4 then begin
    Result := (Days + 4) mod 7;
  end else
    Result := (Days + 5) mod 7 + 6;
end;

function weekday_difference(X: TDateInteger; Y: TDateInteger): TDateInteger;
begin
  Dec(X, Y);
  if Cardinal(X) <= 6 then begin
    Exit(X);
  end else
    Exit(X + 7);
end;

function next_weekday(WeekDay: TDateInteger): TDateInteger;
begin
  if WeekDay < 6 then begin
    Exit(WeekDay + 1);
  end else
    Exit(0);
end;

function prev_weekday(WeekDay: TDateInteger): TDateInteger;
begin
  if WeekDay > 0 then begin
    Exit(WeekDay - 1);
  end else
    Exit(6);
end;

end.
