program Ships;

uses
  Forms,
  Main in 'Main.pas' {FormMain},
  Controls,
  LanGame in 'LanGame.pas' {FormLanSet};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormLanSet, FormLanSet);
  Application.Run;
end.
