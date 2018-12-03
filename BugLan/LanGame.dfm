object FormLanSet: TFormLanSet
  Left = 717
  Top = 237
  Width = 345
  Height = 256
  Caption = #1057#1077#1090#1077#1074#1072#1103' '#1080#1075#1088#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBoxCreate: TGroupBox
    Left = 8
    Top = 8
    Width = 313
    Height = 57
    Caption = #1057#1086#1079#1076#1072#1090#1100
    TabOrder = 0
    object LabelPort: TLabel
      Left = 13
      Top = 21
      Width = 30
      Height = 13
      Caption = #1055#1086#1088#1090':'
    end
    object ButtonCreate: TButton
      Left = 232
      Top = 16
      Width = 75
      Height = 25
      Caption = #1057#1086#1079#1076#1072#1090#1100
      TabOrder = 0
      OnClick = ButtonCreateClick
    end
    object EditPort: TEdit
      Left = 48
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '7273'
    end
  end
  object GroupBoxConnect: TGroupBox
    Left = 8
    Top = 72
    Width = 313
    Height = 105
    Caption = #1055#1088#1080#1089#1086#1077#1076#1080#1085#1080#1090#1100#1089#1103
    TabOrder = 1
    object LabelIP: TLabel
      Left = 16
      Top = 20
      Width = 12
      Height = 13
      Caption = 'IP:'
    end
    object Label1: TLabel
      Left = 16
      Top = 45
      Width = 30
      Height = 13
      Caption = #1055#1086#1088#1090':'
    end
    object EditIP: TEdit
      Left = 48
      Top = 16
      Width = 257
      Height = 21
      TabOrder = 0
      Text = 'ASUS'
    end
    object EditPortClient: TEdit
      Left = 48
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '7273'
    end
    object ButtonConnect: TButton
      Left = 232
      Top = 72
      Width = 75
      Height = 25
      Caption = #1057#1086#1077#1076#1080#1085#1080#1090#1100
      TabOrder = 2
      OnClick = ButtonConnectClick
    end
  end
  object ButtonClose: TButton
    Left = 248
    Top = 184
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 2
    OnClick = ButtonCloseClick
  end
end
