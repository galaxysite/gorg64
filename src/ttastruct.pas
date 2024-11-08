unit ttastruct;

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

interface

uses ttaconst;

type
Tadapt = packed record
	k0 : dword;
	k1 : dword;
	sum0 : dword;
	sum1 : dword;
end;
padapt = ^tadapt;

Tfltst = packed record
error,
qm0, qm1, qm2,qm3,qm4,qm5,qm6,qm7,qm8, // 8 в целях ускорения, без них медленнее
dx0, dx1, dx2, dx3, dx4, dx5, dx6, dx7,dx8,
dl0, dl1, dl2, dl3, dl4, dl5, dl6, dl7: longint;
end;
pfltst = ^tfltst;

Tencoder = packed record
	fst : Tfltst;
	rice : Tadapt;
	last : longint;
end;
pencoder = ^tencoder;

Ttta_hdr = packed record
	TTAid : dword;
	AudioFormat : word;
	NumChannels : word;
	BitsPerSample : word;
	SampleRate : dword;
	DataLength : dword;
	CRC32 : dword;
end;

Twave_hdr = packed record
	ChunkID : dword;
	ChunkSize : dword;
	Format : dword;
	Subchunk1ID : dword;
	Subchunk1Size : dword;
	AudioFormat : word;
	NumChannels : word;
	SampleRate : dword;
	ByteRate : dword;
	BlockAlign : word;
	BitsPerSample : word;
end;
pwave_hdr = ^twave_hdr;

Tsubchunk_hdr = packed record
	SubchunkID : dword;
	SubchunkSize : dword;
end;
psubchunk_hdr = ^Tsubchunk_hdr;

implementation

end.