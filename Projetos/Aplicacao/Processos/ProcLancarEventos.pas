unit ProcLancarEventos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.DBCtrls, Vcl.StdCtrls, Vcl.Mask,Conexao;

type
  TFrmLancarEventos = class(TForm)
    LblMesAno: TLabel;
    EdtMesAno: TMaskEdit;
    DtsFuncionarios: TDataSource;
    DtsCargos: TDataSource;
    QryFuncionarios: TFDQuery;
    QryCargos: TFDQuery;
    LcbCargos: TDBLookupComboBox;
    LcbFuncionarios: TDBLookupComboBox;
    LblFuncionarios: TLabel;
    LblCargos: TLabel;
    QryFuncionariosCODIGO: TIntegerField;
    QryFuncionariosNOME: TStringField;
    QryCargosCODIGO: TIntegerField;
    QryCargosNOME: TStringField;
    LblEventos: TLabel;
    LcbEventos: TDBLookupComboBox;
    DtsEventos: TDataSource;
    QryEventos: TFDQuery;
    QryEventosCODIGO: TIntegerField;
    QryEventosDESCRICAO: TStringField;
    BtnConfirmar: TButton;
    BtnCancelar: TButton;
    EdtValor: TEdit;
    LblValor: TLabel;
    QryFuncionariosSelecionados: TFDQuery;
    QryAux: TFDQuery;
    procedure ClearFormFields;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LcbFuncionariosClick(Sender: TObject);
    procedure LcbCargosClick(Sender: TObject);
    procedure BtnConfirmarClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLancarEventos: TFrmLancarEventos;

implementation

{$R *.dfm}

procedure TFrmLancarEventos.ClearFormFields;
begin
  EdtMesAno.Clear;
  LcbCargos.KeyValue := Null;
  LcbFuncionarios.KeyValue := Null;
  LcbEventos.KeyValue := Null;
  EdtValor.Clear;
  QryFuncionariosSelecionados.Close;
end;

procedure TFrmLancarEventos.BtnCancelarClick(Sender: TObject);
begin
  ClearFormFields;
end;

procedure TFrmLancarEventos.BtnConfirmarClick(Sender: TObject);
var
  MesAno: TDate;
begin
  MesAno := StrToDateDef('01/'+ EdtMesAno.Text, 0);
  if MesAno <= 0 then
  begin
    ShowMessage('O M�s/ano � obrigat�rio.');
    EdtMesAno.SetFocus;
    Exit;
  end;

  if (LcbCargos.KeyValue = Null) and (LcbFuncionarios.KeyValue = Null) then
  begin
    ShowMessage('O cargo ou funcionario � obrigat�rio.');
    LcbCargos.SetFocus;
    Exit;
  end;

  if LcbEventos.KeyValue = Null then
  begin
    ShowMessage('O evento � obrigat�rio.');
    LcbEventos.SetFocus;
    Exit;
  end;

  if StrToFloatDef(EdtValor.Text,0) <= 0 then
  begin
    ShowMessage('O valor � obrigat�rio.');
    EdtValor.SetFocus;
    Exit;
  end;

  QryFuncionariosSelecionados.Close;
  QryFuncionariosSelecionados.SQL.Text := 'SELECT CODIGO FROM FUNCIONARIOS WHERE ATIVO = 1';
  if LcbCargos.KeyValue <> Null then
    QryFuncionariosSelecionados.SQL.Text := QryFuncionariosSelecionados.SQL.Text
      + 'AND f.CARGO = ' + VarToStr(lcbCargos.KeyValue)
  else
    QryFuncionariosSelecionados.SQL.Text := QryFuncionariosSelecionados.SQL.Text
      + 'AND f.CODIGO = ' + VarToStr(LcbFuncionarios.KeyValue);
  QryFuncionariosSelecionados.Open;

  while not QryFuncionariosSelecionados.Eof do
  begin
    QryAux.SQL.Text := 'UPDATE OR INSERT INTO FOLHAS_EVENTOS '
                        + 'VALUES(:MES_ANO, :COD_EVENTO, :COD_FUNCIONARIO, :VALOR) '
                        + 'MATCHING(MES_ANO, COD_EVENTO, COD_FUNCIONARIO) ';

    QryAux.ParamByName('MES_ANO').AsString := EdtMesAno.Text;
    QryAux.ParamByName('COD_EVENTO').AsInteger := LcbEventos.KeyValue;
    QryAux.ParamByName('COD_FUNCIONARIO').AsInteger := QryFuncionariosSelecionados.FieldByName('CODIGO').AsInteger;
    QryAux.ParamByName('VALOR').AsCurrency:= StrToCurr(EdtValor.Text);
    QryAux.ExecSQL;
    QryFuncionariosSelecionados.Next;
  end;

  ClearFormFields;
  ShowMessage('Evento processado.');
end;

procedure TFrmLancarEventos.FormCreate(Sender: TObject);
begin
  QryCargos.Open;
  QryFuncionarios.Open;
  QryEventos.Open;
end;

procedure TFrmLancarEventos.FormDestroy(Sender: TObject);
begin
  QryCargos.Close;
  QryFuncionarios.Close;
  QryEventos.Close;
end;

procedure TFrmLancarEventos.LcbCargosClick(Sender: TObject);
begin
  LcbFuncionarios.KeyValue := Null;
end;

procedure TFrmLancarEventos.LcbFuncionariosClick(Sender: TObject);
begin
  LcbCargos.KeyValue := Null;
end;

end.
