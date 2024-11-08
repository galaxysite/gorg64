unit gv;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$RANGECHECKS ON}
{$SMARTLINK ON}
{$ASMMODE INTEL}
{$CODEPAGE UTF8}

interface

uses SysUtils,Unix,BaseUnix;

var
    name, username, exepath : utf8string;
    lockfile : File of Byte;
    lockfilename : utf8string = '/tmp/dr_lockfile-';


implementation


initialization

username := GetEnvironmentVariable('USER');

name := ParamStr(0);
exepath := ExpandFileName(name);
name := ExtractFileName(name);

{
lockfilename := lockfilename + fpGetEnv('USER') + '.lock';
if FileExists(lockfilename) then exit;
Assign(lockfile, lockfilename);
ReWrite(lockfile);
Close(lockfile);

 application.createform(tmainfo,mainfo);
 application.run;
 
DeleteFile(lockfilename);
}

end.