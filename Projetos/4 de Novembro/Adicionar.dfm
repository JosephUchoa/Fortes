object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Adicionar'
  ClientHeight = 136
  ClientWidth = 184
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 32
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
    TextHint = 'Nome'
  end
  object Edit2: TEdit
    Left = 32
    Top = 35
    Width = 121
    Height = 21
    TabOrder = 1
    TextHint = 'CPF'
  end
  object Edit3: TEdit
    Left = 32
    Top = 62
    Width = 121
    Height = 21
    TabOrder = 2
    TextHint = 'Telefone'
  end
  object Button1: TButton
    Left = 32
    Top = 89
    Width = 121
    Height = 25
    Caption = 'Concluir'
    TabOrder = 3
    OnClick = Button1Click
  end
end
