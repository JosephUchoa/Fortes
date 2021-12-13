unit CalcINSS;

interface

type TInss = class
  class function Calc(Salario: Currency): Currency;
end;

implementation

uses
  SysUtils;

class function TInss.Calc(Salario: Currency): Currency;
begin
  Result := 0;
  if Salario <= 0 then
    raise Exception.Create('Sal�rios deve ser maior que zero.');

  if Salario <= 1045 then
    Result := Salario * 0.075
  else if Salario <= 2089.60 then
    Result := Salario * 0.09
  else if Salario <= 3134.40 then
    Result := Salario * 0.12
  else if Salario <= 6101.06 then
    Result := Salario * 0.14
  else if Salario > 6101.06 then
    Result := Salario * 0.14
end;

end.
