unit LanGame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormLanSet = class(TForm)
    GroupBoxCreate: TGroupBox;
    ButtonCreate: TButton;
    GroupBoxConnect: TGroupBox;
    LabelIP: TLabel;
    ButtonClose: TButton;
    EditIP: TEdit;
    LabelPort: TLabel;
    EditPort: TEdit;
    Label1: TLabel;
    EditPortClient: TEdit;
    ButtonConnect: TButton;
    procedure ButtonCreateClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonConnectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLanSet: TFormLanSet;

implementation
 uses Main;

{$R *.dfm}

procedure TFormLanSet.ButtonCreateClick(Sender: TObject);
begin
 FormMain.ActionNewGame.Execute;
 FormMain.ServerSocket.Close;
 FormMain.ServerSocket.Port:=StrToInt(EditPort.Text);
 FormMain.ServerSocket.Open;
 Your:=tyServer;
end;

procedure TFormLanSet.ButtonCloseClick(Sender: TObject);
begin
 Close;
end;

procedure TFormLanSet.ButtonConnectClick(Sender: TObject);
begin
 FormMain.ClientSocket.Close;
 FormMain.ClientSocket.Port:=StrToInt(EditPortClient.Text);
 FormMain.ClientSocket.Host:=EditIP.Text;
 FormMain.ClientSocket.Open;
 Your:=tyClient;
end;

end.
