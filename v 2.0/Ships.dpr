program Ships;

uses
  Forms,
  Main in 'Main.pas' {FormMain},
  SetShip in 'SetShip.pas' {FormShipPoly},
  Controls;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormShipPoly, FormShipPoly);
  Application.Run;
end.
