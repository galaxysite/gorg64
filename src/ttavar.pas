unit ttavar;

{
    Pascal port of ttacodec
    Copyright (C) 2023  Artyomov N Alexander

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
}

{$MODE OBJFPC}
{$LONGSTRINGS ON}

interface

uses ttastruct, ttaconst, ttaarr, sysutils;

var

u : longint;

input_byte_count : QWord;
output_byte_count : QWord;

wave_hdr : pwave_hdr;
subchunk_hdr : psubchunk_hdr;
tta_hdr : Ttta_hdr;

BIT_BUFFER :  array[0..BIT_BUFFER_SIZE + 8 - 1] of byte;

frame_crc32 : DWord;
bit_count : LongInt = 0;
bit_cache : LongInt;
lastpos : DWord;

shift_16 : PLongInt = @bit_shift;

encoder : tencoder;

atta : pencoder;
ienc, ist, ibit : Int64;

fdout : file;

starttime  : real;
startsystime : TSystemTime;
totaltime : real;
timestr    : string[20];

implementation

initialization
shift_16 := shift_16 + 4;
end.