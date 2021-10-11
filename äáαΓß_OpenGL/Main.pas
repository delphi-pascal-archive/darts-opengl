{*****************************************************************

Author: Dennis Malkoff
Copyrights: Dennis Malkoff
E-mail: info@sminstall.com
WEB: http://www.sminstall.com/

******************************************************************}
unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OpenGL, MMSystem, Math;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; Xm,
      Ym: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; Xm, Ym: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; Xm, Ym: Integer);
  protected
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
  end;

var
  Form1: TForm1;
  DC: HDC;
  hrc: HGLRC;
  y: GLfloat;
  x: GLfloat;
  z: GLfloat;
  yt: GLfloat;
  xt: GLfloat;
  dal: GLfloat;
  lad: GLfloat;
  mDown, mUp: glBoolean;
  quadObj: GLUquadricObj;
  TimerId : uint;

implementation

{$R *.DFM}

procedure Javeline(quadObj: GLUquadricObj);
begin
  gluCylinder(quadObj, 0.02, 0.001, 0.6, 10, 10);
  gluCylinder(quadObj, 0.02, 0.02, 0.5, 10, 10);
  glBegin(GL_TRIANGLES);
    glNormal3f(0.3, 0.1, 1.0);
    glVertex3f(-0.2, 0.01, -0.5);
    glVertex3f(0.2, 0.01, -0.5);
    glVertex3f(0.0, 0.01, 0.01);
  glEnd;
  glBegin(GL_TRIANGLES);
    glNormal3f(0.3, 0.1, 0.0);
    glVertex3f(-0.2, -0.01, -0.5);
    glVertex3f(0.2, -0.01, -0.5);
    glVertex3f(0.0, -0.01, 0.01);
  glEnd;
  glBegin(GL_TRIANGLES);
    glNormal3f(0.3, 0.5, 1.0);
    glVertex3f(0.01, -0.2, -0.5);
    glVertex3f(0.01, 0.2, -0.5);
    glVertex3f(0.01, 0.0, 0.01);
  glEnd;
  glBegin(GL_TRIANGLES);
    glNormal3f( 1.0,  0.1, 1.0);
    glVertex3f(-0.01,-0.2,-0.5);
    glVertex3f(-0.01, 0.2,-0.5);
    glVertex3f(-0.01, 0.0, 0.01);
  glEnd;
  glBegin(GL_QUADS);
    glVertex3f(-0.2, 0.01,-0.5);
    glVertex3f(-0.2,-0.01,-0.5);
    glVertex3f( 0.0,-0.01, 0.01);
    glVertex3f( 0.0, 0.01, 0.01);
  glEnd;
  glBegin(GL_QUADS);
    glVertex3f( 0.2, 0.01,-0.5);
    glVertex3f( 0.2,-0.01,-0.5);
    glVertex3f( 0.0,-0.01, 0.01);
    glVertex3f( 0.0, 0.01, 0.01);
  glEnd;
  glBegin(GL_QUADS);
    glVertex3f(0.01, -0.2, -0.5);
    glVertex3f(-0.01,-0.2,-0.5);
    glVertex3f(-0.01, 0.0, 0.01);
    glVertex3f(0.01, 0.0, 0.01);
  glEnd;
  glBegin(GL_QUADS);
    glVertex3f(0.01, 0.2, -0.5);
    glVertex3f(-0.01, 0.2,-0.5);
    glVertex3f(-0.01, 0.0, 0.01);
    glVertex3f(0.01, 0.0, 0.01);
  glEnd;
  glBegin(GL_QUADS);
    glVertex3f(-0.2, 0.01,-0.5);
    glVertex3f(-0.2,-0.01,-0.5);
    glVertex3f( 0.2,-0.01,-0.5);
    glVertex3f( 0.2, 0.01,-0.5);
  glEnd;
  glBegin(GL_QUADS);
    glVertex3f(0.01, -0.2, -0.5);
    glVertex3f(-0.01,-0.2,-0.5);
    glVertex3f(-0.01, 0.2,-0.5);
    glVertex3f(0.01, 0.2, -0.5);
  glEnd;
end;

procedure Napraw;
begin
  glRotatef(y, 0.0, 1.0, 0.0);
  glRotatef(z, 0.0, 0.0, 1.0);
  glRotatef(x, 1.0, 0.0, 0.0);
end;

procedure Polet;
begin
  glScalef(dal,dal,dal);
  glTranslatef(dal-0.5,lad,1);
  glRotatef(yt, 0.0, 1.0, 0.0);
  glRotatef(xt, 1.0, 0.0, 0.0);
end;

procedure TimeProc(uTimerID, uMessage: UINT; dwUser, dw1, dw2: DWORD) stdcall;
begin
  if mUp=True then
  begin
    if xt=0 then
    begin
      xt:=x;
      yt:=y;
    end;
    dal:=dal-0.01;
    lad:=lad+0.01;
  end else
  begin
    dal:=1.0;
    lad:=0;
  end;
  if dal<0.05 then
  begin
    mUp:=False;
    xt:=0;
  end;
  InvalidateRect(Form1.Handle, nil, False);
end;

procedure TForm1.WMPaint(var Msg: TWMPaint);
begin
  glClear (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

  glPushMatrix;
  glBegin(GL_QUADS);
    glVertex3f(1.0,-1.0,-1.0);
    glVertex3f(1.0,-1.0,1.0);
    glVertex3f(1.0,1.0,1.0);
    glVertex3f(1.0,1.0,-1.0);
  glEnd;
  glPopMatrix;

  glPushMatrix;
  glTranslatef(-0.3,0.3,0.0);
  glScalef(0.2,0.2,1.0);
  gluQuadricDrawStyle(quadObj, GLU_FILL);
  glTranslatef(-0.2,0.2,0.99);
  glColor3f(1.0, 1.0, 1.0);
  gluDisk(quadObj, 0.15, 0.2, 15, 1);
  glColor3f(0.0, 0.0, 0.0);
  gluDisk(quadObj, 0.1, 0.15, 15, 1);
  glColor3f(1.0, 1.0, 1.0);
  gluDisk(quadObj, 0.05, 0.1, 15, 1);
  glPopMatrix;

  glPushMatrix;
  if mUp=False then Napraw else Polet;
  Javeline(quadObj);
  glPopMatrix;
  SwapBuffers(DC);
end;

procedure SetDCPixelFormat(hdc: HDC);
var
  pfd : TPixelFormatDescriptor;
  nPixelFormat : Integer;
begin
  FillChar (pfd, SizeOf (pfd), 0);
  pfd.dwFlags  := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER;
  pfd.cDepthBits:= 32;
  nPixelFormat := ChoosePixelFormat (hdc, @pfd);
  SetPixelFormat (hdc, nPixelFormat, @pfd);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ShowCursor(False);
  WindowState:=wsMaximized;
  DC := GetDC (Handle);
  SetDCPixelFormat(DC);
  hrc := wglCreateContext(DC);
  wglMakeCurrent(DC, hrc);
  glClearColor (0.5, 0.5, 0.75, 1.0);
  glLineWidth (1.5);
  glEnable(GL_LIGHTING);
  glEnable(GL_LIGHT0);
  glEnable(GL_DEPTH_TEST);
  glEnable(GL_COLOR_MATERIAL);
  quadObj := gluNewQuadric;
  y := 0.0;
  x := 0.0;
  z := 0.0;
  mDown:=False;
  mUp:=False;
  TimerID:= timeSetEvent(10, 1, @TimeProc, 0, TIME_PERIODIC);
  wglUseFontOutlines(Canvas.Handle, 0, 255, 1000, 50, 0.15, WGL_FONT_POLYGONS, nil);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  timeKillEvent(TimerID);
  gluDeleteQuadric(quadObj);
  wglMakeCurrent(0, 0);
  wglDeleteContext(hrc);
  ReleaseDC(Handle, DC);
  DeleteDC(DC);
  Application.Minimize;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 If Key = 27 then Close;
 If Key = 37 then y := y + 2.0;
 If Key = 39 then y := y - 2.0;
 If Key = 38 then x := x - 2.0;
 If Key = 40 then x := x + 2.0;
 if key = 87 then z:= z - 2.0;
 if key = 83 then z:= z + 2.0;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  glViewport(0, 0, ClientWidth, ClientHeight);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; Xm,
  Ym: Integer);
begin
  y := -(2*xm/width-1)*100;
  x := -(2*ym/height-1)*100;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; Xm, Ym: Integer);
begin
  mDown:=True;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; Xm, Ym: Integer);
begin
  mDown:=False;
  mUp:=True;
end;

end.

