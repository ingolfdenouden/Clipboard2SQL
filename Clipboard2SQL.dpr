program Clipboard2SQL;

uses
  Forms,
  Main in 'Main.pas' {MainFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Clipboard 2 SQL';
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
