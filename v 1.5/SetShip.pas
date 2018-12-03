unit SetShip;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls, Main;

type
  TFormShipPoly = class(TForm)
    DrawGridPoly: TDrawGrid;
    ButtonAuto: TButton;
    RadioGroupDir: TRadioGroup;
    LabelHint: TLabel;
    ButtonOk: TButton;
    ButtonReset: TButton;
    ButtonExit: TButton;
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormShipPoly: TFormShipPoly;
  TMP, Sli:TArray;
  AllSet:Boolean;
  OldC, OldR:Integer;


procedure ClearSli;  

implementation

{$R *.dfm}

procedure AClear;
var i,j:Byte;
begin
 for i:=1 to 10 do for j:=1 to 10 do TMP[i,j]:=aEmpty;
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
 Game.SetShips;
 TMP:=Poly;
 AllSet:=True;
 ClearSli;
 DrawGridPoly.Repaint;
end;

procedure TFormShipPoly.DrawGridPolyDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var W,H:Byte;
 DRect:TRect;
begin
 if ((ACol=0) and (ARow=0)) or ((ACol=11) or (ARow=11)) then
  begin
   DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.Empty);
   Exit;
  end;
 if ACol=0 then
  begin
   DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.Empty);
   DrawGridPoly.Canvas.Font.Name:='Segoe UI';
   DrawGridPoly.Canvas.Brush.Style:=bsClear;
   W:=DrawGridPoly.Canvas.TextWidth(IntToStr(ARow));
   H:=DrawGridPoly.Canvas.TextHeight(IntToStr(ARow));
   DrawGridPoly.Canvas.TextOut(Rect.Left+((Rect.Right-Rect.Left) div 2)-(W div 2), Rect.Top+((Rect.Bottom-Rect.Top) div 2)-(H div 2), IntToStr(ARow));
   Exit;
  end;
 if ARow=0 then
  begin
   DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.Empty);
   DrawGridPoly.Canvas.Font.Name:='Segoe UI';
   DrawGridPoly.Canvas.Brush.Style:=bsClear;
   W:=DrawGridPoly.Canvas.TextWidth(RuChars[ACol]);
   H:=DrawGridPoly.Canvas.TextHeight(RuChars[ACol]);
   DrawGridPoly.Canvas.TextOut(Rect.Left+((Rect.Right-Rect.Left) div 2)-(W div 2), Rect.Top+((Rect.Bottom-Rect.Top) div 2)-(H div 2), RuChars[ACol]);
   Exit;
  end;
 case TMP[ACol, ARow] of
  1..4:DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.Ships[TMP[ACol, ARow]]);
 else
  DRect.Left:=0;
  DRect.Top:=0;
  DRect.Right:=24;
  DRect.Bottom:=24;
  Bitmaps.Water.Height:=24;
  Bitmaps.Water.Width:=24;
  Bitmaps.Water.Canvas.CopyRect(DRect, Bitmaps.BackGround.Canvas, Rect);
  DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.Water);
 end;
 case Sli[ACol, ARow] of
  1..4:DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.Ships[Sli[ACol, ARow]]);
 end;
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
 if not CheckFullPoly then
  begin
   DrawGridPoly.MouseToCell(X, Y, ACol, ARow);
   if (ARow = 11) or (ACol = 11) or (ARow = 0) or (ACol = 0) then Exit;
   Ship:=GetCurShip;
   SPos.X:=ACol;
   SPos.Y:=ARow;
   Poly:=TMP;
   case RadioGroupDir.ItemIndex of
    0:if Game.CheckInsert(SPos, tdRight, Ship) then
       begin
        Dec(Game.Ships[Ship]);
        Game.InsertShip(SPos, tdRight, Ship);
        TMP:=Poly;
       end;
    1:if Game.CheckInsert(SPos, tdDown, Ship) then
       begin
        Dec(Game.Ships[Ship]);
        Game.InsertShip(SPos, tdDown, Ship);
        TMP:=Poly;
       end;
   end;
   if CheckFullPoly then
    begin
     Game.EndManualSet;
     AllSet:=True;
    end;
   DrawGridPoly.Repaint;
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
 AClear;
 ClearSli;
end;

procedure TFormShipPoly.DrawGridPolyMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var SPos:TPoint;
 ACol, ARow:Integer;
 Ship:Byte;
begin
 if (not CheckFullPoly) and not AllSet then
  begin
   DrawGridPoly.MouseToCell(X, Y, ACol, ARow);
   if (OldC = ACol) and (OldR = ARow) then Exit;
   OldC:=ACol;
   OldR:=ARow;
   if (ARow = 11) or (ACol = 11) or (ARow = 0) or (ACol = 0) then Exit;
   Ship:=GetCurShip;
   SPos.X:=ACol;
   SPos.Y:=ARow;
   case RadioGroupDir.ItemIndex of
    0:if Game.CheckInsert(SPos, tdRight, Ship) then
       begin
        ClearSli;
        Game.InsertShip(SPos, tdRight, Ship);
        Sli:=Poly;
        Game.ClearPoly;
       end;
    1:if Game.CheckInsert(SPos, tdDown, Ship) then
       begin
        ClearSli;
        Game.InsertShip(SPos, tdDown, Ship);
        Sli:=Poly;
        Game.ClearPoly;
       end;
   end;
   DrawGridPoly.Repaint;
  end;
end;

end.
