unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, XPMan, ExtCtrls, pngimage, pngextra, PanelExt,
  Buttons, MMSystem, ActnList;

type
  TFormMain = class(TForm)
    DrawGridPoly: TDrawGrid;
    DrawGridComp: TDrawGrid;
    XPManifest: TXPManifest;
    ListBoxPos: TListBox;
    TimerSpeak: TTimer;
    ButtonClose: TPNGButton;
    ButtonHide: TPNGButton;
    ButtonNew: TPNGButton;
    ButtonHelp: TPNGButton;
    ListBoxHelp: TListBox;
    PanelResult: TPanelExt;
    LabelLosesV: TLabel;
    LabelWinsV: TLabel;
    ButtonCloseP: TPNGButton;
    ButtonNewP: TPNGButton;
    TimerGo: TTimer;
    PanelHelp: TPanelExt;
    LabelTime: TLabel;
    TimerTime: TTimer;
    LabelXP: TLabel;
    EditInput: TComboBox;
    ActionList: TActionList;
    ActionNewGame: TAction;
    TimerCompShoot: TTimer;
    CompShoot: TAction;
    TimerAni: TTimer;
    TimerClearRadar: TTimer;
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
    procedure TimerTimeTimer(Sender: TObject);
    procedure ButtonClosePClick(Sender: TObject);
    procedure DrawGridCompMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ListBoxHelpDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure DrawGridCompKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ActionNewGameExecute(Sender: TObject);
    procedure TimerCompShootTimer(Sender: TObject);
    procedure CompShootExecute(Sender: TObject);
    procedure TimerAniTimer(Sender: TObject);
    procedure TimerClearRadarTimer(Sender: TObject);
  private
   procedure WMNCHitTest(var M: TWMNCHitTest); message wm_NCHitTest;
  protected
   procedure CreateParams(var Params: TCreateParams); override;
  public
  end;
  TLastShoots = record
   ShipSize:Byte;
   Shoots:array[1..4] of TPoint;
   Last:TPoint;
   Use:Boolean;
  end;
  TKillArray = array[1..10, 1..10] of Byte;
  TArray = array[1..10, 1..10] of Byte;
  TDirection = (tdLeft, tdRight, tdUp, tdDown);
  TShips = array[1..4] of Byte;
  TStatus = (tsPlay, tsEnd);
  TLead = (tlPlayer, tlComp);
  TSoundType = (stShoot, stKill, stWound, stWin, stLose, stPast);
  TInfoType = (itLeadPlayer, itTalk, itLeadComp, itGame);
  TSettings = record
   ShowCompTalk:Boolean;
   ShowLeadPlayer:Boolean;
   ShowLeadComp:Boolean;
  end;
  TLogicPos = record
   SPos:TPoint;
   SDir:TDirection;
  end;
  TLogicPoses = array[1..100] of TLogicPos;
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
   LastScore:Byte;
   CompShips, PlayerShips:TShips;
   TimeGame:Cardinal;
   NoSound:Boolean;
   Settings:TSettings;
   LogicPoses:TLogicPoses;
   procedure New;
   procedure WriteIt(Text:string; InfoType:TInfoType);
   procedure ClearList;
   procedure DoCompShoot;
   procedure ClearPoly;
   procedure SetShips;
   procedure ClearAll;
   procedure OnCompWin;
   procedure OnPlayerWin;
   procedure DrawAll(Who:TLead);
   procedure GetRandomCompName;
   procedure Input(SPos:TPoint);
   procedure Waiting;                 overload;
   procedure Waiting(ATime:Cardinal); overload;
   procedure AnalysAnswer(Text:string);
   procedure InsertPast(Ship:TPoint);
   procedure PlayerPast(SPos:TPoint);
   procedure InsertPastForUser(Ship:TPoint);
   procedure InsertShip(SPos:TPoint; Direction:TDirection; ShipSize:Byte);
   procedure ActionTorpedo(NPos:TPoint);
   procedure SetStatus(Win:Boolean);
   procedure KillShip(SPos:TPoint; Direction:TDirection; var Poly:TKillArray; SSize:Byte; Whose:TLead);
   procedure GoSound(SoundType:TSoundType);
   procedure ActionRadar(SPos:TPoint);
   function CalcBusy(APoly:TKillArray):Byte;
   function FindPosForShip(SSize:Byte; APoly:TKillArray; var ALogicPoses:TLogicPoses):Byte;
   function GetInfo(ACol, ARow:Word; APoly, DirShip:TArray):Byte;
   function CheckFullPoly:Boolean;
   function GetCurShip:Byte;
   function ShipIsAllWound(SPos:TPoint; Direction:TDirection; var Poly:TKillArray; SSize:Byte):Boolean;
   function PlayerShoot(SPos:TPoint; var Got:Boolean):Boolean;
   function CompShoot(SPos:TPoint; var Got:Boolean):Boolean;
   function CheckComp:Boolean;
   function CheckPlayer:Boolean;
   function GetNextShoot(LastShoot:TPoint):TPoint;
   function GetShipPos(SPos:TPoint; var Direction:TDirection; var StartPos:TPoint; Poly:TArray):Boolean;
   function CheckCell(SPos:TPoint):Boolean;
   function GetPos(SPos:TPoint):Byte;
   function CheckPos(SPos:TPoint; var Direction:TDirection; ShipSize:Byte):Boolean;
   function CheckInsert(SPos:TPoint; Direction:TDirection; ShipSize:Byte):Boolean;
   function InsertCheck(SPos:TPoint):Boolean;
   function GetScore:Byte;
   function AnalysInput(Text:string):Boolean;
  end;
  TBitmaps = class                                                              //Текстуры
   public
    ResultPanel:TBitmap;                                                        //Панель результата
    BackGround:TBitmap;                                                         //Вода
    FormBrush:TBitmap;                                                          //Оболочка
    Past:TPNGObject;                                                            //Мимо
    Wou:TPNGObject;                                                             //Ранил
    Kill:TPNGObject;                                                            //Убил
    UPast:TPNGObject;                                                           //Здесь нет корабля
    Water:TBitmap;                                                              //Временное изображение клетки
    ListItem:TBitmap;                                                           //Временное изображение элемента списка
    DrawBMP:TBitmap;
    MCursor:TPNGObject;
    Ships:array[1..4] of TPNGObject;                                            //Корабли
    Results:array[0..3] of TPNGObject;                                          //Медали
    ShipsPics:array[1..44] of TPNGObject;
    Ani1:array[1..9] of TPNGObject;
    Fire:array[1..8] of TPNGObject;
    function LoadSkinFromDll(DllName:string):Boolean;
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
  CompDirs:TArray;
  PlayerDirs:TArray;
  Poly:TArray;      //Основное поле, через которое изменяются другие
  Radar:TArray;
  Game:TGame;
  Need:Boolean;     //Перетаскивание возможно
  Bitmaps:TBitmaps;
  Path:String;
  RuChars:array[1..10] of Char = ('А','Б','В','Г','Д','Е','Ж','З','И','К');
  Answer:string;
  Wins, Loses:Word;
  MCur:TPoint;
  SleepTime:Word;
  CompName,
  PlayerName:string;
  Score:Byte;
  GodMode, DoUp:Boolean;
  CurAni:Byte;
  CurFire:Byte;

  //
  NotCensorshipList:TStrings;

  //


  function GetRect(L, T, R, B:Integer):TRect;

implementation
 uses SetShip;

{$R *.dfm}

function TGame.CalcBusy(APoly:TKillArray):Byte;
var i,j:Byte;
begin
 Result:=0;
 for j:=1 to 10 do
  for i:=1 to 10 do
   if APoly[i,j] <> AEmpty then Inc(Result);
end;

function TGame.FindPosForShip(SSize:Byte; APoly:TKillArray; var ALogicPoses:TLogicPoses):Byte;
var i, j, S1, S2, k:Byte;
begin
 Result:=0;
 for j:=1 to 10 do
  for i:=1 to 10 do
   begin
    S1:=0;
    S2:=0;
    for k:= 0 to (SSize-1) do
     begin
      if j+k <= 10 then if APoly[i, j+k] = aEmpty then Inc(S1);
      if i+k <= 10 then if APoly[i+k, j] = aEmpty then Inc(S2);
     end;
    if (S1 = SSize) then
     begin
      if Result+1 > 100 then Exit;
      Inc(Result);
      ALogicPoses[Result].SPos:=Point(i,j);
      ALogicPoses[Result].SDir:=tdDown;
     end;
    if (S2 = SSize) then
     begin
      if Result+1 > 100 then Exit;
      Inc(Result);
      ALogicPoses[Result].SPos:=Point(i,j);
      ALogicPoses[Result].SDir:=tdRight;
     end;
   end;
end;

procedure TGame.GoSound(SoundType:TSoundType);
var TP:Cardinal;
begin //kill 3 //lose 2 //shoot 10 //win 1 //wou 3
 if NoSound then Exit;
 TP:=SND_ASYNC;
 try
  case SoundType of
   stShoot: Exit;
   stKill: PlaySound(PChar(Path+'Sound\kill.wav'), 0, TP);
   stWound: PlaySound(PChar(Path+'Sound\wound.wav'), 0, TP);
   stWin: PlaySound(PChar(Path+'Sound\win.wav'), 0, TP);
   stLose: PlaySound(PChar(Path+'Sound\lose'+IntToStr(Random(2)+1)+'.wav'), 0, TP);
   stPast: PlaySound(PChar(Path+'Sound\past.wav'), 0, TP);
  end;
 except
  NoSound:=True;
 end;
end;

function GetRect(L, T, R, B:Integer):TRect;
begin
 Result:=Rect(L, T, R, B);
end;

procedure TGame.SetStatus(Win:Boolean);
begin
 with FormMain do
  begin
   if Win then LabelLosesV.Caption:='Победа' else LabelLosesV.Caption:='Поражение';
   LabelWinsV.Caption:='Счет: '+IntToStr(Loses)+':'+IntToStr(Wins)+' Очки: '+IntToStr(LastScore);
  end;
end;

procedure TGame.OnCompWin;
begin
 with FormMain do
  begin
   Status:=tsEnd;
   Score:=0;
   PanelResult.Show;
   Inc(Loses);
   TimerTime.Enabled:=False;
   LastScore:=0;
   TimeGame:=0;
  end;
 GoSound(stLose);
 SetStatus(False);
end;

function TGame.GetScore:Byte;
var i,j:Byte;
 Pasts:Byte;
begin
 Pasts:=0;
 for i:=1 to 10 do
  for j:=1 to 10 do if CompKill[i,j] = aPast then Inc(Pasts);
 case Pasts of
  0..27:Result:=3;
  28..54:Result:=2;
  55..81:Result:=1;
 else
  Result:=0;
 end;
 LastScore:=81-Pasts;
end;

procedure TGame.OnPlayerWin;
begin
 Status:=tsEnd;
 with FormMain do
  begin
   Score:=GetScore;
   PanelResult.Show;
   Inc(Wins);
   WriteIt(CompName+': =(', itLeadComp);
   TimerTime.Enabled:=False;
   TimeGame:=0;
  end;
 GoSound(stWin);
 SetStatus(True);
end;

procedure TFormMain.CreateParams(var Params: TCreateParams);
const CS_DROPSHADOW = $00020000;
begin
 inherited;
 Params.WindowClass.Style:=Params.WindowClass.Style or CS_DROPSHADOW;
end;

procedure TGame.WriteIt(Text:string; InfoType:TInfoType);
procedure AWrite;
begin
 if FormMain.ListBoxPos.Count = 26 then FormMain.ListBoxPos.Items.Delete(0);
 FormMain.ListBoxPos.Items.Add(Text);
end;
begin
 case InfoType of
  itLeadPlayer: if Settings.ShowLeadPlayer then AWrite;
  itLeadComp:   if Settings.ShowLeadComp   then AWrite;
  itTalk:       if Settings.ShowCompTalk   then AWrite;
 else
  AWrite;
 end;
end;

procedure TGame.ClearList;
begin
 FormMain.ListBoxPos.Clear;
end;

procedure TGame.GetRandomCompName;
var OldName:string;
begin
 Randomize;
 OldName:=CompName;
 repeat
  case Random(10) of
   0:CompName:='Вася';
   1:CompName:='Курт';
   2:CompName:='Марк';
   3:CompName:='Хан';
   4:CompName:='Хантер';
   5:CompName:='Дед';
   6:CompName:='Горн';
   7:CompName:='Дэйв';
   8:CompName:='Кен';
   9:CompName:='Трэвис';
  end;
 until OldName <> CompName;
end;

procedure TGame.New;
var i,j:Byte;
begin
 Randomize;
 SetShips;
 Comp:=Poly;
 MCur:=Point(0,0);
 for i:=1 to 10 do
  for j:=1 to 10 do PlayerDirs[i,j]:=GetInfo(i, j, Comp, PlayerDirs);
 CompLastShoot:=Point(0,0);
 Lead:=tlPlayer;
 LastShoots.Last:=Point(0, 0);
 Status:=tsPlay;
 for i:=1 to 4 do
  begin
   PlayerShips[i]:=5-i;
   CompShips[i]:=5-i;
  end;
 case Random(6) of
  0:WriteIt(CompName+': Ходи', itLeadComp);
  1:WriteIt(CompName+': Ходите', itLeadComp);
  2:WriteIt(CompName+': Твой ход', itLeadComp);
  3:WriteIt(CompName+': Вперед!', itLeadComp);
  4:WriteIt(CompName+': GO', itLeadComp);
  5:WriteIt(CompName+': Игра началась, ходи', itLeadComp);
  6:WriteIt(CompName+': Твой залп первый!', itLeadComp);
 end;
 FormMain.TimerTime.Enabled:=True;
 FormMain.TimerGo.Enabled:=True;
 FormMain.DrawGridComp.SetFocus;
end;

constructor TBitmaps.Create;
var i:Byte;
begin
 ResultPanel:=TBitmap.Create;
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
 MCursor:=TPNGObject.Create;
 Water:=TBitmap.Create;
 Water.Height:=24;
 Water.Width:=24;
 ListItem:=TBitmap.Create;
 DrawBMP:=TBitmap.Create;
 DrawBMP.Height:=24;
 DrawBMP.Width:=24;
 Results[0]:=TPNGObject.Create;
 Results[1]:=TPNGObject.Create;
 Results[2]:=TPNGObject.Create;
 Results[3]:=TPNGObject.Create;
 for i:=1 to 44 do ShipsPics[i]:=TPNGObject.Create;
 for i:=1 to 9 do Ani1[i]:=TPNGObject.Create;
 for i:=1 to 8 do Fire[i]:=TPNGObject.Create;
 inherited;
end;

procedure TFormMain.WMNCHitTest (var M:TWMNCHitTest);
begin
 inherited;
 if (M.Result = htClient) and Need then M.Result := htCaption;
end;

function TBitmaps.LoadSkinFromDll(DllName:string):Boolean;
var DLL:Cardinal;
 i:Byte;
begin
 Dll:=LoadLibrary(PChar(Dllname));
 if DLL = 0 then
  begin
   MessageBox(FormMain.Handle, 'Отсутствуют необходимые текстуры!'+#13+#10+'Программа будет закрыта.', '', MB_ICONSTOP or MB_OK);
   FreeLibrary(Dll);
   Application.Terminate;
   Result:=False;
   Exit;
  end;
 try
  ResultPanel.LoadFromResourceName(DLL, 'panel');
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
  MCursor.LoadFromResourceName(DLL, 'TARGET');
  for i:=1 to 40 do ShipsPics[i].LoadFromResourceName(DLL, 'S'+IntToStr(i));
  for i:=41 to 44 do ShipsPics[i].LoadFromResourceName(DLL, 'SHIP'+IntToStr(i-40));
  for i:=1 to 9 do Ani1[i].LoadFromResourceName(DLL, 'A'+IntToStr(i));
  for i:=1 to 8 do Fire[i].LoadFromResourceName(DLL, 'F'+IntToStr(i));
  with FormMain do
   begin
    ButtonClose.ImageNormal.LoadFromResourceName(DLL, 'close');
    ButtonHide.ImageNormal.LoadFromResourceName(DLL,  'hide');
    ButtonNew.ImageNormal.LoadFromResourceName(DLL,   'new');
    ButtonHelp.ImageNormal.LoadFromResourceName(DLL,  'user');
    Screen.Cursors[1]:=LoadCursor(DLL, 'SHOOT');
    Screen.Cursors[2]:=LoadCursor(DLL, 'DRAG_HAND');
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
    CompDirs[i,j]:=0;
    PlayerDirs[i,j]:=0;
   end;
 Player:=Poly;
 Comp:=Poly;
 FormMain.PanelResult.Hide;
 FormMain.ListBoxPos.Clear;
 IsNextShoot:=False;
end;

procedure TFormMain.DrawGridPolyDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);

var W, H:Byte;

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
   Bitmaps.DrawBMP.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.FormBrush.Canvas, GetCurRect);
   DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.DrawBMP);
   Exit;
  end;
 if (ACol=0) or (ACol=11) then
  begin
   Bitmaps.DrawBMP.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.FormBrush.Canvas, GetCurRect);
   Bitmaps.DrawBMP.Canvas.Font.Name:='Segoe UI';
   Bitmaps.DrawBMP.Canvas.Font.Style:=[];
   Bitmaps.DrawBMP.Canvas.Brush.Style:=bsClear;
   W:=Bitmaps.DrawBMP.Canvas.TextWidth(IntToStr(ARow));
   H:=Bitmaps.DrawBMP.Canvas.TextHeight(IntToStr(ARow));
   Bitmaps.DrawBMP.Canvas.TextOut(12 - (W div 2), 12 - (H div 2), IntToStr(ARow));
   DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.DrawBMP);
   Exit;
  end;
 if (ARow=0) or (ARow=11) then
  begin
   Bitmaps.DrawBMP.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.FormBrush.Canvas, GetCurRect);
   Bitmaps.DrawBMP.Canvas.Font.Name:='Segoe UI';
   Bitmaps.DrawBMP.Canvas.Font.Style:=[];
   Bitmaps.DrawBMP.Canvas.Brush.Style:=bsClear;
   W:=Bitmaps.DrawBMP.Canvas.TextWidth(RuChars[ACol]);
   H:=Bitmaps.DrawBMP.Canvas.TextHeight(RuChars[ACol]);
   Bitmaps.DrawBMP.Canvas.TextOut(12 - (W div 2), 12 - (H div 2), RuChars[ACol]);
   DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.DrawBMP);
   Exit;
  end;
 Bitmaps.DrawBMP.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.FormBrush.Canvas, GetCurRect);
 if (Game.LastShoots.Last.X = ACol) and (Game.LastShoots.Last.Y = ARow) then Bitmaps.DrawBMP.Canvas.Draw(0,0, Bitmaps.Ani1[CurAni]);
 if Player[ACol, ARow] in [1..4] then Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.ShipsPics[CompDirs[ACol, ARow]]);

 case PlayerKill[ACol, ARow] of
  aPast: Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Past);
  aWound:Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Fire[CurFire]);
  aKill: Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Fire[CurFire]);
  aUser: Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.UPast);
 end;
 DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.DrawBMP);
end;

procedure TFormMain.FormCreate(Sender: TObject);

function GetCurRect:TRect;
begin
 Result.Left:=EditInput.Left;
 Result.Top:=EditInput.Top;
 Result.Right:=Result.Left+EditInput.Width;
 Result.Bottom:=Result.Top+EditInput.Height;
end;

begin
 CurAni:=1;
 CurFire:=1;
 ClientHeight:=361;
 ClientWidth:=925;
 DrawGridPoly.Width:=299;
 DrawGridPoly.Height:=299;
 DrawGridPoly.Top:=35;
 DrawGridPoly.Left:=250;
 ListBoxHelp.Width:=299;
 ListBoxHelp.Height:=299;
 ListBoxHelp.Top:=35;
 ListBoxHelp.Left:=250;
 DrawGridComp.Height:=299;
 DrawGridComp.Width:=299;
 DrawGridComp.Left:=590;
 DrawGridComp.Top:=35;
 LabelTime.Left:=546;
 LabelTime.Top:=336;
 LabelTime.Height:=19;
 LabelXP.Height:=19;
 LabelXP.Top:=336;
 LabelXP.Left:=834;
 PanelHelp.Height:=97;
 PanelHelp.Width:=289;
 ButtonNew.Left:=595;
 EditInput.Left:=616;
 ButtonHelp.Left:=857;
 ButtonHide.Left:=878;
 PanelHelp.Top:=232;
 PanelHelp.Left:=256;
 ListBoxPos.Width:=241;
 ButtonClose.Left:=899;
 EditInput.Width:=237;
 EditInput.Top:=2;
 EditInput.Height:=20;
 //LabelTime.Font.Name:='Techno28';
 PlayerName:='Игрок';
 SleepTime:=0;
 Need:=True;
 SetWindowRgn(Handle, CreateRoundRectRgn(0, 0, Width, Height, 20, 20), True);
 SetWindowRgn(PanelResult.Handle, CreateRoundRectRgn(0, 0, PanelResult.Width, PanelResult.Height, 20, 20), True);
 Bitmaps:=TBitmaps.Create;
 Bitmaps.LoadSkinFromDll(Path+'Graphics\default.dll');
 Brush.Bitmap:=Bitmaps.FormBrush;
 ListBoxPos.Brush.Bitmap:=TBitmap.Create;
 ListBoxPos.Brush.Bitmap.Height:=ListBoxPos.Height;
 ListBoxPos.Brush.Bitmap.Width:=ListBoxPos.Width;
 ListBoxPos.Brush.Bitmap.Canvas.CopyRect(Rect(0, 0, ListBoxPos.Width, ListBoxPos.Height), Bitmaps.FormBrush.Canvas, Rect(ListBoxPos.Left, ListBoxPos.Top, ListBoxPos.Left+ListBoxPos.Width, ListBoxPos.Top+ListBoxPos.Height));

 ListBoxHelp.Brush.Bitmap:=TBitmap.Create;
 ListBoxHelp.Brush.Bitmap.Height:=ListBoxHelp.Height;
 ListBoxHelp.Brush.Bitmap.Width:=ListBoxHelp.Width;
 ListBoxHelp.Brush.Bitmap.Canvas.CopyRect(Rect(0, 0, ListBoxHelp.Width, ListBoxHelp.Height), Bitmaps.FormBrush.Canvas, Rect(ListBoxHelp.Left, ListBoxHelp.Top, ListBoxHelp.Left+ListBoxHelp.Width, ListBoxHelp.Top+ListBoxHelp.Height));
 PanelResult.Brush.Bitmap:=Bitmaps.ResultPanel;
 
 PanelHelp.Brush.Bitmap:=TBitmap.Create;
 PanelHelp.Brush.Bitmap.Height:=PanelHelp.Height;
 PanelHelp.Brush.Bitmap.Width:=PanelHelp.Width;
 PanelHelp.Canvas.Brush.Style:=bsClear;
 PanelHelp.Brush.Bitmap.Canvas.CopyRect(Rect(0, 0, PanelHelp.Width, PanelHelp.Height), Bitmaps.FormBrush.Canvas, Rect(PanelHelp.Left, PanelHelp.Top, PanelHelp.Left+PanelHelp.Width, PanelHelp.Top+PanelHelp.Height));

 Game:=TGame.Create;
 Game.GetRandomCompName;
 Game.Status:=tsEnd;
 Game.ClearAll;
 Game.Settings.ShowCompTalk:=True;
 Game.Settings.ShowLeadPlayer:=True;
 Game.Settings.ShowLeadComp:=True;
 Wins:=0;
 Loses:=0;

 Game.WriteIt('Добро пожаловать на "Морской Бой"', itGame);
 Game.WriteIt('С вами будет играть '+CompName+'.', itGame);
 Game.WriteIt('Поприветствуйте его, назовите', itGame);
 Game.WriteIt('свое имя, или будьте просто игроком', itGame);
end;

procedure TFormMain.DrawGridCompDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var W,H:Byte;

function GetCurRect:TRect;
begin
 Result.Left:=DrawGridComp.Left+Rect.Left;
 Result.Top:=DrawGridComp.Top+Rect.Top;
 Result.Right:=Result.Left+24;
 Result.Bottom:=Result.Top+24;
end;
begin
 if ((ACol=0) and (ARow=0)) or ((ACol=11) and (ARow=11)) or ((ACol=11) and (ARow=0)) or ((ACol=0) and (ARow=11)) then
  begin
   Bitmaps.DrawBMP.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.FormBrush.Canvas, GetCurRect);
   if (MCur.X = ACol) and (MCur.Y = ARow) then Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Ani1[CurAni]);
   DrawGridComp.Canvas.StretchDraw(Rect, Bitmaps.DrawBMP);
   Exit;
  end;
 if (ACol=0) or (ACol=11) then
  begin
   Bitmaps.DrawBMP.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.FormBrush.Canvas, GetCurRect);
   if (MCur.X = ACol) and (MCur.Y = ARow) then Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Ani1[CurAni]);
   Bitmaps.DrawBMP.Canvas.Font.Name:='Segoe UI';
   Bitmaps.DrawBMP.Canvas.Brush.Style:=bsClear;
   W:=Bitmaps.DrawBMP.Canvas.TextWidth(IntToStr(ARow));
   H:=Bitmaps.DrawBMP.Canvas.TextHeight(IntToStr(ARow));
   Bitmaps.DrawBMP.Canvas.TextOut(12 - (W div 2), 12 - (H div 2), IntToStr(ARow));
   DrawGridComp.Canvas.StretchDraw(Rect, Bitmaps.DrawBMP);
   Exit;
  end;
 if (ARow=0) or (ARow=11) then
  begin
   Bitmaps.DrawBMP.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.FormBrush.Canvas, GetCurRect);
   if (MCur.X = ACol) and (MCur.Y = ARow) then Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Ani1[CurAni]);
   Bitmaps.DrawBMP.Canvas.Font.Name:='Segoe UI';
   Bitmaps.DrawBMP.Canvas.Brush.Style:=bsClear;
   W:=Bitmaps.DrawBMP.Canvas.TextWidth(RuChars[ACol]);
   H:=Bitmaps.DrawBMP.Canvas.TextHeight(RuChars[ACol]);
   Bitmaps.DrawBMP.Canvas.TextOut(12 - (W div 2), 12 - (H div 2), RuChars[ACol]);
   DrawGridComp.Canvas.StretchDraw(Rect, Bitmaps.DrawBMP);
   Exit;
  end;
 Bitmaps.DrawBMP.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.FormBrush.Canvas, GetCurRect);
 if (Game.Status=tsEnd) and (Comp[ACol, ARow] in [1..4]) then
  Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.ShipsPics[PlayerDirs[ACol, ARow]]);
 if Radar[ACol, ARow] in [1..4] then Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Kill);
 case CompKill[ACol, ARow] of
  aPast:Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Past);
  aWound:Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Fire[CurFire]);
  aKill:
   begin
    Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.ShipsPics[PlayerDirs[ACol, ARow]]);
    Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Fire[CurFire]);
   end;
  aUser:Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.UPast);
 end;
 if (MCur.X = ACol) and (MCur.Y = ARow) then Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Ani1[CurAni]);
 DrawGridComp.Canvas.StretchDraw(Rect, Bitmaps.DrawBMP);
end;

function TGame.CheckFullPoly:Boolean;
begin
 Result:=Ships[1] = 0;
end;

function TGame.GetCurShip:Byte;
var i:Byte;
begin
 for i:=4 downto 1 do if Ships[i]<>0 then Break;
 Result:=i;
end;

function TGame.ShipIsAllWound(SPos:TPoint; Direction:TDirection; var Poly:TKillArray; SSize:Byte):Boolean;
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

procedure TGame.KillShip(SPos:TPoint; Direction:TDirection; var Poly:TKillArray; SSize:Byte; Whose:TLead);
var i:Byte;
begin
 case Direction of
  tdLeft:  for i:= 0 to SSize-1 do Poly[SPos.X-i, SPos.Y ]:=aKill;
  tdRight: for i:= 0 to SSize-1 do Poly[SPos.X+i, SPos.Y ]:=aKill;
  tdUp:    for i:= 0 to SSize-1 do Poly[SPos.X , SPos.Y-i]:=aKill;
  tdDown:  for i:= 0 to SSize-1 do Poly[SPos.X , SPos.Y+i]:=aKill;
 end;
 case Whose of
  tlPlayer:Game.PlayerShips[SSize]:=Game.PlayerShips[SSize]-1;
  tlComp:Game.CompShips[SSize]:=Game.CompShips[SSize]-1;
 end;
end;

procedure TGame.DrawAll(Who:TLead);
begin
 with FormMain do
  case Who of
   tlComp:  DrawGridPoly.Repaint;
   tlPlayer:DrawGridComp.Repaint;
  end;
end;

function TGame.PlayerShoot(SPos:TPoint; var Got:Boolean):Boolean;
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
    Game.GetShipPos(SPos, Dir, StartPos, Comp);
    Size:=Comp[SPos.X, SPos.Y];
    if ShipIsAllWound(StartPos, Dir, CompKill, Size) then
     begin
      KillShip(StartPos, Dir, CompKill, Size, tlComp);
      Game.DrawAll(tlPlayer);
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

function TGame.CompShoot(SPos:TPoint; var Got:Boolean):Boolean;
var Dir:TDirection;
    StartPos:TPoint;
    Size:Byte;
begin
 Result:=False;
 if Status = tsEnd then Exit;
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
      KillShip(StartPos, Dir, PlayerKill, Size, tlPlayer);
      DrawAll(tlComp);
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

procedure TGame.PlayerPast(SPos:TPoint);
begin
 case CompKill[SPos.X, SPos.Y] of
  aUser:CompKill[SPos.X, SPos.Y]:=aEmpty;
  aEmpty:CompKill[SPos.X, SPos.Y]:=aUser;
 end;
 FormMain.DrawGridComp.OnDrawCell(nil, SPos.X, SPos.Y, Rect((SPos.X*24)+SPos.X, (SPos.Y*24)+SPos.Y, (SPos.X*24)+24+SPos.X, (SPos.Y*24)+24+SPos.Y), [gdFixed]);
 //DrawAll(tlPlayer);
end;

procedure TGame.Input(SPos:TPoint);
var Got:Boolean;
begin
 with FormMain do
  begin
   if not PlayerShoot(SPos, Got) then Exit;
   GoSound(stShoot);
   Waiting;
   WriteIt(PlayerName+': '+RuChars[SPos.X]+'-'+IntToStr(SPos.Y), itLeadPlayer);
   if not Got then
    begin
     GoSound(stPast);
     WriteIt(CompName+': Мимо', itLeadComp);
     Lead:=tlComp;
     DrawAll(tlPlayer);
     CompShoot.Execute;
     //DoCompShoot;
     Exit;
    end
   else
    if CompKill[SPos.X, SPos.Y]=aKill then
     begin
      GoSound(stKill);
      WriteIt(CompName+': Убил', itLeadComp);
      InsertPastForUser(SPos);
      DrawAll(tlPlayer);
      if CheckComp then OnPlayerWin;
     end
    else
     begin
      GoSound(stWound);
      WriteIt(CompName+': Попал', itLeadComp);
     end;
  end;
end;

procedure TGame.ActionTorpedo(NPos:TPoint);
var Got:Boolean;
 SPos:TPoint;
 i:Byte;
begin
 with FormMain do
  begin
   for i:=NPos.X to NPos.X+5 do
    begin
      if i >= 11 then Break;
      SPos.X:=i;
      SPos.Y:=NPos.Y;
      if (PlayerShoot(SPos, Got)) then
       begin
        if Got then
         begin
          DrawAll(tlPlayer);
          if CompKill[SPos.X, SPos.Y]=aKill then
           begin
            WriteIt(CompName+': Убил', itLeadComp);
            InsertPastForUser(SPos);
            DrawAll(tlPlayer);
            if CheckComp then OnPlayerWin;
           end
          else WriteIt(CompName+': Попал', itLeadComp);
          Exit;
         end;
       end;
     DrawAll(tlPlayer);  
     Waiting(600);
    end;
   Lead:=tlComp;
   CompShoot.Execute;
   //DoCompShoot;
   DrawAll(tlPlayer);
  end;
end;

procedure TGame.ActionRadar(SPos:TPoint);
var i,j:SmallInt;
begin
 for i:=-1 to 1 do
  for j:=-1 to 1 do
   begin
    Radar[SPos.X+i, SPos.Y+j]:=Comp[SPos.X+i, SPos.Y+j];
   end;
 FormMain.TimerClearRadar.Enabled:=True;  
end;

procedure TFormMain.DrawGridCompMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var SPos:TPoint;
 ACol, ARow:Integer;
begin
 if Game.Status <> tsPlay then
  begin
   ActionNewGame.Execute;
   Exit;
  end;
 TimerGo.Enabled:=False;
 TimerGo.Interval:=30000;
 DrawGridComp.MouseToCell(X, Y, ACol, ARow);
 if (ACol = 0) or (ARow = 0) or (ARow = 11) or (ACol = 11) then Exit;
 case Button of
  mbLeft:
   begin
    if (Game.Status = tsPlay) and (Game.Lead=tlPlayer) then
     begin
      SPos.X:=ACol;
      SPos.Y:=ARow;
      MCur:=SPos;
      Game.Input(SPos);
     end;
   end;
  mbRight:
   begin
    if (Game.Status = tsPlay) then
     begin
      SPos.X:=ACol;
      SPos.Y:=ARow;
      if (ssCtrl in Shift) and (CompKill[SPos.X, SPos.Y] = aKill) then
       begin
        Game.InsertPastForUser(SPos);
        Game.DrawAll(tlPlayer);
        TimerGo.Enabled:=True;
        Exit;
       end;
      Game.PlayerPast(SPos);
     end;
   end;
  mbMiddle:
   begin
    if not GodMode then Exit;
    SPos.X:=ACol;
    SPos.Y:=ARow;
    //Game.ActionTorpedo(SPos);
    Game.ActionRadar(SPos);
   end;
 end;
 TimerGo.Enabled:=True;
end;

function TGame.GetShipPos(SPos:TPoint; var Direction:TDirection; var StartPos:TPoint; Poly:TArray):Boolean;
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
 if (CheckCell(Point(SPos.X, SPos.Y-1))) and (Poly[SPos.X, SPos.Y-1]=Ship) then Direction:=tdUp else
 if (CheckCell(Point(SPos.X, SPos.Y+1))) and (Poly[SPos.X, SPos.Y+1]=Ship) then Direction:=tdDown else
 if (CheckCell(Point(SPos.X-1, SPos.Y))) and (Poly[SPos.X-1, SPos.Y]=Ship) then Direction:=tdLeft else
 if (CheckCell(Point(SPos.X+1, SPos.Y))) and (Poly[SPos.X+1, SPos.Y]=Ship) then Direction:=tdRight
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

function TGame.CheckPlayer:Boolean;
var i,j:Byte;
 Ships:set of Byte;
begin
 Result:=False;
 Ships:=[1..4];
 for i:=1 to 10 do
  for j:=1 to 10 do if Player[i,j] in Ships then if PlayerKill[i,j]<>aKill then Exit;
 Result:=True;
end;

function TGame.CheckComp:Boolean;
var i,j:Byte;
 Ships:set of Byte;
begin
 Result:=False;
 Ships:=[1..4];
 for i:=1 to 10 do
  for j:=1 to 10 do if Comp[i,j] in Ships then if CompKill[i,j]<>aKill then Exit;
 Result:=True;
end;

function TGame.GetNextShoot(LastShoot:TPoint):TPoint;
var FirstDir:Byte;
 Used:set of TDirection;
 DPos:TPoint;
begin
 Used:=CompUsedDir;
 Randomize;
 if (LastShoot.X = 0) or (LastShoot.Y = 0) then
  begin
   IsNextShoot:=False;
   Result:=Point(1, 1);
   Exit;
  end;
 if LastShoots.Use then
  begin
   case LastDir of
    tdLeft: LastDir:=tdRight;
    tdRight:LastDir:=tdLeft;
    tdUp:   LastDir:=tdDown;
    tdDown: LastDir:=tdUp;
   end;
   UseLastDir:=True;
   LastShoot:=LastShoots.Shoots[1];
  end;

 repeat
  if (not UseLastDir) or (LastDir in Used) then
   repeat FirstDir:=Random(4) until (not (TDirection(FirstDir) in Used)) or (Used = [tdLeft, tdRight, tdUp, tdDown])
  else FirstDir:=Ord(LastDir);
  case TDirection(FirstDir) of
   tdLeft:
    begin
     DPos:=Point(LastShoot.X-1, LastShoot.Y);
     while PlayerKill[DPos.X, DPos.Y] = aWound do Dec(DPos.X);

     if (PlayerKill[DPos.X, DPos.Y] <> aPast) and
        (PlayerKill[DPos.X, DPos.Y] <> aUser)
     then
      if (CheckCell(DPos)) then
       begin
        LastDir:=tdLeft;
        Result:=DPos;
        Exit;
       end
      else
       begin
        DPos:=LastShoot;
        LastDir:=tdRight;
        UseLastDir:=True;
        Include(Used, tdLeft);
        Continue;
       end
     else Include(Used, tdLeft);
    end;
  tdRight:
    begin
     DPos:=Point(LastShoot.X+1, LastShoot.Y);
     while PlayerKill[DPos.X, DPos.Y] = aWound do Inc(DPos.X);
     if (PlayerKill[DPos.X, DPos.Y] <> aPast) and
        (PlayerKill[DPos.X, DPos.Y] <> aUser)
     then
      if (CheckCell(DPos)) then
       begin
        LastDir:=tdRight;
        Result:=DPos;
        Exit;
       end
      else
       begin
        DPos:=LastShoot;
        LastDir:=tdLeft;
        UseLastDir:=True;
        Include(Used, tdRight);
        Continue;
       end
     else Include(Used, tdRight);
    end;
   tdUp:
    begin
     DPos:=Point(LastShoot.X, LastShoot.Y-1);
     while PlayerKill[DPos.X, DPos.Y] = aWound do Dec(DPos.Y);
     if (PlayerKill[DPos.X, DPos.Y] <> aPast) and
        (PlayerKill[DPos.X, DPos.Y] <> aUser)
     then
      if (CheckCell(DPos)) then
       begin
        LastDir:=tdUp;
        Result:=DPos;
        Exit;
       end
      else
       begin
        DPos:=LastShoot;
        LastDir:=tdDown;
        UseLastDir:=True;
        Include(Used, tdUp);
        Continue;
       end
     else Include(Used, tdUp);
    end;
   tdDown:
    begin
     DPos:=Point(LastShoot.X, LastShoot.Y+1);
     while PlayerKill[DPos.X, DPos.Y] = aWound do Inc(DPos.Y);
     if (PlayerKill[DPos.X, DPos.Y] <> aPast) and
        (PlayerKill[DPos.X, DPos.Y] <> aUser)
     then
      if (CheckCell(DPos)) then
       begin
        LastDir:=tdDown;
        Result:=DPos;
        Exit;
       end
      else
       begin
        DPos:=LastShoot;
        LastDir:=tdUp;
        UseLastDir:=True;
        Include(Used, tdDown);
        Continue;
       end
     else Include(Used, tdDown);
    end;
  end;
 until Used = [tdLeft, tdRight, tdUp, tdDown];
 CompUsedDir:=Used;
end;

procedure TGame.InsertPast(Ship:TPoint);
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
 if not Game.GetShipPos(Ship, Dir, SPos, Player) then Exit;
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

procedure TGame.InsertPastForUser(Ship:TPoint);
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

procedure TGame.Waiting;
var CTime:Cardinal;
begin
 FormMain.DrawGridComp.Enabled:=False;
 CTime:=GetTickCount+SleepTime;
 while GetTickCount<CTime do Application.ProcessMessages;
 FormMain.DrawGridComp.Enabled:=True;
end;

procedure TGame.Waiting(ATime:Cardinal);
var CTime:Cardinal;
begin
 FormMain.DrawGridComp.Enabled:=False;
 CTime:=GetTickCount+ATime;
 while GetTickCount<CTime do Application.ProcessMessages;
 FormMain.DrawGridComp.Enabled:=True;
end;

procedure TGame.DoCompShoot;
var SPos:TPoint;
   Got:Boolean;
   i, CPos, LogicID:Byte;
begin
 GoSound(stShoot);
 if not IsNextShoot then                                                        //Если нет рассчитанного хода, то
  begin
   if //(CalcBusy(PlayerKill) >= 45) and                                          //Если кол-во свободных ячеек меньше 55 и
      ((PlayerShips[4] > 0) or                                                  //кол-во 4-х или 3-х или 2-х кораблей больше 0, то
       (PlayerShips[3] > 0) or                                                  //ищем возможную позицию большего корабля
       (PlayerShips[2] > 0))
   then
    begin
     for i:=4 downto 2 do
      begin
       if PlayerShips[i] > 0 then
        begin
         CPos:=FindPosForShip(i, PlayerKill, LogicPoses);
         if CPos > 0 then
          begin
           LogicID:=Random(CPos-1)+1;
           SPos:=LogicPoses[LogicID].SPos;
           LastDir:=LogicPoses[LogicID].SDir;
           case LastDir of
            tdDown:SPos.Y:=SPos.Y+Random(2);
            tdRight:SPos.X:=SPos.X+Random(2);
           end;
           UseLastDir:=True;
           Break;
          end;
        end;
      end;
    end
   else
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
 LastShoots.Last:=SPos;
 Waiting;
 WriteIt(CompName+': '+RuChars[SPos.X]+'-'+IntToStr(SPos.Y), itLeadComp);
 CompShoot(SPos, Got);
 DrawAll(tlComp);
 if Got then
  begin
   if PlayerKill[SPos.X, SPos.Y]=aKill then
    begin
     GoSound(stKill);
     Waiting;
     WriteIt(PlayerName+': Убил', itLeadPlayer);
     InsertPast(SPos);
     DrawAll(tlComp);
     LastShoots.ShipSize:=0;
     LastShoots.Use:=False;
     IsNextShoot:=False;
     IsNS:=False;
     CompUsedDir:=[];
     if CheckPlayer then
      begin
       Status:=tsEnd;
       WriteIt(CompName+': =)', itLeadComp);
       OnCompWin;
       IsNextShoot:=False;
       Exit;
      end;
    end
   else
    begin
     GoSound(stWound);
     Waiting;
     WriteIt(PlayerName+': Попал', itLeadPlayer);
     DrawAll(tlComp);
     Inc(LastShoots.ShipSize);
     LastShoots.Shoots[LastShoots.ShipSize]:=SPos;
     LastShoots.Use:=False;
     UseLastDir:=IsNS;
     IsNextShoot:=True;
    end;
   CompLastShoot:=SPos;
   Waiting;
   FormMain.CompShoot.Execute;
   FormMain.DrawGridComp.SetFocus;
   //DoCompShoot;
   Exit;
  end
 else
  begin
   GoSound(stPast);
   Lead:=tlPlayer;
   WriteIt(PlayerName+': Мимо', itLeadPlayer);
   LastShoots.Use:=IsNS;
   Include(CompUsedDir, LastDir);
   UseLastDir:=False;
   if not IsNS then CompUsedDir:=[];
  end;
 FormMain.DrawGridComp.SetFocus;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
 TimerGo.Enabled:=True;
 DrawGridComp.SetFocus;
end;

procedure TFormMain.ListBoxPosDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var DRect, WRect:TRect;
begin
 DRect.Left:=0;
 DRect.Top:=0;
 DRect.Right:=ListBoxPos.Width;
 DRect.Bottom:=ListBoxPos.ItemHeight;
 Bitmaps.ListItem.Width:=ListBoxPos.Width;
 Bitmaps.ListItem.Height:=ListBoxPos.ItemHeight;
 WRect:=Rect;
 WRect.Top:=WRect.Top+ListBoxPos.Top;
 WRect.Bottom:=WRect.Bottom+ListBoxPos.Top;
 Bitmaps.ListItem.Canvas.CopyRect(DRect, Bitmaps.FormBrush.Canvas, WRect);
 ListBoxPos.Canvas.StretchDraw(Rect, Bitmaps.ListItem);
 ListBoxPos.Canvas.Brush.Style:=bsClear;
 ListBoxPos.Canvas.TextOut(Rect.Left+3, Rect.Top, ListBoxPos.Items.Strings[index]);
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
 ActionNewGame.Execute;
end;

function TGame.AnalysInput(Text:string):Boolean;                                      //Проверка сообщения на принадлежность к ходу,
var SPos:TPoint;                                                                //в противном случае передача на обработку сообщения
   Num:string;
   IntNum:Byte;
begin
 Result:=False;
 if Text = '' then Exit;
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
 Game.Input(SPos);
 Result:=True;
end;

procedure TGame.AnalysAnswer(Text:string);                                            //Обработка сообщения
var MyText, tmp:string;
    ST:Integer;
    A, CName:Boolean;

procedure NotUnderstood;                                                        //Бот не понял сообщение
begin
 case Random(7) of
  0:Answer:='Не понял';
  1:Answer:='Не ясно';
  2:Answer:='Ходи давай';
  3:Answer:='Я не понял';
  4:Answer:='Не понятно';
  5:Answer:='Я приметивен';
  6:Answer:='Что?';
 end;
end;

function GetWord(SPos:Byte):string;                                             //Получить слово с текущей позиции
var i:Byte;
begin
 for i:=SPos to Length(Text) do
  if (Text[i] = ' ') or
     (Text[i] = ',') or
     (Text[i] = '.')
  then Break;
 if i <> Length(Text) then Dec(i);
 Result:=Copy(Text, SPos, i-SPos+1);
end;

function NormWord(AWord:string):Boolean;                                        //Проверка слова на пристойность
var l:Word;
begin
 Result:=False;
 for l:=0 to NotCensorshipList.Count-1 do if AWord = NotCensorshipList.Strings[l] then Exit;
 Result:=True;
end;

function Censorship(AText:string):Boolean;                                      //Проверка текста на пристойность
var i, iOld:Word;
begin
 Result:=False;
 if AText = '' then
  begin
   Result:=True;
   Exit;
  end;
 i:=1;
 iOld:=1;
 repeat
  Inc(i);
  if (AText[i] = ' ') or
     (AText[i] = ',') or
     (AText[i] = '.')
  then
   begin
    if not NormWord(Copy(AText, iOld, i-iOld)) then Exit;
    iOld:=i+1;
    Continue;
   end;
  if i = Length(Text) then
   begin
    if not NormWord(Copy(AText, iOld, i-iOld+1)) then Exit;
    iOld:=i;
    Continue;    
   end;
 until i = Length(AText);
 Result:=True;
end;

begin
 MyText:=AnsiLowerCase(Text);
 Randomize;
 A:=False;
 CName:=False;
 FormMain.TimerSpeak.Interval:=Random(3000)+1000;
 if not Censorship(MyText) then                                                 //Нецензурное слово - удаляем сообщение
  begin
   FormMain.ListBoxPos.Items.Delete(FormMain.ListBoxPos.Items.Count-1);
   A:=True;
  end;
 if (Pos('godmode ', MyText) = 1) then                                          //Режим бога (временно)
  begin
   if Copy(MyText, 9, 2) = 'on' then GodMode:=True;
   if Copy(MyText, 9, 3) = 'off' then GodMode:=False;
  end;
 if (MyText = 'новая игра') or                                                  //Начать новую игру
    (MyText = 'начать заново') or
    (MyText = 'старт новой') or
    (MyText = 'играть') or
    (MyText = 'расставить корабли') or
    (MyText = 'расстановка кораблей') or
    (MyText = 'заново играть') or
    (MyText = 'новый бой') or
    (MyText = 'старт')
 then
  begin
   FormMain.ButtonNewClick(nil);
   Exit;
  end;
 if (MyText = 'начать случайную игру') then                                     //Начать случайную новую игру
  begin
   ClearAll;
   FormShipPoly.ButtonAuto.Click;
   Player:=SetShip.TMP;
   CompDirs:=TMPDir;
   New;
   FormMain.DrawGridPoly.Repaint;
   FormMain.DrawGridComp.Repaint;
   FormMain.TimerGo.Enabled:=True;
   Exit;
  end;
 if (MyText = 'stat') or                                                        //Просмотреть текущий статус игры
    (MyText = 'статус')
 then
  begin
   WriteIt('Игрок:', itGame);
   WriteIt('Катер x'+IntToStr(PlayerShips[1]), itGame);
   WriteIt('Миноносец  x'+IntToStr(PlayerShips[2]), itGame);
   WriteIt('Подлодка  x'+IntToStr(PlayerShips[3]), itGame);
   WriteIt('Авианосец   x'+IntToStr(PlayerShips[4]), itGame);
   WriteIt('Всего: '+IntToStr(PlayerShips[1]+PlayerShips[2]+PlayerShips[3]+PlayerShips[4]), itGame);
   WriteIt('Компьютер:', itGame);
   WriteIt('Катер x'+IntToStr(CompShips[1]), itGame);
   WriteIt('Миноносец  x'+IntToStr(CompShips[2]), itGame);
   WriteIt('Подлодка  x'+IntToStr(CompShips[3]), itGame);
   WriteIt('Авианосец   x'+IntToStr(CompShips[4]), itGame);
   WriteIt('Всего: '+IntToStr(CompShips[1]+CompShips[2]+CompShips[3]+CompShips[4]), itGame);
   Exit;
  end;
 if (Pos('мое имя', MyText) <> 0) then                                          //Представление имени
  begin
   PlayerName:=GetWord(Pos('мое имя', MyText)+8);
   Answer:='Я '+CompName+', приятно познакомится';
   CName:=True;
   A:=True;
  end
 else
 if (Pos('меня зовут', MyText) <> 0) then                                       //Представление имени
  begin
   PlayerName:=GetWord(Pos('меня зовут', MyText)+11);
   Answer:='Я '+CompName+', приятно познакомится';
   CName:=True;
   A:=True;
  end
 else
 if (Pos('я ', MyText) <> 0) then                                               //Представление имени
  if (MyText[Pos('я ', MyText)-1] = '') or
     (MyText[Pos('я ', MyText)-1] = ' ')
  then
  begin
   PlayerName:=GetWord(Pos('я ', MyText)+2);
   Answer:='Я '+CompName+', приятно познакомится';
   CName:=True;
   A:=True;
  end;
 if (Pos('привет', MyText) <> 0) or                                             //Приветствие
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
   else Answer:=tmp+',я '+CompName+', приятно познакомится';
   FormMain.TimerSpeak.Enabled:=True;
   A:=True;
  end;
 if (Pos('пока', MyText) = 1) or                                                //Прощание - выход из игры
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
 if (MyText = 'ходи') or                                                        //Передача хода, пропуск хода
    (MyText = 'ты ходишь') or
    (MyText = 'ты ходишь первый') or
    (MyText = 'ты ходи') or
    (MyText = 'твой ход') or
    (MyText = 'давай ходи')
 then
  begin
   Lead:=tlComp;
   FormMain.CompShoot.Execute;
   //DoCompShoot;
   Exit;
  end;
 if (Pos('смени имя', MyText) <> 0) or                                          //Просьба о смене имени бота
    (Pos('другое имя', MyText) <> 0)
 then
  begin
   GetRandomCompName;
   Answer:='Готово, так лучше?!';
   FormMain.TimerSpeak.Enabled:=True;
   A:=True;
  end;
 if (Pos('sleep=', MyText) <> 0) or                                             //Установка времени задержки между ходами бота
    (Pos('время=', MyText) <> 0) or
    (Pos('время ', MyText) <> 0)
 then
  begin
   try
    ST:=StrToInt(Copy(MyText, 7, Length(MyText)-6));
    Answer:='Задержка '+IntToStr(ST)+' мсек.';
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
   if EditInput.Text = '' then Exit;
   if not Game.AnalysInput(EditInput.Text) then
    begin
     Game.WriteIt(PlayerName+': '+EditInput.Text, itLeadPlayer);
     Game.AnalysAnswer(EditInput.Text);
    end;
   EditInput.Text:='';
  end;
end;

procedure TFormMain.TimerSpeakTimer(Sender: TObject);
begin
 TimerSpeak.Enabled:=False;
 if Answer<>'' then
  begin
   Game.WriteIt(CompName+': '+Answer, itLeadComp);
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
 if TimerGo.Interval = 30000 then TimerGo.Interval:=60000 else
  if TimerGo.Interval = 60000 then TimerGo.Interval:=70000 else
   if TimerGo.Interval = 70000 then TimerGo.Interval:=300000 else TimerGo.Enabled:=False;
 Randomize;
 case Game.Status of
  tsPlay:
   begin
    case Random(6) of
     0:VM:='Ходи';
     1:VM:='Ходи давай';
     2:VM:='Ты уснул';
     3:VM:='Wake up';
     4:VM:='Прошу, ходи';
     5:VM:='Твой ход';
     6:VM:='Ваш ход';
    end;
    Game.WriteIt(CompName+': '+VM, itLeadComp);
   end;
  tsEnd:
   begin
    case Random(6) of
     0:VM:='Счет '+IntToStr(Wins)+':'+IntToStr(Loses)+' давай же изменим его';
     1:VM:='Ну расставляй';
     2:VM:='Расставляй бегом';
     3:VM:='Хочу играть';
     4:VM:='Играть, играть и ещё раз играть';
     5:VM:='Я уже готов, а ты?';
     6:VM:='Ну же, начинай';
    end;
    Game.WriteIt(CompName+': '+VM, itLeadComp);
   end;
 end;
end;

procedure TFormMain.PanelHelpPaint(Sender: TObject);
begin
 PanelHelp.Canvas.Brush.Style:=bsClear;
 PanelHelp.Canvas.Draw(10, 0, Bitmaps.Past);
 PanelHelp.Canvas.TextOut(40, 5, ' - Мимо');
 PanelHelp.Canvas.Draw(10, 25, Bitmaps.UPast);
 PanelHelp.Canvas.TextOut(40, 30, ' - Пусто');
 PanelHelp.Canvas.Draw(10, 50, Bitmaps.Kill);
 PanelHelp.Canvas.TextOut(40, 55, ' - Убил');
 PanelHelp.Canvas.Draw(10, 75, Bitmaps.Wou);
 PanelHelp.Canvas.TextOut(40, 80, ' - Ранил');
 PanelHelp.Canvas.TextOut(120,  4, '4 x');
 PanelHelp.Canvas.Draw(140,  0, Bitmaps.ShipsPics[41]);
 PanelHelp.Canvas.TextOut(120, 29, '3 x');
 PanelHelp.Canvas.Draw(140, 24, Bitmaps.ShipsPics[42]);
 PanelHelp.Canvas.TextOut(120, 54, '2 x');
 PanelHelp.Canvas.Draw(140, 49, Bitmaps.ShipsPics[43]);
 PanelHelp.Canvas.TextOut(120, 79, '1 x');
 PanelHelp.Canvas.Draw(140, 74, Bitmaps.ShipsPics[44]);
end;

procedure TFormMain.PanelResultPaint(Sender: TObject);
begin
 if Score  = 0 then PanelResult.Canvas.Draw(0, 0, Bitmaps.Results[0]);
 if Score >= 1 then PanelResult.Canvas.Draw(0, 0, Bitmaps.Results[1]);
 if Score >= 2 then PanelResult.Canvas.Draw(0, 0, Bitmaps.Results[2]);
 if Score >= 3 then PanelResult.Canvas.Draw(0, 0, Bitmaps.Results[3]);
end;

procedure TFormMain.TimerTimeTimer(Sender: TObject);
var M, S:Byte;
   MT, ST:string;
begin
 Inc(Game.TimeGame);
 M:=Game.TimeGame div 60;
 S:=Game.TimeGame-(M * 60);
 if M<10 then MT:='0'+IntToStr(M) else MT:=IntToStr(M);
 if S<10 then ST:='0'+IntToStr(S) else ST:=IntToStr(S);
 LabelTime.Caption:=MT+':'+ST;
end;

procedure TFormMain.ButtonClosePClick(Sender: TObject);
begin
 PanelResult.Hide;
end;

procedure TFormMain.DrawGridCompMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var ACol, ARow:Integer;
begin
 DrawGridComp.MouseToCell(X, Y, ACol, ARow);
 if (ACol = 0) or (ARow = 0) or (ACol = 11) or (ARow = 11) then
  begin
   if DrawGridComp.Cursor = crDefault then Exit else DrawGridComp.Cursor:=crDefault;
  end
 else
  begin
   LabelXP.Caption:=RuChars[ACol]+'-'+IntToStr(ARow);
   if DrawGridComp.Cursor = 1 then Exit else DrawGridComp.Cursor:=1;
  end;
end;

procedure TFormMain.ListBoxHelpDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var DRect, WRect:TRect;
begin
 DRect.Left:=0;
 DRect.Top:=0;
 DRect.Right:=ListBoxHelp.Width;
 DRect.Bottom:=ListBoxHelp.ItemHeight;
 Bitmaps.ListItem.Width:=ListBoxHelp.Width;
 Bitmaps.ListItem.Height:=ListBoxHelp.ItemHeight;
 WRect:=Rect;
 WRect.Top:=WRect.Top+ListBoxHelp.Top;
 WRect.Bottom:=WRect.Bottom+ListBoxHelp.Top;
 WRect.Left:=WRect.Left+ListBoxHelp.Left;
 WRect.Right:=WRect.Right+ListBoxHelp.Left;

 Bitmaps.ListItem.Canvas.CopyRect(DRect, Bitmaps.FormBrush.Canvas, WRect);
 ListBoxHelp.Canvas.StretchDraw(Rect, Bitmaps.ListItem);
 ListBoxHelp.Canvas.Brush.Style:=bsClear;
 ListBoxHelp.Canvas.TextOut(Rect.Left+3, Rect.Top, ListBoxHelp.Items.Strings[index]);
end;

function TGame.GetInfo(ACol, ARow:Word; APoly, DirShip:TArray):Byte;
begin
 Result:=0;
 Randomize;
 case APoly[ACol, ARow] of
  1:
   begin
    Result:=Random(4)+1;
    Exit;
   end;
  2:
   begin
    if ARow + 1 <= 10 then
    if (APoly[ACol, ARow] = APoly[ACol, ARow+1]) then                           //Верхняя часть 2 пб
     begin
      case Random(2) of
       0:Result:=5;
       1:Result:=9;
      else
       Result:=9;
      end;
      Exit;
     end;
    if ARow - 1 >=1 then
    if (APoly[ACol, ARow] = APoly[ACol, ARow-1]) then                           //Нижняя часть 2 пб
     begin
      case DirShip[ACol, ARow-1] of
       5:Result:=6;
       9:Result:=10;
      end;
      Exit;
     end;
    if ACol + 1 <= 10 then
    if (APoly[ACol, ARow] = APoly[ACol+1, ARow]) then                           //Левая часть 2 пб
     begin
      case Random(2) of
       0:Result:=8;
       1:Result:=12;
      else
       Result:=12;
      end;
      Exit;
     end;
    if ACol - 1 >= 1 then 
    if (APoly[ACol, ARow] = APoly[ACol-1, ARow]) then                           //Правая часть 2 пб
     begin
      case DirShip[ACol-1, ARow] of
       8:Result:=7;
       12:Result:=11;
      end;
      Exit;
     end;
   end;
  3:
   begin
    if ARow + 2 <= 10 then
    if (APoly[ACol, ARow] = APoly[ACol, ARow+1]) and (APoly[ACol, ARow] = APoly[ACol, ARow+2]) then                           //Верхняя часть 3 пб
     begin
      case Random(2) of
       0:Result:=13;
       1:Result:=16;
      else
       Result:=13;
      end;
      Exit;
     end;
    if (ARow - 1 >= 1) and (ARow + 1 <= 10) then
    if (APoly[ACol, ARow] = APoly[ACol, ARow-1]) and (APoly[ACol, ARow] = APoly[ACol, ARow+1]) then                           //Средняя часть 3 пб
     begin
      case DirShip[ACol, ARow-1] of
       13:Result:=14;
       16:Result:=17;
      end;
      Exit;
     end;
    if ARow - 2 >= 1 then
    if (APoly[ACol, ARow] = APoly[ACol, ARow-1]) and (APoly[ACol, ARow] = APoly[ACol, ARow-2]) then                           //Верхняя часть 3 пб
     begin
      case DirShip[ACol, ARow-1] of
       14:Result:=15;
       17:Result:=18;
      end;
      Exit;
     end;
    if ACol + 2 <= 10 then
    if (APoly[ACol, ARow] = APoly[ACol+1, ARow]) and (APoly[ACol, ARow] = APoly[ACol+2, ARow]) then                           //Верхняя часть 3 пб
     begin
      case Random(2) of
       0:Result:=19;
       1:Result:=22;
      else
       Result:=22;
      end;
      Exit;
     end;
    if (ACol - 1 >= 1) and (ACol + 1 <= 10) then
    if (APoly[ACol, ARow] = APoly[ACol-1, ARow]) and (APoly[ACol, ARow] = APoly[ACol+1, ARow]) then                           //Средняя часть 3 пб
     begin
      case DirShip[ACol-1, ARow] of
       19:Result:=20;
       22:Result:=23;
      end;
      Exit;
     end;
    if ACol - 2 >= 1 then
    if (APoly[ACol, ARow] = APoly[ACol-1, ARow]) and (APoly[ACol, ARow] = APoly[ACol-2, ARow]) then                           //Верхняя часть 3 пб
     begin
      case DirShip[ACol-1, ARow] of
       20:Result:=21;
       23:Result:=24;
      end;
      Exit;
     end;
   end;

  4:
   begin
    if ARow + 3 <= 10 then
    if (APoly[ACol, ARow] = APoly[ACol, ARow+1]) and (APoly[ACol, ARow] = APoly[ACol, ARow+2]) and (APoly[ACol, ARow] = APoly[ACol, ARow+3]) then                           //Верхняя часть 3 пб
     begin
      case Random(2) of
       0:Result:=25;
       1:Result:=29;
      else
       Result:=25;
      end;
      Exit;
     end;
    if (ARow - 1 >= 1) and (ARow + 2 <= 10) then
    if (APoly[ACol, ARow] = APoly[ACol, ARow-1]) and (APoly[ACol, ARow] = APoly[ACol, ARow+1]) and (APoly[ACol, ARow] = APoly[ACol, ARow+2]) then                           //Средняя часть 3 пб
     begin
      case DirShip[ACol, ARow-1] of
       25:Result:=26;
       29:Result:=30;
      end;
      Exit;
     end;
    if (ARow - 2 >= 1) and (ARow + 1 <= 10) then
    if (APoly[ACol, ARow] = APoly[ACol, ARow-1]) and (APoly[ACol, ARow] = APoly[ACol, ARow+1]) and (APoly[ACol, ARow] = APoly[ACol, ARow-2]) then                           //Средняя часть 3 пб
     begin
      case DirShip[ACol, ARow-1] of
       26:Result:=27;
       30:Result:=31;
      end;
      Exit;
     end;
    if ARow - 3 >= 1 then
    if (APoly[ACol, ARow] = APoly[ACol, ARow-1]) and (APoly[ACol, ARow] = APoly[ACol, ARow-2]) and (APoly[ACol, ARow] = APoly[ACol, ARow-3]) then                           //Верхняя часть 3 пб
     begin
      case DirShip[ACol, ARow-1] of
       27:Result:=28;
       31:Result:=32;
      end;
      Exit;
     end;

    if ACol + 3 <= 10 then
    if (APoly[ACol, ARow] = APoly[ACol+1, ARow]) and (APoly[ACol, ARow] = APoly[ACol+2, ARow]) and (APoly[ACol, ARow] = APoly[ACol+3, ARow]) then                           //Верхняя часть 3 пб
     begin
      case Random(2) of
       0:Result:=33;
       1:Result:=37;
      else
       Result:=33;
      end;
      Exit;
     end;
    if (ACol - 1 >= 1) and (ACol + 2 <= 10) then
    if (APoly[ACol, ARow] = APoly[ACol-1, ARow]) and (APoly[ACol, ARow] = APoly[ACol+1, ARow]) and (APoly[ACol, ARow] = APoly[ACol+2, ARow]) then                           //Средняя часть 3 пб
     begin
      case DirShip[ACol-1, ARow] of
       33:Result:=34;
       37:Result:=38;
      end;
      Exit;
     end;
    if (ACol - 2 >= 1) and (ACol + 1 <= 10) then
    if (APoly[ACol, ARow] = APoly[ACol-1, ARow]) and (APoly[ACol, ARow] = APoly[ACol+1, ARow]) and (APoly[ACol, ARow] = APoly[ACol-2, ARow]) then                           //Средняя часть 3 пб
     begin
      case DirShip[ACol-1, ARow] of
       34:Result:=35;
       38:Result:=39;
      end;
      Exit;
     end;
    if ACol - 3 >= 1 then 
    if (APoly[ACol, ARow] = APoly[ACol-1, ARow]) and (APoly[ACol, ARow] = APoly[ACol-2, ARow]) and (APoly[ACol, ARow] = APoly[ACol-3, ARow]) then                           //Верхняя часть 3 пб
     begin
      case DirShip[ACol-1, ARow] of
       35:Result:=36;
       39:Result:=40;
      end;
      Exit;
     end;
   end;
 end;
end;

procedure TFormMain.DrawGridCompKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case Key of
  VK_LEFT:  if MCur.X-1 <  0 then Exit else begin Dec(MCur.X); DrawGridComp.Repaint; end;
  VK_RIGHT: if MCur.X+1 > 11 then Exit else begin Inc(MCur.X); DrawGridComp.Repaint; end;
  VK_UP:    if MCur.Y-1 <  0 then Exit else begin Dec(MCur.Y); DrawGridComp.Repaint; end;
  VK_DOWN:  if MCur.Y+1 > 11 then Exit else begin Inc(MCur.Y); DrawGridComp.Repaint; end;
  VK_SPACE: if (MCur.X in [1..10]) and (MCur.Y in [1..10]) then
   begin
    TimerGo.Enabled:=False;
    TimerGo.Interval:=30000;
    if (Game.Status = tsPlay) then
     begin
      if (Game.Lead=tlPlayer) then Game.Input(MCur) else Exit;
     end
    else ActionNewGame.Execute;
    TimerGo.Enabled:=True;
    DrawGridComp.Repaint;
   end;
 end;
 if (MCur.X in [1..10]) and (MCur.Y in [1..10]) then
  LabelXP.Caption:=RuChars[MCur.X]+'-'+IntToStr(MCur.Y);
 DrawGridComp.SetFocus;
end;

procedure TFormMain.ActionNewGameExecute(Sender: TObject);
begin
 case FormShipPoly.ShowModal of
  mrOk:
   begin
    Game.ClearAll;
    Player:=TMP;
    CompDirs:=TMPDir;
    Game.New;
   end;
 else
 end;
 DrawGridPoly.Repaint;
 DrawGridComp.Repaint;
 TimerGo.Enabled:=True;
end;

procedure TFormMain.TimerCompShootTimer(Sender: TObject);
begin
 TimerCompShoot.Enabled:=False;
 Game.DoCompShoot;
end;

procedure TFormMain.CompShootExecute(Sender: TObject);
begin
 TimerCompShoot.Enabled:=True;
end;

procedure TFormMain.TimerAniTimer(Sender: TObject);
begin

 if CurAni = Length(Bitmaps.Ani1) then DoUp:=False;
 if CurAni = 1 then DoUp:=True;
 if DoUp then Inc(CurAni) else Dec(CurAni);

 if CurFire = Length(Bitmaps.Fire) then DoUp:=False;
 if CurFire = 1 then DoUp:=True;
 if DoUp then Inc(CurFire) else Dec(CurFire);

 DrawGridComp.Repaint;
 DrawGridPoly.Repaint;
end;

procedure TFormMain.TimerClearRadarTimer(Sender: TObject);
var i,j:Byte;
begin
 TimerClearRadar.Enabled:=False;
 for i:=1 to 10 do
  for j:=1 to 10 do
   begin
    Application.ProcessMessages;
    Radar[i,j]:=aEmpty;
   end;
end;

initialization
  Path:=ExtractFilePath(ParamStr(0));
  AddFontResource(PChar(Path+'Techno.ttf'));
  SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
  NotCensorshipList:=TStringList.Create;
  if FileExists(Path+'\Bot\Obscene.lst') then
   NotCensorshipList.LoadFromFile(Path+'\Bot\Obscene.lst');

end.
