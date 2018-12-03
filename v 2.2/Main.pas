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
    PanelResult: TPanelExt;
    LabelLosesV: TLabel;
    LabelWinsV: TLabel;
    ButtonCloseP: TPNGButton;
    ButtonNewP: TPNGButton;
    TimerGo: TTimer;
    LabelTime: TLabel;
    TimerTime: TTimer;
    LabelXP: TLabel;
    EditInput: TComboBox;
    ActionList: TActionList;
    ActionNewGame: TAction;
    TimerCompShoot: TTimer;
    PassLead: TAction;
    TimerAni: TTimer;
    TimerClearRadar: TTimer;
    DrawGridRadar: TDrawGrid;
    ButtonRadar: TPNGButton;
    ButtonTorpedo: TPNGButton;
    ButtonFire: TPNGButton;
    DrawGridSet: TDrawGrid;
    TimerSet: TTimer;
    ListBoxHelp: TListBox;
    PanelHelp: TPanelExt;
    ButtonStart: TPNGButton;
    ButtonAutoTune: TPNGButton;
    ButtonClearSet: TPNGButton;
    TimerActions: TTimer;
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
    procedure PassLeadExecute(Sender: TObject);
    procedure TimerAniTimer(Sender: TObject);
    procedure TimerClearRadarTimer(Sender: TObject);
    procedure DrawGridRadarDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure ButtonRadarClick(Sender: TObject);
    procedure ButtonTorpedoClick(Sender: TObject);
    procedure ButtonFireClick(Sender: TObject);
    procedure DrawGridSetDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure DrawGridSetMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DrawGridSetMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TimerSetTimer(Sender: TObject);
    procedure ButtonClearSetClick(Sender: TObject);
    procedure ButtonAutoTuneClick(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure TimerActionsTimer(Sender: TObject);
    procedure DrawGridPolyMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
   procedure WMNCHitTest(var M: TWMNCHitTest); message wm_NCHitTest;
  protected
   procedure CreateParams(var Params: TCreateParams); override;
  public
  end;

  TLastShoots = record                                                          //Псоледний удар компьютера
   ShipSize:Byte;                                                                //Размер корабля
   Shoots:array[1..4] of TPoint;                                                 //Координаты попадания
   Last:TPoint;                                                                  //Последняя координата
   Use:Boolean;                                                                  //Учитывать ли при ударе
  end;
  TKillArray = array[1..10, 1..10] of Byte;                                     //Массив видимых игрокам объектов
  TArray = array[1..10, 1..10] of Byte;                                         //Массив кораблей
  TDirection = (tdLeft, tdRight, tdUp, tdDown);                                 //Направления корабля относительно начала
  TShips = array[1..4] of Byte;                                                 //Список кораблей и их кол-во
  TStatus = (tsPlay, tsEnd, tsPlacement);                                       //Статус игры
  TLead = (tlPlayer, tlComp);                                                   //Владелац хода
  TSoundType = (stShoot, stKill, stWound, stWin, stLose, stPast);               //Типы воспроизводимых звуков
  TInfoType = (itLeadPlayer, itTalk, itLeadComp, itGame);                       //Владалец сообщения
  TSettings = record                                                            //Настройки
   ShowCompTalk:Boolean;                                                         //Показывать сообщения компьютера
   ShowLeadPlayer:Boolean;                                                       //Показывать координаты удара игрока
   ShowLeadComp:Boolean;                                                         //Показывать координаты удара комп-а
  end;
  TLogicPos = record                                                            //Логически возможная позиция корабля
   SPos:TPoint;                                                                  //Координаты начала
   SDir:TDirection;                                                              //Направление
  end;
  TArms = record                                                                //Вооружение
   Bonus:Word;                                                                   //Очки
   GoodShoots:Byte;                                                              //Кол-во удачных ударов подряд
  end;
  TLogicPoses = array[1..100] of TLogicPos;                                     //Массив логически возможных позиция кораблей
  TGame = class
  private
   TorpedoSize:Byte;                                                            //Размер торпеды
   NoSound:Boolean;                                                             //Не воспроизводить музыку
   Score:Byte;                                                                  //Очки игрока после подсчета
  public
   PlayerArms,                                                                  //Вооружение игрока
   CompArms:TArms;                                                              //Вооружение компьютера
   Ships:TShips;                                                                //Кол-во кораблей
   Status:TStatus;                                                              //Статус игры
   Lead:TLead;                                                                  //Владелец текущего хода
   CompLastShoot:TPoint;                                                        //Координаты последнего выстрела комп-а.
   LastDir:TDirection;                                                          //Направление последнего раненого корабля
   UseLastDir:Boolean;                                                          //Учитывать ли предыдущий параметр
   ItNS:Boolean;                                                                //Текущий удар - результат предыдущего
   IsNextShoot:Boolean;                                                         //Делать ход на основании предыдущего
   CompUsedDir:set of TDirection;                                               //Использованные виртуальные направления рананого корабля
   LastShoots:TLastShoots;                                                      //Результат последнего удара
   LastScore:Byte;                                                              //Последний счет игры
   CompShips,                                                                   //Кол-во кораблей компьютера
   PlayerShips:TShips;                                                          //Кол-во кораблей игрока
   TimeGame:Cardinal;                                                           //Прошедшее время игры
   Settings:TSettings;                                                          //Настройки игры
   LogicPoses:TLogicPoses;                                                      //Список логически выбранных координат для стрельбы
   Player:TArray;                                                               //Поле игрока
   Comp:TArray;                                                                 //Поле компьютера
   CompKill:TKillArray;                                                         //Поле которое видит игрок
   PlayerKill:TKillArray;                                                       //Поле которое види компьютер
   CompDirs:TArray;                                                             //Графические данные (Направление кораблей игрока)
   PlayerDirs:TArray;                                                           //Графические данные (Направление корабля компьютера)
   Poly:TArray;                                                                 //Поле, через которое идет расстановка кораблей
   Radar:TArray;                                                                //Радар, Координаты объектов
   //CompRadar:TArray;
   Answer:string;                                                               //Ответ на вопрос заданный компьютеру
   Wins,                                                                        //Кол-во побед игрока
   Loses:Word;                                                                  //Кол-во проигрышей игрока
   MCur:TPoint;                                                                 //Координаты текущей позиции указателя игрока
   SleepTime:Word;                                                              //Время задержки между действиями компьютера
   CompName,                                                                    //Имя компьютера
   PlayerName:string;                                                           //Имя игрока
   RadarText:string;                                                            //Последние координаты радара, в виде текста для игрока
   TMP,                                                                         //(Расстановка) Временное поле
   Sli:TArray;                                                                  //(Расстановка) Sli - поле
   TMPDir,                                                                      //(Расстановка) Временное поле направлений
   SliDir:TArray;                                                               //(Расстановка) Sli - поле направлений
   AllSet:Boolean;                                                              //Все корабли расставлены
   OldC, OldR:Integer;                                                          //Старые координаты курсора
   CurDir,                                                                      //Направление - направо
   OldDir:Boolean;                                                              //Предыдущее направление
   //Обработка действий и вспомогательные процедуры
   procedure New;                                                               //Начать новую игру
   procedure WriteIt(Text:string; InfoType:TInfoType);                          //Послать сообщение
   procedure ClearList;                                                         //Очистить список сообщений
   procedure DoCompShoot;                                                       //Выполнить ход компьютера
   procedure ClearPoly;                                                         //Очистить основное поле
   procedure SetShips;                                                          //Расставить корабли компьютера
   procedure ClearAll;                                                          //Очистить все поля всех игроков
   procedure OnCompWin;                                                         //При выигрыше компьютера
   procedure OnPlayerWin;                                                       //При выигрыше игрока
   procedure DrawAll(Who:TLead);                                                //Перерисовать поле
   procedure GetRandomCompName;                                                 //Учтановить случайное имя компьютеру
   procedure Input(SPos:TPoint);                                                //Выполнить удар игрока
   procedure Waiting;                 overload;                                 //Выполнить заданную игроком задержку
   procedure Waiting(ATime:Cardinal); overload;                                 //Выполнить непосредственную задержку
   procedure AnalysAnswer(Text:string);                                         //Проанализировать сообщение игрока
   procedure InsertPast(Ship:TPoint);                                           //Оградить убитый корабль игрока
   procedure PlayerPast(SPos:TPoint);                                           //Поставить "точку пустоты"
   procedure InsertPastForUser(Ship:TPoint);                                    //Оградить убитый корабль комп-а
   procedure InsertShip(SPos:TPoint; Direction:TDirection; ShipSize:Byte);      //Поставить корабль на поле
   procedure ActionTorpedo(NPos:TPoint);                                        //Пустить торпеду игрока
   procedure ActionTorpedoComp(NPos:TPoint);                                    //Пустить торпеду комп-а
   procedure SetStatus(Win:Boolean);                                            //Показать счет
   procedure KillShip(SPos:TPoint; Direction:TDirection; var Poly:TKillArray; SSize:Byte; Whose:TLead); //Убить корабль
   procedure GoSound(SoundType:TSoundType);                                     //Воспроизвести звук
   procedure ActionRadar(SPos:TPoint);                                          //Включить радар игрока
   procedure ClearSli;                                                          //Расстановка (Очистить sli поле)
   procedure RefreshShips;                                                      //Расстановка (Установить направления)
   procedure UpdateShips;                                                       //Расстановка (Обновить поле)
   procedure AClear;                                                            //Расстановка (Очистка вспомогательных полей)
   procedure TuneForPlacement;                                                  //Настроить окно для расстановки кораблей
   procedure TuneForGame;                                                       //Настроить окно для игры
   procedure ShowSteps(NewPos:TPoint);                                          //Шагать курсором до новых координат
   function GetFirePosition:TPoint;                                             //Получить координаты первого удара
   function GetActualTorpedoPosition(APoly:TKillArray):TPoint;                  //Получить актуальные координаты запуска торпеды
   function CalcBusy(APoly:TKillArray):Byte;                                    //Получить кол-во занятых объектами координат
   function FindPosForShip(SSize:Byte; APoly:TKillArray; var ALogicPoses:TLogicPoses):Byte; //Получить список возможных расположений наибольшего корабля
   function GetInfo(ACol, ARow:Word; APoly, DirShip:TArray):Byte;               //Графические данные (Создать "маску" направлений кораблей)
   function CheckFullPoly:Boolean;                                              //Все корабли расставлены
   function GetCurShip:Byte;                                                    //Получить наибольший не использованный корабль (расствновка)
   function ShipIsAllWound(SPos:TPoint; Direction:TDirection; var Poly:TKillArray; SSize:Byte):Boolean; //Весь ли корабль ранен
   function PlayerShoot(SPos:TPoint; var Got:Boolean):Boolean;                  //Выстрел игрока
   function CompShoot(SPos:TPoint; var Got:Boolean):Boolean;                    //Выстрел коспьютера
   function CheckComp:Boolean;                                                  //Проверить не выиграл ли игрок
   function CheckPlayer:Boolean;                                                //Проверить не выиграл ли компьютер
   function GetNextShoot(LastShoot:TPoint):TPoint;                              //Получить следующий удар на основе предыдущего
   function GetShipPos(SPos:TPoint; var Direction:TDirection; var StartPos:TPoint; Poly:TArray):Boolean; //Получить направление корабля на основе предыдущего удара
   function CheckCell(SPos:TPoint):Boolean;                                     //Проверить координаты на соответствие
   function GetPos(SPos:TPoint):Byte;                                           //Получить объект из основного поля
   function CheckPos(SPos:TPoint; var Direction:TDirection; ShipSize:Byte):Boolean; //
   function CheckInsert(SPos:TPoint; Direction:TDirection; ShipSize:Byte):Boolean; //Проверить на возможность вставки корабля
   function InsertCheck(SPos:TPoint):Boolean;                                   //Вставить корабль
   function GetScore:Byte;                                                      //Узнать счет
   function AnalysInput(Text:string):Boolean;                                   //Проанализировать сообщение игрока (первичное)
   constructor Create;                                                          //Создать игру
  end;
  TBitmaps = class                                                              //Текстуры
   public
    ResultPanel:TBitmap;                                                        //Панель результата
    FormBrush:TBitmap;                                                          //Оболочка
    Past:TPNGObject;                                                            //Мимо
    Wou:TPNGObject;                                                             //Ранил
    Kill:TPNGObject;                                                            //Убил
    UPast:TPNGObject;                                                           //Здесь нет корабля
    ListItem:TBitmap;                                                           //Холст для рисования текста
    DrawBMP:TBitmap;                                                            //Холст для рисования объектов на полях
    DrawBMP2:TBitmap;                                                           //Холст для рисования объектов на полях
    DrawBMP3:TBitmap;                                                           //Холст для рисования объектов на полях
    Ships:array[1..4] of TPNGObject;                                            //Корабли (целые)
    Results:array[0..3] of TPNGObject;                                          //Медали
    ShipsPics:array[1..44] of TPNGObject;                                       //Части кораблей (смотреть блокнот)
    Ani1:array[1..9] of TPNGObject;                                             //Анимированный указатель цели
    Fire:array[1..8] of TPNGObject;                                             //Анимированный огонь
    Radar:TPNGObject;                                                           //Радар
    LineRadar:array[1..36] of TPNGObject;                                       //Линия работы радара
    Ready:array[1..3] of TPNGObject;                                            //Готовность
    RadarObject:TPNGObject;                                                     //Объект на радаре (точка)
    DoUp1:Boolean;                                                              //Цикличные переменные
    DoUp2:Boolean;                                                              //Цикличные переменные
    DoUp3:Boolean;                                                              //Цикличные переменные
    CurAni:Byte;                                                                //Цикличные переменные
    CurFire:Byte;                                                               //Цикличные переменные
    CurLine:Byte;                                                               //Цикличные переменные
    LineCL:Byte;                                                                //Цикличные переменные
    function LoadSkinFromDll(DllName:string):Boolean;                           //Загрузка скина
    constructor Create;                                                         //Создание
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
  Game:TGame;            //Движок игры
  Need:Boolean;          //Перетаскивание окна возможно
  Bitmaps:TBitmaps;      //Графические объекты
  Path:String;           //Корневой каталог
  RuChars:array[1..10] of Char = ('А','Б','В','Г','Д','Е','Ж','З','И','К');     //Обозначение координат

  //
  NotCensorshipList:TStrings;                                                   //Нецензурные выражения
  //


  function GetRect(L, T, R, B:Integer):TRect;                                   //Интерпретация функции Rect

implementation

{$R *.dfm}

procedure TGame.ClearSli;
var i,j:Byte;
begin
 for i:=1 to 10 do for j:=1 to 10 do Sli[i,j]:=aEmpty;
end;

procedure TGame.TuneForPlacement;
begin
 with FormMain do
  begin
   DrawGridSet.Show;
   ButtonStart.Show;
   ButtonClearSet.Show;
   ButtonAutoTune.Show;
   ButtonFire.Hide;
   ButtonRadar.Hide;
   ButtonTorpedo.Hide;
   DrawGridPoly.Hide;
   Game.Status:=tsPlacement;
  end;
end;

procedure TGame.TuneForGame;
begin
 with FormMain do
  begin
   DrawGridPoly.Show;
   DrawGridSet.Hide;
   ButtonStart.Hide;
   ButtonClearSet.Hide;
   ButtonAutoTune.Hide;
   ButtonFire.Show;
   ButtonRadar.Show;
   ButtonTorpedo.Show;
  end;
end;

procedure TGame.RefreshShips;
var i,j:Byte;
begin
 for i:=1 to 10 do
  for j:=1 to 10 do
   begin
    SliDir[i,j]:=GetInfo(i, j, Sli, SliDir);
   end;
end;

procedure TGame.UpdateShips;
var i,j:Byte;
begin
 for i:=1 to 10 do
  for j:=1 to 10 do
   begin
    if TMPDir[i,j] = 0 then TMPDir[i,j]:=GetInfo(i, j, TMP, TMPDir);
   end;
end;

procedure TGame.AClear;
var i,j:Byte;
begin
 for i:=1 to 10 do
  for j:=1 to 10 do
   begin
    TMP[i,j]:=aEmpty;
    TMPDir[i,j]:=0;
   end;
 ClearPoly;
 Ships[1]:=4;
 Ships[2]:=3;
 Ships[3]:=2;
 Ships[4]:=1;
 AllSet:=False;
 FormMain.DrawGridSet.Repaint;
end;

constructor TGame.Create;
begin
 inherited Create;
 TorpedoSize:=4;
 PlayerName:='Игрок';
 SleepTime:=0;
 GetRandomCompName;
 Status:=tsEnd;
 Settings.ShowCompTalk:=True;
 Settings.ShowLeadPlayer:=True;
 Settings.ShowLeadComp:=True;
 Wins:=0;
 Loses:=0;
 CurDir:=True;
 ClearSli;
 ClearAll;
 ClearList;
 AClear;
 WriteIt('Добро пожаловать на "Морской Бой"', itGame);
 WriteIt('С вами будет играть '+CompName+'.', itGame);
 WriteIt('Поприветствуйте его, назовите', itGame);
 WriteIt('свое имя, или будьте просто игроком', itGame);
 WriteIt(' ', itGame);
 WriteIt('Перед началом игры расставте корабли', itGame);
 WriteIt('Поле для расстановки слева, проверьте', itGame);
 WriteIt('Наведите курсор и кликните ЛКМ', itGame);
 WriteIt('Повернуть корабль - клик ПКМ', itGame);
 WriteIt(' ', itGame);
 WriteIt('Справа от радара кнопки управления', itGame);
 WriteIt('Если кнопка "Старт" активна, то', itGame);
 WriteIt('все корабли расставлены', itGame);
 WriteIt('Будьте осторожны', itGame);
 WriteIt(' ', itGame);
 WriteIt('Удачного боя', itGame);
end;

function TGame.GetActualTorpedoPosition(APoly:TKillArray):TPoint;
var ActualPos:array[1..200] of TPoint;
 APCount:Byte;
 CSize, S:Byte;
 x,y,k:Byte;
begin
 APCount:=0;
 Result:=Point(0, 0);
 for CSize:=TorpedoSize downto 2 do
  begin
   for x:=1 to 9 do
    begin
     for y:=1 to 10 do
      begin
       S:=0;
       for k:=0 to CSize-1 do
        if x+k <= 10 then if APoly[x+k, y] = aEmpty then Inc(S);
       if S = CSize then
        begin
         Inc(APCount);
         ActualPos[APCount]:=Point(X, Y);
         if APCount >= 200 then Break;
        end;
      end;
     if APCount >= 200 then Break;
    end;
   if APCount >= 200 then Break;
   if APCount <> 0 then Break;
  end;
 if APCount = 0 then Exit;
 Result:=ActualPos[Random(APCount)+1];
end;

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
begin
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
   if Loses > Wins then LabelWinsV.Hint:='Не в вашу пользу' else
    if Loses < Wins then LabelWinsV.Hint:='В вашу пользу';
  end;
end;

procedure TGame.OnCompWin;
var AText:string;
begin
 with FormMain do
  begin
   Status:=tsEnd;
   Score:=0;
   PanelResult.Show;
   Inc(Loses);
   Randomize;
   case Random(10) of
    0: AText:='=)';
    1: AText:='Хаха';
    2: AText:='Ухаха';
    3: AText:='Оу да';
    4: AText:='Победа за мной';
    5: AText:='Ты проиграл';
    6: AText:='Поздравляю';
    7: AText:='Ещё раз?!';
    8: AText:='Круто, давай ещё';
    9: AText:='Ура!';
   end;
   WriteIt(CompName+': '+AText, itLeadComp);
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
var AText:string;
begin
 Status:=tsEnd;
 with FormMain do
  begin
   Score:=GetScore;
   PanelResult.Show;
   Inc(Wins);
   Randomize;
   case Random(10) of
    0: AText:='=(';
    1: AText:='Гадство';
    2: AText:='Дьявол';
    3: AText:='О нет, я проиграл';
    4: AText:='Победа за тобой';
    5: AText:='Ты выиграл';
    6: AText:='Поздравляю';
    7: AText:='Ещё раз?!';
    8: AText:='Круто, давай ещё';
    9: AText:='Блин, почти';
   end;
   WriteIt(CompName+': '+AText, itLeadComp);
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
 if FormMain.ListBoxPos.Count = 17 then FormMain.ListBoxPos.Items.Delete(0);
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
   0: CompName:='Вася';
   1: CompName:='Курт';
   2: CompName:='Марк';
   3: CompName:='Хан';
   4: CompName:='Хантер';
   5: CompName:='Дед';
   6: CompName:='Горн';
   7: CompName:='Дэйв';
   8: CompName:='Кен';
   9: CompName:='Трэвис';
  end;
 until OldName <> CompName;
end;

procedure TGame.New;
var i,j:Byte;
begin
 TuneForGame;
 SetShips;
 ClearList;
 Comp:=Poly;
 MCur:=Point(0, 0);
 for i:=1 to 10 do
  for j:=1 to 10 do PlayerDirs[i,j]:=GetInfo(i, j, Comp, PlayerDirs);
 CompLastShoot:=Point(0, 0);
 Lead:=tlPlayer;
 LastShoots.Last:=Point(0, 0);
 Status:=tsPlay;
 for i:=1 to 4 do
  begin
   PlayerShips[i]:=5-i;
   CompShips[i]:=5-i;
  end;
 Randomize; 
 case Random(6) of
  0: WriteIt(CompName+': Ходи', itLeadComp);
  1: WriteIt(CompName+': Ходите', itLeadComp);
  2: WriteIt(CompName+': Твой ход', itLeadComp);
  3: WriteIt(CompName+': Вперед!', itLeadComp);
  4: WriteIt(CompName+': GO', itLeadComp);
  5: WriteIt(CompName+': Игра началась, ходи', itLeadComp);
  6: WriteIt(CompName+': Твой залп первый!', itLeadComp);
 end;
 FormMain.TimerTime.Enabled:=True;
 FormMain.TimerGo.Enabled:=True;
 FormMain.DrawGridComp.SetFocus;
end;

constructor TBitmaps.Create;
var i:Byte;
begin
 ResultPanel:=TBitmap.Create;
 FormBrush:=TBitmap.Create;
 Past:=TPNGObject.Create;
 UPast:=TPNGObject.Create;
 Wou:=TPNGObject.Create;
 Kill:=TPNGObject.Create;
 Ships[1]:=TPNGObject.Create;
 Ships[2]:=TPNGObject.Create;
 Ships[3]:=TPNGObject.Create;
 Ships[4]:=TPNGObject.Create;
 Radar:=TPNGObject.Create;
 RadarObject:=TPNGObject.Create;
 ListItem:=TBitmap.Create;
 DrawBMP:=TBitmap.Create;
 DrawBMP.Height:=24;
 DrawBMP.Width:=24;
 DrawBMP.Canvas.Font.Name:='Techno28';  //
 DrawBMP.Canvas.Brush.Style:=bsClear;
 DrawBMP2:=TBitmap.Create;
 DrawBMP2.Height:=FormMain.DrawGridRadar.Height;
 DrawBMP2.Width:=FormMain.DrawGridRadar.Width;
 DrawBMP2.Canvas.Brush.Style:=bsClear;
 DrawBMP2.Canvas.Font.Name:='Techno28';
 DrawBMP2.Canvas.Font.Color:=clWhite;
 DrawBMP2.Canvas.Font.Size:=13;
 DrawBMP3:=TBitmap.Create;
 DrawBMP3.Height:=24;
 DrawBMP3.Width:=24;
 DrawBMP3.Canvas.Font.Name:='Techno28'; //Segoe UI
 DrawBMP3.Canvas.Brush.Style:=bsClear;
 Results[0]:=TPNGObject.Create;
 Results[1]:=TPNGObject.Create;
 Results[2]:=TPNGObject.Create;
 Results[3]:=TPNGObject.Create;
 for i:=1 to 44 do ShipsPics[i]:=TPNGObject.Create;
 for i:=1 to 9 do Ani1[i]:=TPNGObject.Create;
 for i:=1 to 8 do Fire[i]:=TPNGObject.Create;
 for i:=1 to 36 do LineRadar[i]:=TPNGObject.Create;
 for i:=1 to 3 do Ready[i]:=TPNGObject.Create;
 inherited;
end;

procedure TFormMain.WMNCHitTest (var M:TWMNCHitTest);
begin
 inherited;
 if (M.Result = htClient) and Need then M.Result:=htCaption;
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
  Radar.LoadFromResourceName(DLL, 'RADAR');
  RadarObject.LoadFromResourceName(DLL, 'OBJECT');
  for i:=1 to 40 do ShipsPics[i].LoadFromResourceName(DLL, 'S'+IntToStr(i));
  for i:=41 to 44 do ShipsPics[i].LoadFromResourceName(DLL, 'SHIP'+IntToStr(i-40));
  for i:=1 to 9 do Ani1[i].LoadFromResourceName(DLL, 'A'+IntToStr(i));
  for i:=1 to 8 do Fire[i].LoadFromResourceName(DLL, 'F'+IntToStr(i));
  for i:=1 to 36 do LineRadar[i].LoadFromResourceName(DLL, 'R'+IntToStr(i));
  Ready[1].LoadFromResourceName(DLL, 'Red');
  Ready[2].LoadFromResourceName(DLL, 'Orange');
  Ready[3].LoadFromResourceName(DLL, 'Green');
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
 for i:=1 to 10 do for j:=1 to 10 do Poly[i, j]:=aEmpty;
end;

procedure TGame.ClearAll;
var i,j:Byte;
begin
 for i:=1 to 10 do
  for j:=1 to 10 do
   begin
    Poly[i, j]:=aEmpty;
    CompKill[i, j]:=aEmpty;
    PlayerKill[i, j]:=aEmpty;
    CompDirs[i, j]:=0;
    PlayerDirs[i, j]:=0;
    Radar[i, j]:=aEmpty;
   end;
 Player:=Poly;
 Comp:=Poly;
 FormMain.PanelResult.Hide;
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
   if (Game.LastShoots.Last.X = ACol) and (Game.LastShoots.Last.Y = ARow) then Bitmaps.DrawBMP.Canvas.Draw(0,0, Bitmaps.Ani1[Bitmaps.CurAni]);
   DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.DrawBMP);
   Exit;
  end;
 if (ACol=0) or (ACol=11) then
  begin
   Bitmaps.DrawBMP.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.FormBrush.Canvas, GetCurRect);
   W:=Bitmaps.DrawBMP.Canvas.TextWidth(IntToStr(ARow));
   H:=Bitmaps.DrawBMP.Canvas.TextHeight(IntToStr(ARow));
   Bitmaps.DrawBMP.Canvas.TextOut(12 - (W div 2), 12 - (H div 2), IntToStr(ARow));
   if (Game.LastShoots.Last.X = ACol) and (Game.LastShoots.Last.Y = ARow) then Bitmaps.DrawBMP.Canvas.Draw(0,0, Bitmaps.Ani1[Bitmaps.CurAni]);
   DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.DrawBMP);
   Exit;
  end;
 if (ARow=0) or (ARow=11) then
  begin
   Bitmaps.DrawBMP.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.FormBrush.Canvas, GetCurRect);
   W:=Bitmaps.DrawBMP.Canvas.TextWidth(RuChars[ACol]);
   H:=Bitmaps.DrawBMP.Canvas.TextHeight(RuChars[ACol]);
   Bitmaps.DrawBMP.Canvas.TextOut(12 - (W div 2), 12 - (H div 2), RuChars[ACol]);
   if (Game.LastShoots.Last.X = ACol) and (Game.LastShoots.Last.Y = ARow) then Bitmaps.DrawBMP.Canvas.Draw(0,0, Bitmaps.Ani1[Bitmaps.CurAni]);
   DrawGridPoly.Canvas.StretchDraw(Rect, Bitmaps.DrawBMP);
   Exit;
  end;
 Bitmaps.DrawBMP.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.FormBrush.Canvas, GetCurRect);
 if (Game.LastShoots.Last.X = ACol) and (Game.LastShoots.Last.Y = ARow) then Bitmaps.DrawBMP.Canvas.Draw(0,0, Bitmaps.Ani1[Bitmaps.CurAni]);
 if Game.Player[ACol, ARow] in [1..4] then Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.ShipsPics[Game.CompDirs[ACol, ARow]]);

 case Game.PlayerKill[ACol, ARow] of
  aPast: Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Past);
  aWound:Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Fire[Bitmaps.CurFire]);
  aKill: Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Fire[Bitmaps.CurFire]);
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
 ClientHeight:=361;
 ClientWidth:=925;
 {DrawGridPoly.Width:=299;
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
 EditInput.Height:=20;   }

 LabelTime.Font.Name:='Techno28';
 
 Need:=True;
 SetWindowRgn(Handle, CreateRoundRectRgn(0, 0, Width, Height, 20, 20), True);
 SetWindowRgn(PanelResult.Handle, CreateRoundRectRgn(0, 0, PanelResult.Width, PanelResult.Height, 20, 20), True);
 Bitmaps:=TBitmaps.Create;
 Bitmaps.LoadSkinFromDll(Path+'Graphics\default.dll');
 Bitmaps.CurAni:=1;
 Bitmaps.CurFire:=1;
 Bitmaps.CurLine:=1;
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
 Game.TuneForPlacement;
 TimerSet.Enabled:=True;
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
   if (Game.MCur.X = ACol) and (Game.MCur.Y = ARow) then Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Ani1[Bitmaps.CurAni]);
   DrawGridComp.Canvas.StretchDraw(Rect, Bitmaps.DrawBMP);
   Exit;
  end;
 if (ACol=0) or (ACol=11) then
  begin
   Bitmaps.DrawBMP.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.FormBrush.Canvas, GetCurRect);
   if (Game.MCur.X = ACol) and (Game.MCur.Y = ARow) then Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Ani1[Bitmaps.CurAni]);
   W:=Bitmaps.DrawBMP.Canvas.TextWidth(IntToStr(ARow));
   H:=Bitmaps.DrawBMP.Canvas.TextHeight(IntToStr(ARow));
   Bitmaps.DrawBMP.Canvas.TextOut(12 - (W div 2), 12 - (H div 2), IntToStr(ARow));
   DrawGridComp.Canvas.StretchDraw(Rect, Bitmaps.DrawBMP);
   Exit;
  end;
 if (ARow=0) or (ARow=11) then
  begin
   Bitmaps.DrawBMP.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.FormBrush.Canvas, GetCurRect);
   if (Game.MCur.X = ACol) and (Game.MCur.Y = ARow) then Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Ani1[Bitmaps.CurAni]);
   W:=Bitmaps.DrawBMP.Canvas.TextWidth(RuChars[ACol]);
   H:=Bitmaps.DrawBMP.Canvas.TextHeight(RuChars[ACol]);
   Bitmaps.DrawBMP.Canvas.TextOut(12 - (W div 2), 12 - (H div 2), RuChars[ACol]);
   DrawGridComp.Canvas.StretchDraw(Rect, Bitmaps.DrawBMP);
   Exit;
  end;
 Bitmaps.DrawBMP.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.FormBrush.Canvas, GetCurRect);
 if (Game.Status=tsEnd) and (Game.Comp[ACol, ARow] in [1..4]) then
  Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.ShipsPics[Game.PlayerDirs[ACol, ARow]]);
 case Game.CompKill[ACol, ARow] of
  aPast:Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Past);
  aWound:Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Fire[Bitmaps.CurFire]);
  aKill:
   begin
    Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.ShipsPics[Game.PlayerDirs[ACol, ARow]]);
    Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Fire[Bitmaps.CurFire]);
   end;
  aUser:Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.UPast);
 end;
 if (Game.MCur.X = ACol) and (Game.MCur.Y = ARow) then Bitmaps.DrawBMP.Canvas.Draw(0, 0, Bitmaps.Ani1[Bitmaps.CurAni]);
 DrawGridComp.Canvas.StretchDraw(Rect, Bitmaps.DrawBMP);
end;

function TGame.CheckFullPoly:Boolean;
begin
 Result:=Ships[1] = 0;
end;

function TGame.GetCurShip:Byte;
begin
 for Result:=4 downto 1 do if Ships[Result]<>0 then Break;
end;

function TGame.ShipIsAllWound(SPos:TPoint; Direction:TDirection; var Poly:TKillArray; SSize:Byte):Boolean;
var i:Byte;
begin
 Result:=False;
 case Direction of
  tdLeft:  for i:= 0 to SSize-1 do if Poly[SPos.X-i, SPos.Y] <> aWound then Exit;
  tdRight: for i:= 0 to SSize-1 do if Poly[SPos.X+i, SPos.Y] <> aWound then Exit;
  tdUp:    for i:= 0 to SSize-1 do if Poly[SPos.X, SPos.Y-i] <> aWound then Exit;
  tdDown:  for i:= 0 to SSize-1 do if Poly[SPos.X, SPos.Y+i] <> aWound then Exit;
 end;
 Result:=True;
end;

procedure TGame.KillShip(SPos:TPoint; Direction:TDirection; var Poly:TKillArray; SSize:Byte; Whose:TLead);
var i:Byte;
begin
 case Direction of
  tdLeft:  for i:= 0 to SSize-1 do Poly[SPos.X-i, SPos.Y]:=aKill;
  tdRight: for i:= 0 to SSize-1 do Poly[SPos.X+i, SPos.Y]:=aKill;
  tdUp:    for i:= 0 to SSize-1 do Poly[SPos.X, SPos.Y-i]:=aKill;
  tdDown:  for i:= 0 to SSize-1 do Poly[SPos.X, SPos.Y+i]:=aKill;
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
 if Status <> tsPlay then Exit;
 Got:=False;
 case Player[SPos.X, SPos.Y] of
  1..4:
   begin
    if (PlayerKill[SPos.X, SPos.Y]=aWound) or
       (PlayerKill[SPos.X, SPos.Y]=aKill) or
       (PlayerKill[SPos.X, SPos.Y]=aUser)
    then Exit;
    PlayerKill[SPos.X, SPos.Y]:=aWound;
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
 DrawAll(tlPlayer);
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
     PassLead.Execute;
     PlayerArms.GoodShoots:=0;
     Exit;
    end
   else
    begin
     Inc(PlayerArms.GoodShoots);
     if PlayerArms.GoodShoots = 2 then
      begin
       Inc(PlayerArms.Bonus);
       PlayerArms.GoodShoots:=0;
      end;
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
end;

procedure TGame.ActionTorpedoComp(NPos:TPoint);
var Got:Boolean;
 SPos:TPoint;
 i:Byte;
begin
 if (Status <> tsPlay) or (Lead <> tlComp) then Exit;
 with FormMain do
  begin
   ShowSteps(NPos);
   WriteIt(CompName+': Торпеда по координатам '+RuChars[NPos.X]+'-'+IntToStr(NPos.Y), itLeadComp);
   for i:=NPos.X to NPos.X+(TorpedoSize-1) do
    begin
     if i >= 11 then Break;
     SPos.X:=i;
     SPos.Y:=NPos.Y;
      ///////////////////////////////////////////
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
         ItNS:=False;
         CompUsedDir:=[];
         if CheckPlayer then
          begin
           Status:=tsEnd;
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
         UseLastDir:=ItNS;
         IsNextShoot:=True;
        end;
       CompLastShoot:=SPos;
       Waiting;
       FormMain.PassLead.Execute;
       FormMain.DrawGridComp.SetFocus;
       Exit;
      end
     else
      begin
       GoSound(stPast);
       LastShoots.Use:=ItNS;
       UseLastDir:=False;
       CompUsedDir:=[];
      end;
     FormMain.DrawGridComp.SetFocus;
     ///////////////////////////
     DrawAll(tlComp);
     Waiting(600);
    end;
   Lead:=tlPlayer;
   DrawAll(tlComp);
  end;
end;

procedure TGame.ActionTorpedo(NPos:TPoint);
var Got:Boolean;
 SPos:TPoint;
 i:Byte;
 TText:string;
begin
 if (Status <> tsPlay) or (Lead <> tlPlayer) then Exit;
 if (not (NPos.X in [1..10])) or (not (NPos.Y in [1..10])) then Exit;
 if PlayerShips[2] <= 0 then
  begin
   WriteIt('У вас нет Подлодок', itGame);
   Exit;
  end;
 if PlayerArms.Bonus >= 2 then Dec(PlayerArms.Bonus, 2) else Exit;
 TText:=RuChars[NPos.X]+'-'+IntToStr(NPos.Y);
 WriteIt(PlayerName+': Торпеда по координатам: '+TText, itLeadPlayer);
 with FormMain do
  begin
   for i:=NPos.X to NPos.X+(TorpedoSize-1) do
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
          Exit;
         end
        else GoSound(stPast);
       end;
     DrawAll(tlPlayer);
     Waiting(600);
    end;
   Lead:=tlComp;
   PassLead.Execute;
   DrawAll(tlPlayer);
  end;
end;

procedure TGame.ActionRadar(SPos:TPoint);
var i, j:SmallInt;
begin
 if (Status <> tsPlay) or (Lead <> tlPlayer) then Exit;
 if (not (SPos.X in [1..10])) or (not (SPos.Y in [1..10])) then Exit;
 if PlayerShips[3] <= 0 then
  begin
   WriteIt('У вас нет Миноносцев', itGame);
   Exit;
  end;
 RadarText:=RuChars[SPos.X]+'-'+IntToStr(SPos.Y);
 WriteIt(PlayerName+': Использую радар', itLeadPlayer);
 if PlayerArms.Bonus >= 4 then Dec(PlayerArms.Bonus, 4) else Exit;
 for i:=-1 to 1 do
  for j:=-1 to 1 do
   begin
    Radar[2+i, 2+j]:=Comp[SPos.X+i, SPos.Y+j];
   end;
 Bitmaps.LineCL:=1;
 Bitmaps.CurLine:=1;
 FormMain.TimerClearRadar.Enabled:=True;
 DrawAll(tlPlayer);
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
    SPos.X:=ACol;
    SPos.Y:=ARow;
    if (Game.Status = tsPlay) and (Game.Lead=tlPlayer) and (Game.MCur.X = SPos.X) and (Game.MCur.Y = SPos.Y) then
     begin
      Game.MCur:=SPos;
      Game.Input(SPos);
     end
    else Game.MCur:=SPos;
   end;
  mbRight:
   begin
    if (Game.Status = tsPlay) then
     begin
      SPos.X:=ACol;
      SPos.Y:=ARow;
      if (ssCtrl in Shift) and (Game.CompKill[SPos.X, SPos.Y] = aKill) then
       begin
        Game.InsertPastForUser(SPos);
        Game.DrawAll(tlPlayer);
        TimerGo.Enabled:=True;
        Exit;
       end;
      Game.PlayerPast(SPos);
     end;
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
     if (CheckCell(DPos)) and (PlayerKill[DPos.X, DPos.Y] <> aPast) and (PlayerKill[DPos.X, DPos.Y] <> aUser) then
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
      end;
    end;
  tdRight:
    begin
     DPos:=Point(LastShoot.X+1, LastShoot.Y);
     while PlayerKill[DPos.X, DPos.Y] = aWound do Inc(DPos.X);
     if (CheckCell(DPos)) and (PlayerKill[DPos.X, DPos.Y] <> aPast) and (PlayerKill[DPos.X, DPos.Y] <> aUser) then
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
    end;
   tdUp:
    begin
     DPos:=Point(LastShoot.X, LastShoot.Y-1);
     while PlayerKill[DPos.X, DPos.Y] = aWound do Dec(DPos.Y);
     if (CheckCell(DPos)) and (PlayerKill[DPos.X, DPos.Y] <> aPast) and (PlayerKill[DPos.X, DPos.Y] <> aUser) then
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
    end;
   tdDown:
    begin
     DPos:=Point(LastShoot.X, LastShoot.Y+1);
     while PlayerKill[DPos.X, DPos.Y] = aWound do Inc(DPos.Y);
     if (CheckCell(DPos)) and (PlayerKill[DPos.X, DPos.Y] <> aPast) and (PlayerKill[DPos.X, DPos.Y] <> aUser) then
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

function TGame.GetFirePosition:TPoint;
var i, CPos, LogicID:Byte;
begin
 Result:=Point(0, 0);
 Randomize;
 if (CompShips[2] <> 0) and (CompArms.Bonus >= 2) then                          //Если есть подлодки и бонусы, то пускаем торпеду
  begin
   Dec(CompArms.Bonus, 2);
   //Result:=GetActualTorpedoPosition(PlayerKill);
   ActionTorpedoComp(GetActualTorpedoPosition(PlayerKill));
   Exit;
  end;
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
         Result:=LogicPoses[LogicID].SPos;
         LastDir:=LogicPoses[LogicID].SDir;
         case LastDir of
          tdDown:Result.Y:=Result.Y+Random(2);
          tdRight:Result.X:=Result.X+Random(2);
         end;
         UseLastDir:=True;
         Break;
        end;
      end;
    end;
  end
 else
  repeat                                                                        //Выбираем случайную координату
   Result.X:=Random(10)+1;
   Result.Y:=Random(10)+1;
  until (PlayerKill[Result.X, Result.Y] = aEmpty) or (Game.Status <> tsPlay);
end;

procedure TGame.ShowSteps(NewPos:TPoint);
begin
 //NewPos - Новая позиция
 //LastShoots.Last - старая позиция
 repeat
  if LastShoots.Last.X < NewPos.X then Inc(LastShoots.Last.X);
  if LastShoots.Last.X > NewPos.X then Dec(LastShoots.Last.X);
  if LastShoots.Last.Y < NewPos.Y then Inc(LastShoots.Last.Y);
  if LastShoots.Last.Y > NewPos.Y then Dec(LastShoots.Last.Y);
  Waiting(500);
  DrawAll(tlComp);
 until (NewPos.X = LastShoots.Last.X) and
       (NewPos.Y = LastShoots.Last.Y);
end;

procedure TGame.DoCompShoot;
var SPos:TPoint;
   Got:Boolean;

begin
 GoSound(stShoot);
 if not IsNextShoot then                                                        //Если нет рассчитанного хода, то
  begin
   SPos:=GetFirePosition;
   ItNS:=False;
   if (SPos.X = 0) or (SPos.Y = 0) then Exit;                                   //Если, что-то использовано, то выходим
  end
 else
  begin
   SPos:=GetNextShoot(CompLastShoot);
   ItNS:=True;
  end;
 ShowSteps(SPos);
 LastShoots.Last:=SPos;
 Waiting;
 WriteIt(CompName+': '+RuChars[SPos.X]+'-'+IntToStr(SPos.Y), itLeadComp);
 CompShoot(SPos, Got);
 DrawAll(tlComp);
 if Got then
  begin
   Inc(CompArms.GoodShoots);
   if CompArms.GoodShoots = 2 then Inc(CompArms.Bonus);
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
     ItNS:=False;
     CompUsedDir:=[];
     if CheckPlayer then
      begin
       Status:=tsEnd;
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
     UseLastDir:=ItNS;
     IsNextShoot:=True;
    end;
   CompLastShoot:=SPos;
   Waiting;
   FormMain.PassLead.Execute;
   FormMain.DrawGridComp.SetFocus;
   Exit;
  end
 else
  begin
   CompArms.GoodShoots:=0;
   GoSound(stPast);
   Lead:=tlPlayer;
   WriteIt(PlayerName+': Мимо', itLeadPlayer);
   LastShoots.Use:=ItNS;
   Include(CompUsedDir, LastDir);
   UseLastDir:=False;
   if not ItNS then CompUsedDir:=[];
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
var MyText, tmpstr:string;
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
   TuneForPlacement;
   CurDir:=True;
   AClear;
   ClearSli;
   AClear;
   SetShips;
   TMP:=Poly;
   RefreshShips;
   UpdateShips;
   AllSet:=True;
   ClearSli;
   FormMain.DrawGridSet.Repaint;
   Player:=TMP;
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
    0:tmpstr:='Привет';
    1:tmpstr:='Здравствуй';
    2:tmpstr:='Приветствую';
    3:tmpstr:='Welcome';
    4:tmpstr:='Hi, what`s up';
    5:tmpstr:='Хай';
   end;
   if not CName then
    begin
     if PlayerName <> '' then Answer:=tmpstr+', '+PlayerName;
    end
   else Answer:=tmpstr+',я '+CompName+', приятно познакомится';
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
   FormMain.PassLead.Execute;
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
     Game.WriteIt(Game.PlayerName+': '+EditInput.Text, itLeadPlayer);
     Game.AnalysAnswer(EditInput.Text);
    end;
   EditInput.Text:='';
  end;
end;

procedure TFormMain.TimerSpeakTimer(Sender: TObject);
begin
 TimerSpeak.Enabled:=False;
 if Game.Answer<>'' then
  begin
   Game.WriteIt(Game.CompName+': '+Game.Answer, itLeadComp);
   Game.Answer:='';
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
    Game.WriteIt(Game.CompName+': '+VM, itLeadComp);
   end;
  tsEnd:
   begin
    case Random(6) of
     0:VM:='Счет '+IntToStr(Game.Wins)+':'+IntToStr(Game.Loses)+' давай же изменим его';
     1:VM:='Ну расставляй';
     2:VM:='Расставляй бегом';
     3:VM:='Хочу играть';
     4:VM:='Играть, играть и ещё раз играть';
     5:VM:='Я уже готов, а ты?';
     6:VM:='Ну же, начинай';
    end;
    Game.WriteIt(Game.CompName+': '+VM, itLeadComp);
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
 if Game.Score  = 0 then PanelResult.Canvas.Draw(0, 0, Bitmaps.Results[0]);
 if Game.Score >= 1 then PanelResult.Canvas.Draw(0, 0, Bitmaps.Results[1]);
 if Game.Score >= 2 then PanelResult.Canvas.Draw(0, 0, Bitmaps.Results[2]);
 if Game.Score >= 3 then PanelResult.Canvas.Draw(0, 0, Bitmaps.Results[3]);
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
  VK_LEFT:  if Game.MCur.X-1 <  0 then Exit else begin Dec(Game.MCur.X); DrawGridComp.Repaint; end;
  VK_RIGHT: if Game.MCur.X+1 > 11 then Exit else begin Inc(Game.MCur.X); DrawGridComp.Repaint; end;
  VK_UP:    if Game.MCur.Y-1 <  0 then Exit else begin Dec(Game.MCur.Y); DrawGridComp.Repaint; end;
  VK_DOWN:  if Game.MCur.Y+1 > 11 then Exit else begin Inc(Game.MCur.Y); DrawGridComp.Repaint; end;
  VK_SPACE: if (Game.MCur.X in [1..10]) and (Game.MCur.Y in [1..10]) then
   begin
    TimerGo.Enabled:=False;
    TimerGo.Interval:=30000;
    if (Game.Status = tsPlay) then
     if (Game.Lead=tlPlayer) then Game.Input(Game.MCur) else ActionNewGame.Execute;
    TimerGo.Enabled:=True;
    DrawGridComp.Repaint;
   end;
  Ord('R'):Game.ActionRadar(Game.MCur);
  Ord('T'):Game.ActionTorpedo(Game.MCur);
 end;
 if (Game.MCur.X in [1..10]) and (Game.MCur.Y in [1..10]) then
  LabelXP.Caption:=RuChars[Game.MCur.X]+'-'+IntToStr(Game.MCur.Y);
 DrawGridComp.SetFocus;
end;

procedure TFormMain.ActionNewGameExecute(Sender: TObject);
begin
 if Game.Status = tsPlay then
  begin
   if MessageBox(Handle, 'Начать новую игру? Текущая будет прервана!', '', MB_ICONQUESTION or MB_YESNO) <> ID_YES then Exit;
  end;
 if Game.Status = tsPlacement then Exit;
 Game.ClearAll;
 Game.ClearList;
 Game.TuneForPlacement;
 TimerSet.Enabled:=True;
 Game.CurDir:=True;
 Game.AClear;
 Game.ClearSli;
end;

procedure TFormMain.TimerCompShootTimer(Sender: TObject);
begin
 TimerCompShoot.Enabled:=False;
 Game.DoCompShoot;
end;

procedure TFormMain.PassLeadExecute(Sender: TObject);
begin
 //Передать ход компьютеру "на раздумие"
 TimerCompShoot.Enabled:=True;
end;

procedure TFormMain.TimerAniTimer(Sender: TObject);
begin
 with Bitmaps do
  begin
   if CurAni = Length(Bitmaps.Ani1) then DoUp1:=False;
   if CurAni = 1 then DoUp1:=True;
   if DoUp1 then Inc(CurAni) else Dec(CurAni);

   if CurFire = Length(Bitmaps.Fire) then DoUp2:=False;
   if CurFire = 1 then DoUp2:=True;
   if DoUp2 then Inc(CurFire) else Dec(CurFire);

   Inc(CurLine);
   if CurLine > Length(Bitmaps.LineRadar) then CurLine:=1;
   if LineCL < 5 then
    begin
     if CurLine <= 10 then LineCL:=1;
     if CurLine >= 10 then LineCL:=2;
     if CurLine >= 20 then LineCL:=3;
     if CurLine >= 30 then LineCL:=4;
     if CurLine = 36  then LineCL:=5;
    end;
  end;
 DrawGridComp.Repaint;
 DrawGridPoly.Repaint;
 DrawGridRadar.Repaint;
end;

procedure TFormMain.TimerClearRadarTimer(Sender: TObject);
var i,j:Byte;
begin
 TimerClearRadar.Enabled:=False;
 for i:=1 to 10 do
  for j:=1 to 10 do
   begin
    Application.ProcessMessages;
    Game.Radar[i,j]:=aEmpty;
   end;
 DrawGridRadar.Repaint; 
end;

procedure TFormMain.DrawGridRadarDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var x, y:Byte;

function GetCurRect:TRect;
begin
 Result.Left:=DrawGridRadar.Left;
 Result.Top:=DrawGridRadar.Top;
 Result.Right:=Result.Left+DrawGridRadar.Width;
 Result.Bottom:=Result.Top+DrawGridRadar.Height;
end;
begin
 Bitmaps.DrawBMP2.Canvas.CopyRect(GetRect(0, 0, DrawGridRadar.Width, DrawGridRadar.Height), Bitmaps.FormBrush.Canvas, GetCurRect);
 Bitmaps.DrawBMP2.Canvas.Draw(12, 3, Bitmaps.Radar);
 for x:=1 to 3 do
  for y:=1 to 3 do
   if Game.Radar[x, y] in [1..4] then
    begin
     if Bitmaps.LineCL <= 5 then
      begin
       //Если прошла 2 четверть (точки, [1:1], [1:2], [2:1], [2:2]). Позиция линии (not in [1..10])
       if (x<=2) and (y<=2) and  (Bitmaps.LineCL > 1) then Bitmaps.DrawBMP2.Canvas.Draw((16*x)+26+Random(2)-1, (16*y)+14+Random(2)-1, Bitmaps.RadarObject);
       //Если прошла 3 четверть (точки, [1:2], [1:3], [2:2], [2:3]). Позиция линии (not in [11..20])
       if (x<=2) and (y>2)  and  (Bitmaps.LineCL > 2) then Bitmaps.DrawBMP2.Canvas.Draw((16*x)+26+Random(2)-1, (16*y)+14+Random(2)-1, Bitmaps.RadarObject);
       //Если прошла 4 четверть (точки, [2:2], [2:3], [3:2], [3:3]). Позиция линии (not in [21..30])
       if (x>2)  and (y>2)  and  (Bitmaps.LineCL > 3) then Bitmaps.DrawBMP2.Canvas.Draw((16*x)+26+Random(2)-1, (16*y)+14+Random(2)-1, Bitmaps.RadarObject);
       //Если прошла 1 четверть (точки, [2:1], [2:2], [3:1], [3:2]). Позиция линии (not in [31..36])
       if (x>2)  and (y<=2) and  (Bitmaps.LineCL > 4) then Bitmaps.DrawBMP2.Canvas.Draw((16*x)+26+Random(2)-1, (16*y)+14+Random(2)-1, Bitmaps.RadarObject);
      end
     else Bitmaps.DrawBMP2.Canvas.Draw((16*x)+26, (16*y)+14, Bitmaps.RadarObject);
    end;

 Bitmaps.DrawBMP2.Canvas.Draw(12, 3, Bitmaps.LineRadar[Bitmaps.CurLine]);
 Bitmaps.DrawBMP2.Canvas.Brush.Style:=bsClear;
 Bitmaps.DrawBMP2.Canvas.TextOut(45, 95, Game.RadarText);

 for y:=0 to Game.PlayerArms.Bonus do
  begin
   if y = 5 then Break;
   case y+1 of
    1, 2:Bitmaps.DrawBMP2.Canvas.Draw(114, 98-(24*y), Bitmaps.Ready[1]);
    3, 4:Bitmaps.DrawBMP2.Canvas.Draw(114, 98-(24*y), Bitmaps.Ready[2]);
    5:Bitmaps.DrawBMP2.Canvas.Draw(114, 98-(24*y), Bitmaps.Ready[3]);
   end;
  end;

 DrawGridRadar.Canvas.StretchDraw(Rect, Bitmaps.DrawBMP2);
end;

procedure TFormMain.ButtonRadarClick(Sender: TObject);
begin
 Game.ActionRadar(Game.MCur);
end;

procedure TFormMain.ButtonTorpedoClick(Sender: TObject);
begin
 Game.ActionTorpedo(Game.MCur);
end;

procedure TFormMain.ButtonFireClick(Sender: TObject);
begin
 Game.Input(Game.MCur);
end;

procedure TFormMain.DrawGridSetDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var W,H:Byte;

function GetCurRect:TRect;
begin
 Result.Left:=DrawGridSet.Left+Rect.Left;
 Result.Top:=DrawGridSet.Top+Rect.Top;
 Result.Right:=Result.Left+24;
 Result.Bottom:=Result.Top+24;
end;

begin
 if ((ACol=0) and (ARow=0)) or ((ACol=11) and (ARow=11)) or ((ACol=11) and (ARow=0)) or ((ACol=0) and (ARow=11)) then
  begin
   Bitmaps.DrawBMP3.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.FormBrush.Canvas, GetCurRect);
   DrawGridSet.Canvas.StretchDraw(Rect, Bitmaps.DrawBMP3);
   Exit;
  end;
 if (ACol=0) or (ACol=11) then
  begin
   Bitmaps.DrawBMP3.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.FormBrush.Canvas, GetCurRect);
   W:=Bitmaps.DrawBMP3.Canvas.TextWidth(IntToStr(ARow));
   H:=Bitmaps.DrawBMP3.Canvas.TextHeight(IntToStr(ARow));
   Bitmaps.DrawBMP3.Canvas.TextOut(12-(W div 2), 12 -(H div 2), IntToStr(ARow));
   DrawGridSet.Canvas.StretchDraw(Rect, Bitmaps.DrawBMP3);
   Exit;
  end;
 if (ARow=0) or (ARow=11) then
  begin
   Bitmaps.DrawBMP3.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.FormBrush.Canvas, GetCurRect);
   W:=Bitmaps.DrawBMP3.Canvas.TextWidth(RuChars[ACol]);
   H:=Bitmaps.DrawBMP3.Canvas.TextHeight(RuChars[ACol]);
   Bitmaps.DrawBMP3.Canvas.TextOut(12 -(W div 2), 12 -(H div 2), RuChars[ACol]);
   DrawGridSet.Canvas.StretchDraw(Rect, Bitmaps.DrawBMP3);
   Exit;
  end;

 Bitmaps.DrawBMP3.Canvas.CopyRect(GetRect(0, 0, 24, 24), Bitmaps.FormBrush.Canvas, GetCurRect);
 case Game.TMP[ACol, ARow] of
  1..4:Bitmaps.DrawBMP3.Canvas.Draw(0, 0, Bitmaps.ShipsPics[Game.TMPDir[ACol, ARow]]);
 end;
 case Game.Sli[ACol, ARow] of
  1..4:Bitmaps.DrawBMP3.Canvas.Draw(0, 0, Bitmaps.Ships[3]);
  5: Bitmaps.DrawBMP3.Canvas.Draw(0, 0, Bitmaps.Ships[1]);
 end;
 DrawGridSet.Canvas.StretchDraw(Rect, Bitmaps.DrawBMP3);
end;

procedure TFormMain.DrawGridSetMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var SPos:TPoint;
 ACol, ARow:Integer;
 Ship:Byte;
begin
 if Button = mbLeft then
  begin
   if not Game.CheckFullPoly then
    begin
     DrawGridSet.MouseToCell(X, Y, ACol, ARow);
     if (ARow = 11) or (ACol = 11) or (ARow = 0) or (ACol = 0) then Exit;
     Ship:=Game.GetCurShip;
     SPos.X:=ACol;
     SPos.Y:=ARow;
     Game.Poly:=Game.TMP;
     Game.ClearSli;
     case Game.CurDir of
      True:if Game.CheckInsert(SPos, tdRight, Ship) then
            begin
             Dec(Game.Ships[Ship]);
             Game.InsertShip(SPos, tdRight, Ship);
             Game.TMP:=Game.Poly;
            end
           else
            begin
             Game.ClearPoly;
             Game.InsertShip(SPos, tdRight, Ship);
             Game.Sli:=Game.Poly;
             Game.WriteIt('Так ставить нельзя', itGame);
            end;
      False:if Game.CheckInsert(SPos, tdDown, Ship) then
             begin
              Dec(Game.Ships[Ship]);
              Game.InsertShip(SPos, tdDown, Ship);
              Game.TMP:=Game.Poly;
             end
            else
             begin
              Game.ClearPoly;
              Game.InsertShip(SPos, tdDown, Ship);
              Game.Sli:=Game.Poly;
              Game.WriteIt('Так ставить нельзя', itGame);              
             end;
     end;
     Game.UpdateShips;
     if Game.CheckFullPoly then Game.AllSet:=True;
     DrawGridSet.Repaint;
    end;
  end;
 if Button = mbRight then
  begin
   Game.CurDir:=not Game.CurDir;
   Game.ClearSli;
   DrawGridSet.OnMouseMove(Sender, Shift, X, Y);
   DrawGridSet.Repaint;
   Game.RefreshShips;
  end;
end;

procedure TFormMain.DrawGridSetMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var SPos:TPoint;
 ACol, ARow:Integer;
 Ship:Byte;
begin
 if (not Game.CheckFullPoly) and (not Game.AllSet) then
  begin
   if DrawGridSet.Cursor <> 2 then DrawGridSet.Cursor:=2;
   DrawGridSet.MouseToCell(X, Y, ACol, ARow);
   if (Game.OldC = ACol) and (Game.OldR = ARow) and (Game.CurDir = Game.OldDir) then Exit;
   if not ((ACol = 0) or (ARow = 0) or (ACol = 11) or (ARow = 11)) then LabelXP.Caption:=RuChars[ACol]+'-'+IntToStr(ARow);
   Game.OldDir:=Game.CurDir;
   Game.OldC:=ACol;
   Game.OldR:=ARow;
   if (ARow = 11) or (ACol = 11) or (ARow = 0) or (ACol = 0) then Exit;
   Ship:=Game.GetCurShip;
   SPos:=Point(ACol, ARow);
   Game.ClearSli;
   Game.ClearPoly;
   //Game.Poly:=Game.TMP;
   case Game.CurDir of
     True:if Game.CheckInsert(SPos, tdRight, Ship) then Game.InsertShip(SPos, tdRight, Ship) else  Game.InsertShip(SPos, tdRight, 5);
    False:if Game.CheckInsert(SPos, tdDown , Ship) then Game.InsertShip(SPos, tdDown , Ship) else  Game.InsertShip(SPos, tdDown, 5);
   end;
   Game.Sli:=Game.Poly;
   Game.ClearPoly;
   Game.RefreshShips;
   DrawGridSet.Repaint;
  end
 else
  if DrawGridSet.Cursor = crDefault then Exit else DrawGridSet.Cursor:=crDefault;
end;

procedure TFormMain.TimerSetTimer(Sender: TObject);
begin
 ButtonStart.Enabled:=Game.AllSet;
end;

procedure TFormMain.ButtonClearSetClick(Sender: TObject);
begin
 Game.AClear;
 Game.ClearSli;
end;

procedure TFormMain.ButtonAutoTuneClick(Sender: TObject);
begin
 Game.AClear;
 Game.SetShips;
 Game.TMP:=Game.Poly;
 Game.RefreshShips;
 Game.UpdateShips;
 Game.AllSet:=True;
 Game.ClearSli;
 DrawGridSet.Repaint;
end;

procedure TFormMain.ButtonStartClick(Sender: TObject);
begin
 if not Game.AllSet then Exit;
 TimerSet.Enabled:=False;
 Game.ClearAll;
 Game.Player:=Game.TMP;
 Game.CompDirs:=Game.TMPDir;
 Game.New;
 DrawGridPoly.Repaint;
 DrawGridComp.Repaint;
 TimerGo.Enabled:=True;
end;

procedure TFormMain.TimerActionsTimer(Sender: TObject);
begin
 ButtonRadar.Enabled:= Game.PlayerArms.Bonus >= 4;
 ButtonTorpedo.Enabled:= Game.PlayerArms.Bonus >= 2;
end;

procedure TFormMain.DrawGridPolyMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var ACol, ARow:Integer;
begin
 DrawGridPoly.MouseToCell(X, Y, ACol, ARow);
 if not ((ACol = 0) or (ARow = 0) or (ACol = 11) or (ARow = 11)) then LabelXP.Caption:=RuChars[ACol]+'-'+IntToStr(ARow);
end;

procedure TFormMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 Need:=True;
end;

initialization
  Path:=ExtractFilePath(ParamStr(0));
  AddFontResource(PChar(Path+'Techno.ttf'));
  SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
  NotCensorshipList:=TStringList.Create;
  if FileExists(Path+'\Bot\Obscene.lst') then NotCensorshipList.LoadFromFile(Path+'\Bot\Obscene.lst');

end.
