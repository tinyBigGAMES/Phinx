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

unit Phinx.Utils;

{$I Phinx.Defines.inc}

interface

uses
  WinApi.Windows,
  WinApi.Messages,
  System.SysUtils,
  System.IOUtils,
  System.DateUtils,
  System.StrUtils,
  System.Classes,
  System.Math,
  System.JSON,
  System.TypInfo,
  System.Rtti,
  System.Net.HttpClient,
  System.Net.URLClient,
  System.NetConsts;

type
  { PphGenericPointer }
  PphGenericPointer = ^Pointer;

  { PPphGenericPointer }
  PPphGenericPointer = ^PphGenericPointer;

  { TphPointerArray1D<T> }
  TphPointerArray1D<T> = record
    class function GetValue(P: Pointer; Index: Integer): T; static;
    class procedure SetValue(P: Pointer; Index: Integer; const Value: T); static;
  end;

  { TphPointerArray2D<T> }
  TphPointerArray2D<T> = record
    class function GetValue(P: Pointer; Row, Col: Integer): T; static;
    class procedure SetValue(P: Pointer; Row, Col: Integer; const Value: T); static;
  end;

  { phSchemaDescription }
  phSchemaDescription = class(TCustomAttribute)
  private
    FDescription: string;
  public
    constructor Create(const ADescription: string);
    property Description: string read FDescription;
  end;

  { TphTokenPrintAction }
  TphTokenPrintAction = (tpaWait, tpaAppend, tpaNewline);

  { TphTokenResponse }
  TphTokenResponse = record
  private
    FRaw: string;                  // Full response as is
    FTokens: array of string;      // Actual tokens
    FMaxLineLength: Integer;       // Define confined space, in chars for fixed width font
    FWordBreaks: array of char;    // What is considered a logical word-break
    FLineBreaks: array of char;    // What is considered a logical line-break
    FWords: array of String;       // Response but as array of "words"
    FWord: string;                 // Current word accumulating
    FLine: string;                 // Current line accumulating
    FFinalized: Boolean;           // Know the finalization is done
    FRightMargin: Integer;
    function HandleLineBreaks(const AToken: string): Boolean;
    function SplitWord(const AWord: string; var APrefix, ASuffix: string): Boolean;
    function GetLineLengthMax(): Integer;
  public
    procedure Initialize;
    property RightMargin: Integer read FRightMargin;
    property MaxLineLength: Integer read FMaxLineLength;
    function  GetRightMargin(): Integer;
    procedure SetRightMargin(const AMargin: Integer);
    function  GetMaxLineLength(): Integer;
    procedure SetMaxLineLength(const ALength: Integer);
    function AddToken(const aToken: string): TphTokenPrintAction;
    function LastWord(const ATrimLeft: Boolean=False): string;
    function Finalize: Boolean;
    procedure Clear();
  end;

  { TphPayloadStream }
  TphPayloadStream = class(TStream)
  private const
    cWaterMarkGUID: TGUID = '{9FABA105-EDA8-45C3-89F4-369315A947EB}';
  private type
    EPayloadStream = class(Exception);

    TPayloadStreamFooter = packed record
      WaterMark: TGUID;
      ExeSize: Int64;
      DataSize: Int64;
    end;

    TPayloadStreamOpenMode = (
      pomRead,    // read mode
      pomWrite    // write (append) mode
    );
  private
    fMode: TPayloadStreamOpenMode;  // stream open mode
    fFileStream: TFileStream;       // file stream for payload
    fDataStart: Int64;              // start of payload data in file
    fDataSize: Int64;               // size of payload
    function GetPosition: Int64;
    procedure SetPosition(const Value: Int64);
    procedure InitFooter(out Footer: TPayloadStreamFooter);
    function ReadFooter(const FileStream: TFileStream; out Footer: TPayloadStreamFooter): Boolean;
  public
    property CurrentPos: Int64 read GetPosition write SetPosition;
    constructor Create(const FileName: string; const Mode: TPayloadStreamOpenMode);
    destructor Destroy; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
    procedure SetSize(const NewSize: Int64); override;
    function Read(var Buffer; Count: LongInt): LongInt; override;
    function Write(const Buffer; Count: LongInt): LongInt; override;
    property DataSize: Int64 read fDataSize;
  end;

  { phUtils }
  phUtils = class
  private
    class constructor Create();
    class destructor Destroy();
  public
    class procedure UnitInit();
    class function  AsUTF8(const AText: string): Pointer; static;
    class function  GetPhysicalProcessorCount(): DWORD; static;
    class function  EnableVirtualTerminalProcessing(): DWORD; static;
    class function  GetEnvVarValue(const AVarName: string): string; static;
    class function  IsStartedFromDelphiIDE(): Boolean; static;
    class procedure ProcessMessages(); static;
    class function  RandomRange(const AMin, AMax: Integer): Integer; static;
    class function  RandomRangef(const AMin, AMax: Single): Single; static;
    class function  RandomBool(): Boolean; static;
    class function  GetRandomSeed(): Integer; static;
    class procedure SetRandomSeed(const AVaLue: Integer); static;
    class procedure Wait(const AMilliseconds: Double); static;
    class function  SanitizeFromJson(const aText: string): string; static;
    class function  SanitizeToJson(const aText: string): string; static;
    class function  GetJsonSchema(const AClass: TClass; const AMethodName: string): string; static;
    class function  GetJsonSchemas(AClass: TClass): string; static;
    class function  CallStaticMethod(const AClass: TClass; const AMethodName: string; const AArgs: array of TValue): TValue;
    class function  GetISO8601DateTime(): string;
    class function  GetISO8601DateTimeLocal(): string;
    class function  GetLocalDateTime(): string;
    class function  HasEnoughDiskSpace(const AFilePath: string; ARequiredSize: Int64): Boolean;
    class procedure StringToStream(const AString: string; const AStream: TStream);
    class function  StringFromStream(const AStream: TStream): string;
    class function  AddPathToSystemPath(const APath: string): Boolean;
    class function  RemovePathFromSystemPath(const APath: string): Boolean;
    class function  GetEXEPath(): string;
    class function  RemoveQuotes(const AText: string): string;
    class function  FormatNumberWithCommas(const AValue: Int64): string;
    class function  GetRandomThinkingResult(): string;
    class function  TavilyWebSearch(const AAPIKey, AQuery: string): string; static;
  end;

const
  phLF   = AnsiChar(#10);
  phCR   = AnsiChar(#13);
  phCRLF = phLF+phCR;
  phESC  = AnsiChar(#27);

  phVK_ESC = 27;

  // Cursor Movement
  phCSICursorPos = phESC + '[%d;%dH';         // Set cursor position
  phCSICursorUp = phESC + '[%dA';             // Move cursor up
  phCSICursorDown = phESC + '[%dB';           // Move cursor down
  phCSICursorForward = phESC + '[%dC';        // Move cursor forward
  phCSICursorBack = phESC + '[%dD';           // Move cursor backward
  phCSISaveCursorPos = phESC + '[s';          // Save cursor position
  phCSIRestoreCursorPos = phESC + '[u';       // Restore cursor position

  // Cursor Visibility
  phCSIShowCursor = phESC + '[?25h';          // Show cursor
  phCSIHideCursor = phESC + '[?25l';          // Hide cursor
  phCSIBlinkCursor = phESC + '[?12h';         // Enable cursor blinking
  phCSISteadyCursor = phESC + '[?12l';        // Disable cursor blinking

  // Screen Manipulation
  phCSIClearScreen = phESC + '[2J';           // Clear screen
  phCSIClearLine = phESC + '[2K';             // Clear line
  phCSIScrollUp = phESC + '[%dS';             // Scroll up by n lines
  phCSIScrollDown = phESC + '[%dT';           // Scroll down by n lines

  // Text Formatting
  phCSIBold = phESC + '[1m';                  // Bold text
  phCSIUnderline = phESC + '[4m';             // Underline text
  phCSIResetFormat = phESC + '[0m';           // Reset text formatting
  phCSIResetBackground = #27'[49m';         // Reset background text formatting
  phCSIResetForeground = #27'[39m';         // Reset forground text formatting
  phCSIInvertColors = phESC + '[7m';          // Invert foreground/background
  phCSINormalColors = phESC + '[27m';         // Normal colors

  phCSIDim = phESC + '[2m';
  phCSIItalic = phESC + '[3m';
  phCSIBlink = phESC + '[5m';
  phCSIFramed = phESC + '[51m';
  phCSIEncircled = phESC + '[52m';

  // Text Modification
  phCSIInsertChar = phESC + '[%d@';           // Insert n spaces at cursor position
  phCSIDeleteChar = phESC + '[%dP';           // Delete n characters at cursor position
  phCSIEraseChar = phESC + '[%dX';            // Erase n characters at cursor position

  // Colors (Foreground and Background)
  phCSIFGBlack = phESC + '[30m';
  phCSIFGRed = phESC + '[31m';
  phCSIFGGreen = phESC + '[32m';
  phCSIFGYellow = phESC + '[33m';
  phCSIFGBlue = phESC + '[34m';
  phCSIFGMagenta = phESC + '[35m';
  phCSIFGCyan = phESC + '[36m';
  phCSIFGWhite = phESC + '[37m';

  phCSIBGBlack = phESC + '[40m';
  phCSIBGRed = phESC + '[41m';
  phCSIBGGreen = phESC + '[42m';
  phCSIBGYellow = phESC + '[43m';
  phCSIBGBlue = phESC + '[44m';
  phCSIBGMagenta = phESC + '[45m';
  phCSIBGCyan = phESC + '[46m';
  phCSIBGWhite = phESC + '[47m';

  phCSIFGBrightBlack = phESC + '[90m';
  phCSIFGBrightRed = phESC + '[91m';
  phCSIFGBrightGreen = phESC + '[92m';
  phCSIFGBrightYellow = phESC + '[93m';
  phCSIFGBrightBlue = phESC + '[94m';
  phCSIFGBrightMagenta = phESC + '[95m';
  phCSIFGBrightCyan = phESC + '[96m';
  phCSIFGBrightWhite = phESC + '[97m';

  phCSIBGBrightBlack = phESC + '[100m';
  phCSIBGBrightRed = phESC + '[101m';
  phCSIBGBrightGreen = phESC + '[102m';
  phCSIBGBrightYellow = phESC + '[103m';
  phCSIBGBrightBlue = phESC + '[104m';
  phCSIBGBrightMagenta = phESC + '[105m';
  phCSIBGBrightCyan = phESC + '[106m';
  phCSIBGBrightWhite = phESC + '[107m';

  phCSIFGRGB = phESC + '[38;2;%d;%d;%dm';        // Foreground RGB
  phCSIBGRGB = phESC + '[48;2;%d;%d;%dm';        // Backg

type
  { soCharSet }
  phCharSet = set of AnsiChar;

  /// <summary>
  ///   <c>phConsole</c> is a static class responsible for handling console output.
  ///   It provides utility methods for printing messages to the currently active console,
  ///   if one is present. This class is designed for logging, debugging, and
  ///   real-time text output within a console-based environment.
  /// </summary>
  phConsole = class
  private class var
    FInputCodePage: Cardinal;
    FOutputCodePage: Cardinal;
    FTeletypeDelay: Integer;
    FKeyState: array [0..1, 0..255] of Boolean;
  private
    class constructor Create();
    class destructor Destroy();
  public
    class procedure UnitInit();

    /// <summary>
    ///   Prints a message to the currently active console, if available.
    ///   This method does not append a newline after the message.
    /// </summary>
    /// <param name="AMsg">
    ///   The message to be printed to the console.
    /// </param>
    class procedure Print(const AMsg: string); overload; static;

    /// <summary>
    ///   Prints a message to the currently active console, if available,
    ///   and appends a newline at the end.
    /// </summary>
    /// <param name="AMsg">
    ///   The message to be printed to the console.
    /// </param>
    class procedure PrintLn(const AMsg: string); overload; static;

    /// <summary>
    ///   Prints a formatted message to the currently active console, if available.
    ///   This method allows placeholders in the message string to be replaced
    ///   with values from the provided argument array.
    ///   No newline is appended after the message.
    /// </summary>
    /// <param name="AMsg">
    ///   The format string containing placeholders for argument substitution.
    /// </param>
    /// <param name="AArgs">
    ///   An array of values to be inserted into the format string.
    /// </param>
    class procedure Print(const AMsg: string; const AArgs: array of const); overload; static;

    /// <summary>
    ///   Prints a formatted message to the currently active console, if available,
    ///   and appends a newline at the end.
    ///   This method allows placeholders in the message string to be replaced
    ///   with values from the provided argument array.
    /// </summary>
    /// <param name="AMsg">
    ///   The format string containing placeholders for argument substitution.
    /// </param>
    /// <param name="AArgs">
    ///   An array of values to be inserted into the format string.
    /// </param>
    class procedure PrintLn(const AMsg: string; const AArgs: array of const); overload; static;

    /// <summary>
    ///   Prints an empty line to the currently active console, if available.
    ///   This method is equivalent to printing an empty string without appending a newline.
    /// </summary>
    class procedure Print(); overload; static;

    /// <summary>
    ///   Prints a blank line to the currently active console, if available.
    ///   This method simply appends a newline to create a visual separation in output.
    /// </summary>
    class procedure PrintLn(); overload; static;

    class procedure GetCursorPos(X, Y: PInteger); static;
    class procedure SetCursorPos(const X, Y: Integer); static;
    class procedure SetCursorVisible(const AVisible: Boolean); static;
    class procedure HideCursor(); static;
    class procedure ShowCursor(); static;
    class procedure SaveCursorPos(); static;
    class procedure RestoreCursorPos(); static;
    class procedure MoveCursorUp(const ALines: Integer); static;
    class procedure MoveCursorDown(const ALines: Integer); static;
    class procedure MoveCursorForward(const ACols: Integer); static;
    class procedure MoveCursorBack(const ACols: Integer); static;

    class procedure ClearScreen(); static;

    /// <summary>
    ///   Clears the current line where the cursor is positioned in the active console.
    ///   This removes any text from the line without affecting other content in the console.
    /// </summary>
    class procedure ClearLine(); static;

    class procedure ClearLineFromCursor(const AColor: string); static;

    class procedure SetBoldText(); static;
    class procedure ResetTextFormat(); static;
    class procedure SetForegroundColor(const AColor: string); static;
    class procedure SetBackgroundColor(const AColor: string); static;
    class procedure SetForegroundRGB(const ARed, AGreen, ABlue: Byte); static;
    class procedure SetBackgroundRGB(const ARed, AGreen, ABlue: Byte); static;

    class procedure GetSize(AWidth: PInteger; AHeight: PInteger); static;

    class procedure SetTitle(const ATitle: string); static;
    class function  GetTitle(): string; static;

    class function  HasOutput(): Boolean; static;
    class function  WasRunFrom(): Boolean; static;
    class procedure WaitForAnyKey(); static;
    class function  AnyKeyPressed(): Boolean; static;

    class procedure ClearKeyStates(); static;
    class procedure ClearKeyboardBuffer(); static;

    class function  IsKeyPressed(AKey: Byte): Boolean; static;
    class function  WasKeyReleased(AKey: Byte): Boolean; static;
    class function  WasKeyPressed(AKey: Byte): Boolean; static;

    class function  ReadKey(): WideChar; static;
    class function  ReadLnX(const AAllowedChars: phCharSet; AMaxLength: Integer; const AColor: string=phCSIFGWhite): string; static;

    /// <summary>
    ///   Pauses execution and waits for user input in the active console.
    ///   This method is typically used to create a breakpoint in execution, allowing
    ///   the user to acknowledge a message before continuing.
    /// </summary>
    /// <param name="AForcePause">
    ///   If set to <c>True</c>, the pause is enforced even if no console is detected.
    ///   If <c>False</c>, the pause only occurs if a console is present.
    /// </param>
    /// <param name="AColor">
    ///   The foreground color used to display the message in the console.
    ///   Defaults to <c>phCSIFGWhite</c>.
    /// </param>
    /// <param name="AMsg">
    ///   An optional message to display before pausing execution.
    ///   If no message is provided, the function simply waits for user input.
    /// </param>
    class procedure Pause(const AForcePause: Boolean = False; AColor: string = phCSIFGWhite;
      const AMsg: string = ''); static;

    class function  WrapTextEx(const ALine: string; AMaxCol: Integer; const ABreakChars: phCharSet=[' ', '-', ',', ':', #9]): string; static;
    class procedure Teletype(const AText: string; const AColor: string=phCSIFGWhite; const AMargin: Integer=10; const AMinDelay: Integer=0; const AMaxDelay: Integer=3; const ABreakKey: Byte=VK_ESCAPE); static;
  end;

  { TphObject }
  TphObject = class
  protected
    FError: string;
  public
    constructor Create(); virtual;
    destructor Destroy(); override;
    procedure SetError(const AText: string; const AArgs: array of const); virtual;
    function  GetError(): string; virtual;
  end;

implementation

var
  MMarshaller: TMarshaller;

{ TphPointerArray1D<T> }
class function TphPointerArray1D<T>.GetValue(P: Pointer; Index: Integer): T;
var
  Ptr: PByte;
begin
  Ptr := PByte(P);
  Inc(Ptr, Index * SizeOf(T));
  Move(Ptr^, Result, SizeOf(T));
end;

class procedure TphPointerArray1D<T>.SetValue(P: Pointer; Index: Integer; const Value: T);
var
  Ptr: PByte;
begin
  Ptr := PByte(P);
  Inc(Ptr, Index * SizeOf(T));
  Move(Value, Ptr^, SizeOf(T));
end;

{ TphPointerArray2D<T> }
class function TphPointerArray2D<T>.GetValue(P: Pointer; Row, Col: Integer): T;
var
  PP: PPointer;
  Ptr: PByte;
begin
  PP := PPointer(P);
  Inc(PP, Row);
  Ptr := PByte(PP^);
  Inc(Ptr, Col * SizeOf(T));
  Move(Ptr^, Result, SizeOf(T));
end;

class procedure TphPointerArray2D<T>.SetValue(P: Pointer; Row, Col: Integer; const Value: T);
var
  PP: PPointer;
  Ptr: PByte;
begin
  PP := PPointer(P);
  Inc(PP, Row);
  Ptr := PByte(PP^);
  Inc(Ptr, Col * SizeOf(T));
  Move(Value, Ptr^, SizeOf(T));
end;

{ TsoSchemaDescription }
constructor phSchemaDescription.Create(const ADescription: string);
begin
  FDescription := ADescription;
end;

{ TphTokenResponse }
procedure TphTokenResponse.Initialize;
begin
  // Defaults
  FRaw := '';
  SetLength(FTokens, 0);
  SetLength(FWordBreaks, 0);
  SetLength(FLineBreaks, 0);
  SetLength(FWords, 0);
  FWord := '';
  FLine := '';
  FFinalized := False;
  FRightMargin := 10;

  // If stream output is sent to a destination without wordwrap,
  // the TatTokenResponse will find wordbreaks and split into lines by full words

  // Stream is tabulated into full words based on these break characters
  // !Syntax requires at least one!
  SetLength(FWordBreaks, 4);
  FWordBreaks[0] := ' ';
  FWordBreaks[1] := '-';
  FWordBreaks[2] := ',';
  FWordBreaks[3] := '.';

  // Stream may contain forced line breaks
  // !Syntax requires at least one!
  SetLength(FLineBreaks, 2);
  FLineBreaks[0] := #13;
  FLineBreaks[1] := #10;

  SetRightMargin(10);
  SetMaxLineLength(120);
end;

function TphTokenResponse.AddToken(const aToken: string): TphTokenPrintAction;
var
  LPrefix, LSuffix: string;
begin
  // Keep full original response
  FRaw := FRaw + aToken;                    // As continuous string
  Setlength(FTokens, Length(FTokens)+1);    // Make space
  FTokens[Length(FTokens)-1] := aToken;     // As an array

  // Accumulate "word"
  FWord := FWord + aToken;

  // If stream contains linebreaks, print token out without added linebreaks
  if HandleLineBreaks(aToken) then
    exit(TphTokenPrintAction.tpaAppend)

  // Check if a natural break exists, also split if word is longer than the allowed space
  // and print out token with or without linechange as needed
  else if SplitWord(FWord, LPrefix, LSuffix) or FFinalized then
    begin
      // On last call when Finalized we want access to the line change logic only
      // Bad design (fix on top of a fix) Would be better to separate word slipt and line logic from eachother
      if not FFinalized then
        begin
          Setlength(FWords, Length(FWords)+1);        // Make space
          FWords[Length(FWords)-1] := LPrefix;        // Add new word to array
          FWord := LSuffix;                         // Keep the remainder of the split
        end;

      // Word was split, so there is something that can be printed

      // Need for a new line?
      if Length(FLine) + Length(LastWord) > GetLineLengthMax() then
        begin
          Result  := TphTokenPrintAction.tpaNewline;
          FLine   := LastWord;                  // Reset Line (will be new line and then the word)
        end
      else
        begin
          Result  := TphTokenPrintAction.tpaAppend;
          FLine   := FLine + LastWord;          // Append to the line
        end;
    end
  else
    begin
      Result := TphTokenPrintAction.tpaWait;
    end;
end;

function TphTokenResponse.HandleLineBreaks(const AToken: string): Boolean;
var
  LLetter, LLineBreak: Integer;
begin
  Result := false;

  for LLetter := Length(AToken) downto 1 do                   // We are interested in the last possible linebreak
  begin
    for LLineBReak := 0 to Length(Self.FLineBreaks)-1 do       // Iterate linebreaks
    begin
      if AToken[LLetter] = FLineBreaks[LLineBreak] then        // If linebreak was found
      begin
        // Split into a word by last found linechange (do note the stored word may have more linebreak)
        Setlength(FWords, Length(FWords)+1);                          // Make space
        FWords[Length(FWords)-1] := FWord + LeftStr(AToken, Length(AToken)-LLetter); // Add new word to array

        // In case aToken did not end after last LF
        // Word and new line will have whatever was after the last linebreak
        FWord := RightStr(AToken, Length(AToken)-LLetter);
        FLine := FWord;

        // No need to go further
        exit(true);
      end;
    end;
  end;
end;

function TphTokenResponse.Finalize: Boolean;
begin
  // Buffer may contain something, if so make it into a word
  if FWord <> ''  then
    begin
      Setlength(FWords, Length(FWords)+1);      // Make space
      FWords[Length(FWords)-1] := FWord;        // Add new word to array
      Self.FFinalized := True;                // Remember Finalize was done (affects how last AddToken-call behaves)
      exit(true);
    end
  else
    Result := false;
end;

procedure TphTokenResponse.Clear();
begin
  FRaw := '';
  SetLength(FTokens, 0);
  SetLength(FWords, 0);
  FWord := '';
  FLine := '';
  FFinalized := False;
end;

function TphTokenResponse.LastWord(const ATrimLeft: Boolean): string;
begin
  Result := FWords[Length(FWords)-1];
  if ATrimLeft then
    Result := Result.TrimLeft;
end;

function TphTokenResponse.SplitWord(const AWord: string; var APrefix, ASuffix: string): Boolean;
var
  LLetter, LSeparator: Integer;
begin
  Result := false;

  for LLetter := 1 to Length(AWord) do               // Iterate whole word
  begin
    for LSeparator := 0 to Length(FWordBreaks)-1 do   // Iterate all separating characters
    begin
      if AWord[LLetter] = FWordBreaks[LSeparator] then // check for natural break
      begin
        // Let the world know there's stuff that can be a reason for a line change
        Result := True;

        APrefix := LeftStr(AWord, LLetter);
        ASuffix := RightStr(AWord, Length(AWord)-LLetter);
      end;
    end;
  end;

  // Maybe the word is too long but there was no natural break, then cut it to LineLengthMax
  if Length(AWord) > GetLineLengthMax() then
  begin
    Result := True;
    APrefix := LeftStr(AWord, GetLineLengthMax());
    ASuffix := RightStr(AWord, Length(AWord)-GetLineLengthMax());
  end;
end;

function TphTokenResponse.GetLineLengthMax(): Integer;
begin
  Result := FMaxLineLength - FRightMargin;
end;

function  TphTokenResponse.GetRightMargin(): Integer;
begin
  Result := FRightMargin;
end;

procedure TphTokenResponse.SetRightMargin(const AMargin: Integer);
begin
  FRightMargin := AMargin;
end;

function  TphTokenResponse.GetMaxLineLength(): Integer;
begin
  Result := FMaxLineLength;
end;

procedure TphTokenResponse.SetMaxLineLength(const ALength: Integer);
begin
  FMaxLineLength := ALength;
end;

{ TphPayloadStream }
procedure TphPayloadStream.InitFooter(out Footer: TPayloadStreamFooter);
begin
  FillChar(Footer, SizeOf(Footer), 0);
  Footer.WaterMark := cWaterMarkGUID;
end;

function TphPayloadStream.ReadFooter(const FileStream: TFileStream;
  out Footer: TPayloadStreamFooter): Boolean;
var
  FileLen: Int64;
begin
  // Check that file is large enough for a footer!
  FileLen := FileStream.Size;
  if FileLen > SizeOf(Footer) then
  begin
    // Big enough: move to start of footer and read it
    FileStream.Seek(-SizeOf(Footer), soEnd);
    FileStream.Read(Footer, SizeOf(Footer));
  end
  else
    // File not large enough for footer: zero it
    // .. this ensures watermark is invalid
    FillChar(Footer, SizeOf(Footer), 0);
  // Return if watermark is valid
  Result := IsEqualGUID(Footer.WaterMark, cWaterMarkGUID);
end;

constructor TphPayloadStream.Create(const FileName: string; const Mode: TPayloadStreamOpenMode);
var
  Footer: TPayloadStreamFooter; // footer record for payload data
begin
  inherited Create;
  // Open file stream
  fMode := Mode;
  case fMode of
    pomRead: fFileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    pomWrite: fFileStream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareExclusive);
  end;
  // Check for existing payload
  if ReadFooter(fFileStream, Footer) then
  begin
    // We have payload: record start and size of data
    fDataStart := Footer.ExeSize;
    fDataSize := Footer.DataSize;
  end
  else
  begin
    // There is no existing payload: start is end of file
    fDataStart := fFileStream.Size;
    fDataSize := 0;
  end;
  // Set initial file position per mode
  case fMode of
    pomRead: fFileStream.Seek(fDataStart, soBeginning);
    pomWrite: fFileStream.Seek(fDataStart + fDataSize, soBeginning);
  end;
end;

destructor TphPayloadStream.Destroy;
var
  Footer: TPayloadStreamFooter; // payload footer record
begin
  if fMode = pomWrite then
  begin
    // We're in write mode: we need to update footer
    if fDataSize > 0 then
    begin
      // We have payload, so need a footer record
      InitFooter(Footer);
      Footer.ExeSize := fDataStart;
      Footer.DataSize := fDataSize;
      fFileStream.Seek(0, soEnd);
      fFileStream.WriteBuffer(Footer, SizeOf(Footer));
    end
    else
    begin
      // No payload => no footer
      fFileStream.Size := fDataStart;
    end;
  end;
  // Free file stream
  FreeAndNil(fFileStream);
  inherited;
end;

function TphPayloadStream.Seek(const Offset: Int64;
  Origin: TSeekOrigin): Int64;
begin
  // Perform actual seek in underlying file stream
  Result := fFileStream.Seek(Offset, Origin);
end;

procedure TphPayloadStream.SetSize(const NewSize: Int64);
begin
  // Set size of file stream
  fFileStream.Size := NewSize;
end;

function TphPayloadStream.Read(var Buffer; Count: LongInt): LongInt;
begin
  // Read data from file stream and return bytes read
  Result := fFileStream.Read(Buffer, Count);
end;

function TphPayloadStream.Write(const Buffer; Count: LongInt): LongInt;
begin
  // Check in write mode
  if fMode <> pomWrite then
  begin
    raise EPayloadStream.Create(
      'TPayloadStream can''t write in read mode.');
  end;
  // Write the data to file stream and return bytes written
  Result := fFileStream.Write(Buffer, Count);
  // Check if stream has grown
  fDataSize := Max(fDataSize, fFileStream.Position - fDataStart);
end;

function TphPayloadStream.GetPosition: Int64;
begin
  Result := fFileStream.Position - fDataStart;
end;

procedure TphPayloadStream.SetPosition(const Value: Int64);
begin
  fFileStream.Position := fDataStart + Value;
end;

{ phUtils }
class constructor phUtils.Create();
begin
  Randomize();
end;

class destructor phUtils.Destroy();
begin
end;

class procedure phUtils.UnitInit();
begin
  // force constructor
end;

class function  phUtils.AsUTF8(const AText: string): Pointer;
begin
  Result := MMarshaller.AsUtf8(AText).ToPointer;
end;

class function phUtils.GetPhysicalProcessorCount(): DWORD;
var
  BufferSize: DWORD;
  Buffer: PSYSTEM_LOGICAL_PROCESSOR_INFORMATION;
  ProcessorInfo: PSYSTEM_LOGICAL_PROCESSOR_INFORMATION;
  Offset: DWORD;
begin
  Result := 0;
  BufferSize := 0;

  // Call GetLogicalProcessorInformation with buffer size set to 0 to get required buffer size
  if not GetLogicalProcessorInformation(nil, BufferSize) and (WinApi.Windows.GetLastError() = ERROR_INSUFFICIENT_BUFFER) then
  begin
    // Allocate buffer
    GetMem(Buffer, BufferSize);
    try
      // Call GetLogicalProcessorInformation again with allocated buffer
      if GetLogicalProcessorInformation(Buffer, BufferSize) then
      begin
        ProcessorInfo := Buffer;
        Offset := 0;

        // Loop through processor information to count physical processors
        while Offset + SizeOf(SYSTEM_LOGICAL_PROCESSOR_INFORMATION) <= BufferSize do
        begin
          if ProcessorInfo.Relationship = RelationProcessorCore then
            Inc(Result);

          Inc(ProcessorInfo);
          Inc(Offset, SizeOf(SYSTEM_LOGICAL_PROCESSOR_INFORMATION));
        end;
      end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;

class function phUtils.EnableVirtualTerminalProcessing(): DWORD;
var
  HOut: THandle;
  LMode: DWORD;
begin
  HOut := GetStdHandle(STD_OUTPUT_HANDLE);
  if HOut = INVALID_HANDLE_VALUE then
  begin
    Result := GetLastError;
    Exit;
  end;

  if not GetConsoleMode(HOut, LMode) then
  begin
    Result := GetLastError;
    Exit;
  end;

  LMode := LMode or ENABLE_VIRTUAL_TERMINAL_PROCESSING;
  if not SetConsoleMode(HOut, LMode) then
  begin
    Result := GetLastError;
    Exit;
  end;

  Result := 0;  // Success
end;

class function phUtils.GetEnvVarValue(const AVarName: string): string;
var
  LBufSize: Integer;
begin
  LBufSize := GetEnvironmentVariable(PChar(AVarName), nil, 0);
  if LBufSize > 0 then
    begin
      SetLength(Result, LBufSize - 1);
      GetEnvironmentVariable(PChar(AVarName), PChar(Result), LBufSize);
    end
  else
    Result := '';
end;

class function phUtils.IsStartedFromDelphiIDE(): Boolean;
begin
  // Check if the IDE environment variable is present
  Result := (GetEnvironmentVariable('BDS') <> '');
end;

class procedure phUtils.ProcessMessages();
var
  LMsg: TMsg;
begin
  while Integer(PeekMessage(LMsg, 0, 0, 0, PM_REMOVE)) <> 0 do
  begin
    TranslateMessage(LMsg);
    DispatchMessage(LMsg);
  end;
end;

function _RandomRange(const aFrom, aTo: Integer): Integer;
var
  LFrom: Integer;
  LTo: Integer;
begin
  LFrom := aFrom;
  LTo := aTo;

  if AFrom > ATo then
    Result := Random(LFrom - LTo) + ATo
  else
    Result := Random(LTo - LFrom) + AFrom;
end;

class function  phUtils.RandomRange(const AMin, AMax: Integer): Integer;
begin
  Result := _RandomRange(AMin, AMax + 1);
end;

class function  phUtils.RandomRangef(const AMin, AMax: Single): Single;
var
  LNum: Single;
begin
  LNum := _RandomRange(0, MaxInt) / MaxInt;
  Result := AMin + (LNum * (AMax - AMin));
end;

class function  phUtils.RandomBool(): Boolean;
begin
  Result := Boolean(_RandomRange(0, 2) = 1);
end;

class function  phUtils.GetRandomSeed(): Integer;
begin
  Result := System.RandSeed;
end;

class procedure phUtils.SetRandomSeed(const AVaLue: Integer);
begin
  System.RandSeed := AVaLue;
end;

class procedure phUtils.Wait(const AMilliseconds: Double);
var
  LFrequency, LStartCount, LCurrentCount: Int64;
  LElapsedTime: Double;
begin
  // Get the high-precision frequency of the system's performance counter
  QueryPerformanceFrequency(LFrequency);

  // Get the starting value of the performance counter
  QueryPerformanceCounter(LStartCount);

  // Convert milliseconds to seconds for precision timing
  repeat
    QueryPerformanceCounter(LCurrentCount);
    LElapsedTime := (LCurrentCount - LStartCount) / LFrequency * 1000.0; // Convert to milliseconds
  until LElapsedTime >= AMilliseconds;
end;

class function  phUtils.SanitizeToJson(const aText: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(aText) do
  begin
    case aText[i] of
      '\': Result := Result + '\\';
      '"': Result := Result + '\"';
      '/': Result := Result + '\/';
      #8:  Result := Result + '\b';
      #9:  Result := Result + '\t';
      #10: Result := Result + '\n';
      #12: Result := Result + '\f';
      #13: Result := Result + '\r';
      else
        Result := Result + aText[i];
    end;
  end;
  Result := Result;
end;

class function  phUtils.SanitizeFromJson(const aText: string): string;
var
  LText: string;
begin
  LText := aText;
  LText := LText.Replace('\n', #10);
  LText := LText.Replace('\r', #13);
  LText := LText.Replace('\b', #8);
  LText := LText.Replace('\t', #9);
  LText := LText.Replace('\f', #12);
  LText := LText.Replace('\/', '/');
  LText := LText.Replace('\"', '"');
  LText := LText.Replace('\\', '\');
  Result := LText;
end;

// Helper function to map Delphi types to JSON Schema types
function GetJsonType(DelphiType: TRttiType): string;
begin
  if not Assigned(DelphiType) then
    Exit('null');

  case DelphiType.TypeKind of
    tkInteger, tkInt64: Result := 'integer';
    tkFloat: Result := 'number';
    tkChar, tkWChar, tkString, tkLString, tkWString, tkUString: Result := 'string';
    tkEnumeration:
      begin
        if SameText(DelphiType.Name, 'Boolean') then
          Result := 'boolean'
        else
          Result := 'string';
      end;
    tkClass, tkRecord: Result := 'object';
    tkSet, tkDynArray, tkArray: Result := 'array';
  else
    Result := 'unknown';
  end;
end;

class function phUtils.GetJsonSchema(const AClass: TClass; const AMethodName: string): string;
var
  JsonRoot, JsonFunction, JsonParams, JsonProperties, JsonParamObj: TJSONObject;
  RequiredArray: TJSONArray;
  Context: TRttiContext;
  RttiType: TRttiType;
  Method: TRttiMethod;
  Param: TRttiParameter;
  Attr: TCustomAttribute;
  ParamDescription: string;
begin
  Result := '';
  Context := TRttiContext.Create;
  try
    RttiType := Context.GetType(AClass.ClassInfo);
    if not Assigned(RttiType) then Exit;

    Method := RttiType.GetMethod(AMethodName);
    if not Assigned(Method) then Exit;

    // Ensure the method is a STATIC method
    if not (Method.MethodKind in [mkClassFunction, mkClassProcedure]) then
      Exit; // Return empty result if it's not a static method

    // Root JSON Object
    JsonRoot := TJSONObject.Create;
    JsonRoot.AddPair('type', 'function');

    // Function JSON Object
    JsonFunction := TJSONObject.Create;
    JsonFunction.AddPair('name', AMethodName);

    // Extract method description (if available)
    for Attr in Method.GetAttributes do
      if Attr is phSchemaDescription then
        JsonFunction.AddPair('description', phSchemaDescription(Attr).Description);

    // Parameter Section
    JsonParams := TJSONObject.Create;
    JsonParams.AddPair('type', 'object');

    JsonProperties := TJSONObject.Create;
    RequiredArray := TJSONArray.Create;

    for Param in Method.GetParameters do
    begin
      JsonParamObj := TJSONObject.Create;
      JsonParamObj.AddPair('type', GetJsonType(Param.ParamType));

      // Extract parameter description (if available)
      ParamDescription := '';
      for Attr in Param.GetAttributes do
        if Attr is phSchemaDescription then
          ParamDescription := phSchemaDescription(Attr).Description;

      if ParamDescription <> '' then
        JsonParamObj.AddPair('description', ParamDescription);

      JsonProperties.AddPair(Param.Name, JsonParamObj);
      RequiredArray.AddElement(TJSONString.Create(Param.Name));
    end;

    JsonParams.AddPair('properties', JsonProperties);
    JsonParams.AddPair('required', RequiredArray);
    JsonFunction.AddPair('parameters', JsonParams);

    // Return Type
    if Assigned(Method.ReturnType) then
      JsonFunction.AddPair('return_type', GetJsonType(Method.ReturnType))
    else
      JsonFunction.AddPair('return_type', 'void');

    JsonRoot.AddPair('function', JsonFunction);

    Result := JsonRoot.Format();
    JsonRoot.Free();

  finally
    Context.Free;
  end;
end;

class function phUtils.CallStaticMethod(const AClass: TClass; const AMethodName: string; const AArgs: array of TValue): TValue;
var
  Context: TRttiContext;
  RttiType: TRttiType;
  Method: TRttiMethod;
begin
  Context := TRttiContext.Create;
  try
    RttiType := Context.GetType(AClass.ClassInfo);
    if not Assigned(RttiType) then
      raise Exception.Create('Class RTTI not found.');

    Method := RttiType.GetMethod(AMethodName);
    if not Assigned(Method) then
      raise Exception.CreateFmt('Method "%s" not found.', [AMethodName]);

    // Ensure the method is a class method (STATIC method)
    if not (Method.MethodKind in [mkClassFunction, mkClassProcedure]) then
      raise Exception.CreateFmt('Method "%s" is not a static class method.', [AMethodName]);

    // Invoke the method dynamically
    Result := Method.Invoke(nil, AArgs);
  finally
    Context.Free;
  end;
end;

class function phUtils.GetJsonSchemas(AClass: TClass): string;
var
  JsonRoot, JsonTool: TJSONObject;
  JsonToolsArray: TJSONArray;
  Context: TRttiContext;
  RttiType: TRttiType;
  Method: TRttiMethod;
begin
  Result := '';
  JsonRoot := TJSONObject.Create;
  JsonToolsArray := TJSONArray.Create;
  Context := TRttiContext.Create;
  try
    RttiType := Context.GetType(AClass.ClassInfo);
    if not Assigned(RttiType) then Exit;

    // Loop through all published methods
    for Method in RttiType.GetMethods do
    begin
      // Ensure the method is published and static
      if (Method.Visibility = mvPublished) and
         (Method.MethodKind in [mkClassFunction, mkClassProcedure]) then
      begin
        // Get the JSON schema for the method
        JsonTool := TJSONObject.ParseJSONValue(GetJsonSchema(AClass, Method.Name)) as TJSONObject;
        if Assigned(JsonTool) then
          JsonToolsArray.AddElement(JsonTool);
      end;
    end;

    // Add tools array to the root JSON object
    JsonRoot.AddPair('tools', JsonToolsArray);
    Result := JsonRoot.Format();
    JsonRoot.Free();
  finally
    Context.Free;
  end;
end;

class function phUtils.GetISO8601DateTime(): string;
begin
  Result := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss"Z"', Now);
end;

class function phUtils.GetISO8601DateTimeLocal(): string;
var
  TZI: TTimeZoneInformation;
  Bias, HoursOffset, MinsOffset: Integer;
  TimeZoneStr: string;
begin
  case GetTimeZoneInformation(TZI) of
    TIME_ZONE_ID_STANDARD, TIME_ZONE_ID_DAYLIGHT:
      Bias := TZI.Bias + TZI.DaylightBias; // Adjust for daylight saving time
    else
      Bias := 0; // Default to UTC if timezone is unknown
  end;

  HoursOffset := Abs(Bias) div 60;
  MinsOffset := Abs(Bias) mod 60;

  if Bias = 0 then
    TimeZoneStr := 'Z'
  else
    TimeZoneStr := Format('%s%.2d:%.2d', [IfThen(Bias > 0, '-', '+'), HoursOffset, MinsOffset]);

  Result := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', Now) + TimeZoneStr;
end;

class function phUtils.GetLocalDateTime(): string;
begin
 Result := FormatDateTime('dddd, dd mmmm yyyy hh:nn:ss AM/PM', Now);
end;

class function phUtils.HasEnoughDiskSpace(const AFilePath: string; ARequiredSize: Int64): Boolean;
var
  LFreeAvailable, LTotalSpace, LTotalFree: Int64;
  LDrive: string;
begin
  Result := False;

  // Resolve the absolute path in case of a relative path
  LDrive := ExtractFileDrive(TPath.GetFullPath(AFilePath));

  // If there is no drive letter, use the current drive
  if LDrive = '' then
    LDrive := ExtractFileDrive(TDirectory.GetCurrentDirectory);

  // Ensure drive has a trailing backslash
  if LDrive <> '' then
    LDrive := LDrive + '\';

  if GetDiskFreeSpaceEx(PChar(LDrive), LFreeAvailable, LTotalSpace, @LTotalFree) then
    Result := LFreeAvailable >= ARequiredSize;
end;

class procedure phUtils.StringToStream(const AString: string; const AStream: TStream);
var
  n: LongInt;
begin
  n := ByteLength(AString);
  AStream.Write(n, SizeOf(n));
  if n > 0 then AStream.Write(AString[1], n);
end;

class function phUtils.StringFromStream(const AStream: TStream): string;
var
  n: LongInt;
begin
  AStream.Read(n, SizeOf(n));
  SetLength(Result, n div SizeOf(Char));
  if n > 0 then AStream.Read(Result[1], n);
end;

class function phUtils.AddPathToSystemPath(const APath: string): Boolean;
var
  LCurrentPath: string;
begin
  Result := False;
  if not TDirectory.Exists(APath) then Exit;

  SetLength(LCurrentPath, GetEnvironmentVariable('PATH', nil, 0) - 1);
  GetEnvironmentVariable('PATH', PChar(LCurrentPath), Length(LCurrentPath) + 1);

  if not LCurrentPath.Contains(APath) then
  begin
    LCurrentPath := APath + ';' + LCurrentPath;
    if SetEnvironmentVariable('PATH', PChar(LCurrentPath)) then
    begin
      SendMessage(HWND_BROADCAST, WM_SETTINGCHANGE, 0, LPARAM(PChar('Environment')));
      Result := True;
    end;
  end;
end;

class function phUtils.RemovePathFromSystemPath(const APath: string): Boolean;
var
  LCurrentPath: string;
  LNewPath: string;
begin
  Result := False;

  if not TDirectory.Exists(APath) then Exit;

  SetLength(LCurrentPath, GetEnvironmentVariable('PATH', nil, 0) - 1);
  GetEnvironmentVariable('PATH', PChar(LCurrentPath), Length(LCurrentPath) + 1);

  LNewPath := LCurrentPath.Replace(';' + APath, '', [rfReplaceAll, rfIgnoreCase]);
  LNewPath := LNewPath.Replace(APath + ';', '', [rfReplaceAll, rfIgnoreCase]);
  LNewPath := LNewPath.Replace(APath, '', [rfReplaceAll, rfIgnoreCase]);

  if LNewPath <> LCurrentPath then
  begin
    if SetEnvironmentVariable('PATH', PChar(LNewPath)) then
    begin
      SendMessage(HWND_BROADCAST, WM_SETTINGCHANGE, 0, LPARAM(PChar('Environment')));
      Result := True;
    end;
  end;
end;

class function  phUtils.GetEXEPath(): string;
begin
  Result := TPath.GetDirectoryName(ParamStr(0));
end;

class function  phUtils.RemoveQuotes(const AText: string): string;
var
  S: string;
begin
  S := AnsiDequotedStr(aText, '"');
  Result := AnsiDequotedStr(S, '''');
end;

class function phUtils.FormatNumberWithCommas(const AValue: Int64): string;
begin
  Result := FormatFloat('#,##0', AValue);
end;

class function phUtils.GetRandomThinkingResult(): string;
const
  CMessages: array[0..9] of string = (
    'Here’s what I came up with:',
    'This is what I found:',
    'Here’s my answer:',
    'Done! Here’s the result:',
    'Here’s my response:',
    'I’ve worked it out:',
    'Processing complete. Here’s my output:',
    'Here’s what I think:',
    'After thinking it through, here’s my take:',
    'Solution ready! Check this out:'
  );
begin
  Result := CMessages[Random(Length(CMessages))];
end;

class function phUtils.TavilyWebSearch(const AAPIKey, AQuery: string): string;
var
  HttpClient: THTTPClient;
  Response: IHTTPResponse;
  JsonRequest, JsonResponse: TJSONObject;
  StringContent: TStringStream;
  Url: string;
begin
  Result := '';
  if AAPIKey.IsEmpty then Exit;

  HttpClient := THTTPClient.Create;
  try
    // Set the API URL
    Url := 'https://api.tavily.com/search';

    // Create JSON request body
    JsonRequest := TJSONObject.Create;
    try
      JsonRequest.AddPair('api_key', AAPIKey);
      JsonRequest.AddPair('query', AQuery);
      JsonRequest.AddPair('include_answer', 'advanced'); // Include 'include_answer' parameter
      JsonRequest.AddPair('include_answer', TJSONBool.Create(True));
      JsonRequest.AddPair('include_images', TJSONBool.Create(False));
      JsonRequest.AddPair('include_image_descriptions', TJSONBool.Create(False));
      JsonRequest.AddPair('include_raw_content', TJSONBool.Create(False));
      JsonRequest.AddPair('max_results', TJSONNumber.Create(1));
      JsonRequest.AddPair('include_domains', TJSONArray.Create); // Empty array
      JsonRequest.AddPair('exclude_domains', TJSONArray.Create); // Empty array

      // Convert JSON to string stream
      StringContent := TStringStream.Create(JsonRequest.ToString, TEncoding.UTF8);
      try
        // Set content type to application/json
        HttpClient.ContentType := 'application/json';

        // Perform the POST request
        Response := HttpClient.Post(Url, StringContent);

        // Check if the response is successful
        if Response.StatusCode = 200 then
        begin
          // Parse the JSON response
          JsonResponse := TJSONObject.ParseJSONValue(Response.ContentAsString(TEncoding.UTF8)) as TJSONObject;
          try
            // Extract the 'answer' field from the response
            if JsonResponse.TryGetValue('answer', Result) then
            begin
              // 'Result' now contains the answer from the API
            end
            else
            begin
              raise Exception.Create('The "answer" field is missing in the API response.');
            end;
          finally
            JsonResponse.Free;
          end;
        end
        else
        begin
          raise Exception.CreateFmt('Error: %d - %s', [Response.StatusCode, Response.StatusText]);
        end;
      finally
        StringContent.Free;
      end;
    finally
      JsonRequest.Free;
    end;
  finally
    HttpClient.Free;
  end;
end;

{ phConsole }
class constructor phConsole.Create();
begin
  FTeletypeDelay := 0;

  // save current console codepage
  FInputCodePage := GetConsoleCP();
  FOutputCodePage := GetConsoleOutputCP();

  // set code page to UTF8
  SetConsoleCP(CP_UTF8);
  SetConsoleOutputCP(CP_UTF8);

  phUtils.EnableVirtualTerminalProcessing();
end;

class destructor phConsole.Destroy();
begin
  // restore code page
  SetConsoleCP(FInputCodePage);
  SetConsoleOutputCP(FOutputCodePage);
end;

class procedure phConsole.UnitInit();
begin
end;

class procedure phConsole.Print(const AMsg: string);
begin
  if not HasOutput() then Exit;
  Write(AMsg+phCSIResetFormat);
end;

class procedure phConsole.PrintLn(const AMsg: string);
begin
  if not HasOutput() then Exit;
  WriteLn(AMsg+phCSIResetFormat);
end;

class procedure phConsole.Print(const AMsg: string; const AArgs: array of const);
begin
  if not HasOutput() then Exit;
  Write(Format(AMsg, AArgs)+phCSIResetFormat);
end;

class procedure phConsole.PrintLn(const AMsg: string; const AArgs: array of const);
begin
  if not HasOutput() then Exit;
  WriteLn(Format(AMsg, AArgs)+phCSIResetFormat);
end;

class procedure phConsole.Print();
begin
  if not HasOutput() then Exit;
  Write(phCSIResetFormat);
end;

class procedure phConsole.PrintLn();
begin
  if not HasOutput() then Exit;
  WriteLn(phCSIResetFormat);
end;

class procedure phConsole.GetCursorPos(X, Y: PInteger);
var
  hConsole: THandle;
  BufferInfo: TConsoleScreenBufferInfo;
begin
  hConsole := GetStdHandle(STD_OUTPUT_HANDLE);
  if hConsole = INVALID_HANDLE_VALUE then
    Exit;

  if not GetConsoleScreenBufferInfo(hConsole, BufferInfo) then
    Exit;

  if Assigned(X) then
    X^ := BufferInfo.dwCursorPosition.X;
  if Assigned(Y) then
    Y^ := BufferInfo.dwCursorPosition.Y;
end;

class procedure phConsole.SetCursorPos(const X, Y: Integer);
begin
  if not HasOutput() then Exit;
  Write(Format(phCSICursorPos, [X, Y]));
end;

class procedure phConsole.SetCursorVisible(const AVisible: Boolean);
var
  ConsoleInfo: TConsoleCursorInfo;
  ConsoleHandle: THandle;
begin
  ConsoleHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  ConsoleInfo.dwSize := 25; // You can adjust cursor size if needed
  ConsoleInfo.bVisible := AVisible;
  SetConsoleCursorInfo(ConsoleHandle, ConsoleInfo);
end;

class procedure phConsole.HideCursor();
begin
  if not HasOutput() then Exit;
  Write(phCSIHideCursor);
end;

class procedure phConsole.ShowCursor();
begin
  if not HasOutput() then Exit;
  Write(phCSIShowCursor);
end;

class procedure phConsole.SaveCursorPos();
begin
  if not HasOutput() then Exit;
  Write(phCSISaveCursorPos);
end;

class procedure phConsole.RestoreCursorPos();
begin
  if not HasOutput() then Exit;
  Write(phCSIRestoreCursorPos);
end;

class procedure phConsole.MoveCursorUp(const ALines: Integer);
begin
  if not HasOutput() then Exit;
  Write(Format(phCSICursorUp, [ALines]));
end;

class procedure phConsole.MoveCursorDown(const ALines: Integer);
begin
  if not HasOutput() then Exit;
  Write(Format(phCSICursorDown, [ALines]));
end;

class procedure phConsole.MoveCursorForward(const ACols: Integer);
begin
  if not HasOutput() then Exit;
  Write(Format(phCSICursorForward, [ACols]));
end;

class procedure phConsole.MoveCursorBack(const ACols: Integer);
begin
  if not HasOutput() then Exit;
  Write(Format(phCSICursorBack, [ACols]));
end;

class procedure phConsole.ClearScreen();
begin
  if not HasOutput() then Exit;
  Write(phCSIClearScreen);
  SetCursorPos(0, 0);
end;

class procedure phConsole.ClearLine();
begin
  if not HasOutput() then Exit;
  Write(phCR);
  Write(phCSIClearLine);
end;

class procedure phConsole.ClearLineFromCursor(const AColor: string);
var
  LConsoleOutput: THandle;
  LConsoleInfo: TConsoleScreenBufferInfo;
  LNumCharsWritten: DWORD;
  LCoord: TCoord;
begin
  LConsoleOutput := GetStdHandle(STD_OUTPUT_HANDLE);

  if GetConsoleScreenBufferInfo(LConsoleOutput, LConsoleInfo) then
  begin
    LCoord.X := 0;
    LCoord.Y := LConsoleInfo.dwCursorPosition.Y;

    Print(AColor, []);
    FillConsoleOutputCharacter(LConsoleOutput, ' ', LConsoleInfo.dwSize.X
      - LConsoleInfo.dwCursorPosition.X, LCoord, LNumCharsWritten);
    SetConsoleCursorPosition(LConsoleOutput, LCoord);
  end;
end;

class procedure phConsole.SetBoldText();
begin
  if not HasOutput() then Exit;
  Write(phCSIBold);
end;

class procedure phConsole.ResetTextFormat();
begin
  if not HasOutput() then Exit;
  Write(phCSIResetFormat);
end;

class procedure phConsole.SetForegroundColor(const AColor: string);
begin
  if not HasOutput() then Exit;
  Write(AColor);
end;

class procedure phConsole.SetBackgroundColor(const AColor: string);
begin
  if not HasOutput() then Exit;
  Write(AColor);
end;

class procedure phConsole.SetForegroundRGB(const ARed, AGreen, ABlue: Byte);
begin
  if not HasOutput() then Exit;
  Write(Format(phCSIFGRGB, [ARed, AGreen, ABlue]));
end;

class procedure phConsole.SetBackgroundRGB(const ARed, AGreen, ABlue: Byte);
begin
  if not HasOutput() then Exit;
  Write(Format(phCSIBGRGB, [ARed, AGreen, ABlue]));
end;

class procedure phConsole.GetSize(AWidth: PInteger; AHeight: PInteger);
var
  LConsoleInfo: TConsoleScreenBufferInfo;
begin
  if not HasOutput() then Exit;

  GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), LConsoleInfo);
  if Assigned(AWidth) then
    AWidth^ := LConsoleInfo.dwSize.X;

  if Assigned(AHeight) then
  AHeight^ := LConsoleInfo.dwSize.Y;
end;

class procedure phConsole.SetTitle(const ATitle: string);
begin
  WinApi.Windows.SetConsoleTitle(PChar(ATitle));
end;

class function  phConsole.GetTitle(): string;
const
  MAX_TITLE_LENGTH = 1024;
var
  LTitle: array[0..MAX_TITLE_LENGTH] of WideChar;
  LTitleLength: DWORD;
begin
  // Get the console title and store it in LTitle
  LTitleLength := GetConsoleTitleW(LTitle, MAX_TITLE_LENGTH);

  // If the title is retrieved, assign it to the result
  if LTitleLength > 0 then
    Result := string(LTitle)
  else
    Result := '';
end;

class function  phConsole.HasOutput(): Boolean;
var
  LStdHandle: THandle;
begin
  LStdHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  Result := (LStdHandle <> INVALID_HANDLE_VALUE) and
            (GetFileType(LStdHandle) = FILE_TYPE_CHAR);
end;

class function  phConsole.WasRunFrom(): Boolean;
var
  LStartupInfo: TStartupInfo;
begin
  LStartupInfo.cb := SizeOf(TStartupInfo);
  GetStartupInfo(LStartupInfo);
  Result := ((LStartupInfo.dwFlags and STARTF_USESHOWWINDOW) = 0);
end;

class procedure phConsole.WaitForAnyKey();
var
  LInputRec: TInputRecord;
  LNumRead: Cardinal;
  LOldMode: DWORD;
  LStdIn: THandle;
begin
  LStdIn := GetStdHandle(STD_INPUT_HANDLE);
  GetConsoleMode(LStdIn, LOldMode);
  SetConsoleMode(LStdIn, 0);
  repeat
    ReadConsoleInput(LStdIn, LInputRec, 1, LNumRead);
  until (LInputRec.EventType and KEY_EVENT <> 0) and
    LInputRec.Event.KeyEvent.bKeyDown;
  SetConsoleMode(LStdIn, LOldMode);
end;

class function  phConsole.AnyKeyPressed(): Boolean;
var
  LNumberOfEvents     : DWORD;
  LBuffer             : TInputRecord;
  LNumberOfEventsRead : DWORD;
  LStdHandle           : THandle;
begin
  Result:=false;
  //get the console handle
  LStdHandle := GetStdHandle(STD_INPUT_HANDLE);
  LNumberOfEvents:=0;
  //get the number of events
  GetNumberOfConsoleInputEvents(LStdHandle,LNumberOfEvents);
  if LNumberOfEvents<> 0 then
  begin
    //retrieve the event
    PeekConsoleInput(LStdHandle,LBuffer,1,LNumberOfEventsRead);
    if LNumberOfEventsRead <> 0 then
    begin
      if LBuffer.EventType = KEY_EVENT then //is a Keyboard event?
      begin
        if LBuffer.Event.KeyEvent.bKeyDown then //the key was pressed?
          Result:=true
        else
          FlushConsoleInputBuffer(LStdHandle); //flush the buffer
      end
      else
      FlushConsoleInputBuffer(LStdHandle);//flush the buffer
    end;
  end;
end;

class procedure phConsole.ClearKeyStates();
begin
  FillChar(FKeyState, SizeOf(FKeyState), 0);
  ClearKeyboardBuffer();
end;

class procedure phConsole.ClearKeyboardBuffer();
var
  LInputRecord: TInputRecord;
  LEventsRead: DWORD;
  LMsg: TMsg;
begin
  while PeekConsoleInput(GetStdHandle(STD_INPUT_HANDLE), LInputRecord, 1, LEventsRead) and (LEventsRead > 0) do
  begin
    ReadConsoleInput(GetStdHandle(STD_INPUT_HANDLE), LInputRecord, 1, LEventsRead);
  end;

  while PeekMessage(LMsg, 0, WM_KEYFIRST, WM_KEYLAST, PM_REMOVE) do
  begin
    // No operation; just removing messages from the queue
  end;
end;

class function  phConsole.IsKeyPressed(AKey: Byte): Boolean;
begin
  Result := (GetAsyncKeyState(AKey) and $8000) <> 0;
end;

class function  phConsole.WasKeyReleased(AKey: Byte): Boolean;
begin
  Result := False;
  if IsKeyPressed(AKey) and (not FKeyState[1, AKey]) then
  begin
    FKeyState[1, AKey] := True;
    Result := True;
  end
  else if (not IsKeyPressed(AKey)) and (FKeyState[1, AKey]) then
  begin
    FKeyState[1, AKey] := False;
    Result := False;
  end;
end;

class function  phConsole.WasKeyPressed(AKey: Byte): Boolean;
begin
  Result := False;
  if IsKeyPressed(AKey) and (not FKeyState[1, AKey]) then
  begin
    FKeyState[1, AKey] := True;
    Result := False;
  end
  else if (not IsKeyPressed(AKey)) and (FKeyState[1, AKey]) then
  begin
    FKeyState[1, AKey] := False;
    Result := True;
  end;
end;

class function  phConsole.ReadKey(): WideChar;
var
  LInputRecord: TInputRecord;
  LEventsRead: DWORD;
begin
  repeat
    ReadConsoleInput(GetStdHandle(STD_INPUT_HANDLE), LInputRecord, 1, LEventsRead);
  until (LInputRecord.EventType = KEY_EVENT) and LInputRecord.Event.KeyEvent.bKeyDown;
  Result := LInputRecord.Event.KeyEvent.UnicodeChar;
end;

class function  phConsole.ReadLnX(const AAllowedChars: phCharSet; AMaxLength: Integer; const AColor: string): string;
var
  LInputChar: Char;
begin
  Result := '';

  repeat
    LInputChar := ReadKey;

    if CharInSet(LInputChar, AAllowedChars) then
    begin
      if Length(Result) < AMaxLength then
      begin
        if not CharInSet(LInputChar, [#10, #0, #13, #8])  then
        begin
          //Print(LInputChar, AColor);
          Print('%s%s', [AColor, LInputChar]);
          Result := Result + LInputChar;
        end;
      end;
    end;
    if LInputChar = #8 then
    begin
      if Length(Result) > 0 then
      begin
        //Print(#8 + ' ' + #8);
        Print(#8 + ' ' + #8, []);
        Delete(Result, Length(Result), 1);
      end;
    end;
  until (LInputChar = #13);

  PrintLn();
end;

class procedure phConsole.Pause(const AForcePause: Boolean; AColor: string; const AMsg: string);
var
  LDoPause: Boolean;
begin
  if not HasOutput then Exit;

  ClearKeyboardBuffer();

  if not AForcePause then
  begin
    LDoPause := True;
    if WasRunFrom() then LDoPause := False;
    if phUtils.IsStartedFromDelphiIDE() then LDoPause := True;
    if not LDoPause then Exit;
  end;

  WriteLn;
  if AMsg = '' then
    Print('%sPress any key to continue... ', [aColor])
  else
    Print('%s%s', [aColor, AMsg]);

  WaitForAnyKey();
  WriteLn;
end;

class function  phConsole.WrapTextEx(const ALine: string; AMaxCol: Integer; const ABreakChars: phCharSet): string;
var
  LText: string;
  LPos: integer;
  LChar: Char;
  LLen: Integer;
  I: Integer;
begin
  LText := ALine.Trim;

  LPos := 0;
  LLen := 0;

  while LPos < LText.Length do
  begin
    Inc(LPos);

    LChar := LText[LPos];

    if LChar = #10 then
    begin
      LLen := 0;
      continue;
    end;

    Inc(LLen);

    if LLen >= AMaxCol then
    begin
      for I := LPos downto 1 do
      begin
        LChar := LText[I];

        if CharInSet(LChar, ABreakChars) then
        begin
          LText.Insert(I, #10);
          Break;
        end;
      end;

      LLen := 0;
    end;
  end;

  Result := LText;
end;

class procedure phConsole.Teletype(const AText: string; const AColor: string; const AMargin: Integer; const AMinDelay: Integer; const AMaxDelay: Integer; const ABreakKey: Byte);
var
  LText: string;
  LMaxCol: Integer;
  LChar: Char;
  LWidth: Integer;
begin
  GetSize(@LWidth, nil);
  LMaxCol := LWidth - AMargin;

  LText := WrapTextEx(AText, LMaxCol);

  for LChar in LText do
  begin
    phUtils.ProcessMessages();
    Print('%s%s', [AColor, LChar]);
    if not phUtils.RandomBool() then
      FTeletypeDelay := phUtils.RandomRange(AMinDelay, AMaxDelay);
    phUtils.Wait(FTeletypeDelay);
    if IsKeyPressed(ABreakKey) then
    begin
      ClearKeyboardBuffer;
      Break;
    end;
  end;
end;

{ TphObject }
constructor TphObject.Create();
begin
  inherited;
end;

destructor TphObject.Destroy();
begin
  inherited;
end;

procedure TphObject.SetError(const AText: string; const AArgs: array of const);
begin
  FError := Format(AText, AArgs);
end;

function  TphObject.GetError(): string;
begin
  Result := FError;
end;

initialization
begin
  ReportMemoryLeaksOnShutdown := True;
  SetExceptionMask(GetExceptionMask + [exOverflow, exInvalidOp]);
  SetConsoleCP(CP_UTF8);
  SetConsoleOutputCP(CP_UTF8);
  phUtils.EnableVirtualTerminalProcessing();
  Randomize();
end;

finalization
begin
end;

end.
