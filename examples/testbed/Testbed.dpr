{===============================================================================
   ___ _    _
  | _ \ |_ (_)_ _ __ __™
  |  _/ ' \| | ' \\ \ /
  |_| |_||_|_|_||_/_\_\

  A High-Performance AI
  Inference Library for
     ONNX and Phi-4

 Copyright © 2025-present tinyBigGAMES™ LLC
 All Rights Reserved.

 https://github.com/tinyBigGAMES/Phinx

 See LICENSE file for license information
===============================================================================}

program Testbed;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Phinx.Utils in '..\..\src\Phinx.Utils.pas',
  Phinx.Core in '..\..\src\Phinx.Core.pas',
  Phinx.CLibs in '..\..\src\Phinx.CLibs.pas',
  UTestbed in 'UTestbed.pas';

begin
  try
    RunTests();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
