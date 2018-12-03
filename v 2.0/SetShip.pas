unit SetShip;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls, Main, pngextra;

type
  TFormShipPoly = class(TForm)
    DrawGridPoly: TDrawGrid;
    ButtonAuto: TButton;
    ButtonOk: TButton;
    ButtonReset: TButton;
    ButtonExit: TButton;
    ButtonOk1: TPNGButton;
    ButtonSet: TPNGButton;
    ButtonReset1: TPNGButton;
    ButtonExit1: TPNGButton;
    ButtonHelp: TPNGButton;
    Timer: TTimer;
    procedure ButtonAutoClick(Sender: TObject);
    procedure DrawGridPolyDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure ButtonResetClick(Sender: TObject);
    procedure DrawGridPolyMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ButtonOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DrawGridPolyMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure ButtonExit1Click(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormShipPoly: TFormShipPoly;
  TMP, Sli:TArray;
  TMPDir, SliDir:TArray;
  AllSet:Boolean;
  OldC, OldR:Integer;
  CurDir, OldDir:Boolean;
  BMP:TBitmap;


procedure ClearSli;  

implementation

{$R *.dfm}

procedure RefreshShips;
var i,j:Byte;
begin
 for i:=1 to 10 do
  for j:=1 to 10 do
   begin
    SliDir[i,j]:=Game.GetInfo(i, j, Sli, SliDir);
   end;
end;

procedure UpdateShips;
var i,j:Byte;
begin
 for i:=1 to 10 do
  for j:=1 to 10 do
   begin
    if TMPDir[i,j] = 0 then TMPDir[i,j]:=Game.GetInfo(i, j, TMP, TMPDir);
   end;
end;

procedure AClear;
var i,j:Byte;
begin
 for i:=1 to 10 do
  for j:=1 to 10 do
   begin
    TMP[i,j]:=aEmpty;
    TMPDir[i,j]:=0;
   end;
 Game.ClearPoly;
 Game.Ships[1]:=4;
 Game.Ships[2]:=3;
 Game.Ships[3]:=2;
 Game.Ships[4]:=1;
 AllSet:=False;
 FormShipPoly.DrawGridPoly.Repaint;
end;

procedure TFormShipPoly.ButtonAutoClick(Sender: TObject);
begin
 AClear;
 Game.SetShips;
 TMP:=Poly;
 RefreshShips;
 UpdateShips;
 AllSet:=True;
 ClearSli;
 DrawGridPoly.Repaint;
end;

procedure TFormShipPoly.DrawGridPolyDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var W,H:Byte;

function GetCurRect:TRect;
begin
 Result.Left:=DrawGridPoly.Left+Rect.Left;
 Result.Top:=DrawGridPoly.Top+Rect.Top;
 Result.Right:=Result.Left+24;
 Result.Bottom:=Result.Top+24;
end;

begin
 if ((ACol=0) and (ARow=0)) or ((ACol=11) and (ARow=11)) or ((ACol=11) and (ARow=0)) or ((ACol=0) and (ARow=11)) then
  begin
   BMP.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.BackGround.Canvas, GetCurRect);
   DrawGridPoly.Canvas.StretchDraw(Rect, BMP);
   Exit;
  end;
 if (ACol=0) or (ACol=11) then
  begin
   BMP.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.BackGround.Canvas, GetCurRect);
   BMP.Canvas.Font.Name:='Segoe UI';
   BMP.Canvas.Brush.Style:=bsClear;
   W:=BMP.Canvas.TextWidth(IntToStr(ARow));
   H:=BMP.Canvas.TextHeight(IntToStr(ARow));
   BMP.Canvas.TextOut(12-(W div 2), 12 -(H div 2), IntToStr(ARow));
   DrawGridPoly.Canvas.StretchDraw(Rect, BMP);
   Exit;
  end;
 if (ARow=0) or (ARow=11) then
  begin
   BMP.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.BackGround.Canvas, GetCurRect);
   BMP.Canvas.Font.Name:='Segoe UI';
   BMP.Canvas.Brush.Style:=bsClear;
   W:=BMP.Canvas.TextWidth(RuChars[ACol]);
   H:=BMP.Canvas.TextHeight(RuChars[ACol]);
   BMP.Canvas.TextOut(12 -(W div 2), 12 -(H div 2), RuChars[ACol]);
   DrawGridPoly.Canvas.StretchDraw(Rect, BMP);
   Exit;
  end;

 BMP.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.BackGround.Canvas, GetCurRect);
 case TMP[ACol, ARow] of
  1..4:BMP.Canvas.Draw(0, 0, Bitmaps.ShipsPics[TMPDir[ACol, ARow]]);
  //DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.Ships[TMP[ACol, ARow]]);
 end;
 case Sli[ACol, ARow] of
  1..4:BMP.Canvas.Draw(0, 0, Bitmaps.Ships[Sli[ACol, ARow]]);
 end;
 DrawGridPoly.Canvas.StretchDraw(Rect, BMP);
end;

procedure TFormShipPoly.ButtonResetClick(Sender: TObject);
begin
 AClear;
 ClearSli;
end;

procedure TFormShipPoly.DrawGridPolyMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var SPos:TPoint;
 ACol, ARow:Integer;
 Ship:Byte;
begin
 if Button = mbLeft then
  begin
   if not Game.CheckFullPoly then
    begin
     DrawGridPoly.MouseToCell(X, Y, ACol, ARow);
     if (ARow = 11) or (ACol = 11) or (ARow = 0) or (ACol = 0) then Exit;
     Ship:=Game.GetCurShip;
     SPos.X:=ACol;
     SPos.Y:=ARow;
     Poly:=TMP;
     ClearSli;
     case CurDir of
      True:if Game.CheckInsert(SPos, tdRight, Ship) then
         begin
          Dec(Game.Ships[Ship]);
          Game.InsertShip(SPos, tdRight, Ship);
          TMP:=Poly;
          UpdateShips;
         end;
      False:if Game.CheckInsert(SPos, tdDown, Ship) then
         begin
          Dec(Game.Ships[Ship]);
          Game.InsertShip(SPos, tdDown, Ship);
          TMP:=Poly;
          UpdateShips;
         end;
     end;
     if Game.CheckFullPoly then AllSet:=True;
     DrawGridPoly.Repaint;
    end;
  end;
 if Button = mbRight then
  begin
   CurDir:=not CurDir;
   ClearSli;
   DrawGridPoly.OnMouseMove(Sender, Shift, X, Y);
   DrawGridPoly.Repaint;
   RefreshShips;
  end;
end;

procedure TFormShipPoly.ButtonOkClick(Sender: TObject);
begin
 if not AllSet then
  begin
   ModalResult:=mrNone;
   MessageBox(Handle, 'Расставьте все корабли!', '', MB_ICONWARNING or MB_OK);
  end
 else ModalResult:=mrOk;
end;

procedure ClearSli;
var i,j:Byte;
begin
 for i:=1 to 10 do for j:=1 to 10 do Sli[i,j]:=aEmpty;
end;

procedure TFormShipPoly.FormShow(Sender: TObject);
begin
 CurDir:=True;
 AClear;
 ClearSli;
end;

procedure TFormShipPoly.DrawGridPolyMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var SPos:TPoint;
 ACol, ARow:Integer;
 Ship:Byte;
begin
 if (not Game.CheckFullPoly) and not AllSet then
  begin
   if DrawGridPoly.Cursor <> 2 then DrawGridPoly.Cursor:=2;
   DrawGridPoly.MouseToCell(X, Y, ACol, ARow);
   if (OldC = ACol) and (OldR = ARow) and (CurDir = OldDir) then Exit;
   OldDir:=CurDir;
   OldC:=ACol;
   OldR:=ARow;
   if (ARow = 11) or (ACol = 11) or (ARow = 0) or (ACol = 0) then Exit;
   Ship:=Game.GetCurShip;
   SPos.X:=ACol;
   SPos.Y:=ARow;
   ClearSli;
   case CurDir of
    True:if Game.CheckInsert(SPos, tdRight, Ship) then
       begin
        ClearSli;
        Game.ClearPoly;
        Game.InsertShip(SPos, tdRight, Ship);
        Sli:=Poly;
        Game.ClearPoly;
        RefreshShips;
       end;
    False:if Game.CheckInsert(SPos, tdDown, Ship) then
       begin
        ClearSli;
        Game.ClearPoly;
        Game.InsertShip(SPos, tdDown, Ship);
        Sli:=Poly;
        Game.ClearPoly;
        RefreshShips;
       end;
   end;
   RefreshShips;
   DrawGridPoly.Repaint;
  end
 else
  if DrawGridPoly.Cursor = crDefault then Exit
  else DrawGridPoly.Cursor:=crDefault;
end;

procedure TFormShipPoly.FormCreate(Sender: TObject);
begin
 ClientHeight:=360;
 ClientWidth:=299;
 ButtonAuto.Height:=45;
 ButtonAuto.Width:=65;
 ButtonOk.Height:=45;
 ButtonOk.Width:=65;
 ButtonReset.Height:=45;
 ButtonReset.Width:=65;
 ButtonExit.Height:=45;
 ButtonExit.Width:=65;
 DrawGridPoly.Height:=299;
 DrawGridPoly.Width:=299;
 FormShipPoly.Brush.Bitmap:=Bitmaps.BackGround;
 BMP:=TBitmap.Create;
 BMP.Height:=24;
 BMP.Width:=24;
end;

procedure TFormShipPoly.ButtonExit1Click(Sender: TObject);
begin
 ModalResult:=mrCancel;
end;

procedure TFormShipPoly.TimerTimer(Sender: TObject);
begin
 ButtonOk1.Enabled:=AllSet;
end;

end.
