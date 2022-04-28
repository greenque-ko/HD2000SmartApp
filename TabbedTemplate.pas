unit TabbedTemplate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.TabControl,
  FMX.StdCtrls, FMX.Gestures, IdBaseComponent, IdComponent, IdTCPConnection, IdGlobal,
  IdTCPClient, FMX.Controls.Presentation, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo, FMX.Objects, FMX.Ani, FMX.Edit, FMX.EditBox, FMX.SpinBox,
  FMX.Layouts, FMX.ExtCtrls, FMX.Effects, FMX.Filter.Effects,
  FMX.TMSCustomComponent, FMX.TMSPDFIO, FMX.TMSMemoPDFIO, FMX.TMSMemo,
  FMX.TMSMemoStyles, FMX.TMSBaseControl, FMX.TMSPDFLib, System.IOUtils;

type
  TTabbedForm = class(TForm)
    HeaderToolBar: TToolBar;
    ToolBarLabel: TLabel;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    GestureManager1: TGestureManager;
    IdTCPClient1: TIdTCPClient;
    Timer1: TTimer;
    Sco: TRectangle;
    TabItem5: TTabItem;
    TabItem6: TTabItem;
    TabItem7: TTabItem;
    ScrollBox2: TScrollBox;
    Memo1: TMemo;
    TabControl_Monitor: TTabControl;
    Monitoring: TTabItem;
    Alarm_Status: TTabItem;
    Operating_Mode: TTabItem;
    Setpoint: TTabItem;
    recMonitoring: TRectangle;
    scrollboxMonitoring: TScrollBox;
    lblU1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblU2: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lblU3: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    lblUavg: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    lbliL2: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    lblUe: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    lblie: TLabel;
    Label21: TLabel;
    lblS: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    lblP: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    lblQ: TLabel;
    Label32: TLabel;
    lblPF: TLabel;
    Label35: TLabel;
    lblF: TLabel;
    Label47: TLabel;
    lblPWMduty: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    lblAnalRef: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    lblDFMsd: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    lblDFMod: TLabel;
    Label58: TLabel;
    lblPFccc: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    lbliccc: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Button3: TButton;
    StyleBook1: TStyleBook;
    btnSendData: TButton;
    btnConnect: TButton;
    btnDisconnect: TButton;
    ButtonCreatePdf: TButton;
    ImageLogo: TImage;
    ImageViewer: TImageViewer;
    btnPdfMemo: TButton;
    SaveDialog1: TSaveDialog;
    TMSFMXMemoPDFIO1: TTMSFMXMemoPDFIO;
    TMSFMXMemoPascalStyler1: TTMSFMXMemoPascalStyler;
    Label5: TLabel;
    radioLandscape: TRadioButton;
    radioPortrait: TRadioButton;
    TMSFMXMemo1: TTMSFMXMemo;
    Edit1: TEdit;
    Label8: TLabel;
    btnChangeIP: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure IdTCPClient1Connected(Sender: TObject);
    procedure btnPdfMemoClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure IdTCPClient1Disconnected(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnSendDataClick(Sender: TObject);
    procedure Rectangle21Click(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure ButtonCreatePdfClick(Sender: TObject);
    procedure btnPrintPDFClick(Sender: TObject);
  private
    { Private declarations }
    {$IFDEF ANDROID}
    procedure CreatePdf;
    procedure OpenPDF(const AFileName: string);
    {$ENDIF}

  public
    { Public declarations }
  end;

var
  TabbedForm: TTabbedForm;

implementation
{$if CompilerVersion >= 33}
  {$define D103PLUS} // Delphi 10.3 or higher
{$endif}

{$if CompilerVersion >= 35}
  {$define D11PLUS} // Delphi 11 or higher
{$endif}

{$R *.fmx}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}

{$IFDEF ANDROID}
uses System.UIConsts, Androidapi.Helpers, System.Math, PdfLibrary
{$IFDEF D103PLUS}
  ,
  Androidapi.JNI.Os,
  Androidapi.JNI.JavaTypes,
  System.Permissions
{$ENDIF D103PLUS}

{$IFDEF ANDROID}
   ,
   Androidapi.JNI.GraphicsContentViewText,
   Androidapi.JNI.Support,
   Androidapi.JNI.Net
{$ENDIF}
;
{$ELSE}
uses System.UIConsts, System.Math;
{$ENDIF}


var
  boolConnect: Boolean=false;

procedure TTabbedForm.btnConnectClick(Sender: TObject);
begin
  //Memo1.Lines.Add('Connection button clicked ...');
  IdTCPClient1.Connect;
end;

procedure TTabbedForm.btnDisconnectClick(Sender: TObject);
begin
  //Memo1.Lines.Add('Disconnection button clicked ...');
  IdTCPClient1.Disconnect;
end;

procedure TTabbedForm.btnPrintPDFClick(Sender: TObject);
begin
{$IFDEF ANDROID}
{$ifdef D103PLUS}
  PermissionsService.RequestPermissions([JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE)],

  {$ifdef D11PLUS}
    procedure(const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray)
  {$else}
    procedure(const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>)
  {$endif D11PLUS}
    begin
      if (Length(AGrantResults) = 1) and (AGrantResults[0] = TPermissionStatus.Granted) then
        CreatePdf
      else
        ShowMessage('Permission denied');
    end);
{$else}
  CreatePdf;
{$endif D103PLUS}
{$ENDIF}
end;

procedure TTabbedForm.btnSendDataClick(Sender: TObject);
begin
  //Memo1.Lines.Add('Send button clicked ...');
  IdTCPClient1.Socket.WriteLn('Test data sending ...');
end;

procedure TTabbedForm.btnPdfMemoClick(Sender: TObject);
var
  fn: string;
  FileName: string;
begin
    if radioPortrait.IsChecked then
      TMSFMXMemoPDFIO1.Options.PageOrientation := poPortrait
    else
      TMSFMXMemoPDFIO1.Options.PageOrientation := poLandscape;

  if SaveDialog1.Execute then
  begin
    fn := SaveDialog1.FileName;

    if ExtractFileExt(fn) = '' then
      fn := fn + '.PDF';

    TMSFMXMemoPDFIO1.Save(fn);
    ShowMessage('The file was generated at: ' + fn);
  end;

  fn := 'FMXMemoDemo.PDF';

  {$IFDEF ANDROID}
  TMSFMXMemoPDFIO1.Save(TPath.GetSharedDocumentsPath + PathDelim + fn);
  {$ENDIF}

  {$IFDEF IOS}
  TMSFMXMemoPDFIO1.Save(TPath.GetDocumentsPath + PathDelim + fn);
  {$ENDIF}

  ShowMessage('The file was generated at: ' + TPath.GetDocumentsPath + PathDelim + fn);

  FileName :=  TPath.GetSharedDocumentsPath + PathDelim + fn;

  {$IFDEF ANDROID}
  OpenPDF(FileName);
  {$ENDIF}

  //IdTCPClient1.Connect;

end;

procedure TTabbedForm.Button2Click(Sender: TObject);
begin
  IdTCPClient1.Disconnect;
end;

procedure TTabbedForm.Button3Click(Sender: TObject);
begin
  lblU1.Text := Format('%8.1f',[1234.5]);
end;

procedure TTabbedForm.FormCreate(Sender: TObject);
begin
  { This defines the default active tab at runtime }
  TabControl1.ActiveTab := TabItem1;
end;

procedure TTabbedForm.FormGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
{$IFDEF ANDROID}
  case EventInfo.GestureID of
    sgiLeft:
    begin
      if TabControl1.ActiveTab <> TabControl1.Tabs[TabControl1.TabCount-1] then
        TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex+1];
      Handled := True;
    end;

    sgiRight:
    begin
      if TabControl1.ActiveTab <> TabControl1.Tabs[0] then
        TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex-1];
      Handled := True;
    end;
  end;
{$ENDIF}
end;

procedure TTabbedForm.IdTCPClient1Connected(Sender: TObject);
begin

  Memo1.Lines.Add('TCP/IP Connection: Connected ...');
  boolConnect := true;
  btnConnect.Enabled := false;
  btnSendData.Enabled := true;
  btnDisconnect.Enabled := true;

end;

procedure TTabbedForm.IdTCPClient1Disconnected(Sender: TObject);
begin

  Memo1.Lines.Add('TCP/IP Connection: Disconnected ...');
  boolConnect := false;
  btnConnect.Enabled := true;
  btnSendData.Enabled := false;
  btnDisconnect.Enabled := false;

end;

procedure TTabbedForm.Rectangle21Click(Sender: TObject);
begin
  IdTCPClient1.Socket.WriteLn('Test data sending ...');
end;

var
 boolAlm: Boolean=true;

procedure TTabbedForm.SpeedButton1Click(Sender: TObject);
begin
{
  if boolAlm then
  begin
    Rectangle2.Fill.Color := TAlphaColorRec.Red;
    boolAlm := false;
  end
  else
  begin
    Rectangle2.Fill.Color := TAlphaColorRec.Chartreuse;
    boolAlm := true;
  end;
}
end;

procedure TTabbedForm.Timer1Timer(Sender: TObject);
var
  S: String;
  I, nSize: Integer;
  //byteBuf: array [0..100] of Byte;
  byteBuf: TIdBytes;

begin

   if (boolConnect) then
   begin

    Timer1.Enabled := false;
    S := '';

    IdTCPClient1.IOHandler.CheckForDataOnSource(1);

    nSize := IdTCPClient1.IOHandler.InputBuffer.Size;

    if  nSize>0 then
    begin
      IdTCPClient1.Socket.ReadBytes(byteBuf, nSize, false);
      for I := 0 to (nSize-1) do
      begin
        S := S+Chr(byteBuf[I]);
      end;
    end;

    if Length(S)>0 then
    begin
      Memo1.Lines.Add(S);
    end;

    Timer1.Enabled := true;

   end;

end;


procedure TTabbedForm.ButtonCreatePdfClick(Sender: TObject);
begin
{$IFDEF ANDROID}
{$ifdef D103PLUS}
  PermissionsService.RequestPermissions([JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE)],

  {$ifdef D11PLUS}
    procedure(const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray)
  {$else}
    procedure(const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>)
  {$endif D11PLUS}
    begin
      if (Length(AGrantResults) = 1) and (AGrantResults[0] = TPermissionStatus.Granted) then
        CreatePdf
      else
        ShowMessage('Permission denied');
    end);
{$else}
  CreatePdf;
{$endif D103PLUS}
{$ENDIF}
end;

{$IFDEF ANDROID}
procedure TTabbedForm.CreatePdf;
var
  Document: TPdfDocument;
  Page: TPdfPage;
  PageHeight: Single;
  UnicodeFont: TPdfFont;
  Content: TPdfPageContentStream;
  DashPattern: TSingleDynArray;
  CenterX, CenterY: Single;
  Matrix: TPdfMatrix;
  FileName: string;

{$IFDEF ANDROID}
   Intent      : JIntent;
   URI         : Jnet_Uri;
{$ENDIF}
begin

  Document := TPdfDocument.Create;

  try
    Document.Creator := 'PDF Library for Android';
    Document.CreationDate := Now;

    Page := Document.AddPage;
    try
      PageHeight := -Page.MediaBox.Height;

      Content := Page.CreateContentStream;
      try
        // add text
        Content.BeginText;

        Content.NonStrokingColor(TAlphaColorRec.Green);
        Content.Font(TPdfFont.Helvetica, 16);
        Content.NewLineAtOffset(20, PageHeight - 20);
        Content.Text('Hello, world!');

        Content.Font(TPdfFont.HelveticaBold, 24);
        Content.NewLineAtOffset(0, -30);
        Content.Text('Hello, world!');

        UnicodeFont := Document.LoadFontAsset('com/tom_roush/pdfbox/resources/ttf/LiberationSans-Regular.ttf');
        try
          Content.Font(UnicodeFont, 24);
          Content.NewLineAtOffset(0, -30);
          Content.Text('English only!');

          Content.EndText;

          // draw lines
          Content.StrokingColor(TAlphaColorRec.Orange);
          Content.LineWidth(2);
          Content.MoveTo(20, PageHeight - 100);
          Content.LineTo(100, PageHeight - 100);
          Content.Stroke;

          Content.LineWidth(4);
          Content.LineCapStyle(TPdfLineCapStyle.Round);
          Content.MoveTo(20, PageHeight - 114);
          Content.LineTo(150, PageHeight - 114);
          Content.Stroke;

          SetLength(DashPattern, 2);
          DashPattern[0] := 4;
          DashPattern[1] := 2;

          Content.LineWidth(8);
          Content.LineCapStyle(TPdfLineCapStyle.Butt);
          Content.LineDashPattern(DashPattern);
          Content.MoveTo(20, PageHeight - 132);
          Content.LineTo(200, PageHeight - 132);
          Content.Stroke;

          // draw logo
          Content.Image(ImageLogo.Bitmap, 30, PageHeight - 410);

          // draw rectangles
          Content.StrokingColor(TAlphaColorRec.Red);
          Content.LineWidth(2);
          Content.Rectangle(TRectF.Create(20, PageHeight - 150, 100, PageHeight - 230));
          Content.Stroke;

          Content.NonStrokingColor(TAlphaColorRec.Red);
          Content.Rectangle(TRectF.Create(120, PageHeight - 150, 200, PageHeight - 230));
          Content.Fill;

          CenterX := 110;
          CenterY := PageHeight - 300;

          Matrix := TPdfMatrix.Create;
          try

            Matrix.Translate(CenterX, CenterY);
            Matrix.Rotate(DegToRad(45));
            Matrix.Translate(-CenterX, -CenterY);

            Content.NonStrokingColor(TAlphaColorRec.LightBlue);
            Content.Transform(Matrix);
            Content.Rectangle(TRectF.Create(CenterX - 40, CenterY - 40, CenterX + 40, CenterY + 40));
            Content.Fill;

            Content.StrokingColor(TAlphaColorRec.Blue);
            Content.LineWidth(2);
            Content.Rectangle(TRectF.Create(CenterX - 40, CenterY - 40, CenterX + 40, CenterY + 40));
            Content.Stroke;

            Content.Close;

            // render to bitmap
            ImageViewer.Bitmap := Document.RenderPage(0, 2.0);

            // save to file
            FileName := TPath.GetSharedDocumentsPath + PathDelim + 'new.pdf';
            Document.Save(FileName);
            //ShowMessage('File ' + FileName + ' created');

{$IFDEF ANDROID}

             OpenPDF(FileName);
{$ENDIF}



          finally
            Matrix.Free;
          end;

        finally
          UnicodeFont.Free;
        end;

      finally
        Content.Free;
      end;

    finally
      Page.Free;
    end;

  finally
    Document.Free;
  end;

end;



{
procedure TTabbedForm.OpenPDFA(const AFileName: string);
var
  LIntent: JIntent;
  LAuthority: JString;
  LUri: Jnet_Uri;
begin
  LAuthority := StringToJString(JStringToString(TAndroidHelper.Context.getApplicationContext.getPackageName) + '.fileprovider');
  LUri := TJFileProvider.JavaClass.getUriForFile(TAndroidHelper.Context, LAuthority, TJFile.JavaClass.init(StringToJString(AFileName)));
  LIntent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW);
  LIntent.setDataAndType(LUri, StringToJString('application/pdf'));
  LIntent.setFlags(TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);
  TAndroidHelper.Activity.startActivity(LIntent);
end;

procedure TTabbedForm.OpenPDF(const AFileName: string);
var
  LIntent: JIntent;
  LFile: JFile;
  LFileName: string;
begin
  // NOTE: You will need a PDF viewer installed on your device in order for this to work
  //LFileName := TPath.Combine(TPath.GetDocumentsPath, 'sample.pdf');
  LFile := TJFile.JavaClass.init(StringToJString(AFileName));
  LIntent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW);
  LIntent.setDataAndType(TAndroidHelper.JFileToJURI(LFile), StringToJString('application/pdf'));
  LIntent.setFlags(TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);
  TAndroidHelper.Activity.startActivity(LIntent);
end;
}

procedure TTabbedForm.OpenPDF(const AFileName: string);
var
  LIntent: JIntent;
  LUri: Jnet_Uri;
begin

  LUri := TAndroidHelper.JFileToJURI(TJFile.JavaClass.init(StringToJString(AFileName)));
  LIntent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW);
  LIntent.setDataAndType(LUri, StringToJString('application/pdf'));
  LIntent.setFlags(TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);
  TAndroidHelper.Activity.startActivity(LIntent);

end;
{$ENDIF}

end.
