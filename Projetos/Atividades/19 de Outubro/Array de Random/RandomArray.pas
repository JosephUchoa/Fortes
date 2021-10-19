unit RandomArray;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
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
var
  Arr: array[1..20] of Integer;
  I: Integer;
  Media: Double;
begin
  Memo1.Clear;
  for I := Low(Arr) to High(arr) do
  begin
    Arr[I] := Random(100) + 1;
    Memo1.Lines.add('Arr[' + IntToStr(I) + '] = ' + IntToStr(Arr[I]));
  end;

  for I := Low(Arr) to High(arr) do
    Media := Media + Arr[I];

  Media := Media / Length(Arr);
  Memo1.Lines.add('M�dia = ' + FloatToStr(Media))



end;

end.
