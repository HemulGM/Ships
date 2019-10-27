object FormMain: TFormMain
  Left = 232
  Top = 150
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsNone
  Caption = #1052#1086#1088#1089#1082#1086#1081' '#1073#1086#1081
  ClientHeight = 361
  ClientWidth = 925
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  ScreenSnap = True
  ShowHint = True
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonClose: TSpeedButton
    Left = 899
    Top = 3
    Width = 18
    Height = 18
    Hint = #1042#1099#1093#1086#1076
    Flat = True
    OnClick = ButtonCloseClick
    OnMouseEnter = ButtonCloseMouseEnter
  end
  object ButtonHide: TSpeedButton
    Left = 878
    Top = 3
    Width = 18
    Height = 18
    Hint = #1057#1082#1088#1099#1090#1100' '#1086#1082#1085#1086
    Flat = True
    OnClick = ButtonHideClick
    OnMouseEnter = ButtonCloseMouseEnter
  end
  object ButtonNew: TSpeedButton
    Left = 596
    Top = 3
    Width = 18
    Height = 18
    Hint = #1053#1086#1074#1072#1103' '#1080#1075#1088#1072
    Flat = True
    OnClick = ButtonNewClick
    OnMouseEnter = ButtonCloseMouseEnter
  end
  object ButtonHelp: TSpeedButton
    Left = 857
    Top = 3
    Width = 18
    Height = 18
    Hint = #1055#1086#1084#1086#1097#1100
    Flat = True
    OnClick = ButtonHelpClick
    OnMouseEnter = ButtonCloseMouseEnter
  end
  object LabelTime: TLabel
    Left = 544
    Top = 336
    Width = 53
    Height = 19
    Caption = '00:00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Techno28'
    Font.Style = []
    ParentFont = False
  end
  object LabelXP: TLabel
    Left = 834
    Top = 336
    Width = 55
    Height = 19
    Alignment = taRightJustify
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Techno28'
    Font.Style = []
    ParentFont = False
  end
  object ButtonRadar: TSpeedButton
    Left = 176
    Top = 312
    Width = 57
    Height = 41
    Hint = #1047#1072#1087#1091#1089#1082' '#1088#1072#1076#1072#1088#1072' ('#1085#1077#1079#1072#1073#1091#1076#1100#1090#1077' '#1091#1082#1072#1079#1072#1090#1100' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099')'
    Caption = #1056#1072#1076#1072#1088
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    OnClick = ButtonRadarClick
    OnMouseEnter = ButtonCloseMouseEnter
  end
  object ButtonTorpedo: TSpeedButton
    Left = 176
    Top = 272
    Width = 57
    Height = 41
    Hint = #1055#1091#1089#1090#1080#1090#1100' '#1090#1086#1088#1087#1077#1076#1091
    Caption = #1058#1086#1088#1087#1077#1076#1072
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    OnClick = ButtonTorpedoClick
    OnMouseEnter = ButtonCloseMouseEnter
  end
  object ButtonFire: TSpeedButton
    Left = 176
    Top = 232
    Width = 57
    Height = 41
    Hint = #1054#1075#1086#1085#1100'!'
    Caption = #1054#1075#1086#1085#1100
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    OnClick = ButtonFireClick
    OnMouseEnter = ButtonCloseMouseEnter
  end
  object ButtonStart: TSpeedButton
    Left = 176
    Top = 232
    Width = 57
    Height = 41
    Hint = #1053#1072#1095#1072#1090#1100' '#1080#1075#1088#1091
    Caption = #1057#1090#1072#1088#1090
    Enabled = False
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Visible = False
    OnClick = ButtonStartClick
    OnMouseEnter = ButtonCloseMouseEnter
  end
  object ButtonAutoTune: TSpeedButton
    Left = 176
    Top = 272
    Width = 57
    Height = 41
    Hint = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1088#1072#1089#1089#1090#1072#1074#1080#1090#1100' '#1082#1086#1088#1072#1073#1083#1080' ('#1090#1077#1082#1091#1097#1077#1077' '#1088#1072#1089#1087#1086#1083#1086#1078#1077#1085#1080#1077' '#1091#1076#1072#1083#1080#1090#1089#1103')'
    Caption = #1056#1072#1089#1089#1090#1072#1074#1080#1090#1100
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Visible = False
    OnClick = ButtonAutoTuneClick
    OnMouseEnter = ButtonCloseMouseEnter
  end
  object ButtonClearSet: TSpeedButton
    Left = 176
    Top = 312
    Width = 57
    Height = 41
    Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1086#1083#1077
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Visible = False
    OnClick = ButtonClearSetClick
    OnMouseEnter = ButtonCloseMouseEnter
  end
  object DrawGridPoly: TDrawGrid
    Left = 250
    Top = 35
    Width = 299
    Height = 299
    BorderStyle = bsNone
    ColCount = 12
    Ctl3D = False
    DefaultColWidth = 24
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 12
    FixedRows = 0
    Options = [goVertLine, goHorzLine]
    ParentCtl3D = False
    ScrollBars = ssNone
    TabOrder = 0
    OnDrawCell = DrawGridPolyDrawCell
    OnMouseMove = DrawGridPolyMouseMove
    ColWidths = (
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24)
    RowHeights = (
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24)
  end
  object DrawGridComp: TDrawGrid
    Left = 590
    Top = 35
    Width = 299
    Height = 299
    BorderStyle = bsNone
    ColCount = 12
    Ctl3D = False
    DefaultColWidth = 24
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 12
    FixedRows = 0
    Options = [goVertLine, goHorzLine]
    ParentCtl3D = False
    ScrollBars = ssNone
    TabOrder = 1
    OnDrawCell = DrawGridCompDrawCell
    OnKeyDown = DrawGridCompKeyDown
    OnMouseDown = DrawGridCompMouseDown
    OnMouseMove = DrawGridCompMouseMove
    ColWidths = (
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24)
    RowHeights = (
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24)
  end
  object ListBoxPos: TListBox
    Left = 0
    Top = 8
    Width = 225
    Height = 225
    Style = lbOwnerDrawVariable
    AutoComplete = False
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Enabled = False
    ExtendedSelect = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ImeName = 'Russian'
    ItemHeight = 13
    ParentFont = False
    TabOrder = 2
    OnDrawItem = ListBoxPosDrawItem
  end
  object EditInput: TComboBox
    Left = 616
    Top = 1
    Width = 237
    Height = 21
    BevelInner = bvNone
    BevelKind = bkFlat
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    ImeName = 'Russian'
    ParentFont = False
    TabOrder = 3
    OnChange = EditInputChange
    OnKeyPress = EditInputKeyPress
    Items.Strings = (
      #1089#1090#1072#1090#1091#1089
      #1084#1077#1085#1103' '#1079#1086#1074#1091#1090
      #1087#1088#1080#1074#1077#1090
      #1079#1076#1088#1072#1074#1089#1090#1074#1091#1081
      #1087#1088#1080#1074#1077#1090#1089#1090#1074#1080#1077
      #1093#1072#1081
      'hi'
      #1076#1072#1088#1086#1074
      #1079#1076#1072#1088#1086#1074#1072
      #1079#1076#1072#1088#1086#1074
      #1087#1086#1082#1072
      #1076#1086' '#1089#1074#1080#1076#1072#1085#1080#1103
      #1076#1086' '#1074#1089#1090#1088#1077#1095#1080
      #1074#1099#1093#1086#1076
      'exit'
      'quit'
      #1079#1072#1082#1088#1099#1090#1100
      'close'
      'bye'
      #1093#1086#1076#1080
      #1089#1084#1077#1085#1080' '#1080#1084#1103
      #1076#1088#1091#1075#1086#1077' '#1080#1084#1103
      'sleep'
      #1074#1088#1077#1084#1103'='
      #1074#1088#1077#1084#1103' '
      #1085#1072#1095#1072#1090#1100' '#1089#1083#1091#1095#1072#1081#1085#1091#1102' '#1080#1075#1088#1091
      #1085#1086#1074#1072#1103' '#1080#1075#1088#1072
      #1085#1072#1095#1072#1090#1100' '#1079#1072#1085#1086#1074#1086
      #1089#1090#1072#1088#1090' '#1085#1086#1074#1086#1081
      #1080#1075#1088#1072#1090#1100
      #1088#1072#1089#1089#1090#1072#1074#1080#1090#1100' '#1082#1086#1088#1072#1073#1083#1080
      #1088#1072#1089#1089#1090#1072#1085#1086#1074#1082#1072' '#1082#1086#1088#1072#1073#1083#1077#1081
      #1079#1072#1085#1086#1074#1086' '#1080#1075#1088#1072#1090#1100
      #1085#1086#1074#1099#1081' '#1073#1086#1081
      #1089#1090#1072#1088#1090
      #1096#1072#1075#1080
      #1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1096#1072#1075#1080
      #1073#1077#1079' '#1096#1072#1075#1086#1074
      #1085#1077#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1096#1072#1075#1080
      #1089#1082#1088#1099#1090#1100' '#1096#1072#1075#1080
      #1091#1073#1088#1072#1090#1100' '#1096#1072#1075#1080)
  end
  object DrawGridRadar: TDrawGrid
    Left = 0
    Top = 232
    Width = 161
    Height = 128
    BorderStyle = bsNone
    ColCount = 1
    Ctl3D = False
    DefaultColWidth = 161
    DefaultRowHeight = 129
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    GridLineWidth = 0
    Options = []
    ParentCtl3D = False
    ScrollBars = ssNone
    TabOrder = 4
    OnDrawCell = DrawGridRadarDrawCell
    ColWidths = (
      161)
    RowHeights = (
      129)
  end
  object DrawGridSet: TDrawGrid
    Left = 250
    Top = 35
    Width = 299
    Height = 299
    BorderStyle = bsNone
    ColCount = 12
    DefaultColWidth = 24
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 12
    FixedRows = 0
    ScrollBars = ssNone
    TabOrder = 5
    Visible = False
    OnDrawCell = DrawGridSetDrawCell
    OnMouseMove = DrawGridSetMouseMove
    OnMouseUp = DrawGridSetMouseDown
    ColWidths = (
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24)
    RowHeights = (
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24)
  end
  object ListBoxHelp: TListBox
    Left = 250
    Top = 35
    Width = 299
    Height = 299
    Style = lbOwnerDrawFixed
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    ImeName = 'Russian'
    ItemHeight = 13
    Items.Strings = (
      #1048#1075#1088#1072' "'#1052#1086#1088#1089#1082#1086#1081' '#1041#1086#1081'"'
      '------------------------------------------------------'
      #1056#1072#1079#1088#1072#1073#1086#1090#1095#1080#1082' '#1087#1088#1086#1075#1088#1072#1084#1084#1099': '#1043#1077#1085#1085#1072#1076#1080#1081' '#1052#1072#1083#1080#1085#1080#1085
      '------------------------------------------------------'
      #1042#1099' '#1084#1086#1078#1077#1090#1077' '#1087#1086#1087#1088#1080#1074#1077#1090#1089#1090#1074#1086#1074#1072#1090#1100' '#1073#1086#1090#1072' ("'#1055#1088#1080#1074#1077#1090'")'
      #1057#1086#1086#1073#1097#1080#1090#1100' '#1077#1084#1091' '#1089#1074#1086#1077' '#1080#1084#1103' ('#1053#1072#1087#1088#1080#1084#1077#1088' "'#1071' '#1048#1074#1072#1085'")'
      #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1072#1076#1077#1088#1078#1082#1091' '#1084#1077#1078#1076#1091' '#1093#1086#1076#1072#1084#1080' (sleep=1) '#1074' '#1084#1080#1085'.'
      '------------------------------------------------------'
      #1042#1099' '#1084#1086#1078#1077#1090#1077' '#1089#1076#1077#1083#1072#1090#1100' '#1093#1086#1076' '#1091#1082#1072#1079#1072#1074' '#1082#1086#1086#1088#1076#1080#1085#1072#1090#1099' ('#1050'1, '#1050'-1)'
      #1052#1086#1078#1085#1086' '#1087#1088#1086#1087#1091#1089#1090#1080#1090#1100' '#1093#1086#1076', '#1080#1083#1080' '#1087#1077#1088#1077#1076#1072#1090#1100' '#1093#1086#1076' '#1073#1086#1090#1091' ("'#1093#1086#1076#1080'")'
      '------------------------------------------------------')
    TabOrder = 6
    Visible = False
    OnDrawItem = ListBoxHelpDrawItem
  end
  object PanelHelp: TPanelExt
    Left = 256
    Top = 232
    Width = 289
    Height = 97
    Caption = 'PanelHelp'
    DefaultPaint = False
    OnPaint = PanelHelpPaint
    Color = clWhite
    Locked = True
    TabOrder = 7
    Visible = False
  end
  object PanelResult: TPanelExt
    Left = 454
    Top = 80
    Width = 260
    Height = 153
    DefaultPaint = False
    OnPaint = PanelResultPaint
    TabOrder = 8
    object LabelLosesV: TLabel
      Left = 8
      Top = 112
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object LabelWinsV: TLabel
      Left = 8
      Top = 128
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object ButtonCloseP: TSpeedButton
      Left = 208
      Top = 108
      Width = 49
      Height = 47
      Hint = #1047#1072#1082#1088#1099#1090#1100
      Flat = True
      OnClick = ButtonClosePClick
    end
    object ButtonNewP: TSpeedButton
      Left = 155
      Top = 108
      Width = 49
      Height = 47
      Hint = #1048#1075#1088#1072#1090#1100' '#1089#1085#1086#1074#1072
      Flat = True
      OnClick = ButtonNewClick
    end
  end
  object XPManifest: TXPManifest
    Left = 328
    Top = 8
  end
  object TimerSpeak: TTimer
    Enabled = False
    OnTimer = TimerSpeakTimer
    Left = 392
    Top = 8
  end
  object TimerGo: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = TimerGoTimer
    Left = 448
    Top = 8
  end
  object TimerTime: TTimer
    Enabled = False
    OnTimer = TimerTimeTimer
    Left = 504
    Top = 8
  end
  object ActionList: TActionList
    Left = 552
    Top = 8
    object ActionNewGame: TAction
      Caption = #1053#1086#1074#1072#1103' '#1080#1075#1088#1072
      Hint = #1053#1086#1074#1072#1103' '#1080#1075#1088#1072
      OnExecute = ActionNewGameExecute
    end
    object PassLead: TAction
      Caption = 'PassLead'
      OnExecute = PassLeadExecute
    end
  end
  object TimerCompShoot: TTimer
    Enabled = False
    OnTimer = TimerCompShootTimer
    Left = 280
    Top = 8
  end
  object TimerAni: TTimer
    Interval = 65
    OnTimer = TimerAniTimer
    Left = 280
    Top = 64
  end
  object TimerClearRadar: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = TimerClearRadarTimer
    Left = 344
    Top = 64
  end
  object TimerSet: TTimer
    Enabled = False
    Interval = 400
    OnTimer = TimerSetTimer
    Left = 416
    Top = 64
  end
  object TimerActions: TTimer
    Interval = 200
    OnTimer = TimerActionsTimer
    Left = 464
    Top = 64
  end
end
