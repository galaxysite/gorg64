unit ttaconst;

{
    Pascal port of ttacodec (http://tta.sourceforge.net)
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

const
	MAX_BPS = 16;    
	FRAME_TIME = 1.04489795918367346939;    
	TTA1_SIGN = $31415454;    
	RIFF_SIGN = $46464952;    
	WAVE_SIGN = $45564157;    
	fmt_SIGN = $20746D66;    
	data_SIGN = $61746164;    
	MAX_ORDER = 16;    
	BIT_BUFFER_SIZE = 1024*1024;    
	WAVE_FORMAT_PCM = 1;    
	WAVE_FORMAT_EXTENSIBLE = $FFFE;    
	o = 8;

implementation


end.