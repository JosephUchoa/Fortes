unit HoraExtra;

{
  A empresa Abc precisa de um programa para calcular as horas extras dos seus funcion�rios.
  Desenvolva uma aplica��o que registre o c�digo do funcion�rio, o dia/m�s (25/02),
  se o dia � feriado ou domingo e o total de horas extras no dia. Se o dia � feriado ou domingo
  o valor da hora de trabalho deve ser acrescida em 100%, caso contr�rio � acrescido em 50%.
  A aplica��o deve imprimir o c�digo do funcion�rio, o total e o valor das horas extras 50%,
  o total e o valor das horas extras 100% e o valor total a ser pago. O Valor da hora de trabalho
  � de 20.00 para todos os funcion�rios.
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXPickers, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Generics.Collections, StrUtils;

type
  RHorasExtras = record
    Horas: Integer;
    Domingo, Feriado: Bool;
  end;

  THorasExtras = class(TForm)
    PgControl: TPageControl;
    Registro: TTabSheet;
    Consulta: TTabSheet;
    DtPicker: TDateTimePicker;
    LblData: TLabel;
    RgFeriado: TRadioGroup;
    LblFeriado: TLabel;
    EdtCodigo: TEdit;
    EdtHoras: TEdit;
    LblCodigo1: TLabel;
    LblHoras: TLabel;
    MemoConsulta: TMemo;
    LblCodigo2: TLabel;
    BtnRegistrar: TButton;
    CbCodigo: TComboBox;
    BtnConsulta: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnRegistrarClick(Sender: TObject);
    procedure BtnConsultaClick(Sender: TObject);
    procedure PgControlChange(Sender: TObject);
  private
    { Private declarations }
    FFuncionario: TDictionary<String, TDictionary<TDate, RHorasExtras> >;
  public
    { Public declarations }
  end;

var
  HorasExtras: THorasExtras;

implementation

{$R *.dfm}

procedure THorasExtras.BtnConsultaClick(Sender: TObject);
var
  FuncDict: TDictionary<TDate, RHorasExtras>;
  HorasPair: TPair<TDate, RHorasExtras>;
  Horas50, Horas100: Double;
begin
  if CbCodigo.Items.Count = 0 then
    raise Exception.Create('Nenhuma funcionario registrado');
  
  Horas50 := 0;
  Horas100 := 0;
  MemoConsulta.Clear;

    
  FFuncionario.TryGetValue(CbCodigo.Text, FuncDict);
  MemoConsulta.Lines.Add('------ Funcionario: ' + CbCodigo.Text + ' ------');
  MemoConsulta.Lines.Add('Datas Registradas: ');
  for HorasPair in FuncDict do
  begin
    MemoConsulta.Lines.Add(' ' + DateToStr(HorasPair.Key) +
     ' | Domingo: ' + IfThen(HorasPair.Value.Domingo,'Sim','N�o') +
     ' | Feriado: ' + IfThen(HorasPair.Value.Feriado,'Sim','N�o'));     

    if HorasPair.Value.Domingo or HorasPair.Value.Feriado then
      Horas100 := Horas100 + HorasPair.Value.Horas
    else 
      Horas50 := Horas50 + HorasPair.Value.Horas;    
  end;
  
  Horas50 := Horas50 / 60;
  Horas100 := Horas100 / 60;
  
  MemoConsulta.Lines.Add('Extras 50% | Horas: ' + Format('%.2f', [Horas50])
    + ' | Valor: ' + Format('%.2f', [Horas50*10.0]) );
  MemoConsulta.Lines.Add('Extras 100% | Horas: ' + Format('%.2f', [Horas100])
    + ' | Valor: ' + Format('%.2f', [Horas100*20.0]) );

  MemoConsulta.Lines.Add('Valor Total: R$' + Format('%.2f', [Horas50*10.0 + Horas100*20.0]));    
  
end;

procedure THorasExtras.BtnRegistrarClick(Sender: TObject);
var
  Dia: Integer;
  RecHoras: RHorasExtras;
  DictFunc: TDictionary<TDate, RHorasExtras>;
begin
  if EdtCodigo.Text = '' then
    raise Exception.Create('Digite um codigo de funcionario.');

  RecHoras.Horas := StrToIntDef(EdtHoras.Text,0);
  if RecHoras.Horas <= 0 then
    raise Exception.Create('Horas devem ser positivas.');

  RecHoras.Domingo := (DayOfWeek(DtPicker.Date) = 1);
  RecHoras.Feriado := (RgFeriado.ItemIndex = 0);

  FFuncionario.TryGetValue(EdtCodigo.Text, DictFunc); 
  if not Assigned(DictFunc) then
    DictFunc := TDictionary<TDate, RHorasExtras>.Create;

  DictFunc.AddOrSetValue(DtPicker.Date, RecHoras);
  FFuncionario.AddOrSetValue(EdtCodigo.Text,DictFunc);
  ShowMessage('Horas Registradas.');    
end;

procedure THorasExtras.FormCreate(Sender: TObject);
begin
  PgControl.TabIndex := 0;
  FFuncionario := TDictionary<String, TDictionary<TDate, RHorasExtras> >.Create;
end;

procedure THorasExtras.FormDestroy(Sender: TObject);
begin
  FFuncionario.Free;
end;

procedure THorasExtras.PgControlChange(Sender: TObject);
var
  FuncPair: TPair<String, TDictionary<TDate, RHorasExtras> >;
begin                              
  CbCodigo.Items.Clear;
  for FuncPair in FFuncionario do
      CbCodigo.Items.Add(FuncPair.Key);
  CbCodigo.ItemIndex := 0;
end;

end.
