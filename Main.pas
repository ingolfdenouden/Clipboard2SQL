unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, Spin, ComCtrls, FDOTable, ClipBrd, ShowMsgs,
  IniFiles, OSUtils, Strings;

type
  TMainFrm = class(TForm)
    CancelBtn: TButton;
    OKBtn: TButton;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    TypeBox: TComboBox;
    Label2: TLabel;
    CommitSpn: TSpinEdit;
    TableEdt: TEdit;
    Label4: TLabel;
    UpdateFieldEdt: TEdit;
    Label5: TLabel;
    CommitChk: TCheckBox;
    Label6: TLabel;
    SQLBox: TMemo;
    ProgressBar: TProgressBar;
    Label1: TLabel;
    RecordsLbl: TLabel;
    NullValueEdt: TEdit;
    Label7: TLabel;
    PasteClipboardBtn: TButton;
    CopyClipboardBtn: TButton;
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure TypeBoxChange(Sender: TObject);
    procedure TableEdtChange(Sender: TObject);
    procedure UpdateFieldEdtChange(Sender: TObject);
    procedure NullValueEdtChange(Sender: TObject);
    procedure CommitChkClick(Sender: TObject);
    procedure CommitSpnChange(Sender: TObject);
    procedure PasteClipboardBtnClick(Sender: TObject);
    procedure CopyClipboardBtnClick(Sender: TObject);
  private
    FTable: TFDOTable;
    FConfig: TIniFile;
    FUser: String;
    function ConfigRead(const Ident: String; const Default: String = ''): String;
    function ConfigReadInt(const Ident: String; const Default: Integer = 0): Integer;
    procedure ConfigWrite(const Ident, Value: String);
    procedure SetControlsEnabled(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ControlsEnabled: Boolean write SetControlsEnabled;
  end;

var
  MainFrm: TMainFrm;

implementation

{$R *.dfm}

procedure TMainFrm.PasteClipboardBtnClick(Sender: TObject);
begin
  SQLBox.Text := Clipboard.AsText;
  FTable.Document := SQLBox.Text;

  RecordsLbl.Caption := IntToStr(FTable.RecordCount);
end;

procedure TMainFrm.CommitChkClick(Sender: TObject);
begin
  ConfigWrite('InsertCommit', BoolToStr(CommitChk.Checked));
end;

procedure TMainFrm.CommitSpnChange(Sender: TObject);
begin
  ConfigWrite('CommitEveryX', IntToStr(CommitSpn.Value));
end;

function TMainFrm.ConfigRead(const Ident, Default: String): String;
begin
  if FConfig.SectionExists(FUser) then begin
    Result := FConfig.ReadString(FUser, Ident, Default);
  end
  else Result := Default;
end;

function TMainFrm.ConfigReadInt(const Ident: String;
  const Default: Integer): Integer;
begin
  if not TryStrToInt(ConfigRead(Ident, ''), Result) then
    Result := Default;
end;

procedure TMainFrm.ConfigWrite(const Ident, Value: String);
begin
  FConfig.WriteString(FUser, Ident, StringReplace(Value,'''','''''',[rfReplaceAll]));
end;

procedure TMainFrm.CopyClipboardBtnClick(Sender: TObject);
begin
  Clipboard.AsText := SQLBox.Text;

  ShowInfo('Text is copied to Clipboard.');
end;

constructor TMainFrm.Create(AOwner: TComponent);
begin
  inherited;
  FUser := GetUserName;

  FTable := TFDOTable.Create;
  FConfig := TIniFile.Create(ExtractFilePath(ParamStr(0))+'Config.ini');

  TypeBox.ItemIndex := TypeBox.Items.IndexOf(ConfigRead('StatementType', TypeBox.Text));
  if TypeBox.ItemIndex = -1 then
    TypeBox.ItemIndex := TypeBox.Items.IndexOf('INSERT');

  TableEdt.Text := ConfigRead('Target', TableEdt.Text);
  UpdateFieldEdt.Text := ConfigRead('UpdateField', UpdateFieldEdt.Text);
  NullValueEdt.Text := ConfigRead('NullValue', NullValueEdt.Text);
  CommitChk.Checked := StrToBool(ConfigRead('InsertCommit', BoolToStr(CommitChk.Checked)));
  CommitSpn.Value := ConfigReadInt('CommitEveryX', CommitSpn.Value);

  TypeBoxChange(nil);
end;

destructor TMainFrm.Destroy;
begin
  FTable.Free;
  inherited;
end;

procedure TMainFrm.NullValueEdtChange(Sender: TObject);
begin
  ConfigWrite('NullValue', NullValueEdt.Text);
end;

procedure TMainFrm.OKBtnClick(Sender: TObject);
var
  Text: String;

  procedure Write(const S: String);
  begin
    Text := Text + S;
  end;

  function GetField(const S: String): String;
  var
    Tmp: String;
  begin
    Result := S;

    Tmp := LeaveChars(Result, ['a'..'z','A'..'Z','0'..'9','_']);

    if CompareText(Result, Tmp) <> 0 then begin
      Result := '['+Result+']';
    end;
  end;

  function GetValue(const S: String): String;
  begin
    if S = '' then Result := NullValueEdt.Text
    else begin
      Result := S;
      Result := StringReplace(Result, '‘', '''', [rfReplaceAll]);
      Result := StringReplace(Result, '’', '''', [rfReplaceAll]);
      Result := ''''+StringReplace(Result, '''', '''''', [rfReplaceAll])+'''';
    end;
  end;

var
  I, C: Integer;
begin
  ControlsEnabled := False;
  try
    Text := '';
    ProgressBar.Max := FTable.RecordCount;
    FTable.First;
    repeat
      case TypeBox.ItemIndex of
        0: begin
          Write('insert into '+TableEdt.Text+' (');
          for I := 0 to FTable.FieldList.Count-1 do begin
            if I > 0 then Write(',');
            Write(GetField(FTable.FieldList[I]));
          end;
          Write(') values (');
          for I := 0 to FTable.FieldList.Count-1 do begin
            if I > 0 then Write(',');
            Write(GetValue(FTable.Fields[I].AsString));
          end;
          Write(');'#13#10);
        end;
        1: begin
          Write('update '+TableEdt.Text+' set ');
          C := 0;
          for I := 0 to FTable.FieldList.Count-1 do begin
            if SameText(FTable.FieldList[I],UpdateFieldEdt.Text) = False then begin
              if C > 0 then Write(', ');
              Write(GetField(FTable.FieldList[I])+' = '+GetValue(FTable.Fields[I].AsString));
              Inc(C);
            end;
          end;
          Write(
            ' where '+GetField(UpdateFieldEdt.Text)+' = '+
            GetValue(FTable.FieldByName(UpdateFieldEdt.Text).AsString)+
            ';'#13#10);
        end;
      end;

      if CommitChk.Checked and (CommitSpn.Value > 0) then begin
        if (FTable.RecNo + 1) mod CommitSpn.Value = 0 then
          Write(#13#10'commit work;'#13#10#13#10);
      end;

      FTable.Next;

      ProgressBar.Position := FTable.RecNo + 1;
      ProgressBar.Update;

    until FTable.EOF;

    if CommitChk.Checked then begin
      Write(#13#10'commit work;');
    end;

    SQLBox.Text := Text;

    ProgressBar.Position := 0;
  finally
    ControlsEnabled := True;
  end;
end;

procedure TMainFrm.SetControlsEnabled(const Value: Boolean);
begin
  OKBtn.Enabled := Value;
  CancelBtn.Enabled := Value;
  TypeBox.Enabled := Value;
  CommitSpn.Enabled := Value;
end;

procedure TMainFrm.TableEdtChange(Sender: TObject);
begin
  ConfigWrite('Target', TableEdt.Text);
end;

procedure TMainFrm.TypeBoxChange(Sender: TObject);
begin
  UpdateFieldEdt.Enabled := (TypeBox.Text <> 'INSERT');
end;

procedure TMainFrm.UpdateFieldEdtChange(Sender: TObject);
begin
  ConfigWrite('UpdateField', UpdateFieldEdt.Text);
end;

procedure TMainFrm.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

end.
