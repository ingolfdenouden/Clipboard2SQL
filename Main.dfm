object MainFrm: TMainFrm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Clipboard 2 SQL'
  ClientHeight = 568
  ClientWidth = 764
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    764
    568)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 370
    Top = 219
    Width = 43
    Height = 13
    Caption = 'Records:'
  end
  object RecordsLbl: TLabel
    Left = 422
    Top = 219
    Width = 6
    Height = 13
    Caption = '0'
  end
  object CancelBtn: TButton
    Left = 663
    Top = 213
    Width = 87
    Height = 25
    Caption = 'Close'
    TabOrder = 0
    OnClick = CancelBtnClick
  end
  object OKBtn: TButton
    Left = 148
    Top = 213
    Width = 75
    Height = 25
    Caption = 'Convert'
    TabOrder = 1
    OnClick = OKBtnClick
  end
  object GroupBox2: TGroupBox
    Left = 12
    Top = 12
    Width = 740
    Height = 189
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Settings'
    TabOrder = 2
    ExplicitWidth = 703
    object Label3: TLabel
      Left = 20
      Top = 28
      Width = 50
      Height = 13
      Caption = 'Statement'
    end
    object Label2: TLabel
      Left = 348
      Top = 52
      Width = 66
      Height = 13
      Caption = 'Commit every'
    end
    object Label4: TLabel
      Left = 20
      Top = 64
      Width = 32
      Height = 13
      Caption = 'Target'
    end
    object Label5: TLabel
      Left = 20
      Top = 88
      Width = 58
      Height = 13
      Caption = 'Update field'
    end
    object Label6: TLabel
      Left = 501
      Top = 51
      Width = 36
      Height = 13
      Caption = 'records'
    end
    object Label7: TLabel
      Left = 20
      Top = 120
      Width = 46
      Height = 13
      Caption = 'Null value'
    end
    object TypeBox: TComboBox
      Left = 108
      Top = 25
      Width = 97
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      ItemIndex = 0
      TabOrder = 0
      Text = 'INSERT'
      OnChange = TypeBoxChange
      Items.Strings = (
        'INSERT'
        'UPDATE')
    end
    object CommitSpn: TSpinEdit
      Left = 436
      Top = 48
      Width = 57
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
      OnChange = CommitSpnChange
    end
    object TableEdt: TEdit
      Left = 108
      Top = 60
      Width = 193
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = 'DB.SCHEMA.TABLE'
      OnChange = TableEdtChange
    end
    object UpdateFieldEdt: TEdit
      Left = 108
      Top = 84
      Width = 137
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = 'FIELD'
      OnChange = UpdateFieldEdtChange
    end
    object CommitChk: TCheckBox
      Left = 348
      Top = 25
      Width = 147
      Height = 17
      Caption = 'Insert commit statement'
      TabOrder = 4
      OnClick = CommitChkClick
    end
    object NullValueEdt: TEdit
      Left = 108
      Top = 116
      Width = 69
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      Text = 'null'
      OnChange = NullValueEdtChange
    end
  end
  object SQLBox: TMemo
    Left = 12
    Top = 252
    Width = 740
    Height = 305
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 3
    WordWrap = False
    ExplicitWidth = 644
    ExplicitHeight = 340
  end
  object ProgressBar: TProgressBar
    Left = 508
    Top = 217
    Width = 137
    Height = 18
    TabOrder = 4
  end
  object PasteClipboardBtn: TButton
    Left = 12
    Top = 213
    Width = 129
    Height = 25
    Caption = 'Copy from Clipboard'
    TabOrder = 5
    OnClick = PasteClipboardBtnClick
  end
  object CopyClipboardBtn: TButton
    Left = 228
    Top = 213
    Width = 121
    Height = 25
    Caption = 'Move to Clipboard'
    TabOrder = 6
    OnClick = CopyClipboardBtnClick
  end
end
