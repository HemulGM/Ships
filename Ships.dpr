program Ships;

uses
  Forms,
  Main in 'Main.pas' {FormMain},
  Controls;

{$R Ships.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
