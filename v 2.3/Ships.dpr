program Ships;

uses
  Forms,
  Main in 'Main.pas' {FormMain},
  Controls;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
