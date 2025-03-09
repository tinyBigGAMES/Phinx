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

{
  ===== USAGE NOTES =====

  GPU Requirements:
   - A CUDA-compatible NVIDIA GPU with 8–12GB of VRAM is required for
     inference.

  Storage Requirements:
   - Ensure at least 7GB of free disk space for the model.

  Download Model:
  - https://huggingface.co/tinybiggames/Phinx/resolve/main/Phinx.model?download=true

  Setup Instructions:
  - Place the downloaded model in your preferred directory. The examples
    assume:
    - Path: C:/LLM/PHINX/repo

  Additional Information:
  - Developed with: Delphi 12.2
  - Tested on: Windows 11 (24H2)
}
unit UTestbed;

interface

uses
  System.SysUtils,
  Phinx.Utils,
  Phinx.Core;

procedure RunTests();

implementation

const
  // Maximum context size for inference
  CMaxContext = 1024*8;

  // Determines whether the model should stream responses
  CStream = True;

{ -----------------------------------------------------------------------------
 Test01: Model Building
 This procedure builds a machine learning model using the TPhinx library.
 It specifies the model folder and filename, then calls the BuildModel
 function. Progress updates are displayed in the console, and the result is
 printed in color.
 NOTE: This example will not run on your device. It is used to build the
       Phinx.model file thats used by this library. The code is here just to
       show how easy it is working with the Phinx library.
------------------------------------------------------------------------------ }
procedure Test00();
const
  // Define the folder path where the model will be built
  CModelFolder = 'C:/LLM/PHINX/build';

  // Define the filename for the model to be created
  CModelFilename = 'C:/LLM/PHINX/repo/Phinx.model';
begin
  // Print a message indicating the start of model building
  phConsole.PrintLn('Building model %s"...', [CModelFilename]);

  // Call the BuildModel function to construct the model
  if TPhinx.BuildModel(CModelFolder, CModelFilename,
    procedure(const AFilename: string; const APercentage: Integer; const ANewFile: Boolean)
    begin
      // If a new file is being created, print a new line
      if ANewFile then phConsole.PrintLn();

      // Print the progress of the model building with a green foreground color
      phConsole.Print(phCSIFGGreen+#13'%s(%d%s)...', [string(AFilename), APercentage, '%']);
    end
  ) then
      // If model building succeeds, print a success message in cyan color
      phConsole.PrintLn(phCSIFGCyan+phCRLF+'Success!')
  else
      // If model building fails, print a failure message in red color
      phConsole.PrintLn(phCSIFGRed+phCRLF+'Failed!');
end;

{ -----------------------------------------------------------------------------
 Test01: Basic Inference
 This procedure initializes the Phinx AI model for basic natural language
 processing tasks. It loads a trained model, processes a simple user query,
 generates a response, and retrieves performance metrics including token count,
 processing speed, and execution time.
------------------------------------------------------------------------------ }
procedure Test01();
var
  LPhinx: TPhinx; // Instance of TPhinx for model inference
  LInputTokens: UInt32; // Stores the number of input tokens processed
  LOutputTokens: UInt32; // Stores the number of output tokens generated
  LSpeed: Double; // Stores the inference speed in tokens per second
  LTime: Double; // Stores the total inference time in seconds
begin
  // Set the console title
  phConsole.SetTitle('Phinx: Basic Inference');

  // Display an instruction message
  phConsole.PrintLn(phCSIFGBrightYellow+'Press ESC to cancel inference.'+phCRLF);

  // Create an instance of TPhinx for model inference
  LPhinx := TPhinx.Create();
  try
    // Set the maximum inference context length
    LPhinx.MaxLength := CMaxContext;

    // Set up a status event handler to display status messages
    LPhinx.StatusEvent :=
      procedure(const AID, AStatus: string)
      begin
        // Handle inference start and end status messages
        if (AID = 'TPhinx.RunInference') and (AStatus = 'InferenceStart') then
          phConsole.ClearLine()
        else
        if (AID = 'TPhinx.RunInference') and (AStatus = 'InferenceEnd') then
          phConsole.PrintLn()
        else
        if (AID = 'TPhinx.RunInference') and (AStatus = CphStatusEnd) then
            phConsole.ClearLine()
        else
        begin
          phConsole.ClearLine();
          phConsole.Print(phCR+phCSIFGYellow+AStatus);
        end;
      end;

    // Event triggered at the start of inference
    LPhinx.InferenceStartEvent :=
      procedure()
      begin
        phConsole.PrintLn('Question:');
        phConsole.PrintLn(phCSIFGCyan+phConsole.WrapTextEx(LPhinx.GetLastUserMessage(), 120-10));
        phConsole.PrintLn();
        phConsole.PrintLn('Response:');
      end;

    // Event triggered when the model generates a new token
    LPhinx.NextTokenEvent :=
      procedure(const AToken: string)
      begin
        phConsole.Print(phCSIFGGreen+AToken);
      end;

    // Load the model; exit if loading fails
    if not LPhinx.LoadModel() then Exit;

    // Set a system message to define the AI assistant's persona
    LPhinx.SetSystemMessage('You are a helpful AI assistant.');

    // Add a user query for general knowledge retrieval
    LPhinx.AddUserMessage('Who is Bill Gates? (detailed)', []);

    // Enable or disable streaming of inference responses
    LPhinx.Stream := CStream;

    // Run the model inference
    if LPhinx.RunInference() then
    begin
      // If streaming is disabled, print the full response
      if not LPhinx.Stream then
      begin
        phConsole.PrintLn(LPhinx.GetInferenceResponse());
      end;

      // Retrieve performance metrics for the inference
      LPhinx.GetPerformance(@LInputTokens, @LOutputTokens, @LSpeed, @LTime);

      // Display inference performance metrics in the console
      phConsole.PrintLn(phCRLF+'Performance:');
      phConsole.PrintLn(phCSIFGBrightYellow+'Input Tokens : %d', [LInputTokens]); // Input tokens count
      phConsole.PrintLn(phCSIFGBrightYellow+'Output Tokens: %d', [LOutputTokens]); // Output tokens count
      phConsole.PrintLn(phCSIFGBrightYellow+'Speed        : %.2f tokens/sec', [LSpeed]); // Processing speed
      phConsole.PrintLn(phCSIFGBrightYellow+'Time         : %.2f seconds', [LTime]); // Execution time
    end
    else
    begin
      // If inference fails, display an error message in red
      phConsole.PrintLn(phCSIFGRed+'Error: %s', [LPhinx.GetError()]);
    end;

    // Unload the model after inference to free resources
    LPhinx.UnloadModel();
  finally
    // Free the TPhinx instance to prevent memory leaks
    LPhinx.Free();
  end;
end;


{ -----------------------------------------------------------------------------
 Test02: Reasoning Inference
 This procedure initializes the Phinx AI model for logical reasoning tasks.
 It loads a trained model, processes a financial reasoning query, generates a
 response, and retrieves performance metrics including token count, processing
 speed, and execution time.
------------------------------------------------------------------------------ }
procedure Test02();
var
  LPhinx: TPhinx; // Instance of TPhinx for model inference
  LInputTokens: UInt32; // Stores the number of input tokens processed
  LOutputTokens: UInt32; // Stores the number of output tokens generated
  LSpeed: Double; // Stores the inference speed in tokens per second
  LTime: Double; // Stores the total inference time in seconds
begin
  // Set the console title
  phConsole.SetTitle('Phinx: Reasoning');

  // Display an instruction message
  phConsole.PrintLn(phCSIFGBrightYellow+'Press ESC to cancel inference.'+phCRLF);

  // Create an instance of TPhinx for model inference
  LPhinx := TPhinx.Create();
  try
    // Set the maximum inference context length
    LPhinx.MaxLength := CMaxContext;

    // Set up a status event handler to display status messages
    LPhinx.StatusEvent :=
      procedure(const AID, AStatus: string)
      begin
        // Handle inference start and end status messages
        if (AID = 'TPhinx.RunInference') and (AStatus = 'InferenceStart') then
          phConsole.ClearLine()
        else
        if (AID = 'TPhinx.RunInference') and (AStatus = 'InferenceEnd') then
          phConsole.PrintLn()
        else
        if (AID = 'TPhinx.RunInference') and (AStatus = CphStatusEnd) then
            phConsole.ClearLine()
        else
        begin
          phConsole.ClearLine();
          phConsole.Print(phCR+phCSIFGYellow+AStatus);
        end;
      end;

    // Event triggered at the start of inference
    LPhinx.InferenceStartEvent :=
      procedure()
      begin
        phConsole.PrintLn('Question:');
        phConsole.PrintLn(phCSIFGCyan+phConsole.WrapTextEx(LPhinx.GetLastUserMessage(), 120-10));
        phConsole.PrintLn();
        phConsole.PrintLn('Response:');
      end;

    // Event triggered when the model generates a new token
    LPhinx.NextTokenEvent :=
      procedure(const AToken: string)
      begin
        phConsole.Print(phCSIFGGreen+AToken);
      end;

    // Load the model; exit if loading fails
    if not LPhinx.LoadModel() then Exit;

    // Set a system message to define the AI assistant's persona
    LPhinx.SetSystemMessage('You are a helpful AI assistant.');

    // Add a user query involving financial reasoning
    LPhinx.AddUserMessage('I have $20,000 in my savings account, where I receive a 4% profit per year and payments twice a year. Can you please tell me how long it will take for me to become a millionaire? Think step by step carefully.', []);

    // Enable or disable streaming of inference responses
    LPhinx.Stream := CStream;

    // Run the model inference
    if LPhinx.RunInference() then
    begin
      // If streaming is disabled, print the full response
      if not LPhinx.Stream then
      begin
        phConsole.PrintLn(LPhinx.GetInferenceResponse());
      end;

      // Retrieve performance metrics for the inference
      LPhinx.GetPerformance(@LInputTokens, @LOutputTokens, @LSpeed, @LTime);

      // Display inference performance metrics in the console
      phConsole.PrintLn(phCRLF+'Performance:');
      phConsole.PrintLn(phCSIFGBrightYellow+'Input Tokens : %d', [LInputTokens]); // Input tokens count
      phConsole.PrintLn(phCSIFGBrightYellow+'Output Tokens: %d', [LOutputTokens]); // Output tokens count
      phConsole.PrintLn(phCSIFGBrightYellow+'Speed        : %.2f tokens/sec', [LSpeed]); // Processing speed
      phConsole.PrintLn(phCSIFGBrightYellow+'Time         : %.2f seconds', [LTime]); // Execution time
    end
    else
    begin
      // If inference fails, display an error message in red
      phConsole.PrintLn(phCSIFGRed+'Error: %s', [LPhinx.GetError()]);
    end;

    // Unload the model after inference to free resources
    LPhinx.UnloadModel();
  finally
    // Free the TPhinx instance to prevent memory leaks
    LPhinx.Free();
  end;
end;


{ -----------------------------------------------------------------------------
 Test03: Vision Inference
 This procedure initializes the Phinx AI model for image analysis.
 It loads a trained model, processes an image input, generates a textual
 description, and retrieves performance metrics including token count,
 processing speed, and execution time.
------------------------------------------------------------------------------ }
procedure Test03();
var
  LPhinx: TPhinx; // Instance of TPhinx for model inference
  LInputTokens: UInt32; // Stores the number of input tokens processed
  LOutputTokens: UInt32; // Stores the number of output tokens generated
  LSpeed: Double; // Stores the inference speed in tokens per second
  LTime: Double; // Stores the total inference time in seconds
begin
  // Set the console title
  phConsole.SetTitle('Phinx: Vision');

  // Display an instruction message
  phConsole.PrintLn(phCSIFGBrightYellow+'Press ESC to cancel inference.'+phCRLF);

  // Create an instance of TPhinx for model inference
  LPhinx := TPhinx.Create();
  try
    // Set the maximum inference context length
    LPhinx.MaxLength := CMaxContext;

    // Set up a status event handler to display status messages
    LPhinx.StatusEvent :=
      procedure(const AID, AStatus: string)
      begin
        // Handle inference start and end status messages
        if (AID = 'TPhinx.RunInference') and (AStatus = 'InferenceStart') then
          phConsole.ClearLine()
        else
        if (AID = 'TPhinx.RunInference') and (AStatus = 'InferenceEnd') then
          phConsole.PrintLn()
        else
        if (AID = 'TPhinx.RunInference') and (AStatus = CphStatusEnd) then
            phConsole.ClearLine()
        else
        begin
          phConsole.ClearLine();
          phConsole.Print(phCR+phCSIFGYellow+AStatus);
        end;
      end;

    // Event triggered at the start of inference
    LPhinx.InferenceStartEvent :=
      procedure()
      begin
        phConsole.PrintLn('Question:');
        phConsole.PrintLn(phCSIFGCyan+phConsole.WrapTextEx(LPhinx.GetLastUserMessage(), 120-10));
        phConsole.PrintLn();
        phConsole.PrintLn('Response:');
      end;

    // Event triggered when the model generates a new token
    LPhinx.NextTokenEvent :=
      procedure(const AToken: string)
      begin
        phConsole.Print(phCSIFGGreen+AToken);
      end;

    // Load the model; exit if loading fails
    if not LPhinx.LoadModel() then Exit;

    // Provide an image input for model inference
    LPhinx.AddImage('res/images/landscape.jpg');

    // Set a system message to define the AI assistant's persona
    LPhinx.SetSystemMessage('You are a helpful AI assistant.');

    // Add a user query requesting a detailed image description
    LPhinx.AddUserMessage('Describe the image in detail.', [1]);

    // Enable or disable streaming of inference responses
    LPhinx.Stream := CStream;

    // Run the model inference
    if LPhinx.RunInference() then
    begin
      // If streaming is disabled, print the full response
      if not LPhinx.Stream then
      begin
        phConsole.PrintLn(LPhinx.GetInferenceResponse());
      end;

      // Retrieve performance metrics for the inference
      LPhinx.GetPerformance(@LInputTokens, @LOutputTokens, @LSpeed, @LTime);

      // Display inference performance metrics in the console
      phConsole.PrintLn(phCRLF+'Performance:');
      phConsole.PrintLn(phCSIFGBrightYellow+'Input Tokens : %d', [LInputTokens]); // Input tokens count
      phConsole.PrintLn(phCSIFGBrightYellow+'Output Tokens: %d', [LOutputTokens]); // Output tokens count
      phConsole.PrintLn(phCSIFGBrightYellow+'Speed        : %.2f tokens/sec', [LSpeed]); // Processing speed
      phConsole.PrintLn(phCSIFGBrightYellow+'Time         : %.2f seconds', [LTime]); // Execution time
    end
    else
    begin
      // If inference fails, display an error message in red
      phConsole.PrintLn(phCSIFGRed+'Error: %s', [LPhinx.GetError()]);
    end;

    // Unload the model after inference to free resources
    LPhinx.UnloadModel();
  finally
    // Free the TPhinx instance to prevent memory leaks
    LPhinx.Free();
  end;
end;


{ -----------------------------------------------------------------------------
 Test04: Vision & Code Generation Inference
 This procedure initializes the Phinx AI model for vision and code generation
 tasks. It loads a trained model, processes an image input, generates an HTML
 + JS response, and retrieves performance metrics including token count,
 processing speed, and execution time.
------------------------------------------------------------------------------ }
procedure Test04();
var
  LPhinx: TPhinx; // Instance of TPhinx for model inference
  LInputTokens: UInt32; // Stores the number of input tokens processed
  LOutputTokens: UInt32; // Stores the number of output tokens generated
  LSpeed: Double; // Stores the inference speed in tokens per second
  LTime: Double; // Stores the total inference time in seconds
begin
  // Set the console title
  phConsole.SetTitle('Phinx: Vision/CodeGen');

  // Display an instruction message
  phConsole.PrintLn(phCSIFGBrightYellow+'Press ESC to cancel inference.'+phCRLF);

  // Create an instance of TPhinx for model inference
  LPhinx := TPhinx.Create();
  try
    // Set the maximum inference context length
    LPhinx.MaxLength := CMaxContext;

    // Set up a status event handler to display status messages
    LPhinx.StatusEvent :=
      procedure(const AID, AStatus: string)
      begin
        // Handle inference start and end status messages
        if (AID = 'TPhinx.RunInference') and (AStatus = 'InferenceStart') then
          phConsole.ClearLine()
        else
        if (AID = 'TPhinx.RunInference') and (AStatus = 'InferenceEnd') then
          phConsole.PrintLn()
        else
        if (AID = 'TPhinx.RunInference') and (AStatus = CphStatusEnd) then
            phConsole.ClearLine()
        else
        begin
          phConsole.ClearLine();
          phConsole.Print(phCR+phCSIFGYellow+AStatus);
        end;
      end;

    // Event triggered at the start of inference
    LPhinx.InferenceStartEvent :=
      procedure()
      begin
        phConsole.PrintLn('Question:');
        phConsole.PrintLn(phCSIFGCyan+phConsole.WrapTextEx(LPhinx.GetLastUserMessage(), 120-10));
        phConsole.PrintLn();
        phConsole.PrintLn('Response:');
      end;

    // Event triggered when the model generates a new token
    LPhinx.NextTokenEvent :=
      procedure(const AToken: string)
      begin
        phConsole.Print(phCSIFGGreen+AToken);
      end;

    // Load the model; exit if loading fails
    if not LPhinx.LoadModel() then Exit;

    // Provide an image input for model inference
    LPhinx.AddImage('res/images/imgcodegen.png');

    // Set a system message to define the AI assistant's persona
    LPhinx.SetSystemMessage('You are a helpful AI assistant.');

    // Add a user query related to code generation from an image
    LPhinx.AddUserMessage('Can you generate HTML + JS code about this image?', [1]);

    // Enable or disable streaming of inference responses
    LPhinx.Stream := CStream;

    // Run the model inference
    if LPhinx.RunInference() then
    begin
      // If streaming is disabled, print the full response
      if not LPhinx.Stream then
      begin
        phConsole.PrintLn(LPhinx.GetInferenceResponse());
      end;

      // Retrieve performance metrics for the inference
      LPhinx.GetPerformance(@LInputTokens, @LOutputTokens, @LSpeed, @LTime);

      // Display inference performance metrics in the console
      phConsole.PrintLn(phCRLF+'Performance:');
      phConsole.PrintLn(phCSIFGBrightYellow+'Input Tokens : %d', [LInputTokens]); // Input tokens count
      phConsole.PrintLn(phCSIFGBrightYellow+'Output Tokens: %d', [LOutputTokens]); // Output tokens count
      phConsole.PrintLn(phCSIFGBrightYellow+'Speed        : %.2f tokens/sec', [LSpeed]); // Processing speed
      phConsole.PrintLn(phCSIFGBrightYellow+'Time         : %.2f seconds', [LTime]); // Execution time
    end
    else
    begin
      // If inference fails, display an error message in red
      phConsole.PrintLn(phCSIFGRed+'Error: %s', [LPhinx.GetError()]);
    end;

    // Unload the model after inference to free resources
    LPhinx.UnloadModel();
  finally
    // Free the TPhinx instance to prevent memory leaks
    LPhinx.Free();
  end;
end;


{ -----------------------------------------------------------------------------
 RunTests: Execute Phinx Test Cases
 This procedure runs different test cases for the Phinx AI model.
 It selects and executes a test case based on the assigned test number,
 allowing for streamlined evaluation of different AI functionalities.
------------------------------------------------------------------------------ }
procedure RunTests();
var
  LNum: Integer; // Variable to store test case number
begin
  // Display Phinx version information
  phConsole.PrintLn(phCSIFGMagenta+'Phinx v%s'+phCRLF, [CphVersion]);

  // Set the test number to an example to run
  LNum := 01;

  // Execute the corresponding test case based on the test number
  case LNum of
    00: Test00(); // Run Test00 (Model Building)
    01: Test01(); // Run Test01 (Basic Inference)
    02: Test02(); // Run Test02 (Reasoning Inference)
    03: Test03(); // Run Test03 (Vision Inference)
    04: Test04(); // Run Test04 (Vision & Code Generation Inference)
  end;

  // Pause the console to wait for user input before closing
  phConsole.Pause();
end;

end.
