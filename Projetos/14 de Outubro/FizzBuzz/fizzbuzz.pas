unit fizzbuzz;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    StaticText1: TStaticText;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var N: Integer;
  I: Integer;

begin
  Memo1.Clear;
  if TryStrToInt(Edit1.Text, N) then
    for I := 1 to N do
    begin
      if (I mod 3 = 0) and (I mod 5 = 0) then
        Memo1.Lines.Add(IntToStr(I) + ' - FIZZBUZZ')
      else if I mod 3 = 0 then
        Memo1.Lines.Add(IntToStr(I) + ' - FIZZ')
      else if I mod 5 = 0 then
        Memo1.Lines.Add(IntToStr(I) + ' - BUZZ')
    end
  else
        Memo1.Lines.Add('Digite um valor v�lido')

end;

end.
