program Calculator;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  CalculatorFm in '..\CalculatorFm.pas' {MainFm},
  CalculatorWeb in 'CalculatorWeb.pas' {MainWM: TWebModule};

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TMainFm, MainFm);
  Application.Run;
end.
