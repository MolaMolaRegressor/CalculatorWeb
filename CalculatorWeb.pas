unit CalculatorWeb;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp;

type
  TMainWM = class(TWebModule)
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1WebActionItem1Action(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TMainWM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TMainWM.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content :=
    '<html>' +
    '<head><title>Калькулятор</title></head>' +
    '<body>Введите пример<br><br></body>' +
    '<form method = "POST" action="http://localhost:8080/calculation" target="_self"">'+
    '<input type="text" name="inpCalc"/><br><br>'+
    '<button>Вычислить</button> '+
    '</form>'+
    '</html>';
end;

procedure TMainWM.WebModule1WebActionItem1Action(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  I, J, numAct, numFirstAct, numCount, iNumFirst, iNumSecond, countDot: ShortInt;
  firstNum, secondNum, answ: Double;
  str: string;
begin
  numAct := 0;
  numFirstAct := 0;
  iNumFirst := 0;
  numCount := 0;
  str := Request.ContentFields.Values['inpCalc'];
  Response.Content := '<html>' +
      '<head><title>Калькулятор</title></head>' +
      '<body>Введите пример<br><br></body>' +
      '<form method = "POST" action="http://localhost:8080/calculation" target="_self">'+
      '<input type="text" name="inpCalc"/><br><br>'+
      '<button>Вычислить</button> '+
      '</form>'+
      '<head><title>Калькулятор</title></head>';
  for I := 1 to str.Length do
  begin
    if (str[I] in ['+', '-']) then
    begin
      numAct := numAct + 1;
      countDot := 0;
    end;
    if (str[I] in ['*', '/']) then
    begin
      numFirstAct := numFirstAct + 1;
      countDot := 0;
    end;
    if str[I] = ',' then
      countDot := countDot + 1;
    if not(str[I] in ['1', '2','3', '4','5', '6','7', '8', '9', '0', ',','+',
    '-','*', '/']) or (countDot > 1) then
    begin
      Response.Content := Response.Content +
      '<body>Некорректная запись примера<br><br></body>'  +
      '</html>';
      exit;
    end;
  end;
  if numAct + numFirstAct > 0 then
  begin
      for I := 1 to numFirstAct do
        begin
          for J := 1 to str.Length do
          begin
            if (str[J] = '*') or (str[J] = '/') then
            begin
              iNumFirst := J - 1;
              while not((iNumFirst = 1) or (str[iNumFirst -1 ] in
              ['+', '-', '*', '/'])) do
                iNumFirst := iNumFirst - 1;
              firstNum := StrToFloat(Copy(str, iNumFirst, J-iNumFirst));
              iNumSecond := J + 1;
              while not((iNumSecond = str.Length) or (str[iNumSecond + 1] in
              ['+', '-', '*', '/'])) do
                iNumSecond := iNumSecond + 1;
              secondNum := StrToFloat(Copy(str, J + 1, iNumSecond - J));
              if str[J] = '*' then
                answ := firstNum * secondNum
              else
              begin
                if (secondNum <> 0) then
                  answ := firstNum / secondNum
                else
                  begin
                    Response.Content := Response.Content +
                      '<body>Невозможно деление на 0<br><br></body>'  +
                      '</html>';
                    exit;
                  end;
              end;
          str := Copy(str, 1, iNumFirst-1) + FloatToStr(answ) + Copy(str, iNumSecond + 1);
          break;
        end;
      end;
    end;
    for I := 1 to numAct do
      begin
        for J := 1 to str.Length do
        begin
          if (str[J] = '+') or (str[J] = '-') then
          begin
            iNumSecond := J + 1;
            firstNum := StrToFloat(Copy(str, 1, J - 1));
            while not((iNumSecond = str.Length) or (str[iNumSecond + 1] in ['+', '-'])) do
              iNumSecond := iNumSecond + 1;
            secondNum := StrToFloat(Copy(str, J + 1, iNumSecond - J));
            if str[J] = '+' then
              answ := firstNum + secondNum
            else
              answ := firstNum - secondNum;
            str := FloatToStr(answ) + Copy(str, iNumSecond + 1);
            break;
          end;
        end;
      end;
      Response.Content := Response.Content +
        '<body><b>Ответ:</b><br>' + Request.ContentFields.Values['inpCalc'] +
        ' = ' + str +'<br><br></body>'  +
        '</html>';
  end
  else
    Response.Content := Response.Content +
      '<body>В примере не было ни одного действия<br><br></body>'  +
      '</html>';
end;

end.
