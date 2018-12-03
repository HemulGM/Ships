object FormShipPoly: TFormShipPoly
  Left = 435
  Top = 177
  BorderStyle = bsDialog
  Caption = #1056#1072#1089#1089#1090#1072#1085#1086#1074#1082#1072' '#1082#1086#1088#1072#1073#1083#1077#1081
  ClientHeight = 302
  ClientWidth = 449
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LabelHint: TLabel
    Left = 312
    Top = 88
    Width = 128
    Height = 65
    Caption = 
      #1042#1099#1073#1080#1088#1080#1090#1077' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077#13#10#1082#1072#1088#1072#1073#1083#1103' '#1080' '#1082#1083#1080#1082#1085#1080#1090#1077' '#1074' '#13#10#1090#1091' '#1082#1083#1077#1090#1082#1091', '#1074' '#1082#1086#1090#1086#1088#1091 +
      #1102' '#13#10#1085#1091#1078#1085#1086' '#1087#1086#1089#1090#1072#1074#1080#1090#1100' '#13#10#1082#1086#1088#1072#1073#1083#1100
  end
  object DrawGridPoly: TDrawGrid
    Left = 0
    Top = 0
    Width = 303
    Height = 303
    ColCount = 12
    DefaultColWidth = 24
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 12
    FixedRows = 0
    TabOrder = 0
    OnDrawCell = DrawGridPolyDrawCell
    OnMouseMove = DrawGridPolyMouseMove
    OnMouseUp = DrawGridPolyMouseDown
  end
  object ButtonAuto: TButton
    Left = 312
    Top = 8
    Width = 129
    Height = 25
    Caption = #1056#1072#1089#1089#1090#1072#1074#1080#1090#1100
    TabOrder = 1
    OnClick = ButtonAutoClick
  end
  object RadioGroupDir: TRadioGroup
    Left = 312
    Top = 168
    Width = 129
    Height = 57
    Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    ItemIndex = 0
    Items.Strings = (
      #1055#1086' '#1075#1086#1088#1080#1079#1086#1085#1090#1072#1083#1080
      #1055#1086' '#1074#1077#1088#1090#1080#1082#1072#1083#1080)
    TabOrder = 2
  end
  object ButtonOk: TButton
    Left = 312
    Top = 240
    Width = 129
    Height = 25
    Caption = #1043#1086#1090#1086#1074#1086
    TabOrder = 3
    OnClick = ButtonOkClick
  end
  object ButtonReset: TButton
    Left = 312
    Top = 40
    Width = 129
    Height = 25
    Caption = #1057#1073#1088#1086#1089#1080#1090#1100
    TabOrder = 4
    OnClick = ButtonResetClick
  end
  object ButtonExit: TButton
    Left = 312
    Top = 272
    Width = 129
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 5
  end
end
