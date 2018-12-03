unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, XPMan, ExtCtrls, pngimage, pngextra, PanelExt,
  Buttons;

type
  TFormMain = class(TForm)
    DrawGridPoly: TDrawGrid;
    DrawGridComp: TDrawGrid;
    XPManifest1: TXPManifest;
    ListBoxPos: TListBox;
    TimerSpeak: TTimer;
    ButtonClose: TPNGButton;
    ButtonHide: TPNGButton;
    ButtonNew: TPNGButton;
    LabelAutor: TLabel;
    EditInput: TEdit;
    ButtonHelp: TPNGButton;
    ListBoxHelp: TListBox;
    PanelResult: TPanelExt;
    LabelLoses: TLabel;
    LabelLosesV: TLabel;
    LabelWins: TLabel;
    LabelWinsV: TLabel;
    ButtonCloseP: TPNGButton;
    ButtonNewP: TPNGButton;
    TimerGo: TTimer;
    PanelHelp: TPanelExt;
    procedure DrawGridPolyDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure DrawGridCompDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure DrawGridCompMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure ListBoxPosDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonHideClick(Sender: TObject);
    procedure ButtonCloseMouseEnter(Sender: TObject);
    procedure ButtonCloseMouseExit(Sender: TObject);
    procedure ButtonNewClick(Sender: TObject);
    procedure EditInputKeyPress(Sender: TObject; var Key: Char);
    procedure TimerSpeakTimer(Sender: TObject);
    procedure ButtonHelpClick(Sender: TObject);
    procedure TimerGoTimer(Sender: TObject);
    procedure PanelHelpPaint(Sender: TObject);
    procedure PanelResultPaint(Sender: TObject);
  private
   procedure WMNCHitTest(var M: TWMNCHitTest); message wm_NCHitTest;
  protected
   procedure CreateParams(var Params: TCreateParams); override;
  public
  end;
  TLastShoots = record
   ShipSize:Byte;
   Shoots:array[1..4] of TPoint;
   Use:Boolean;
  end;
  TKillArray = array[1..10, 1..10] of Byte;
  TArray = array[1..10, 1..10] of Byte;
  TDirection = (tdLeft, tdRight, tdUp, tdDown);
  TShips = array[1..4] of Byte;
  TStatus = (tsManualSet, tsPlay, tsWait, tsEnd);
  TLead = (tlPlayer, tlComp);
  TGame = class
   IsEnd:Boolean;
   MSet:Boolean;
   Ships:TShips;
   Status:TStatus;
   Lead:TLead;
   CompLastShoot:TPoint;
   LastDir:TDirection;
   UseLastDir:Boolean;
   IsNS:Boolean;
   IsNextShoot:Boolean;
   CompUsedDir:set of TDirection;
   LastShoots:TLastShoots;
   procedure New;
   procedure WriteIt(Text:string);
   procedure ClearList;
   procedure DoCompShoot;
   procedure BeginManualSet;
   procedure EndManualSet;
   procedure ClearPoly;
   procedure SetShips;
   procedure ClearAll;
   function CheckCell(SPos:TPoint):Boolean;
   function GetPos(SPos:TPoint):Byte;
   function CheckPos(SPos:TPoint; var Direction:TDirection; ShipSize:Byte):Boolean;
   function CheckInsert(SPos:TPoint; Direction:TDirection; ShipSize:Byte):Boolean;
   function InsertCheck(SPos:TPoint):Boolean;
   procedure InsertShip(SPos:TPoint; Direction:TDirection; ShipSize:Byte);
  end;
  TBitmaps = class                                                              //Текстуры
   public
    ResultPanel:TBitmap;                                                        //Панель результата
    Empty:TBitmap;                                                              //Пустая клетка
    BackGround:TBitmap;                                                         //Вода
    FormBrush:TBitmap;                                                          //Оболочка
    Past:TPNGObject;                                                            //Мимо
    Wou:TPNGObject;                                                             //Ранил
    Kill:TPNGObject;                                                            //Убил
    UPast:TPNGObject;                                                           //Здесь нет корабля
    Water:TBitmap;                                                              //Временное изображение клетки
    ListItem:TBitmap;                                                           //Временное изображение элемента списка
    Ships:array[1..4] of TPNGObject;                                               //Корабли
    Results:array[0..3] of TPNGObject;                                          //
    ShipsV2:array[0..6] of TPNGObject;
    //(tdUp, tdLeft, tdDown, tdRight, tdMediumLeft, tdMediumUp, tdOne);
    constructor Create;
  end;



const
  aEmpty = 22;
  aKill  = 33;
  aBusy  = 44;
  aWound = 55;
  aPast  = 66;
  aUser  = 77;

var
  FormMain: TFormMain;
  Player:TArray;
  Comp:TArray;
  CompKill:TKillArray;
  PlayerKill:TKillArray;
  Poly:TArray;      //Основное поле, через которое изменяются другие
  Game:TGame;
  Need:Boolean;     //Перетаскивание возможно
  Bitmaps:TBitmaps;
  Path:String;
  RuChars:array[1..10] of Char = ('А','Б','В','Г','Д','Е','Ж','З','И','К');
  DeForm:Boolean;
  IsMax:Boolean;
  MPos:TPoint;
  Answer:string;
  Wins, Loses:Word;
  SleepTime:Word;
  CompName, PlayerName:string;
  Score:Byte;


  function GetShipPos(SPos:TPoint; var Direction:TDirection; var StartPos:TPoint; Poly:TArray):Boolean;
  function CheckFullPoly:Boolean;
  function GetCurShip:Byte;
  function CheckPlayer:Boolean;
  function CheckComp:Boolean;
  procedure InsertPastForUser(Ship:TPoint);
  procedure Waiting;

implementation
 uses SetShip;

{$R *.dfm}

procedure SetStatus;
begin
 with FormMain do
  begin
   LabelLosesV.Caption:=IntToStr(Loses);
   LabelWinsV.Caption:=IntToStr(Wins);
  end;
end;

procedure OnCompWin;
begin
 with FormMain do
  begin
   Score:=0;
   //ImageResult.Picture.Assign(Bitmaps.Lose);
   PanelResult.Show;
   Inc(Loses);
  end;
 SetStatus;
end;

function GetScore:Byte;
var i,j:Byte;
 Pasts:Byte;
 Kills:Byte;
begin
 Pasts:=0;
 Kills:=0;
 for i:=1 to 10 do
  for j:=1 to 10 do //Poly[i,j]:=Random(5)
   begin
    if CompKill[i,j] = aPast then Inc(Pasts);
    if CompKill[i,j] = aKill then Inc(Kills);
   end;
 case Kills - Pasts of
  -40..-20:Result:=1;
  -19..-10:Result:=2;
  -9 .. 20:Result:=3;
 else
  Result:=0;
 end;
end;

procedure OnPlayerWin;
begin
 with FormMain do
  begin
   Score:=GetScore;
   //ImageResult.Picture.Assign(Bitmaps.Win);
   PanelResult.Show;
   //ShowMessage(IntToStr(GetScore));
   Inc(Wins);
  end;
 SetStatus;
end;

procedure TFormMain.CreateParams(var Params: TCreateParams);
const CS_DROPSHADOW = $00020000;
begin
 inherited;
 Params.WindowClass.Style:=Params.WindowClass.Style or CS_DROPSHADOW;
end;

procedure TGame.WriteIt(Text:string);
begin
 if FormMain.ListBoxPos.Count = 26 then
  FormMain.ListBoxPos.Items.Delete(0);
 FormMain.ListBoxPos.Items.Add(Text);
end;

procedure TGame.ClearList;
begin
 FormMain.ListBoxPos.Clear;
end;

procedure GetRandomCompName;
begin
 Randomize;
 case Random(6) of
  0:CompName:='Вася';
  1:CompName:='Курт';
  2:CompName:='Марк';
  3:CompName:='Хан';
  4:CompName:='Хантер';
  5:CompName:='Дед';
  6:CompName:='Горн';
 end;
end;

procedure TGame.New;
begin
 Randomize;
 SetShips;
 Comp:=Poly;
 CompLastShoot:=Point(0,0);
 Lead:=tlPlayer;
 Status:=tsPlay;
 GetRandomCompName;
 FormMain.TimerGo.Enabled:=True;
end;

constructor TBitmaps.Create;
begin
 ResultPanel:=TBitmap.Create;
 Empty:=TBitmap.Create;
 BackGround:=TBitmap.Create;
 FormBrush:=TBitmap.Create;
 Past:=TPNGObject.Create;
 UPast:=TPNGObject.Create;
 Wou:=TPNGObject.Create;
 Kill:=TPNGObject.Create;
 Ships[1]:=TPNGObject.Create;
 Ships[2]:=TPNGObject.Create;
 Ships[3]:=TPNGObject.Create;
 Ships[4]:=TPNGObject.Create;
 Water:=TBitmap.Create;
 ListItem:=TBitmap.Create;
 Results[0]:=TPNGObject.Create;
 Results[1]:=TPNGObject.Create;
 Results[2]:=TPNGObject.Create;
 Results[3]:=TPNGObject.Create;
 ShipsV2[0]:=TPNGObject.Create;
 ShipsV2[1]:=TPNGObject.Create;
 ShipsV2[2]:=TPNGObject.Create;
 ShipsV2[3]:=TPNGObject.Create;
 ShipsV2[4]:=TPNGObject.Create;
 ShipsV2[5]:=TPNGObject.Create;
 ShipsV2[6]:=TPNGObject.Create;

 inherited;
end;

procedure TFormMain.WMNCHitTest (var M:TWMNCHitTest);
begin
 inherited;
 if (M.Result = htClient) and Need then M.Result := htCaption;
end;

function LoadSkinFromDll(DllName:string):Boolean;
var DLL:Cardinal;
begin
 Dll:=LoadLibrary(PChar(Dllname));
 if DLL=0 then
  begin
   Result:=False;
   Exit;
  end;
 with Bitmaps do
  try
   ResultPanel.LoadFromResourceName(DLL, 'panel');
   Empty.LoadFromResourceName(DLL, 'Empty');
   BackGround.LoadFromResourceName(DLL, 'bg');
   FormBrush.LoadFromResourceName(DLL, 'brush');
   Past.LoadFromResourceName(DLL, 'past');
   UPast.LoadFromResourceName(DLL, 'upast');
   Wou.LoadFromResourceName(DLL, 'wou');
   Kill.LoadFromResourceName(DLL, 'kill');
   Ships[1].LoadFromResourceName(DLL, 'Sh1');
   Ships[2].LoadFromResourceName(DLL, 'Sh2');
   Ships[3].LoadFromResourceName(DLL, 'Sh3');
   Ships[4].LoadFromResourceName(DLL, 'Sh4');
   Results[0].LoadFromResourceName(DLL, 'M0');
   Results[1].LoadFromResourceName(DLL, 'M1');
   Results[2].LoadFromResourceName(DLL, 'M2');
   Results[3].LoadFromResourceName(DLL, 'M3');

   ShipsV2[0].LoadFromResourceName(DLL, 'UP');
   ShipsV2[1].LoadFromResourceName(DLL, 'LEFT');
   ShipsV2[2].LoadFromResourceName(DLL, 'DOWN');
   ShipsV2[3].LoadFromResourceName(DLL, 'RIGHT');
   ShipsV2[4].LoadFromResourceName(DLL, 'MLEFT');
   ShipsV2[5].LoadFromResourceName(DLL, 'MUP');
   ShipsV2[6].LoadFromResourceName(DLL, 'ONE');

   ////(tdUp, tdLeft, tdDown, tdRight, tdMediumLeft, tdMediumUp, tdOne);
   with FormMain do
    begin
     ButtonClose.ImageNormal.LoadFromResourceName(DLL, 'close');
     ButtonHide.ImageNormal.LoadFromResourceName(DLL,  'hide');
     ButtonNew.ImageNormal.LoadFromResourceName(DLL,   'new');
     ButtonHelp.ImageNormal.LoadFromResourceName(DLL,  'user');
     Screen.Cursors[1]:=LoadCursor(DLL, 'SHOOT');
     DrawGridComp.Cursor:=1;
     DrawGridPoly.Repaint;
    end;
   FreeLibrary(DLL);
  except
   begin
    MessageBox(FormMain.Handle, 'Отсутствуют необходимые текстуры!'+#13+#10+'Программа будет закрыта.', '', MB_ICONSTOP or MB_OK);
    FreeLibrary(Dll);
    Application.Terminate;
   end;
  end;
 Result:=True;
end;

function TGame.CheckCell(SPos:TPoint):Boolean;
begin
 Result:= (SPos.X >= 1) and (SPos.X <= 10) and (SPos.Y >= 1) and (SPos.Y <= 10);
end;

function TGame.GetPos(SPos:TPoint):Byte;
begin
 Result:=Poly[SPos.X, SPos.Y];
end;

function TGame.CheckPos(SPos:TPoint; var Direction:TDirection; ShipSize:Byte):Boolean;
var FirstDir:Byte;
 i,j:Smallint;
 Used:set of TDirection;
 IsBreak:Boolean;
 DPos:TPoint;
begin
 Result:=False;
 if Poly[SPos.X, SPos.Y]<>aEmpty then Exit;
 Used:=[];
 Randomize;
 repeat
  repeat
   FirstDir:=Random(4);
  until (not (TDirection(FirstDir) in Used)) or (Used = [tdLeft, tdRight, tdUp, tdDown]);
  IsBreak:=False;
  case TDirection(FirstDir) of
   tdLeft:begin
           if SPos.X<ShipSize then
            begin
             Include(Used, tdLeft);
             Continue;
            end;
           for j:=-1 to 1 do
            begin
             for i:=-1 to ShipSize do
              begin
               DPos:=Point(SPos.X-i, SPos.Y+j);
               if (CheckCell(DPos)) then
                if (not (GetPos(DPos)=aEmpty)) then
                 if (not (GetPos(DPos)=aBusy)) then
                  begin
                   Include(Used, tdLeft);
                   IsBreak:=True;
                   Break;
                  end;
              end;
             if IsBreak then Break;
            end;
           if IsBreak then Continue;
           Result:=True;
           Direction:=tdLeft;
           Exit;
          end;
  tdRight:begin
           if (10 - SPos.X)<ShipSize then
            begin
             Include(Used, tdRight);
             Continue;
            end;
           for j:=-1 to 1 do
            begin
             for i:=-1 to ShipSize do
              begin
               DPos:=Point(SPos.X+i, SPos.Y+j);
               if (CheckCell(DPos)) then
                if (not (GetPos(DPos)=aEmpty)) then
                 if (not (GetPos(DPos)=aBusy)) then
                  begin
                   Include(Used, tdRight);
                   IsBreak:=True;
                   Break;
                  end;
              end;
             if IsBreak then Break;
            end;
           if IsBreak then Continue;
           Result:=True;
           Direction:=tdRight;
           Exit;
          end;
   tdUp:  begin
           if SPos.Y<ShipSize then
            begin
             Include(Used, tdUp);
             Continue;
            end;
           for j:=-1 to 1 do
            begin
             for i:=-1 to ShipSize do
              begin
               DPos:=Point(SPos.X+j, SPos.Y-i);
               if (CheckCell(DPos)) then
                if (not (GetPos(DPos)=aEmpty)) then
                 if (not (GetPos(DPos)=aBusy)) then
                  begin
                   Include(Used, tdUp);
                   IsBreak:=True;
                   Break;
                  end;
              end;
             if IsBreak then Break;
            end;
           if IsBreak then Continue;;
           Result:=True;
           Direction:=tdUp;
           Exit;
          end;
   tdDown:begin
           if (10 - SPos.Y)<ShipSize then
            begin
             Include(Used, tdDown);
             Continue;
            end;
           for j:=-1 to 1 do
            begin
             for i:=-1 to ShipSize do
              begin
               DPos:=Point(SPos.X+j, SPos.Y+i);
               if (CheckCell(DPos)) then
                if (not (GetPos(DPos)=aEmpty)) then
                 if (not (GetPos(DPos)=aBusy)) then
                  begin
                   Include(Used, tdDown);
                   IsBreak:=True;
                   Break;
                  end;
              end;
             if IsBreak then Break;
            end;
           if IsBreak then Continue;
           Result:=True;
           Direction:=tdDown;
           Exit;
          end;
  end;
 until Used = [tdLeft, tdRight, tdUp, tdDown];
end;

function TGame.CheckInsert(SPos:TPoint; Direction:TDirection; ShipSize:Byte):Boolean;
var  i,j:Smallint;
     DPos:TPoint;
begin
 Result:=False;
 if Poly[SPos.X, SPos.Y]<>aEmpty then Exit;
 case Direction of
  tdLeft:begin
          if SPos.X<ShipSize then Exit;
          for j:=-1 to 1 do
           begin
            for i:=-1 to ShipSize do
             begin
              DPos:=Point(SPos.X-i, SPos.Y+j);
              if (CheckCell(DPos)) then
               if (not (GetPos(DPos)=aEmpty)) then
                if (not (GetPos(DPos)=aBusy)) then Exit;
             end;
           end;
          Result:=True;
          Exit;
         end;
 tdRight:begin
          if (10 - SPos.X)+1<ShipSize then Exit;
          for j:=-1 to 1 do
           begin
            for i:=-1 to ShipSize do
             begin
              DPos:=Point(SPos.X+i, SPos.Y+j);
              if (CheckCell(DPos)) then
               if (not (GetPos(DPos)=aEmpty)) then
                if (not (GetPos(DPos)=aBusy)) then Exit;
             end;
           end;
          Result:=True;
          Exit;
         end;
   tdUp: begin
          if SPos.Y<ShipSize then Exit;
          for j:=-1 to 1 do
           begin
            for i:=-1 to ShipSize do
             begin
              DPos:=Point(SPos.X+j, SPos.Y-i);
              if (CheckCell(DPos)) then
               if (not (GetPos(DPos)=aEmpty)) then
                if (not (GetPos(DPos)=aBusy)) then Exit;
             end;
           end;
          Result:=True;
          Exit;
         end;
  tdDown:begin
          if (10 - SPos.Y)+1<ShipSize then Exit;
          for j:=-1 to 1 do
           begin
            for i:=-1 to ShipSize do
             begin
              DPos:=Point(SPos.X+j, SPos.Y+i);
              if (CheckCell(DPos)) then
               if (not (GetPos(DPos)=aEmpty)) then
                if (not (GetPos(DPos)=aBusy)) then Exit;
             end;
           end;
          Result:=True;
          Exit;
         end;
 end;
end;

function TGame.InsertCheck(SPos:TPoint):Boolean;
begin
 Result:=CheckCell(SPos) and (Poly[SPos.X, SPos.Y]=aEmpty);
end;

procedure TGame.InsertShip(SPos:TPoint; Direction:TDirection; ShipSize:Byte);
var i:SmallInt;
begin
 case Direction of
  tdLeft:begin
          for i:= -1 to ShipSize   do if InsertCheck(Point(SPos.X-i, SPos.Y-1)) then Poly[SPos.X-i, SPos.Y-1]:=aBusy;
          for i:=  0 to ShipSize-1 do Poly[SPos.X-i, SPos.Y ]:=ShipSize;
          for i:= -1 to ShipSize   do if InsertCheck(Point(SPos.X-i, SPos.Y+1)) then Poly[SPos.X-i, SPos.Y+1]:=aBusy;
          if InsertCheck(Point(SPos.X+1, SPos.Y)) then Poly[SPos.X+1, SPos.Y]:=aBusy;
          if InsertCheck(Point(SPos.X-ShipSize, SPos.Y)) then Poly[SPos.X-ShipSize, SPos.Y]:=aBusy;
          Exit;
         end;
 tdRight:begin
          for i:= -1 to ShipSize   do if InsertCheck(Point(SPos.X+i, SPos.Y-1)) then Poly[SPos.X+i, SPos.Y-1]:=aBusy;
          for i:=  0 to ShipSize-1 do Poly[SPos.X+i, SPos.Y ]:=ShipSize;
          for i:= -1 to ShipSize   do if InsertCheck(Point(SPos.X+i, SPos.Y+1)) then Poly[SPos.X+i, SPos.Y+1]:=aBusy;
          if InsertCheck(Point(SPos.X-1, SPos.Y)) then Poly[SPos.X-1, SPos.Y]:=aBusy;
          if InsertCheck(Point(SPos.X+ShipSize, SPos.Y)) then Poly[SPos.X+ShipSize, SPos.Y]:=aBusy;
          Exit;
         end;
  tdUp:  begin
          for i:= -1 to ShipSize   do if InsertCheck(Point(SPos.X-1, SPos.Y-i)) then Poly[SPos.X-1, SPos.Y-i]:=aBusy;
          for i:=  0 to ShipSize-1 do Poly[SPos.X , SPos.Y-i]:=ShipSize;
          for i:= -1 to ShipSize   do if InsertCheck(Point(SPos.X+1, SPos.Y-i)) then Poly[SPos.X+1, SPos.Y-i]:=aBusy;
          if InsertCheck(Point(SPos.X, SPos.Y+1)) then Poly[SPos.X, SPos.Y+1]:=aBusy;
          if InsertCheck(Point(SPos.X, SPos.Y-ShipSize)) then Poly[SPos.X, SPos.Y-ShipSize]:=aBusy;
          Exit;
         end;
  tdDown:begin
          for i:= -1 to ShipSize   do if InsertCheck(Point(SPos.X-1, SPos.Y+i)) then Poly[SPos.X-1, SPos.Y+i]:=aBusy;
          for i:=  0 to ShipSize-1 do Poly[SPos.X , SPos.Y+i]:=ShipSize;
          for i:= -1 to ShipSize   do if InsertCheck(Point(SPos.X+1, SPos.Y+i)) then Poly[SPos.X+1, SPos.Y+i]:=aBusy;
          if InsertCheck(Point(SPos.X, SPos.Y-1)) then Poly[SPos.X, SPos.Y-1]:=aBusy;
          if InsertCheck(Point(SPos.X, SPos.Y+ShipSize)) then Poly[SPos.X, SPos.Y+ShipSize]:=aBusy;
          Exit;
         end;
 end;
end;

procedure TGame.SetShips;
var i:Byte;
 SPos:TPoint;
 ShipSize:Byte;
 Direction:TDirection;
 Insert:Boolean;
 OutExcept:Cardinal;
begin
 ClearPoly;
 for ShipSize:=4 downto 1 do
  for i:=1 to 5-ShipSize do
   begin
    OutExcept:=0;
    repeat
     Randomize;
     SPos.X:=Random(10)+1;
     SPos.Y:=Random(10)+1;
     if CheckPos(SPos, Direction, ShipSize) then
      begin
       Insert:=True;
       InsertShip(SPos, Direction, ShipSize);
      end
     else Insert:=False;
     Inc(OutExcept);
    until Insert or (OutExcept=300000);
   end;
end;

procedure TGame.ClearPoly;
var i,j:Byte;
begin
 for i:=1 to 10 do for j:=1 to 10 do Poly[i,j]:=aEmpty;
end;

procedure TGame.ClearAll;
var i,j:Byte;
begin
 for i:=1 to 10 do
  for j:=1 to 10 do
   begin
    Poly[i,j]:=aEmpty;
    CompKill[i,j]:=aEmpty;
    PlayerKill[i,j]:=aEmpty;
   end;
 Player:=Poly;
 Comp:=Poly;
 FormMain.PanelResult.Hide;
 FormMain.ListBoxPos.Clear;
 IsNextShoot:=False;
end;

procedure TFormMain.DrawGridPolyDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
type
  TSDir  = (tdUp, tdLeft, tdDown, tdRight, tdMediumLeft, tdMediumUp, tdOne);

var W, H:Byte;
 DRect:TRect;

function GetInfo:TSDir;
begin                 //X, Y
 if Player[ACol, ARow] = 1 then
  begin
   Result:=tdOne;
   Exit;
  end;
 if Player[ACol, ARow] = 2 then
  begin
   if (Player[ACol, ARow+1] = Player[ACol, ARow]) then
    begin
     Result:=tdUp;
     Exit;
    end;
   if (Player[ACol, ARow-1] = Player[ACol, ARow]) then
    begin
     Result:=tdDown;
     Exit;
    end;
   if (Player[ACol, ARow] = Player[ACol-1, ARow]) then
    begin
     Result:=tdRight;
     Exit;
    end;
   if (Player[ACol, ARow] = Player[ACol+1, ARow]) then
    begin
     Result:=tdLeft;
     Exit;
    end;
  end;
 if (Player[ACol, ARow+1] = Player[ACol, ARow]) and (Player[ACol, ARow-1] = Player[ACol, ARow]) then
  begin
   Result:=tdMediumUp;
   Exit;
  end;
 if (Player[ACol, ARow+1] <> Player[ACol, ARow]) and (Player[ACol, ARow-1] = Player[ACol, ARow]) then
  begin
   Result:=tdDown;
   Exit;
  end;
 if (Player[ACol, ARow-1] <> Player[ACol, ARow]) and (Player[ACol, ARow+1] = Player[ACol, ARow]) then
  begin
   Result:=tdUp;
   Exit;
  end;
 if (Player[ACol, ARow] = Player[ACol-1, ARow]) and (Player[ACol, ARow] = Player[ACol+1, ARow]) then
  begin
   Result:=tdMediumLeft;
   Exit;
  end;
 if (Player[ACol, ARow] <> Player[ACol+1, ARow]) and (Player[ACol, ARow] = Player[ACol-1, ARow]) then
  begin
   Result:=tdRight;
   Exit;
  end;
 if (Player[ACol, ARow] <> Player[ACol-1, ARow]) and (Player[ACol, ARow] = Player[ACol+1, ARow]) then
  begin
   Result:=tdLeft;
   Exit;
  end;
end;

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
   DrawGridPoly.Canvas.Font.Style:=[];
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
   DrawGridPoly.Canvas.Font.Style:=[];
   DrawGridPoly.Canvas.Brush.Style:=bsClear;
   W:=DrawGridPoly.Canvas.TextWidth(RuChars[ACol]);
   H:=DrawGridPoly.Canvas.TextHeight(RuChars[ACol]);
   DrawGridPoly.Canvas.TextOut(Rect.Left+((Rect.Right-Rect.Left) div 2)-(W div 2), Rect.Top+((Rect.Bottom-Rect.Top) div 2)-(H div 2), RuChars[ACol]);
   Exit;
  end;
 DRect.Left:=0;
 DRect.Top:=0;
 DRect.Right:=24;
 DRect.Bottom:=24;
 Bitmaps.Water.Height:=24;
 Bitmaps.Water.Width:=24;
 Bitmaps.Water.Canvas.CopyRect(DRect, Bitmaps.BackGround.Canvas, Rect);
 DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.Water);
 case Player[ACol, ARow] of
  1..4:DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.ShipsV2[Ord(GetInfo)]);
 else
  {DRect.Left:=0;
  DRect.Top:=0;
  DRect.Right:=24;
  DRect.Bottom:=24;
  Bitmaps.Water.Height:=24;
  Bitmaps.Water.Width:=24;
  Bitmaps.Water.Canvas.CopyRect(DRect, Bitmaps.BackGround.Canvas, Rect);
  DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.Water);     }
 end;
 case PlayerKill[ACol, ARow] of
  aPast: DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.Past);
  aWound:DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.Wou);
  aKill: DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.Kill);
  aUser: DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.UPast);
 end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
 PlayerName:='Игрок';
 SleepTime:=500;
 LabelAutor.Caption:='Разработчик: Геннадий Малинин';
 SetWindowRgn(Handle, CreateRoundRectRgn(0, 0,Width, Height, 20, 20), True);
 Game:=TGame.Create;
 Need:=True;
 Bitmaps:=TBitmaps.Create;
 Game.ClearAll;
 LoadSkinFromDll(Path+'Graphics\default.dll');
 Brush.Bitmap:=Bitmaps.FormBrush;
 ListBoxPos.Brush.Bitmap:=Bitmaps.FormBrush;
 DeForm:=False;
 IsMax:=True;
 PanelResult.Brush.Bitmap:=Bitmaps.ResultPanel;
 Wins:=0;
 Loses:=0;
end;

procedure TFormMain.DrawGridCompDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);

var W,H:Byte;
 DRect:TRect;

begin
 if ((ACol=0) and (ARow=0)) or ((ACol=11) or (ARow=11)) then
  begin
   DrawGridComp.Canvas.StretchDraw(Rect, Bitmaps.Empty);
   Exit;
  end;
 if ACol=0 then
  begin
   DrawGridComp.Canvas.StretchDraw(Rect, Bitmaps.Empty);
   DrawGridComp.Canvas.Font.Name:='Segoe UI';
   DrawGridComp.Canvas.Brush.Style:=bsClear;
   W:=DrawGridComp.Canvas.TextWidth(IntToStr(ARow));
   H:=DrawGridComp.Canvas.TextHeight(IntToStr(ARow));
   DrawGridComp.Canvas.TextOut(Rect.Left+((Rect.Right-Rect.Left) div 2)-(W div 2), Rect.Top+((Rect.Bottom-Rect.Top) div 2)-(H div 2), IntToStr(ARow));
   Exit;
  end;
 if ARow=0 then
  begin
   DrawGridComp.Canvas.StretchDraw(Rect, Bitmaps.Empty);
   DrawGridComp.Canvas.Font.Name:='Segoe UI';
   DrawGridComp.Canvas.Brush.Style:=bsClear;
   W:=DrawGridComp.Canvas.TextWidth(RuChars[ACol]);
   H:=DrawGridComp.Canvas.TextHeight(RuChars[ACol]);
   DrawGridComp.Canvas.TextOut(Rect.Left+((Rect.Right-Rect.Left) div 2)-(W div 2), Rect.Top+((Rect.Bottom-Rect.Top) div 2)-(H div 2), RuChars[ACol]);
   Exit;
  end;
 DRect.Left:=0;
 DRect.Top:=0;
 DRect.Right:=24;
 DRect.Bottom:=24;
 Bitmaps.Water.Height:=24;
 Bitmaps.Water.Width:=24;
 Bitmaps.Water.Canvas.CopyRect(DRect, Bitmaps.BackGround.Canvas, Rect);
 DrawGridComp.Canvas.StretchDraw(Rect, Bitmaps.Water);
 if Game.Status=tsEnd then if Comp[ACol, ARow] in [1..4] then
  begin

   DrawGridComp.Canvas.StretchDraw(Rect, Bitmaps.Ships[Comp[ACol, ARow]]);
  end;
 case CompKill[ACol, ARow] of
  aPast:DrawGridComp.Canvas.StretchDraw(Rect, Bitmaps.Past);
  aWound:DrawGridComp.Canvas.StretchDraw(Rect, Bitmaps.Wou);
  aKill:
   begin
    DrawGridComp.Canvas.StretchDraw(Rect, Bitmaps.Ships[Comp[ACol, ARow]]);
    DrawGridComp.Canvas.StretchDraw(Rect, Bitmaps.Kill);
   end;
  aUser:DrawGridComp.Canvas.StretchDraw(Rect, Bitmaps.UPast);
 end;
end;

procedure TGame.BeginManualSet;
begin
 Status:=tsManualSet;
end;

procedure TGame.EndManualSet;
begin
 Status:=tsWait;
end;

function CheckFullPoly:Boolean;
begin
 Result:=Game.Ships[1] = 0;
end;

function GetCurShip:Byte;
var i:Byte;
begin
 for i:=4 downto 1 do if Game.Ships[i]<>0 then Break;
 Result:=i;
end;

function ShipIsAllWound(SPos:TPoint; Direction:TDirection; var Poly:TKillArray; SSize:Byte):Boolean;
var i:Byte;
begin
 Result:=False;
 case Direction of
  tdLeft:  for i:= 0 to SSize-1 do if Poly[SPos.X-i, SPos.Y ] <> aWound then Exit;
  tdRight: for i:= 0 to SSize-1 do if Poly[SPos.X+i, SPos.Y ] <> aWound then Exit;
  tdUp:    for i:= 0 to SSize-1 do if Poly[SPos.X , SPos.Y-i] <> aWound then Exit;
  tdDown:  for i:= 0 to SSize-1 do if Poly[SPos.X , SPos.Y+i] <> aWound then Exit;
 end;
 Result:=True;
end;

procedure KillShip(SPos:TPoint; Direction:TDirection; var Poly:TKillArray; SSize:Byte);
var i:Byte;
begin
 case Direction of
  tdLeft:  for i:= 0 to SSize-1 do Poly[SPos.X-i, SPos.Y ]:=aKill;
  tdRight: for i:= 0 to SSize-1 do Poly[SPos.X+i, SPos.Y ]:=aKill;
  tdUp:    for i:= 0 to SSize-1 do Poly[SPos.X , SPos.Y-i]:=aKill;
  tdDown:  for i:= 0 to SSize-1 do Poly[SPos.X , SPos.Y+i]:=aKill;
 end;
end;

procedure DrawAll;
begin
 with FormMain do
  begin
   DrawGridComp.Repaint;
   DrawGridPoly.Repaint;
  end;
end;

function PlayerShoot(SPos:TPoint; var Got:Boolean):Boolean;
var Dir:TDirection;
    StartPos:TPoint;
    Size:Byte;
begin
 Result:=False;
 Got:=False;
 if not Game.CheckCell(SPos) then Exit;
 case Comp[SPos.X, SPos.Y] of
  1..4:
   begin
    if (CompKill[SPos.X, SPos.Y]=aWound) or
       (CompKill[SPos.X, SPos.Y]=aKill) or
       (CompKill[SPos.X, SPos.Y]=aUser)
    then Exit;
    CompKill[SPos.X, SPos.Y]:=aWound;
    GetShipPos(SPos, Dir, StartPos, Comp);
    Size:=Comp[SPos.X, SPos.Y];
    if ShipIsAllWound(StartPos, Dir, CompKill, Size) then
     begin
      KillShip(StartPos, Dir, CompKill, Size);
      DrawAll;
     end;
    Got:=True;
    Result:=True;
   end;
 else
  if (CompKill[SPos.X, SPos.Y]=aUser) then Exit;
  if (CompKill[SPos.X, SPos.Y]=aPast) then Exit;
  CompKill[SPos.X, SPos.Y]:=aPast;
  Result:=True;
 end;
end;

function CompShoot(SPos:TPoint; var Got:Boolean):Boolean;
var Dir:TDirection;
    StartPos:TPoint;
    Size:Byte;
begin
 Result:=False;
 if Game.Status = tsEnd then Exit;
 Got:=False;
 case Player[SPos.X, SPos.Y] of
  1..4:
   begin
    if (PlayerKill[SPos.X, SPos.Y]=aWound) or
       (PlayerKill[SPos.X, SPos.Y]=aKill) or
       (PlayerKill[SPos.X, SPos.Y]=aUser)
    then Exit;
    try
     PlayerKill[SPos.X, SPos.Y]:=aWound;
    except
     ShowMessage(IntToStr(SPos.X)+' : '+IntToStr(Spos.Y));
    end;
    GetShipPos(SPos, Dir, StartPos, Player);
    Size:=Player[SPos.X, SPos.Y];
    if ShipIsAllWound(StartPos, Dir, PlayerKill, Size) then
     begin
      KillShip(StartPos, Dir, PlayerKill, Size);
      DrawAll;
     end;
    Result:=True;
    Got:=True;
   end;
 else
  if (PlayerKill[SPos.X, SPos.Y]=aUser) then Exit;
  PlayerKill[SPos.X, SPos.Y]:=aPast;
  Result:=True;
 end;
end;

procedure PlayerPast(SPos:TPoint);
begin
 case CompKill[SPos.X, SPos.Y] of
  aUser:CompKill[SPos.X, SPos.Y]:=aEmpty;
  aEmpty:CompKill[SPos.X, SPos.Y]:=aUser;
 end;
 DrawAll;
end;

procedure Input(SPos:TPoint);
var Got:Boolean;
begin
 with FormMain do
  begin
   if (PlayerShoot(SPos, Got)) then
    begin
     Game.WriteIt(PlayerName+': '+RuChars[SPos.X]+'-'+IntToStr(SPos.Y));
     Waiting;
     if not Got then
      begin
       Game.WriteIt(CompName+': Мимо');
       Game.Lead:=tlComp;
       Game.DoCompShoot;
       DrawAll;
      end
     else
      if CompKill[SPos.X, SPos.Y]=aKill then
       begin
        Game.WriteIt(CompName+': Убил');
        InsertPastForUser(SPos);
        DrawAll;
        if CheckComp then
         begin
          Game.Status:=tsEnd;
          DrawAll;
          Game.WriteIt(CompName+': =(');
          OnPlayerWin;
         end;
       end
      else Game.WriteIt(CompName+': Попал');
    end;
  end;
end;

procedure TFormMain.DrawGridCompMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var SPos:TPoint;
 ACol, ARow:Integer;
begin
 TimerGo.Enabled:=False;
 TimerGo.Interval:=30000;
 case Button of
  mbLeft:
   begin
    if (Game.Status = tsPlay) and (Game.Lead=tlPlayer) then
     begin
      DrawGridComp.MouseToCell(X, Y, ACol, ARow);
      SPos.X:=ACol;
      SPos.Y:=ARow;
      Input(SPos);
     end;
   end;
  mbRight:
   begin
    if (Game.Status = tsPlay) then
     begin
      DrawGridComp.MouseToCell(X, Y, ACol, ARow);
      SPos.X:=ACol;
      SPos.Y:=ARow;
      if (ssCtrl in Shift) and (CompKill[SPos.X, SPos.Y] = aKill) then
       begin
        InsertPastForUser(SPos);
        DrawAll;
        TimerGo.Enabled:=True;
        Exit;
       end;
      PlayerPast(SPos);
     end;
   end;
 end;
 TimerGo.Enabled:=True;
end;

function GetShipPos(SPos:TPoint; var Direction:TDirection; var StartPos:TPoint; Poly:TArray):Boolean;
var i:Byte;
 Ship:Byte;
begin
 Result:=False;
 Ship:=Poly[SPos.X, SPos.Y];
 if Ship = 1 then
  begin
   StartPos:=SPos;
   Direction:=tdLeft;
   Result:=True;
   Exit;
  end;
 if (Game.CheckCell(Point(SPos.X, SPos.Y-1))) and (Poly[SPos.X, SPos.Y-1]=Ship) then Direction:=tdUp else
 if (Game.CheckCell(Point(SPos.X, SPos.Y+1))) and (Poly[SPos.X, SPos.Y+1]=Ship) then Direction:=tdDown else
 if (Game.CheckCell(Point(SPos.X-1, SPos.Y))) and (Poly[SPos.X-1, SPos.Y]=Ship) then Direction:=tdLeft else
 if (Game.CheckCell(Point(SPos.X+1, SPos.Y))) and (Poly[SPos.X+1, SPos.Y]=Ship) then Direction:=tdRight
 else
  begin
   StartPos:=SPos;
   Direction:=tdUp;
   Exit;
  end;
 case Direction of
  tdLeft:
   begin
    if SPos.X<>10 then
     begin
      for i:=SPos.X to 10 do if Poly[i+1, SPos.Y]<>Ship then Break;
      StartPos.X:=i;
     end
    else StartPos.X:=10;
    StartPos.Y:=SPos.Y;
   end;
  tdRight:
   begin
    if SPos.X<>1 then
     begin
      for i:=SPos.X downto 1 do if Poly[i-1, SPos.Y]<>Ship then Break;
      StartPos.X:=i;
     end
    else StartPos.X:=1;
    StartPos.Y:=SPos.Y;
   end;
  tdUp:
   begin
    if SPos.Y<>10 then
     begin
      for i:=SPos.Y to 10 do if Poly[SPos.X, i+1]<>Ship then Break;
      StartPos.Y:=i;
     end
    else StartPos.Y:=10;
    StartPos.X:=SPos.X;
   end;
  tdDown:
   begin
    if SPos.Y<>1 then
     begin
      for i:=SPos.Y downto 1 do if Poly[SPos.X, i-1]<>Ship then Break;
      StartPos.Y:=i;
     end
    else StartPos.Y:=1;
    StartPos.X:=SPos.X;
   end;
 end;
 Result:=True;
end;

function CheckPlayer:Boolean;
var i,j:Byte;
 Ships:set of Byte;
begin
 Result:=False;
 Ships:=[1..4];
 for i:=1 to 10 do
  for j:=1 to 10 do if Player[i,j] in Ships then if PlayerKill[i,j]<>aKill then Exit;
 Result:=True;
end;

function CheckComp:Boolean;
var i,j:Byte;
 Ships:set of Byte;
begin
 Result:=False;
 Ships:=[1..4];
 for i:=1 to 10 do
  for j:=1 to 10 do if Comp[i,j] in Ships then if CompKill[i,j]<>aKill then Exit;
 Result:=True;
end;

function GetNextShoot(LastShoot:TPoint):TPoint;
var FirstDir:Byte;
 Used:set of TDirection;
 DPos:TPoint;
begin
 Used:=Game.CompUsedDir;
 Randomize;
 if (LastShoot.X = 0) or (LastShoot.Y = 0) then
  begin
   Game.IsNextShoot:=False;
   Result:=Point(1, 1);
   Exit;
  end;
 if Game.LastShoots.Use then
  begin
   case Game.LastDir of
    tdLeft: Game.LastDir:=tdRight;
    tdRight:Game.LastDir:=tdLeft;
    tdUp:Game.LastDir:=tdDown;
    tdDown:Game.LastDir:=tdUp;
   end;
   Game.UseLastDir:=True;
   LastShoot:=Game.LastShoots.Shoots[1];
  end;

 repeat
  if (not Game.UseLastDir) or (Game.LastDir in Used) then
   repeat FirstDir:=Random(4) until (not (TDirection(FirstDir) in Used)) or (Used = [tdLeft, tdRight, tdUp, tdDown])
  else FirstDir:=Ord(Game.LastDir);
  case TDirection(FirstDir) of
   tdLeft:
    begin
     DPos:=Point(LastShoot.X-1, LastShoot.Y);
     if (Game.CheckCell(DPos)) and
        (PlayerKill[DPos.X, DPos.Y] <> aPast) and
        (PlayerKill[DPos.X, DPos.Y] <> aUser)
     then
      begin
       Game.LastDir:=tdLeft;
       Result:=DPos;
       Exit;
      end
     else Include(Used, tdLeft);
    end;
  tdRight:
    begin
     DPos:=Point(LastShoot.X+1, LastShoot.Y);
     if (Game.CheckCell(DPos)) and
        (PlayerKill[DPos.X, DPos.Y] <> aPast) and
        (PlayerKill[DPos.X, DPos.Y] <> aUser)
     then
      begin
       Game.LastDir:=tdRight;
       Result:=DPos;
       Exit;
      end
     else Include(Used, tdRight);
    end;
   tdUp:
    begin
     DPos:=Point(LastShoot.X, LastShoot.Y-1);
     if (Game.CheckCell(DPos)) and
        (PlayerKill[DPos.X, DPos.Y] <> aPast) and
        (PlayerKill[DPos.X, DPos.Y] <> aUser)
     then
      begin
       Game.LastDir:=tdUp;
       Result:=DPos;
       Exit;
      end
     else Include(Used, tdUp);
    end;
   tdDown:
    begin
     DPos:=Point(LastShoot.X, LastShoot.Y+1);
     if (Game.CheckCell(DPos)) and
        (PlayerKill[DPos.X, DPos.Y] <> aPast) and
        (PlayerKill[DPos.X, DPos.Y] <> aUser)
     then
      begin
       Game.LastDir:=tdDown;
       Result:=DPos;
       Exit;
      end
     else Include(Used, tdDown);
    end;
  end;
 until Used = [tdLeft, tdRight, tdUp, tdDown];
 Game.CompUsedDir:=Used;
end;

procedure InsertPast(Ship:TPoint);
var Dir:TDirection;
   SPos:TPoint;
   ShipSize:Byte;
   i:SmallInt;

function CheckPoint(SPos:TPoint):Boolean;
begin
 Result:= (SPos.X >= 1)  and
          (SPos.X <= 10) and
          (SPos.Y >= 1)  and
          (SPos.Y <= 10) and
          (PlayerKill[SPos.X, SPos.Y] = aEmpty);
end;

begin
 ShipSize:=Player[Ship.X, Ship.Y];
 if not GetShipPos(Ship, Dir, SPos, Player) then Exit;
 case Dir of
  tdLeft:begin
          for i:= -1 to ShipSize do if CheckPoint(Point(SPos.X-i, SPos.Y-1)) then PlayerKill[SPos.X-i, SPos.Y-1]:=aUser;
          for i:= -1 to ShipSize do if CheckPoint(Point(SPos.X-i, SPos.Y+1)) then PlayerKill[SPos.X-i, SPos.Y+1]:=aUser;
          if CheckPoint(Point(SPos.X+1, SPos.Y)) then PlayerKill[SPos.X+1, SPos.Y]:=aUser;
          if CheckPoint(Point(SPos.X-ShipSize, SPos.Y)) then PlayerKill[SPos.X-ShipSize, SPos.Y]:=aUser;
          Exit;
         end;
 tdRight:begin
          for i:= -1 to ShipSize do if CheckPoint(Point(SPos.X+i, SPos.Y-1)) then PlayerKill[SPos.X+i, SPos.Y-1]:=aUser;
          for i:= -1 to ShipSize do if CheckPoint(Point(SPos.X+i, SPos.Y+1)) then PlayerKill[SPos.X+i, SPos.Y+1]:=aUser;
          if CheckPoint(Point(SPos.X-1, SPos.Y)) then PlayerKill[SPos.X-1, SPos.Y]:=aUser;
          if CheckPoint(Point(SPos.X+ShipSize, SPos.Y)) then PlayerKill[SPos.X+ShipSize, SPos.Y]:=aUser;
          Exit;
         end;
  tdUp:  begin
          for i:= -1 to ShipSize do if CheckPoint(Point(SPos.X-1, SPos.Y-i)) then PlayerKill[SPos.X-1, SPos.Y-i]:=aUser;
          for i:= -1 to ShipSize do if CheckPoint(Point(SPos.X+1, SPos.Y-i)) then PlayerKill[SPos.X+1, SPos.Y-i]:=aUser;
          if CheckPoint(Point(SPos.X, SPos.Y+1)) then PlayerKill[SPos.X, SPos.Y+1]:=aUser;
          if CheckPoint(Point(SPos.X, SPos.Y-ShipSize)) then PlayerKill[SPos.X, SPos.Y-ShipSize]:=aUser;
          Exit;
         end;
  tdDown:begin
          for i:= -1 to ShipSize do if CheckPoint(Point(SPos.X-1, SPos.Y+i)) then PlayerKill[SPos.X-1, SPos.Y+i]:=aUser;
          for i:= -1 to ShipSize do if CheckPoint(Point(SPos.X+1, SPos.Y+i)) then PlayerKill[SPos.X+1, SPos.Y+i]:=aUser;
          if CheckPoint(Point(SPos.X, SPos.Y-1)) then PlayerKill[SPos.X, SPos.Y-1]:=aUser;
          if CheckPoint(Point(SPos.X, SPos.Y+ShipSize)) then PlayerKill[SPos.X, SPos.Y+ShipSize]:=aUser;
          Exit;
         end;
 end;
end;

procedure InsertPastForUser(Ship:TPoint);
var Dir:TDirection;
   SPos:TPoint;
   ShipSize:Byte;
   i:SmallInt;

function CheckPoint(SPos:TPoint):Boolean;
begin
 Result:= (SPos.X >= 1)  and
          (SPos.X <= 10) and
          (SPos.Y >= 1)  and
          (SPos.Y <= 10) and
          (CompKill[SPos.X, SPos.Y] = aEmpty);
end;

begin
 ShipSize:=Comp[Ship.X, Ship.Y];
 if not GetShipPos(Ship, Dir, SPos, Comp) then Exit;
 case Dir of
  tdLeft:begin
          for i:= -1 to ShipSize do if CheckPoint(Point(SPos.X-i, SPos.Y-1)) then CompKill[SPos.X-i, SPos.Y-1]:=aUser;
          for i:= -1 to ShipSize do if CheckPoint(Point(SPos.X-i, SPos.Y+1)) then CompKill[SPos.X-i, SPos.Y+1]:=aUser;
          if CheckPoint(Point(SPos.X+1, SPos.Y)) then CompKill[SPos.X+1, SPos.Y]:=aUser;
          if CheckPoint(Point(SPos.X-ShipSize, SPos.Y)) then CompKill[SPos.X-ShipSize, SPos.Y]:=aUser;
          Exit;
         end;
 tdRight:begin
          for i:= -1 to ShipSize do if CheckPoint(Point(SPos.X+i, SPos.Y-1)) then CompKill[SPos.X+i, SPos.Y-1]:=aUser;
          for i:= -1 to ShipSize do if CheckPoint(Point(SPos.X+i, SPos.Y+1)) then CompKill[SPos.X+i, SPos.Y+1]:=aUser;
          if CheckPoint(Point(SPos.X-1, SPos.Y)) then CompKill[SPos.X-1, SPos.Y]:=aUser;
          if CheckPoint(Point(SPos.X+ShipSize, SPos.Y)) then CompKill[SPos.X+ShipSize, SPos.Y]:=aUser;
          Exit;
         end;
  tdUp:  begin
          for i:= -1 to ShipSize do if CheckPoint(Point(SPos.X-1, SPos.Y-i)) then CompKill[SPos.X-1, SPos.Y-i]:=aUser;
          for i:= -1 to ShipSize do if CheckPoint(Point(SPos.X+1, SPos.Y-i)) then CompKill[SPos.X+1, SPos.Y-i]:=aUser;
          if CheckPoint(Point(SPos.X, SPos.Y+1)) then CompKill[SPos.X, SPos.Y+1]:=aUser;
          if CheckPoint(Point(SPos.X, SPos.Y-ShipSize)) then CompKill[SPos.X, SPos.Y-ShipSize]:=aUser;
          Exit;
         end;
  tdDown:begin
          for i:= -1 to ShipSize do if CheckPoint(Point(SPos.X-1, SPos.Y+i)) then CompKill[SPos.X-1, SPos.Y+i]:=aUser;
          for i:= -1 to ShipSize do if CheckPoint(Point(SPos.X+1, SPos.Y+i)) then CompKill[SPos.X+1, SPos.Y+i]:=aUser;
          if CheckPoint(Point(SPos.X, SPos.Y-1)) then CompKill[SPos.X, SPos.Y-1]:=aUser;
          if CheckPoint(Point(SPos.X, SPos.Y+ShipSize)) then CompKill[SPos.X, SPos.Y+ShipSize]:=aUser;
          Exit;
         end;
 end;
end;

procedure Waiting;
var CTime:Cardinal;
begin
 FormMain.DrawGridComp.Enabled:=False;
 CTime:=GetTickCount+SleepTime;
 while GetTickCount<CTime do Application.ProcessMessages;
 FormMain.DrawGridComp.Enabled:=True;
end;

procedure TGame.DoCompShoot;
 var SPos:TPoint;
  Got:Boolean;
begin
 if not IsNextShoot then
  begin
   repeat
    SPos.X:=Random(10)+1;
    SPos.Y:=Random(10)+1;
   until (PlayerKill[SPos.X, SPos.Y] = aEmpty) or (Game.Status = tsEnd);
   IsNS:=False;
  end
 else
  begin
   SPos:=GetNextShoot(CompLastShoot);
   IsNS:=True;
  end;
 Waiting;
 try
  WriteIt(CompName+': '+RuChars[SPos.X]+'-'+IntToStr(SPos.Y));
 except
  ShowMessage(IntToStr(SPos.X)+' : '+IntToStr(Spos.Y));
 end;
 Waiting;
 CompShoot(SPos, Got);
 DrawAll;
 if Got then
  begin
   if PlayerKill[SPos.X, SPos.Y]=aKill then
    begin
     Game.WriteIt(PlayerName+': Убил');
     DrawAll;
     InsertPast(SPos);
     LastShoots.ShipSize:=0;
     LastShoots.Use:=False;
     IsNextShoot:=False;
     IsNS:=False;
     CompUsedDir:=[];
     if CheckPlayer then
      begin
       Game.Status:=tsEnd;
       DrawAll;
       Game.WriteIt(CompName+': =)');
       OnCompWin;
       IsNextShoot:=False;
      end;
    end
   else
    begin
     Game.WriteIt(PlayerName+': Попал');
     DrawAll;
     Inc(LastShoots.ShipSize);
     LastShoots.Shoots[LastShoots.ShipSize]:=SPos;
     LastShoots.Use:=False;
     UseLastDir:=IsNS;
     IsNextShoot:=True;
    end;
   CompLastShoot:=SPos;
   DoCompShoot;
   Exit;
  end
 else
  begin
   Lead:=tlPlayer;
   Game.WriteIt(PlayerName+': Мимо');
   LastShoots.Use:=IsNS;
   Include(CompUsedDir, Game.LastDir);
   UseLastDir:=False;
   if not IsNS then CompUsedDir:=[];
  end;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
 case FormShipPoly.ShowModal of
  mrOk:
   begin
    Player:=Poly;
    Game.New;
   end;
 else
  Application.Terminate;
 end;
 Game.WriteIt('Игра "Морской Бой"');
 Game.WriteIt('С вами будет играть '+CompName);
 Game.WriteIt('Поприветствуйте его');
 Game.WriteIt('и назовите свое имя');
end;

procedure TFormMain.ListBoxPosDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var DRect:TRect;
begin
 DRect.Left:=0;
 DRect.Top:=0;
 DRect.Right:=ListBoxPos.Width;
 DRect.Bottom:=ListBoxPos.ItemHeight;
 Bitmaps.ListItem.Width:=ListBoxPos.Width;
 Bitmaps.ListItem.Height:=ListBoxPos.ItemHeight;
 Bitmaps.ListItem.Canvas.CopyRect(DRect, Bitmaps.FormBrush.Canvas, Rect);
 ListBoxPos.Canvas.Draw(Rect.Left, Rect.Top, Bitmaps.ListItem);
 ListBoxPos.Canvas.Brush.Style:=bsClear;
 ListBoxPos.Canvas.TextOut(Rect.Left+3, Rect.Top, ListBoxPos.Items.Strings[index]);
end;

procedure TFormMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 MPos.X:=X;
 MPos.Y:=Y;
end;

procedure TFormMain.ButtonCloseClick(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TFormMain.ButtonHideClick(Sender: TObject);
begin
 Application.Minimize;
end;

procedure TFormMain.ButtonCloseMouseEnter(Sender: TObject);
begin
 Need:=False;
end;

procedure TFormMain.ButtonCloseMouseExit(Sender: TObject);
begin
 Need:=True;
end;

procedure TFormMain.ButtonNewClick(Sender: TObject);
begin
 case FormShipPoly.ShowModal of
  mrOk:
   begin
    Game.ClearAll;
    Player:=TMP;
    Game.New;
   end;
 else
 end;
 DrawGridPoly.Repaint;
 DrawGridComp.Repaint;
end;

function AnalysInput(Text:string):Boolean;
var SPos:TPoint;
   Num:string;
   IntNum:Byte;
begin
 Result:=False;
 case Text[1] of
  'А','а':SPos.X:=1;
  'Б','б':SPos.X:=2;
  'В','в':SPos.X:=3;
  'Г','г':SPos.X:=4;
  'Д','д':SPos.X:=5;
  'Е','е':SPos.X:=6;
  'Ж','ж':SPos.X:=7;
  'З','з':SPos.X:=8;
  'И','и':SPos.X:=9;
  'К','к':SPos.X:=10;
 else
  Exit;
 end;
 if Text[2] = '-' then Num:=Copy(Text, 3, Length(Text)-(Length(Text)-3))
 else Num:=Copy(Text, 2, Length(Text)-(Length(Text)-2));
 try
  IntNum:=StrToInt(Num);
 except
  Exit;
 end;
 if (IntNum <= 0) or (IntNum > 10) then Exit;
 SPos.Y:=IntNum;
 Input(SPos);
 Result:=True;
end;

procedure AnalysAnswer(Text:string);
var MyText, tmp:string;
    ST:Integer;
    A, CName:Boolean;

procedure NotUnderstood;
begin
 case Random(5) of
  0:Answer:='Не понял';
  1:Answer:='Не ясно';
  2:Answer:='Ходи давай';
  3:Answer:='Я не понял';
  4:Answer:='Не понятно';
  5:Answer:='Я приметивен';
 end;
end;

function GetWord(SPos:Byte):string;
var i:Byte;
begin
 for i:=SPos to Length(Text) do
  if (Text[i] = ' ') or
     (Text[i] = ',') or
     (Text[i] = '.')
  then Break;
 if i = Length(Text) then Result:=Copy(Text, SPos, i) else Result:=Copy(Text, SPos, i-1);
end;  

begin
 MyText:=AnsiLowerCase(Text);
 Randomize;
 A:=False;
 CName:=False;
 FormMain.TimerSpeak.Interval:=Random(3000)+1000;
 if (Pos('мое имя', MyText) <> 0) then
  begin
   PlayerName:=GetWord(Pos('мое имя', MyText)+8);
   Answer:='Я '+CompName+', приятно познакомится, '+PlayerName;
   CName:=True;
   A:=True;
  end
 else
 if (Pos('меня зовут', MyText) <> 0) then
  begin
   PlayerName:=GetWord(Pos('меня зовут', MyText)+11);
   Answer:='Я '+CompName+', приятно познакомится, '+PlayerName;
   CName:=True;
   A:=True;
  end
 else
 if (Pos('я ', MyText) <> 0) then
  begin
   PlayerName:=GetWord(Pos('я ', MyText)+2);
   Answer:='Я '+CompName+', приятно познакомится, '+PlayerName;
   CName:=True;
   A:=True;
  end;
 if (Pos('привет', MyText) <> 0) or
    (Pos('здравствуй', MyText) <> 0) or
    (Pos('приветствие', MyText) <> 0) or
    (Pos('хай', MyText) <> 0) or
    (Pos('hi', MyText) <> 0) or
    (Pos('даров', MyText) <> 0) or
    (Pos('здарова', MyText) <> 0) or
    (Pos('здаров', MyText) <> 0)
 then
  begin
   case Random(5) of
    0:tmp:='Привет';
    1:tmp:='Здравствуй';
    2:tmp:='Приветствую';
    3:tmp:='Welcome';
    4:tmp:='Hi, what`s up';
    5:tmp:='Хай';
   end;
   if not CName then
    begin
     if PlayerName <> '' then Answer:=tmp+', '+PlayerName;
    end
   else Answer:=tmp+',я '+CompName+', приятно познакомится, '+PlayerName;
   FormMain.TimerSpeak.Enabled:=True;
   A:=True;
  end; 
 if (Pos('пока', MyText) = 1) or
    (Pos('до свидания', MyText) = 1) or
    (Pos('до встречи', MyText) = 1) or
    (Pos('выход', MyText) = 1) or
    (Pos('exit', MyText) = 1) or
    (Pos('quit', MyText) = 1) or
    (Pos('закрыть', MyText) = 1) or
    (Pos('close', MyText) = 1) or
    (Pos('bye', MyText) = 1)
 then
  begin
   Answer:='До встречи';
   FormMain.TimerSpeak.Enabled:=True;
   A:=True;
   Waiting;
   Application.Terminate;
  end;
 if Pos('ходи', MyText) <> 0 then
  begin
   Game.Lead:=tlComp;
   Game.DoCompShoot;
   DrawAll;
   Exit;
  end;
 if (Pos('смени имя', MyText) <> 0) or
    (Pos('другое имя', MyText) <> 0)
 then
  begin
   GetRandomCompName;
   Answer:='Готово, так лучше?!';
   FormMain.TimerSpeak.Enabled:=True;
   A:=True;
  end;
 if Pos('sleep=', MyText) <> 0 then
  begin
   try
    ST:=StrToInt(Copy(MyText, 7, Length(MyText)-6))*1000;
    Answer:='Задержка '+IntToStr(ST div 1000)+' сек.';
   except
    begin
     ST:=SleepTime;
     NotUnderstood;
     Answer:=Answer+', шаблон: "sleep=1"';
    end;
   end;
   SleepTime:=ST;
   FormMain.TimerSpeak.Enabled:=True;
   A:=True;
  end;
 if not A then NotUnderstood;
 FormMain.TimerSpeak.Enabled:=True;
end;

procedure TFormMain.EditInputKeyPress(Sender: TObject; var Key: Char);
begin
 if Key = #13 then
  begin
   Key:=#0;
   if not AnalysInput(EditInput.Text) then
    begin
     Game.WriteIt(PlayerName+': '+EditInput.Text);
     AnalysAnswer(EditInput.Text);
    end;
   EditInput.Clear; 
  end;
end;

procedure TFormMain.TimerSpeakTimer(Sender: TObject);
begin
 TimerSpeak.Enabled:=False;
 if Answer<>'' then
  begin
   Game.WriteIt(CompName+': '+Answer);
   Answer:='';
  end;
end;

procedure TFormMain.ButtonHelpClick(Sender: TObject);
begin
 DrawGridPoly.Visible:= not DrawGridPoly.Visible;
 ListBoxHelp.Visible:= not ListBoxHelp.Visible;
 PanelHelp.Visible:=ListBoxHelp.Visible;
end;

procedure TFormMain.TimerGoTimer(Sender: TObject);
var VM:string;
begin
 if TimerGo.Interval = 30000 then TimerGo.Interval:=300000
 else TimerGo.Enabled:=False;
 Randomize;
 case Random(6) of
  0:VM:='Ходи';
  1:VM:='Ходи давай';
  2:VM:='Ты уснул';
  3:VM:='Wake up';
  4:VM:='Прошу, ходи';
  5:VM:='Твой ход';
  6:VM:='Ваш ход';
 end;
 Game.WriteIt(CompName+': '+VM);
end;

procedure TFormMain.PanelHelpPaint(Sender: TObject);
begin
 PanelHelp.Canvas.Draw(10, 0, Bitmaps.Past);
 PanelHelp.Canvas.TextOut(40, 5, ' - Мимо');
 PanelHelp.Canvas.Draw(10, 25, Bitmaps.UPast);
 PanelHelp.Canvas.TextOut(40, 30, ' - Пусто');
 PanelHelp.Canvas.Draw(10, 50, Bitmaps.Kill);
 PanelHelp.Canvas.TextOut(40, 55, ' - Убил');
 PanelHelp.Canvas.Draw(10, 75, Bitmaps.Wou);
 PanelHelp.Canvas.TextOut(40, 80, ' - Ранил');
 PanelHelp.Canvas.TextOut(120, 4, '4 x');
 PanelHelp.Canvas.Draw(140,  0, Bitmaps.Ships[1]);
 PanelHelp.Canvas.TextOut(120, 29, '3 x');
 PanelHelp.Canvas.Draw(140, 25, Bitmaps.Ships[2]);
 PanelHelp.Canvas.Draw(165, 25, Bitmaps.Ships[2]);
 PanelHelp.Canvas.TextOut(120, 54, '2 x');
 PanelHelp.Canvas.Draw(140, 50, Bitmaps.Ships[3]);
 PanelHelp.Canvas.Draw(165, 50, Bitmaps.Ships[3]);
 PanelHelp.Canvas.Draw(190, 50, Bitmaps.Ships[3]);
 PanelHelp.Canvas.TextOut(120, 79, '1 x');
 PanelHelp.Canvas.Draw(140, 75, Bitmaps.Ships[4]);
 PanelHelp.Canvas.Draw(165, 75, Bitmaps.Ships[4]);
 PanelHelp.Canvas.Draw(190, 75, Bitmaps.Ships[4]);
 PanelHelp.Canvas.Draw(215, 75, Bitmaps.Ships[4]);
end;

procedure TFormMain.PanelResultPaint(Sender: TObject);
begin
 if Score  = 0 then PanelResult.Canvas.Draw(0, 0, Bitmaps.Results[0]);
 if Score >= 1 then PanelResult.Canvas.Draw(0, 0, Bitmaps.Results[1]);
 if Score >= 2 then PanelResult.Canvas.Draw(0, 0, Bitmaps.Results[2]);
 if Score >= 3 then PanelResult.Canvas.Draw(0, 0, Bitmaps.Results[3]);
end;

initialization
  Path:=ExtractFilePath(ParamStr(0));

end.
