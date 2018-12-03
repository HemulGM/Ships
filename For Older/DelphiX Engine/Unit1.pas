unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DXInput, DXDraws, DXClass, DXSprite;

type
  TFormDraw = class(TDXForm)
    DXDraw: TDXDraw;
    DXSpriteEngine: TDXSpriteEngine;
    DXTimer: TDXTimer;
    DXImageList: TDXImageList;
    DXInput: TDXInput;
    procedure DXTimerActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDraw: TFormDraw;

implementation

{$R *.dfm}

type
  TGrid = class(TImageSprite)       //����� �����
  end;

  TShip = class(TImageSprite)       // ����� �������
  public
   //constructor Create(AParent: TSprite); override; //��� ��������
   //destructor Destroy; override;                   //��� ������
  end;

{constructor TShip.Create(AParent:TSprite);
begin
 //dasd
 inherited;
end;

destructor TShip.Destroy;
begin
 inherited Destroy;
end; }

procedure TFormDraw.DXTimerActivate(Sender: TObject);
begin
 if not DXDraw.CanDraw then exit; // ���� ��� DirectX �������
 DXInput.Update;
 DXSpriteEngine.Move(0);
 DXSpriteEngine.Dead;
 DXDraw.Surface.Fill(0);
 DXSpriteEngine.Draw;
 DXDraw.Flip;
end;

procedure TFormDraw.FormCreate(Sender: TObject);
begin
 with TGrid.Create(DXSpriteEngine.Engine) do
  begin
   PixelCheck:=True;            // ��� ������������ ������������ ������ �����
   Image:= FormDraw.DXImageList.Items.Find('GRID'); //���� ������ � ImageList`�
   x:=20; // x ����������
   y:=10;  // y ����������
   Width:=Image.Width;          //������ ����� ������ �������
   Height:=Image.Height;        //������ ����� ������ �������
  end;
 with TGrid.Create(DXSpriteEngine.Engine) do
  begin
   PixelCheck:=True;
   Image:= FormDraw.DXImageList.Items.Find('GRID');
   x:=10+350;
   y:=10;
   Width:=Image.Width;
   Height:=Image.Height;
  end;
 with TShip.Create(DXSpriteEngine.Engine) do
  begin
   //PixelCheck:=True;
   Image:=DXImageList.Items.Find('4');
   x:=20;
   y:=10;
   Width:=Image.Width;
   Height:=Image.Height;
  end;
 with TShip.Create(DXSpriteEngine.Engine) do
  begin
   //PixelCheck:=True;
   Image:=DXImageList.Items.Find('KILL');
   x:=50;
   y:=40;
   Width:=Image.Width;
   Height:=Image.Height;
  end;
end;

procedure TFormDraw.DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 with TShip.Create(DXSpriteEngine.Engine) do
  begin
   //PixelCheck:=True;
   Image:=DXImageList.Items.Find('3');
   x:=20;
   y:=10;
   Width:=Image.Width;
   Height:=Image.Height;
  end;
end;

end.
