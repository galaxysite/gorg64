unit ttafunctions;
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
//{$RANGECHECKS ON}
{$LONGSTRINGS ON}
{$SMARTLINK ON}
{$ASMMODE INTEL}

interface

uses ttaconst, ttaarr, ttastruct, ttavar, math, sysutils, syscall;

function compress(fin, fout : utf8string)  : boolean;

implementation

function getrealtime(const st: TSystemTime) : real; register;
begin
result := st.Hour*3600.0 + st.Minute*60.0 + st.Second + st.MilliSecond/1000.0;
end;
function getrealtime : real; register;
var
	st:TSystemTime;
begin
GetLocalTime(st);
result:=getrealtime(st);
end;

procedure UPDATE_CRC32(var x, crc : DWord); register; inline;
begin
	crc := (((crc shr o) and $00FFFFFF) xor crc32_table[(crc xor x) and $FF]);
end;
procedure UPDATE_CRC32(var x : byte; var crc : DWord); register; inline;
begin
	crc := (((crc shr o) and $00FFFFFF) xor crc32_table[(crc xor x) and $FF]);
end;
function crc32(buffer :  PByte; len : DWord) : DWord; register; inline;
var
	i : DWord;
	crc : DWord = $FFFFFFFF;
begin
for i := 0 to len-1 do begin
	UPDATE_CRC32(buffer[i], crc);
end;
Exit(crc  xor  $FFFFFFFF);
end;

procedure put_binary(value, bits : DWord); register; inline;
begin
	while (bit_count >= o) do begin
		BIT_BUFFER[ibit] := bit_cache and $FF;
		UPDATE_CRC32(BIT_BUFFER[ibit], frame_crc32);
		bit_cache := bit_cache shr o;
		bit_count := bit_count - o;
		Inc(ibit);
	end;
	bit_cache := bit_cache or (value and bit_mask[bits]) shl bit_count;
	bit_count := bit_count + bits;
end;

function compress(fin, fout : utf8string)  :  boolean; register;
var
shift : byte;
sum, l7, l6, l5, l4 : Int64;
prev : LongInt;
num_chan, data_size, byte_size, data_len : DWord;
buffer_len, framelen, lastlen, fframes : DWord;
value : DWord;
st_size : DWord = 0;
offset : DWord = 0;
def_subchunk_size : DWord = 16;
extra_len : DWord = 0;
f : Int64;
asrc : pbyte;
adata : Plongint;
seek_table : PDWord;
tmp : LongInt;
e_t : bytebool;
res : DWord;
fsrc : Int64;
fh : Int64;
z : Int64 = 0; // siZe
a {Address} : Int64;
T : LongInt;

begin
GetLocalTime(startsystime);
starttime := getrealtime(startsystime);

Assign(fdout, fout);
FileMode := 1; ReWrite(fdout, 1);
ienc := 0; ist := 0; ibit := 0;

	// clear statistics
	output_byte_count := 0;

	// print process banner
	WriteLn(stderr, 'Encode: ' + fin);

fh := do_SysCall(2 {Open}, Int64(PChar(fin)),0 {R W old 2}); if fh < 0 then begin WriteLn(stderr, 'Error: can''t open input file'); Exit(true); end;
z  := do_SysCall(o {GET LEN}, fh,0{from begin},2{SEEK_END}); if z < sizeof(wave_hdr) then begin WriteLn(stderr, 'Error: can''t get len input file'); do_SysCall(3 {Close}, fh); Exit(true); end;
a := do_SysCall(9 {FILEMAP}, 0{from begin},z,1{PROT_},1{MAP_},fh,0{from begin file});
adata := Pointer(a);
if (a < 0) or (do_SysCall(3 {Close}, fh) < 0)  then begin WriteLn(stderr, 'Error: can''t map input file'); do_SysCall(3 {Close}, fh); Exit(true); end;

	// read WAVE header
	wave_hdr := @adata[0];
	input_byte_count := sizeof(twave_hdr);

	tta_hdr.AudioFormat := wave_hdr^.AudioFormat;

	// check for supported formats
	if (tta_hdr.AudioFormat <> WAVE_FORMAT_PCM) or (wave_hdr^.ChunkID <> RIFF_SIGN) or (wave_hdr^.Format <> WAVE_SIGN) or (wave_hdr^.Subchunk1ID <> fmt_SIGN) or (wave_hdr^.Subchunk1Size > wave_hdr^.ChunkSize) or (wave_hdr^.NumChannels = 0) or (wave_hdr^.BitsPerSample > MAX_BPS)  then begin
		WriteLn(stderr, 'File format error'); do_SysCall(3 {Close}, fh); Exit(true);
	end;

	// skip extra format bytes
	if (wave_hdr^.Subchunk1Size > def_subchunk_size) then begin
		extra_len := wave_hdr^.Subchunk1Size - def_subchunk_size;
		input_byte_count := input_byte_count + extra_len;
		WriteLn(stderr, 'Encode: skiped  extra format bytes');
	end;

	// stop unsupported chunks
	subchunk_hdr := @adata[input_byte_count div 4];
	input_byte_count := input_byte_count + sizeof(subchunk_hdr^);
	if (subchunk_hdr^.SubchunkID <> data_SIGN) then begin
		WriteLn(stderr, 'unsupported chunk');
		Halt;
	end;

	framelen := Round(FRAME_TIME * wave_hdr^.SampleRate);
	num_chan := wave_hdr^.NumChannels;
	data_size := subchunk_hdr^.SubchunkSize;
	byte_size := (wave_hdr^.BitsPerSample + 7) div o;
if byte_size <> 2 then begin
writeln(stderr, 'Unsupported byte_size');
do_SysCall(3 {Close}, fh);
Exit(true);
end;
shift := flt_set[byte_size - 1]; u := 1 shl (shift - 1);

	data_len := data_size div (byte_size * num_chan);

	lastlen := data_len mod framelen;
	fframes := data_len div framelen; if lastlen <> 0 then Inc(fframes);
	st_size := (fframes + 1);
	buffer_len := num_chan * framelen;

	tta_hdr.TTAid := TTA1_SIGN;  tta_hdr.NumChannels := wave_hdr^.NumChannels; tta_hdr.BitsPerSample := wave_hdr^.BitsPerSample;	tta_hdr.SampleRate := wave_hdr^.SampleRate; tta_hdr.DataLength := data_len; tta_hdr.CRC32 := crc32(PByte(@tta_hdr), sizeof(tta_hdr) - sizeof(longint));

	// grab some space for an encoder buffers
	GetMem(seek_table, st_size*4*4);
	GetMem(atta, num_chan*sizeof(tencoder));
	// write TTA header
	blockwrite(fdout, tta_hdr, sizeof(tta_hdr));
	if  IOResult <> 0 then begin WriteLn(stderr, 'Write file header error'); do_SysCall(3 {Close}, fh); Close(fdout); Exit(true); end
	else output_byte_count := output_byte_count + sizeof(tta_hdr);

	Dec(tta_hdr.NumChannels);

	// allocate space for a seek table
	blockwrite(fdout, seek_table[0], st_size*4);
	if  IOResult <> 0 then begin WriteLn(stderr, 'Write space for seek table error'); do_SysCall(3 {Close}, fh); Close(fdout); Exit(true); end
	else output_byte_count := output_byte_count + st_size * sizeof(dword);

	 bit_count := 0; bit_cache := 0; ibit := 0; lastpos := output_byte_count;

	for fframes := fframes - 1 downto 0 do begin
		if ((fframes = 0) and (lastlen<>0)) then begin framelen := lastlen; buffer_len := num_chan * framelen; end;
		frame_crc32 := $FFFFFFFF;
		for f := 0 to tta_hdr.NumChannels {num_chan - 1} do // encoder_init
		with atta[f] do begin filldword(fst, sizeof(Tfltst), 0);
			with rice do begin k0 := 10; k1 := k0; sum0 := 16384; sum1 := sum0; end;
			last := 0;
		end; {next f encoder_init}

		prev := 0;
		fsrc := 0; // read_wave
res :=  (buffer_len * byte_size);
if res + input_byte_count  > z then res := res - ((res + input_byte_count ) - z);
if res < 1 then break;
asrc := @adata[input_byte_count div 4];

		FOR f := 0 to res div byte_size - 1 do begin
		T := asrc[fsrc]; Inc(fsrc); T := T or (ShortInt(asrc[fsrc]) shl o); Inc(fsrc);

		// transform data
		e_t := ienc < tta_hdr.NumChannels {num_chan - 1}; if e_t then begin
		prev := ((asrc[fsrc] or (ShortInt(asrc[fsrc + 1]) shl o)) - T); Tmp :=  prev;
		end else Tmp := T - prev div 2;

		// compress stage 1: fixed order 1 prediction
		T := Tmp - LongInt(((QWord(atta[ienc].last) shl 5) - QWord(atta[ienc].last)) shr 5);
		atta[ienc].last := tmp;
// compress stage 2: adaptive hybrid filter
with atta[ienc].fst do begin
	if (error < 0) then begin
Dec(qm0, dx0); Dec(qm1, dx1); Dec(qm2, dx2); Dec(qm3, dx3); Dec(qm4, dx4); Dec(qm5, dx5); Dec(qm6, dx6); Dec(qm7, dx7);
	end else
	if (error > 0) then begin
Inc(qm0, dx0); Inc(qm1, dx1); Inc(qm2, dx2); Inc(qm3, dx3); Inc(qm4, dx4); Inc(qm5, dx5); Inc(qm6, dx6); Inc(qm7, dx7);
	end;
sum := u +  dl0 * qm0 + dl1 * qm1 + dl2 * qm2 + dl3 * qm3 +dl4 * qm4 + dl5 * qm5 + dl6 * qm6 + dl7 * qm7;
l7 := dl7; l6 := dl6; l5 := dl5; l4 := dl4;
dl0 :=dl1; dl1 :=dl2; dl2 :=dl3; dl3 :=dl4;
dl6 := T - dl7;
dl5 := dl6 - l6;
dl4 := dl5 - l5;
dl7 := T;
dx0 :=dx1; dx1 :=dx2; dx2 :=dx3; dx3 :=dx4;

dx7 := (sarlongint(l7, 30) or 1) shl  2;
dx6 := (sarlongint(l6, 30) or 1) shl  1;
dx5 := (sarlongint(l5, 30) or 1) shl  1;
dx4 := sarlongint(l4, 30) or 1;

T := T - sarlongint(sum, shift);
error := T;
end; {w}
			if T > 0 then value := ((T shl 1)-1) else value := (-(T) shl 1);

			// encode Rice unsigned
			with atta[ienc].rice do begin
			Inc(sum0, (value - (sum0 shr 4)));
			if (value >= bit_shift[k0]) then begin
				Dec(value, bit_shift[k0]);
tmp := 1 + (value shr k1);
	while true do begin // put_unary(1 + (value shr k1));
		while (bit_count >= o) do begin
			BIT_BUFFER[ibit] := Byte(bit_cache) and $FF;
			UPDATE_CRC32(BIT_BUFFER[ibit], frame_crc32);
			bit_cache :=  bit_cache shr o;
			Dec(bit_count, o);
			Inc(ibit);
		end; {wend}
		if (tmp > 23)  then begin
			bit_cache := bit_cache or (bit_mask[23] shl bit_count);
			Inc(bit_count, 23);
			Dec(tmp, 23);
		end else begin
			bit_cache := bit_cache or (bit_mask[tmp] shl bit_count);
			Inc(bit_count, (tmp + 1));
			break;
		end;
	if tmp = 0 then break;
	end; {wend};
				if (k1 <> 0) then put_binary((value and bit_mask[k1]), k1);
				sum1 := sum1 + value - (sum1 shr 4);
				if ((k1 > 0) and (sum1 < shift_16[k1])) then Dec(k1)
				else if (sum1 > shift_16[k1 + 1]) then Inc(k1);
			end else begin // put_unary0;
while (bit_count >= o) do begin
	BIT_BUFFER[ibit] := Byte(bit_cache) and $FF;
	UPDATE_CRC32(BIT_BUFFER[ibit], frame_crc32);
	bit_cache :=  bit_cache shr o;
	Dec(bit_count, o);
	Inc(ibit);
end; {wend} Inc(bit_count);
				if (k0 <> 0) then put_binary((value and bit_mask[k0]), k0);
			end;
			if (k0 > 0) and (sum0 < shift_16[k0]) then Dec(k0)
			else if sum0 > shift_16[k0 + 1] then Inc(k0);
			end; {w}

			if e_t then Inc(ienc) else ienc := 0;
		end; {next f}

	while (bit_count <> 0)  do begin // seek_table[ist] := done_buffer_write; Inc(ist);
		BIT_BUFFER[ibit] := bit_cache and $FF;
		UPDATE_CRC32(BIT_BUFFER[ibit], frame_crc32);
		bit_cache := bit_cache shr o;
		if bit_count > o then Dec(bit_count, o) else bit_count := 0;
		Inc(ibit);
	end;
	frame_crc32 := frame_crc32 xor $FFFFFFFF;
	Move(frame_crc32,BIT_BUFFER[ibit], 4);
	blockwrite(fdout, BIT_BUFFER[0], ibit + sizeof(longint), tmp);
			if (IOResult <> 0) then begin
				Writeln(stderr, 'done_buffer_write error');
				Halt;
			end;
	Inc(output_byte_count, tmp);
	ibit := 0;
	seek_table[ist] := output_byte_count - lastpos;
	lastpos := output_byte_count; {d b w} Inc(ist);

		Inc(input_byte_count, (byte_size * buffer_len));
	end; {if fframes}

	// update the seek table
	seek(fdout, sizeof(tta_hdr) + offset);
	if  IOResult <> 0 then begin WriteLn(stderr, 'Seek error'); do_SysCall(3 {Close}, fh); Close(fdout); Exit(true); end;

	seek_table[st_size - 1] := crc32(PByte(@seek_table[0]), (st_size - 1)*4);
	blockwrite( fdout, seek_table[0], st_size*4); // placement of seek_table in file: Ok
	if  IOResult <> 0 then begin WriteLn(stderr, 'Write seek table error'); do_SysCall(3 {Close}, fh); Close(fdout); Exit(true); end;

FreeMem(seek_table);
do_SysCall(11 {Unmap}, a,z);
FreeMem(atta);

          totaltime:=getrealtime-starttime;
          if totaltime<0 then
            totaltime:=totaltime+3600.0*24.0;
          if round(frac(totaltime)*10) >= 10 then
            totaltime:=trunc(totaltime) + 1;
          timestr:=inttostr(trunc(totaltime))+'.'+inttostr(round(frac(totaltime)*10));

	writeln(stderr, 'Encode: complete, wrote ',output_byte_count,' bytes, ratio: ',output_byte_count / (input_byte_count + 1),', time: ' + timestr);
	Exit(false);
end;

end.