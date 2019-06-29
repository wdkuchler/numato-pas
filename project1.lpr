program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp
  { you can add units after this };

type

  { TMyApplication }

  TMyApplication = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    device: String;
    command: String;
    fp: THandle;
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure Usage; virtual;
    procedure Wakeup; virtual;
    procedure Activate; virtual;
    procedure Deactivate; virtual;
  end;

{ TMyApplication }

procedure TMyApplication.DoRun;
var
  ErrorMsg: String;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('dc', '');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Usage;
    Terminate;
    Exit;
  end;

  // parse device parameter
  device:=GetOptionValue('d', 'device');

  // parse command parameter
  command:=GetOptionValue('c', 'command');

  fp:= FileCreate(device, fmOpenReadWrite);
  If fp=feInvalidHandle then
    begin
      writeln('Error opening device ' + device);
      Halt(1);
    end;

  writeln('USB Relay Module Controller - USBPOWRL002');

  Wakeup;
  Sleep(50);

  writeln('processing ' + command + '...');
  case lowercase(command) of
    'on':
      begin
       writeln('let''s activate relay');
       Activate;
      end;
    'off':
      begin
       writeln('let''s deactivate relay');
       Deactivate;
      end;
    'pulse':
      begin
        writeln('let''s activate relay');
        Activate;
        Sleep(1000);
        writeln('let''s deactivate relay');
        Deactivate; ;
      end
    else
         WriteLn('Error: invalid command argument ',command);
         Usage;
         FileClose(fp);
         Terminate;
    end;

  FileClose(fp);
  // stop program loop
  Terminate;
end;

constructor TMyApplication.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TMyApplication.Destroy;
begin
  inherited Destroy;
end;

procedure TMyApplication.Usage;
begin
  write('Usage: ');
  writeln(Params[0] + ' -d device -c command');
  writeln('Where:');
  writeln('device name, Ex.: /dev/ttyACM0 or COM1');
  writeln('command, Ex.: "pulse" or "on" and "off"');
end;

procedure TMyApplication.Wakeup;
var
  wake: String= #13;
  i: Longint;
begin
  For i:=0 to wake.Length-1 do
    FileWrite(fp, wake.Chars[i], 1);
  FileFlush(fp);
end;

procedure TMyApplication.Activate;
var
  openIt: String='relay on 0' + #13;
  i: Longint;
begin
  For i:=0 to openIt.Length-1 do
      FileWrite(fp, openIt.Chars[i], 1);
  FileFlush(fp);
end;

procedure TMyApplication.Deactivate;
var
  closeIt: String='relay off 0' + #13;
  i: Longint;
begin
  For i:=0 to closeIt.Length-1 do
      FileWrite(fp, closeIt.Chars[i], 1);
  FileFlush(fp);
end;

var
  Application: TMyApplication;
begin
  Application:=TMyApplication.Create(nil);
  Application.Title:='numato-pas';
  Application.Run;
  Application.Free;
end.


