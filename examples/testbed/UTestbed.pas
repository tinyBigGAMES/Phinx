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

   - Get search api key from:
     - https://tavily.com/
     - You get 1000 free tokens per month
     - Create a an environment variable named "TAVILY_API_KEY" and set it to
       the search api key.

   - Get text-to-speech key from:
      - https://www.lemonfox.ai/apis/text-to-speech/
      - 1 month free trial
      - Create a an environment variable named "LEMONFOX_API_KEY" and set it to
        the tts api key.

   - Get jina.ai key from:
      - https://jina.ai/
      - 1M free tokens
      - Create a an environment variable named "JINA_API_KEY" and set it to
        the jina api key.

  Additional Information:
   - Developed with: Delphi 12.2
   - Tested on: Windows 11 (24H2)
}
unit UTestbed;

interface

uses
  WinApi.Windows,
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

  // Pause the console to wait for user input before closing
  phConsole.Pause(True);
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
    LPhinx.AddUserMessage('Who is Bill Gates? (detailed)', [], []);

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
      phConsole.ClearLine();
      phConsole.PrintLn(phCSIFGRed+'Error: %s', [LPhinx.GetError()]);
    end;

    // Unload the model after inference to free resources
    LPhinx.UnloadModel();

    // Pause the console to wait for user input before closing
    phConsole.Pause(True);
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
    LPhinx.AddUserMessage('I have $20,000 in my savings account, where I receive a 4% profit per year and payments twice a year. Can you please tell me how long it will take for me to become a millionaire? Think step by step carefully.', [], []);

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
      phConsole.ClearLine();
      phConsole.PrintLn(phCSIFGRed+'Error: %s', [LPhinx.GetError()]);
    end;

    // Unload the model after inference to free resources
    LPhinx.UnloadModel();

    // Pause the console to wait for user input before closing
    phConsole.Pause();
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
    LPhinx.AddImage('res/images/landscape01.jpg');
    //LPhinx.AddImage('res/images/landscape02.jpg');

    // Set a system message to define the AI assistant's persona
    LPhinx.SetSystemMessage('You are a helpful AI assistant.');

    // Add a user query requesting a detailed image description
    LPhinx.AddUserMessage('Describe the image in detail.', [1], []);

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
      phConsole.ClearLine();
      phConsole.PrintLn(phCSIFGRed+'Error: %s', [LPhinx.GetError()]);
    end;

    // Unload the model after inference to free resources
    LPhinx.UnloadModel();

    // Pause the console to wait for user input before closing
    phConsole.Pause();
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
    LPhinx.AddUserMessage('Can you generate HTML + JS code about this image?', [1], []);

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

    // Pause the console to wait for user input before closing
    phConsole.Pause();
  finally
    // Free the TPhinx instance to prevent memory leaks
    LPhinx.Free();
  end;
end;

{ -----------------------------------------------------------------------------
 Test05: Audio Transcription
 This procedure utilizes the Phinx AI model to transcribe spoken words from an
 audio file. It loads an audio file, performs speech-to-text inference, and
 retrieves performance metrics.
------------------------------------------------------------------------------ }
procedure Test05();
const
  CAudioFilename = 'res/audios/digthis.wav'; // Audio WAV filename
var
  LPhinx: TPhinx; // Instance of TPhinx for model inference
  LInputTokens: UInt32; // Stores the number of input tokens processed
  LOutputTokens: UInt32; // Stores the number of output tokens generated
  LSpeed: Double; // Stores the inference speed in tokens per second
  LTime: Double; // Stores the total inference time in seconds
begin
  // Set the console title
  phConsole.SetTitle('Phinx: Audio Transcribe');

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
        // Play the loaded WAV file
        LPhinx.WavPlayer.Play();

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

    // Add audio file for inference
    LPhinx.AddAudio(CAudioFilename);

    // Open wavplayer, using the console handle
    LPhinx.WavPlayer.Open();

    // Load audio file for playback
    LPhinx.WavPlayer.LoadFromFile(CAudioFilename);

    // Set a system message to define the AI assistant's persona
    LPhinx.SetSystemMessage('You are a helpful AI assistant.');

    // Add a user query requesting audio transcription
    LPhinx.AddUserMessage('Transcribe the audio to text.', [], [1]);

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
      phConsole.ClearLine();
      phConsole.PrintLn(phCSIFGRed+'Error: %s', [LPhinx.GetError()]);
    end;

    // Unload the model after inference to free resources
    LPhinx.UnloadModel();

    // Pause the console to wait for user input before closing
    phConsole.Pause(True);
  finally
    // Free the TPhinx instance to prevent memory leaks
    LPhinx.Free();
  end;
end;


{ -----------------------------------------------------------------------------
 Test06: Audio Transcription and Translation
 This procedure utilizes the Phinx AI model to transcribe spoken words from an
 audio file and translate the text into German. It loads an audio file,
 performs speech-to-text inference, translates the output, and retrieves
 performance metrics.
------------------------------------------------------------------------------ }
procedure Test06();
const
  CAudioFilename = 'res/audios/1272-141231-0002.wav'; // Audio WAV filename
var
  LPhinx: TPhinx; // Instance of TPhinx for model inference
  LInputTokens: UInt32; // Stores the number of input tokens processed
  LOutputTokens: UInt32; // Stores the number of output tokens generated
  LSpeed: Double; // Stores the inference speed in tokens per second
  LTime: Double; // Stores the total inference time in seconds
begin
  // Set the console title
  phConsole.SetTitle('Phinx: Audio Transcribe/lation');

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
        // Play the loaded WAV file
        LPhinx.WavPlayer.Play();

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

    // Add audio file for inference
    LPhinx.AddAudio(CAudioFilename);

    // Open wavplayer, using the console handle
    LPhinx.WavPlayer.Open();

    // Load audio file for playback
    LPhinx.WavPlayer.LoadFromFile(CAudioFilename);

    // Set a system message to define the AI assistant's persona
    LPhinx.SetSystemMessage('You are a helpful AI assistant.');

    // Add a user query requesting audio transcription and translation
    LPhinx.AddUserMessage('Transcribe the audio to text, and then translate the audio to German.', [], [1]);

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
      phConsole.ClearLine();
      phConsole.PrintLn(phCSIFGRed+'Error: %s', [LPhinx.GetError()]);
    end;

    // Unload the model after inference to free resources
    LPhinx.UnloadModel();

    // Pause the console to wait for user input before closing
    phConsole.Pause(True);
  finally
    // Free the TPhinx instance to prevent memory leaks
    LPhinx.Free();
  end;
end;

{ -----------------------------------------------------------------------------
 Test07: Real-Time Web Search
 This procedure utilizes Phinx to perform a web search query. It retrieves
 real-time information from the web, processes the query, and displays the
 response in the console.
------------------------------------------------------------------------------ }
procedure Test07();
var
  LQuestion: string; // Stores the user's search query
  LResponse: string; // Stores the retrieved web search response
begin
  // Set the console title
  phConsole.SetTitle('Phinx: WebSearch');

  // Define the search query
  LQuestion := 'What is Bill Gates current net worth as of 2025?';

  // Display the question
  phConsole.PrintLn('Question:');
  phConsole.PrintLn(phCSIFGCyan+LQuestion+phCRLF);

  // Perform web search using Phinx
  phConsole.PrintLn('Response:');
  LResponse := TPhinx.WebSearch(LQuestion);

  // Display the response with formatted text wrapping
  phConsole.PrintLn(phCSIFGGreen+phConsole.WrapTextEx(LResponse, 120-10));

  // Pause the console to allow user review before exiting
  phConsole.Pause();
end;

{ -----------------------------------------------------------------------------
 Test08: Text-to-Speech (TTS)
 This procedure utilizes Phinx to convert text into speech. It processes a
 predefined text input, generates an audio file, and plays the output using an
 internal WAV player.
------------------------------------------------------------------------------ }
procedure Test08();
const
  CSpeechFilename = 'speech.wav'; // Filename for the generated speech output
var
  LPhinx: TPhinx; // Instance of TPhinx for text-to-speech conversion
  LQuestion: string; // Stores the text input to be converted to speech
begin
  // Set the console title
  phConsole.SetTitle('Phinx: Text To Speech');

  // Create an instance of TPhinx
  LPhinx := TPhinx.Create();
  try
    // Define the text input to be converted to speech
    LQuestion := 'Phinx is an advanced AI inference library designed to leverage ONNX Runtime GenAI and the Phi-4 Multimodal ONNX model for fast, efficient, and scalable AI applications. Built for developers seeking seamless integration of generative and multimodal AI into their projects, Phinx provides an optimized and flexible runtime environment with robust performance.';

    // Display the input text
    phConsole.PrintLn('Text:');
    phConsole.PrintLn(phCSIFGCyan+phConsole.WrapTextEx(LQuestion, 120-10)+phCRLF);

    // Display the output file name
    phConsole.PrintLn('Output:');
    phConsole.PrintLn(phCSIFGGreen+CSpeechFilename);

    // Perform text-to-speech conversion
    if LPhinx.TextToSpeech(LQuestion, CSpeechFilename, phBella, phUS) then
    begin
      // If conversion is successful, play the generated speech file
      if LPhinx.WavPlayer.Open() then
      begin
        LPhinx.WavPlayer.LoadFromFile(CSpeechFilename);
        LPhinx.WavPlayer.Play();
        phConsole.Pause(True);
        LPhinx.WavPlayer.Close();
      end;
    end
    else
    begin
      // If conversion fails, display an error message
      phConsole.PrintLn('Failed to convert text to speech.');
      phConsole.Pause(True);
    end;
  finally
    // Free the TPhinx instance to release resources
    LPhinx.Free();
  end;
end;

{ -----------------------------------------------------------------------------
 Test09: Vector Embeddings
 This procedure utilizes Phinx to generate vector embeddings for the given text
 inputs. The resulting embeddings are printed to the console.
------------------------------------------------------------------------------ }
procedure Test09();
var
  LEmbs: TArray<TArray<Single>>; // Stores the generated vector embeddings
  I, J: Integer; // Loop variables for iterating over embeddings
begin
  // Set the console title
  phConsole.SetTitle('Phinx: Vector Embeddings');

  // Generate embeddings for the given text inputs
  LEmbs := TPhinx.Embeddings(phDocument,
    ['Delphi is a programming language based on Object Pascal.',
    'Jina AI provides cloud-based embedding solutions.']);

  // Print embeddings
  for I := 0 to High(LEmbs) do
  begin
    phConsole.PrintLn('Embedding for Input %d:', [I + 1]);
    for J := 0 to High(LEmbs[I]) do
    begin
      phConsole.Print(phCSIFGGreen+'%.6f ', [LEmbs[I][J]]);
    end;
    phConsole.PrintLn(phCRLF);
  end;

  // Pause the console to allow user review before exiting
  phConsole.Pause();
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
  // Display Phinx ASCII logo
  TPhinx.PrintLogo();

  // Set the test number to an example to run
  LNum := 01;

  // Execute the corresponding test case based on the test number
  case LNum of
    00: Test00(); // Run Test00 (Model Building)
    01: Test01(); // Run Test01 (Basic Inference)
    02: Test02(); // Run Test02 (Reasoning Inference)
    03: Test03(); // Run Test03 (Vision Inference)
    04: Test04(); // Run Test04 (Vision & Code Generation Inference)
    05: Test05(); // Run Test05 (Audio Transcribe)
    06: Test06(); // Run Test06 (Audio Transcribe/Translation)
    07: Test07(); // Run Test07 (Web Search)
    08: Test08(); // Run Test08 (Text-to-Speech)
    09: Test09(); // Run Test09 (Vector Embeddings)
  end;
end;

end.
