﻿{===============================================================================
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

unit Phinx.Core;

{$I Phinx.Defines.inc}

interface

uses
  WinApi.Windows,
  System.SysUtils,
  System.IOUtils,
  System.DateUtils,
  System.Classes,
  System.Math,
  Phinx.CLibs,
  Phinx.Utils;

const
  /// <summary>
  ///   Defines the current version of the Phinx framework.
  ///   This version number follows semantic versioning and should be updated
  ///   accordingly with major, minor, and patch revisions.
  /// </summary>
  CphVersion = '0.1.0';

  /// <summary>
  ///   Specifies the default filename and path for the Phinx model file.
  ///   This file contains the <c>phi4-multimodal</c> ONNX model and all necessary
  ///   dependencies for execution. Ensure the path is correctly set before use.
  /// </summary>
  CphDefaultModelFilename = 'C:/LLM/PHINX/repo/Phinx.model';

  /// <summary>
  ///   Specifies the default maximum context length for processing input data.
  ///   This value determines how much context is retained during inference.
  /// </summary>
  //cphDefaultMaxContext = 7680;
  cphDefaultMaxContext = 1024;

  /// <summary>
  ///   Represents the status message indicating the start of an operation or process.
  ///   This constant is typically used with status events to signal the beginning
  ///   of an execution phase.
  /// </summary>
  CphStatusStart = 'Start';

  /// <summary>
  ///   Represents the status message indicating the completion of an operation or process.
  ///   This constant is used to notify that a task has successfully ended.
  /// </summary>
  CphStatusEnd = 'End';

  /// <summary>
  ///   API key used for web search functionality.
  ///   This key is required to authenticate requests when using the Tavily web search service.
  ///   Ensure that the key is valid and has sufficient quota for search operations.
  /// </summary>
  CphWebSearchAPIKey = 'TAVILY_API_KEY';

  /// <summary>
  ///   API key used for text-to-speech (TTS) functionality.
  ///   This key is required to authenticate requests when using the LemonFox TTS service.
  ///   Ensure that the key is valid and has sufficient quota for audio generation.
  /// </summary>
  CphTextToSpeechApiKey = 'LEMONFOX_API_KEY';

  /// <summary>
  ///   API key used for accessing Jina.ai services.
  ///   Jina.ai provides various AI-powered services, including embeddings, search,
  ///   and other machine learning capabilities. This key is required for authentication
  ///   when making requests to Jina.ai's APIs.
  ///   Ensure that the key is valid and has sufficient quota for the intended services.
  /// </summary>
  cphJinaApiKey = 'JINA_API_KEY';

type
  /// <summary>
  ///   Defines supported language options for text processing and speech synthesis.
  ///   These values represent different English language variants.
  /// </summary>
  TphLanguages = (phUS,    /// <summary> American English (US) </summary>
                  phUS_GB  /// <summary> British English (GB) </summary>
                 );

  /// <summary>
  ///   Enumerates the available text-to-speech (TTS) voices.
  ///   These voices can be used for generating speech from text input.
  /// </summary>
  TphTTSVoices = (
    phHeart,    /// <summary> Heart voice model </summary>
    phBella,    /// <summary> Bella voice model </summary>
    phMichael,  /// <summary> Michael voice model </summary>
    phAlloy,    /// <summary> Alloy voice model </summary>
    phAoede,    /// <summary> Aoede voice model </summary>
    phKore,     /// <summary> Kore voice model </summary>
    phJessica,  /// <summary> Jessica voice model </summary>
    phNicole,   /// <summary> Nicole voice model </summary>
    phNova,     /// <summary> Nova voice model </summary>
    phRiver,    /// <summary> River voice model </summary>
    phSarah,    /// <summary> Sarah voice model </summary>
    phSky,      /// <summary> Sky voice model </summary>
    phEcho,     /// <summary> Echo voice model </summary>
    phEric,     /// <summary> Eric voice model </summary>
    phFenrir,   /// <summary> Fenrir voice model </summary>
    phLiam,     /// <summary> Liam voice model </summary>
    phOnyx,     /// <summary> Onyx voice model </summary>
    phPuck,     /// <summary> Puck voice model </summary>
    phAdam,     /// <summary> Adam voice model </summary>
    phSanta     /// <summary> Santa voice model </summary>
  );

  /// <summary>
  ///   Specifies roles for embedding operations.
  ///   These roles define the purpose of the embeddings within a search or retrieval system.
  /// </summary>
  TphEmbedRole = (
    phDocument, /// <summary> Represents an embedding for a document or stored content. </summary>
    phQuery     /// <summary> Represents an embedding for a search query. </summary>
  );

  /// <summary>
  ///   Defines a generic event type with no parameters.
  ///   Used for signaling state changes, notifications, or simple event triggers.
  /// </summary>
  TphEvent = reference to procedure();

  /// <summary>
  ///   Represents a callback function to determine whether an inference operation should be canceled.
  ///   Returns <c>True</c> if the inference should be stopped; otherwise, returns <c>False</c>.
  ///   Used in long-running inference tasks to provide user-controlled interruption.
  ///   If not defined, pressing <c>ESC</c> will cancel inference.
  /// </summary>
  TphCancelInferenceEvent = reference to function(): Boolean;

  /// <summary>
  ///   Event triggered upon generating the next token during an inference operation.
  ///   Provides the generated token as a string parameter.
  ///   This can be used for real-time output streaming or logging purposes.
  /// </summary>
  /// <param name="AToken">
  ///   The token generated by the model during inference.
  /// </param>
  TphNextTokenEvent = reference to procedure(const AToken: string);

  /// <summary>
  ///   Defines an event type for reporting status updates associated with a specific identifier.
  ///   This event is typically used to track progress, state changes, or messages within the system.
  /// </summary>
  /// <param name="AID">
  ///   A unique identifier associated with the status update.
  ///   This can be used to track specific tasks or processes.
  /// </param>
  /// <param name="AStatus">
  ///   A string representing the current status message or state.
  /// </param>
  TphStatusEvent = reference to procedure(const AID, AStatus: string);

  /// <summary>
  ///   Event triggered during the model-building process to report progress.
  ///   Provides the filename being processed, the percentage of completion, and whether a new file is being created.
  /// </summary>
  /// <param name="AFilename">
  ///   The name of the model file being processed.
  /// </param>
  /// <param name="APercentage">
  ///   The completion percentage of the build process.
  /// </param>
  /// <param name="ANewFile">
  ///   Indicates whether a new file is being created (<c>True</c>) or an existing one is being updated (<c>False</c>).
  /// </param>
  TphBuildModelProgressEvent = reference to procedure(const AFilename: string; const APercentage: Integer; const ANewFile: Boolean);

  /// <summary>
  ///   Represents the core Phinx class, inheriting from <c>TphObject</c>.
  ///   This class serves as the primary interface for managing and interacting
  ///   with the Phinx framework.
  /// </summary>
  TPhinx = class(TphObject)
  protected
    FVFolder: Pointer;
    FClibDllHandle: THandle;
    FConfig: POgaConfig;
    FModel: POgaModel;
    FProcessor: POgaMultiModalProcessor;
    FTokenizer: POgaTokenizer;
    FTokenizerStream: POgaTokenizerStream;
    FImages: POgaImages;
    FAudios: POgaAudios;
    FInputTokens: NativeUInt;
    FOutputTokens: NativeUInt;
    FTokenSpeed: Double;
    FElapsedTime: Double;
    FModelLoaded: Boolean;
    FCancelInferenceEvent: TphCancelInferenceEvent;
    FNextTokenEvent: TphNextTokenEvent;
    FInferenceStartEvent: TphEvent;
    FInferenceEndEvent: TphEvent;
    FStatusEvent: TphStatusEvent;
    FStream: Boolean;
    FInferenceResponse: string;
    FTokenResponse: TphTokenResponse;
    FMessages: TStringList;
    FSystemMessage: string;
    FLastUserMessage: string;
    FImageList: TStringList;
    FAudioList: TStringList;
    FWavPlayer: TphWavPlayer;
    FDiversityPenalty: Single;
    FDoSample: Boolean;
    FEarlyStopping: Boolean;
    FLengthPenalty: Single;
    FMaxLength: UInt32;
    FMinLength: UInt32;
    FNoRepeatNumGramSize: UInt32;
    FNumBeams: UInt32;
    FNumReturnSequences: UInt32;
    FPastPresentShareBuffer: Boolean;
    FRepetitionPenalty: Single;
    FTemperature: Single;
    FTopK: UInt32;
    FTopP: Single;

    function  LoadClibsDLL(): Boolean;
    procedure UnloadCLibsDLL();
    function  CheckResult(const AResult: POgaResult): Boolean;
    function  GetModelBasePath(): string;
    procedure SetMaxLength(const AValue: UInt32);
    procedure LoadImages();
    procedure LoadAudios();
    function  OnCancelInference(): Boolean;
    procedure OnNextToken(const AToken: string);
    procedure OnInferenceStart();
    procedure OnInferenceEnd();
    procedure OnStatus(const AID, AMsg: string; const AArgs: array of const);
  public
    /// <summary>
    ///   Event triggered to determine whether an ongoing inference process should be canceled.
    ///   This property allows external control over inference execution, enabling
    ///   interruption when necessary.
    /// </summary>
    property CancelInferenceEvent: TphCancelInferenceEvent read FCancelInferenceEvent write FCancelInferenceEvent;

    /// <summary>
    ///   Event triggered when the next token is generated during inference.
    ///   This property allows real-time processing or logging of generated tokens.
    /// </summary>
    property NextTokenEvent: TphNextTokenEvent read FNextTokenEvent write FNextTokenEvent;

    /// <summary>
    ///   Event triggered when an inference session begins.
    ///   This can be used to handle setup operations, logging, or UI updates
    ///   before inference starts.
    /// </summary>
    property InferenceStartEvent: TphEvent read FInferenceStartEvent write FInferenceStartEvent;

    /// <summary>
    ///   Event triggered when an inference session ends.
    ///   This can be used to handle cleanup operations, logging, or UI updates
    ///   after inference completes.
    /// </summary>
    property InferenceEndEvent: TphEvent read FInferenceEndEvent write FInferenceEndEvent;

    /// <summary>
    ///   Event triggered to report status updates associated with a specific identifier.
    ///   This event can be used to track progress, log state changes, or provide
    ///   real-time feedback on ongoing operations.
    /// </summary>
    property StatusEvent: TphStatusEvent read FStatusEvent write FStatusEvent;

    /// <summary>
    ///   Determines whether inference results should be streamed in real-time.
    ///   When set to <c>True</c>, tokens are emitted progressively as they are generated.
    ///   When set to <c>False</c>, results are returned as a complete response.
    ///   Default value is <c>True</c>.
    /// </summary>
    property Stream: Boolean read FStream write FStream default True;


    /// <summary>
    ///   Controls the diversity penalty applied during inference.
    ///   A higher value discourages repetitive patterns in the generated text.
    /// </summary>
    property DiversityPenalty: Single read FDiversityPenalty write FDiversityPenalty;

    /// <summary>
    ///   Determines whether sampling is used for text generation.
    ///   If <c>True</c>, sampling techniques such as Top-K or Top-P will be applied.
    ///   If <c>False</c>, deterministic generation (e.g., greedy decoding) is used.
    /// </summary>
    property DoSample: Boolean read FDoSample write FDoSample;

    /// <summary>
    ///   Enables early stopping when generating text.
    ///   If <c>True</c>, generation stops when all output sequences reach an end condition.
    /// </summary>
    property EarlyStopping: Boolean read FEarlyStopping write FEarlyStopping;

    /// <summary>
    ///   Controls the length penalty applied during sequence generation.
    ///   Higher values encourage longer outputs, while lower values discourage verbosity.
    /// </summary>
    property LengthPenalty: Single read FLengthPenalty write FLengthPenalty;

    /// <summary>
    ///   Specifies the maximum length of the generated sequence.
    ///   Once this length is reached, the generation process stops.
    /// </summary>
    property MaxLength: UInt32 read FMaxLength write SetMaxLength;

    /// <summary>
    ///   Specifies the minimum length of the generated sequence.
    ///   The model will not produce outputs shorter than this value.
    /// </summary>
    property MinLength: UInt32 read FMinLength write FMinLength;

    /// <summary>
    ///   Prevents repetition of phrases by enforcing a no-repeat n-gram rule.
    ///   This property specifies the size of the n-gram that should not be repeated.
    /// </summary>
    property NoRepeatNumGramSize: UInt32 read FNoRepeatNumGramSize write FNoRepeatNumGramSize;

    /// <summary>
    ///   Defines the number of beams used for beam search.
    ///   Higher values improve search quality but increase computational cost.
    /// </summary>
    property NumBeams: UInt32 read FNumBeams write FNumBeams;

    /// <summary>
    ///   Specifies how many different sequences should be returned after generation.
    ///   When greater than 1, multiple possible outputs are generated.
    /// </summary>
    property NumReturnSequences: UInt32 read FNumReturnSequences write FNumReturnSequences;

    /// <summary>
    ///   Determines whether past-present key-value buffers are shared across decoding steps.
    ///   If <c>True</c>, memory efficiency is improved by reusing computation from previous steps.
    /// </summary>
    property PastPresentShareBuffer: Boolean read FPastPresentShareBuffer write FPastPresentShareBuffer;

    /// <summary>
    ///   Controls the penalty applied for token repetition.
    ///   A value greater than 1 discourages repeated words, reducing redundancy.
    /// </summary>
    property RepetitionPenalty: Single read FRepetitionPenalty write FRepetitionPenalty;

    /// <summary>
    ///   Adjusts the randomness of token selection during generation.
    ///   Higher values increase randomness, while lower values make outputs more deterministic.
    /// </summary>
    property Temperature: Single read FTemperature write FTemperature;

    /// <summary>
    ///   Sets the Top-K sampling parameter, limiting token selection to the top K most probable tokens.
    ///   A lower value makes generation more focused, while a higher value increases randomness.
    /// </summary>
    property TopK: UInt32 read FTopK write FTopK;

    /// <summary>
    ///   Sets the Top-P (nucleus) sampling parameter, restricting token selection
    ///   to a cumulative probability threshold.
    ///   This controls output randomness while ensuring diversity.
    /// </summary>
    property TopP: Single read FTopP write FTopP;

    /// <summary>
    ///   Provides access to the WAV player component.
    ///   This allows loading and playing WAV audio files for audio-based output or processing.
    /// </summary>
    property WavPlayer: TphWavPlayer read FWavPlayer;

    /// <summary>
    ///   Initializes a new instance of the <c>TPhinx</c> class.
    ///   This constructor sets up necessary resources and prepares the instance
    ///   for operation within the Phinx framework.
    /// </summary>
    constructor Create(); override;

    /// <summary>
    ///   Destroys the instance of the <c>TPhinx</c> class.
    ///   This destructor ensures proper cleanup of allocated resources before
    ///   the object is removed from memory.
    /// </summary>
    destructor Destroy(); override;

    /// <summary>
    ///   Retrieves the right margin value for token output formatting.
    ///   This value defines the horizontal boundary beyond which tokens should not be placed,
    ///   ensuring proper text alignment in output processing.
    /// </summary>
    /// <returns>
    ///   The right margin position in character units.
    /// </returns>
    function GetTokenRightMargin(): UInt32;

    /// <summary>
    ///   Sets the right margin value for token output formatting.
    ///   This determines the maximum width before token placement is constrained.
    /// </summary>
    /// <param name="AValue">
    ///   The right margin position in character units.
    /// </param>
    procedure SetTokenRightMargin(const AValue: UInt32);

    /// <summary>
    ///   Retrieves the maximum line length allowed before a token is wrapped.
    ///   This ensures tokens do not exceed a specified number of characters per line.
    /// </summary>
    /// <returns>
    ///   The maximum number of characters per line before wrapping occurs.
    /// </returns>
    function GetTokenMaxLineLength(): UInt32;

    /// <summary>
    ///   Sets the maximum line length allowed before a token is wrapped.
    ///   This controls text flow by enforcing a character limit per line.
    /// </summary>
    /// <param name="AValue">
    ///   The maximum number of characters per line before wrapping occurs.
    /// </param>
    procedure SetTokenMaxLineLength(const AValue: UInt32);

    /// <summary>
    ///   Clears all stored images from memory.
    ///   This resets the image processing context, ensuring no residual images remain.
    /// </summary>
    procedure ClearImages();

    /// <summary>
    ///   Adds an image to the processing pipeline from the specified file.
    ///   The image is loaded and made available for inference or further processing.
    /// </summary>
    /// <param name="AFilename">
    ///   The full path to the image file that should be added.
    /// </param>
    /// <returns>
    ///   <c>True</c> if the image was successfully loaded and added; otherwise, <c>False</c>.
    /// </returns>
    function AddImage(const AFilename: string): Boolean;

    /// <summary>
    ///   Clears all stored audio files from memory.
    ///   This resets the audio processing context, ensuring no residual audio files remain.
    /// </summary>
    procedure ClearAudios();

    /// <summary>
    ///   Adds an audio file to the processing pipeline from the specified file.
    ///   The audio file is loaded and made available for inference processing.
    /// </summary>
    /// <param name="AFilename">
    ///   The full path to the audio file that should be added.
    /// </param>
    /// <returns>
    ///   <c>True</c> if the audio file was successfully loaded and added; otherwise, <c>False</c>.
    /// </returns>
    function AddAudio(const AFilename: string): Boolean;

    /// <summary>
    ///   Clears all stored messages, including system, user, and assistant messages.
    ///   This resets the conversation history, ensuring a fresh context for new interactions.
    /// </summary>
    procedure ClearMessages();

    /// <summary>
    ///   Sets the system message, which provides context or instructions for the assistant.
    ///   This message is typically used to guide responses or enforce behavioral constraints.
    /// </summary>
    /// <param name="AContent">
    ///   The content of the system message to be stored.
    /// </param>
    procedure SetSystemMessage(const AContent: string);

    /// <summary>
    ///   Retrieves the current system message.
    ///   The system message contains context or instructions influencing model behavior.
    /// </summary>
    /// <returns>
    ///   The stored system message as a string.
    /// </returns>
    function GetSystemMessage(): string;

    /// <summary>
    ///   Adds a user message to the conversation history.
    ///   This represents input provided by the user, contributing to the ongoing dialogue.
    /// </summary>
    /// <param name="AContent">
    ///   The content of the user message to be added.
    /// </param>
    function AddUserMessage(const AContent: string; const AImages: array of UInt32; const AAudios: array of UInt32): Boolean;

    /// <summary>
    ///   Retrieves the most recent user message from the conversation history.
    ///   This allows access to the last user input for reference or processing.
    /// </summary>
    /// <returns>
    ///   The last recorded user message as a string.
    /// </returns>
    function GetLastUserMessage(): string;

    /// <summary>
    ///   Adds an assistant message to the conversation history.
    ///   This represents a response generated by the AI, contributing to the dialogue.
    /// </summary>
    /// <param name="AContent">
    ///   The content of the assistant's message to be added.
    /// </param>
    procedure AddAssistantMessage(const AContent: string);

    /// <summary>
    ///   Retrieves the complete inference prompt constructed from the conversation history.
    ///   This includes system instructions, user inputs, and assistant responses.
    /// </summary>
    /// <returns>
    ///   The compiled inference prompt as a string.
    /// </returns>
    function GetInferencePrompt(): string;

    /// <summary>
    ///   Loads a Phinx model file, which is a specialized virtual folder containing
    ///   the <c>phi4-multimodal</c> ONNX model along with all necessary dependencies
    ///   required to execute ONNX inference.
    /// </summary>
    /// <param name="AFilename">
    ///   The full path to the Phinx model file. If not specified, the default model path
    ///   <c>CphDefaultModelPath</c> is used.
    /// </param>
    /// <returns>
    ///   <c>True</c> if the model was successfully loaded; otherwise, <c>False</c>.
    /// </returns>
    function LoadModel(const AFilename: string = CphDefaultModelFilename): Boolean;

    /// <summary>
    ///   Checks whether a Phinx model is currently loaded and ready for inference.
    /// </summary>
    /// <returns>
    ///   <c>True</c> if a model is successfully loaded; otherwise, <c>False</c>.
    /// </returns>
    function ModelLoaded(): Boolean;

    /// <summary>
    ///   Unloads the currently loaded Phinx model, releasing all associated resources.
    ///   This ensures proper cleanup of memory and ONNX execution dependencies.
    /// </summary>
    procedure UnloadModel();

    /// <summary>
    ///   Executes an inference process using the currently loaded Phinx model.
    ///   This function processes input data, generates predictions, and constructs
    ///   a response based on the provided context.
    /// </summary>
    /// <returns>
    ///   <c>True</c> if inference was successfully executed; otherwise, <c>False</c>.
    ///   A return value of <c>False</c> may indicate that no model is loaded or
    ///   that an error occurred during processing.
    /// </returns>
    function RunInference(): Boolean;

    /// <summary>
    ///   Retrieves the full response generated by the last inference process.
    ///   This function should be called after <c>RunInference</c> to obtain the model's output.
    /// </summary>
    /// <returns>
    ///   The generated inference response as a string.
    /// </returns>
    function GetInferenceResponse(): string;

    /// <summary>
    ///   Retrieves performance metrics for the most recent inference operation.
    ///   This function provides insights into the efficiency of the inference process.
    /// </summary>
    /// <param name="AInputTokens">
    ///   A pointer to a variable that will receive the number of input tokens processed.
    /// </param>
    /// <param name="AOutputTokens">
    ///   A pointer to a variable that will receive the number of output tokens generated.
    /// </param>
    /// <param name="ASpeed">
    ///   A pointer to a variable that will receive the processing speed in tokens per second.
    /// </param>
    /// <param name="ATime">
    ///   A pointer to a variable that will receive the total inference time in seconds.
    /// </param>
    procedure GetPerformance(AInputTokens, AOutputTokens: PUInt32; ASpeed, ATime: PDouble);

    /// <summary>
    ///   Performs a web search using the configured API key.
    ///   This function sends the provided query to the web search service and returns
    ///   relevant results as a string.
    /// </summary>
    /// <param name="AQuery">
    ///   The search query to be executed.
    /// </param>
    /// <returns>
    ///   A string containing the search results in a structured format.
    /// </returns>
    class function WebSearch(const AQuery: string): string;

    /// <summary>
    ///   Converts text input into speech and saves it as an audio file.
    ///   This function utilizes a text-to-speech (TTS) service to generate spoken
    ///   audio from the provided text.
    /// </summary>
    /// <param name="AInputText">
    ///   The text to be converted into speech.
    /// </param>
    /// <param name="AOutputFile">
    ///   The filename where the generated speech audio will be saved.
    ///   Defaults to <c>'speech.wav'</c>.
    /// </param>
    /// <param name="AVoice">
    ///   The voice model to use for speech generation.
    ///   Defaults to <c>phBella</c>.
    /// </param>
    /// <param name="ALanguage">
    ///   The language model to be used for speech synthesis.
    ///   Defaults to <c>phUS</c> (American English).
    /// </param>
    /// <returns>
    ///   <c>True</c> if the text was successfully converted into speech and saved;
    ///   otherwise, <c>False</c>.
    /// </returns>
    class function TextToSpeech(const AInputText: string; const AOutputFile: string = 'speech.wav';
      const AVoice: TphTTSVoices = phBella; const ALanguage: TphLanguages = phUS): Boolean;

    /// <summary>
    ///   Generates embeddings for the provided input text.
    ///   This function returns a numerical representation of the text, suitable for
    ///   semantic search, similarity comparisons, and AI applications.
    /// </summary>
    /// <param name="ARole">
    ///   Specifies the role of the embedding, either as a document or a query.
    /// </param>
    /// <param name="AInputs">
    ///   An array of strings for which embeddings should be generated.
    /// </param>
    /// <returns>
    ///   A two-dimensional array of floating-point values, where each sub-array
    ///   represents the embedding vector for a corresponding input string.
    /// </returns>
    class function Embeddings(const ARole: TphEmbedRole; const AInputs: array of string): TArray<TArray<Single>>;

    /// <summary>
    ///   Constructs a <c>phinx.model</c> file from a specified folder containing
    ///   the <c>phi4-multimodal</c> model along with all necessary ONNX runtimes
    ///   and dependencies required for execution.
    /// </summary>
    /// <param name="AFolder">
    ///   The directory containing the <c>phi4-multimodal</c> model files and ONNX runtimes.
    /// </param>
    /// <param name="AFilename">
    ///   The full path where the generated <c>phinx.model</c> file will be saved.
    /// </param>
    /// <param name="AProgressEvent">
    ///   An optional callback event to track the progress of the build process.
    ///   This event provides updates on the file being processed, the completion percentage,
    ///   and whether a new file is being created.
    ///   If set to <c>nil</c>, no progress tracking is provided.
    /// </param>
    /// <returns>
    ///   <c>True</c> if the model was successfully built; otherwise, <c>False</c>.
    /// </returns>
    class function BuildModel(const AFolder: string; const AFilename: string;
      const AProgressEvent: TphBuildModelProgressEvent = nil): Boolean;

    /// <summary>
    ///   Prints an ASCII logo to the console with customizable colors for different sections.
    ///   This method is typically used to display branding or identification information
    ///   when starting the application.
    /// </summary>
    /// <param name="ATitleColor">
    ///   The color code for the main title of the logo.
    ///   Defaults to <c>phCSIDim + phCSIFGGreen</c>.
    /// </param>
    /// <param name="AVersionColor">
    ///   The color code for the version number displayed within the logo.
    ///   Defaults to <c>phCSIDim + phCSIFGWhite</c>.
    /// </param>
    /// <param name="ASubTitleColor">
    ///   The color code for the subtitle or additional information in the logo.
    ///   Defaults to <c>phCSIDim + phCSIFGMagenta</c>.
    /// </param>
    class procedure PrintLogo(const ATitleColor: string = {phCSIDim +} phCSIFGGreen;
      const AVersionColor: string = {phCSIDim +} phCSIFGWhite;
      const ASubTitleColor: string = {phCSIDim +} phCSIFGMagenta);

  end;

implementation

{ Phinx.Core.Utils }
type
  { TphVFolder }
  TphVFolder = Pointer;

  { TphVFolder_BuildProgressCallback }
  TphVFolder_BuildProgressCallback = procedure(const AFilename: PWideChar; const APercentage: Integer; const ANewFile: Boolean; const AUserData: Pointer); cdecl;

var
  vfolder_build: function(const AFolderPath, AFilename: PWideChar; const AProgressCallback: TphVFolder_BuildProgressCallback=nil; const AUserData: Pointer=nil): Boolean; cdecl;
  vfolder_new: function(): TphVFolder; cdecl;
  vfolder_setVirtualBasePathToEXE: function(const vfolder: TphVFolder): Boolean; cdecl;
  vfolder_open: function(const vfolder: TphVFolder; const AFilename: PWideChar): Boolean; cdecl;
  vfolder_openAllFiles: function(const vfolder: TphVFolder; ACount: PInt64): Boolean; cdecl;
  vfolder_getVirtualBasePath: function(const vfolder: TphVFolder): PWideChar; cdecl;
  vfolder_close: procedure(const vfolder: TphVFolder); cdecl;
  vfolder_free: procedure(var vfolder: TphVFolder); cdecl;

{ TPhinx }
function TPhinx.LoadClibsDLL(): Boolean;
begin
  Result := False;

  if FClibDllHandle <> 0 then
  begin
    Result := True;
    Exit;
  end;

  try
    FClibDllHandle := LoadLibrary('Phinx.Deps.dll');
    if FClibDllHandle = 0 then
    begin
      SetError('Failed to load extracted CLibs DLL', []);
      Exit;
    end;

    Phinx.CLibs.GetExports(FClibDllHandle);

    Result := True;

  except
    on E: Exception do
      SetError('Unexpected error: %s', [E.Message]);
  end;
end;

procedure TPhinx.UnloadCLibsDLL();
begin
  if FClibDllHandle <> 0 then
  begin
    FreeLibrary(FClibDllHandle);
    FClibDllHandle := 0;
  end;
end;

function TPhinx.CheckResult(const AResult: POgaResult): Boolean;
var
  LErrorMessage: PUTF8Char;
begin
  Result := False;
  if Assigned(AResult) then
  begin
    LErrorMessage := OgaResultGetError(AResult);
    if Assigned(LErrorMessage) then
    begin
      SetError(string(LErrorMessage), []);
    end;
    Exit;
  end;
  Result := True;
end;

function  TPhinx.OnCancelInference(): Boolean;
begin
  if Assigned(FCancelInferenceEvent) then
    Result := FCancelInferenceEvent()
  else
    Result := Boolean((GetAsyncKeyState(VK_ESCAPE) and $8000) <> 0);
end;

procedure TPhinx.OnNextToken(const AToken: string);
begin
  FInferenceResponse := FInferenceResponse + AToken;

  if not FStream then Exit;

  if Assigned(FNextTokenEvent) then
    FNextTokenEvent(AToken)
  else
    phConsole.Print(AToken)
end;

procedure TPhinx.OnInferenceStart();
begin
  if Assigned(FInferenceStartEvent) then
    FInferenceStartEvent();
end;

procedure TPhinx.OnInferenceEnd();
begin
  if Assigned(FInferenceEndEvent) then
    FInferenceEndEvent();
end;

procedure TPhinx.OnStatus(const AID, AMsg: string; const AArgs: array of const);
var
  LStatus: string;
begin
  LStatus := Format(AMsg, AArgs);
  if Assigned(FStatusEvent) then
    FStatusEvent(AID, LStatus);
end;

constructor TPhinx.Create();
begin
  inherited;

  FMessages := TStringList.Create();
  FImageList := TStringList.Create();
  FAudioList := TStringList.Create();
  FWavPlayer := TphWavPlayer.Create();
  FTokenResponse.Initialize();
  FStream := True;

  FDiversityPenalty := 0.0;
  FDoSample := False;
  FEarlyStopping := True;
  FLengthPenalty := 1.0;
  MaxLength := cphDefaultMaxContext;
  FMinLength := 0;
  FNoRepeatNumGramSize := 0;
  FNumBeams := 1;
  FNumReturnSequences := 1;
  FPastPresentShareBuffer := True;
  FRepetitionPenalty := 1.0;
  FTemperature := 1.0;
  FTopK := 1;
  FTopP := 1.0;

end;

destructor TPhinx.Destroy();
begin
  UnloadModel();
  FWavPlayer.Free();
  FAudioList.Free();
  FImageList.Free();
  FMessages.Free();

  inherited;
end;

function  TPhinx.GetTokenRightMargin(): UInt32;
begin
  Result := FTokenResponse.GetRightMargin();
end;

procedure TPhinx.SetTokenRightMargin(const AValue: UInt32);
begin
  FTokenResponse.SetRightMargin(AValue);
end;

function  TPhinx.GetTokenMaxLineLength(): UInt32;
begin
  Result := FTokenResponse.GetMaxLineLength();
end;

procedure TPhinx.SetTokenMaxLineLength(const AValue: UInt32);
begin
  FTokenResponse.SetMaxLineLength(AValue);
end;

procedure TPhinx.ClearImages();
begin
  FImageList.Clear();

  if Assigned(FImages) then
  begin
    OgaDestroyImages(FImages);
    FImages := nil;
  end;
end;

function TPhinx.AddImage(const AFilename: string): Boolean;
begin
  Result := TFile.Exists(AFilename);
  if Result then
  begin
    FImageList.Add(AFilename);
  end;
end;

procedure TPhinx.ClearAudios();
begin
  FAudioList.Clear();

  if Assigned(FAudios) then
  begin
    OgaDestroyAudios(FAudios);
    FAudios := nil;
  end;
end;

function TPhinx.AddAudio(const AFilename: string): Boolean;
begin
  Result := TFile.Exists(AFilename);
  if Result then
  begin
    FAudioList.Add(AFilename);
  end;
end;

procedure TPhinx.ClearMessages();
begin
  FMessages.Clear();
  FSystemMessage := '';
end;

procedure TPhinx.SetSystemMessage(const AContent: string);
begin
  FSystemMessage := AContent;
end;

function  TPhinx.GetSystemMessage(): string;
begin
  Result := FSystemMessage;
end;

function  TPhinx.AddUserMessage(const AContent: string; const AImages: array of UInt32; const AAudios: array of UInt32): Boolean;
var
  LMessage: string;
  LMediaTokens: string;
  I, LNum: Integer;
begin
  Result := False;

  if AContent.IsEmpty then Exit;

  LMediaTokens := '';

  I := 1;
  for LNum in AImages do
  begin
    if not InRange(LNum, 1, FImageList.Count) then
    begin
      continue;
    end;
    LMediaTokens := LMediaTokens + Format('<|image_%d|>', [I]);
    Inc(I);
  end;

  I := 1;
  for LNum in AAudios do
  begin
    if not InRange(LNum, 1, FAudioList.Count) then
    begin
      continue;
    end;
    LMediaTokens := LMediaTokens + Format('<|audio_%d|>', [I]);
    Inc(I);
  end;

  LMessage := Format('<|user|>%s%s<|end|>', [LMediaTokens, AContent]);
  FMessages.Add(LMessage);

  FLastUserMessage := AContent;
end;

function  TPhinx.GetLastUserMessage(): string;
begin
  Result := FLastUserMessage;
end;

procedure TPhinx.AddAssistantMessage(const AContent: string);
var
  LMessage: string;
begin
  if AContent.IsEmpty then Exit;

  LMessage := Format('<|assistant|>%s<|end|>', [AContent]);
  FMessages.Add(LMessage);

end;

function  TPhinx.GetInferencePrompt(): string;
var
  LItem: string;
begin
  Result := '';
  for LItem in FMessages do
  begin
    Result := Result + LItem;
  end;

  Result := Result.Trim();

  if not Result.IsEmpty then
  begin
    // Process system message
    if not FSystemMessage.IsEmpty then
    begin
      Result := Format('<|system|>%s<|end|>', [FSystemMessage]) + Result;
    end;

    // Process ending message
    Result := Result + '<|assistant|>';
  end;

  Result := Result.Trim();
end;

function  TPhinx.LoadModel(const AFilename: string): Boolean;
const
  CID = 'TPhinx.LoadModel';
var
  LFilename: string;
begin
  OnStatus(CID, CphStatusStart, []);

  Result := False;

  if FModelLoaded then
  begin
    Result := True;
    Exit;
  end;

  LFilename := AFilename;

  if not TFile.Exists(LFilename) then Exit;

  FVFolder := vfolder_new();
  if not Assigned(FVFolder) then Exit;

  vfolder_setVirtualBasePathToEXE(FVFolder);
  if vfolder_open(FVFolder,  PWideChar(AFilename)) then
  begin
    vfolder_openAllFiles(FVFolder, nil);
  end;

  OnStatus(CID, 'Loading library dependencies...', []);
  if not LoadClibsDLL() then Exit;

  OnStatus(CID, 'Creating model config...', []);
  if not CheckResult(OgaCreateConfig(phUtils.AsUtf8(GetModelBasePath()), @FConfig)) then Exit;

  OnStatus(CID, 'Clearing model providers...', []);
  if not CheckResult(OgaConfigClearProviders(FConfig)) then Exit;

  OnStatus(CID, 'Appending CUDA model provider...', []);
  if not CheckResult(OgaConfigAppendProvider(FConfig, 'cuda')) then Exit;

  OnStatus(CID, 'Enabled CUDA graph...', []);
  OgaConfigSetProviderOption(FConfig, 'cuda', 'enable_cuda_graph', '0');

  OnStatus(CID, 'Creating model from config...', []);
  if not CheckResult(OgaCreateModelFromConfig(FConfig, @FModel)) then Exit;

  OnStatus(CID, 'Creating tokenizer...', []);
  if not CheckResult(OgaCreateTokenizer(FModel, @FTokenizer)) then Exit;

  OnStatus(CID, 'Creating multimedia processor...', []);
  if not CheckResult(OgaCreateMultiModalProcessor(FModel, @FProcessor)) then Exit;

  OnStatus(CID, 'Creating tokenzier stream from processor...', []);
  if not CheckResult(OgaCreateTokenizerStreamFromProcessor(FProcessor, @FTokenizerStream)) then Exit;

  FModelLoaded := True;
  Result := True;

  OnStatus(CID, 'Succesfully loaded model!', []);

  OnStatus(CID, CphStatusEnd, []);
end;

function  TPhinx.ModelLoaded(): Boolean;
begin
  Result := FModelLoaded;
end;

procedure TPhinx.UnloadModel();
begin
  if Assigned(FVFolder) then
  begin
    if Assigned(FTokenizerStream) then
    begin
      OgaDestroyTokenizerStream(FTokenizerStream);
      FTokenizerStream := nil;
    end;

    if Assigned(FProcessor) then
    begin
      OgaDestroyMultiModalProcessor(FProcessor);
      FProcessor := nil;
    end;

    if Assigned(FTokenizer) then
    begin
      OgaDestroyTokenizer(FTokenizer);
      FTokenizer := nil;
    end;

    if Assigned(FModel) then
    begin
      OgaDestroyModel(FModel);
      FModel := nil;
    end;

    if Assigned(FConfig) then
    begin
      OgaDestroyConfig(FConfig);
      FConfig := nil;
    end;

    OgaShutdown();

    UnloadCLibsDLL();
    vfolder_close(FVFolder);
    vfolder_free(FVFolder);
    FVFolder := nil;
    FModelLoaded := False;
  end;
end;

function  TPhinx.GetModelBasePath(): string;
begin
  Result := TPath.Combine(string(vfolder_getVirtualBasePath(FVFolder)), 'model');
end;

procedure TPhinx.SetMaxLength(const AValue: UInt32);
begin
  FMaxLength := EnsureRange(AValue, 512, 131072);
end;

procedure TPhinx.LoadImages();
type
  PCharArray = array of PUTF8Char;
var
  StrArray: PCharArray;
  I: Integer;
  LImagePaths: POgaStringArray;
begin
  if Assigned(FImages) then Exit;
  if FImageList.Count = 0  then Exit;

  SetLength(StrArray, FImageList.Count);
  for I := 0 to FImageList.Count-1 do
  begin
    StrArray[I] := PUTF8Char(UTF8String(FImageList[I]));
  end;

  if not CheckResult(OgaCreateStringArrayFromStrings(@StrArray[0], Length(StrArray), @LImagePaths)) then Exit;
  try
    if not CheckResult(OgaLoadImages(LImagePaths, @FImages)) then Exit;

  finally
    OgaDestroyStringArray(LImagePaths);
  end;
end;

procedure TPhinx.LoadAudios();
type
  PCharArray = array of PUTF8Char;
var
  StrArray: PCharArray;
  I: Integer;
  LAudioPaths: POgaStringArray;
begin
  if Assigned(FAudios) then Exit;
  if FAudioList.Count = 0  then Exit;

  SetLength(StrArray, FAudioList.Count);
  for I := 0 to FAudioList.Count-1 do
  begin
    StrArray[I] := PUTF8Char(UTF8String(FAudioList[I]));
  end;

  if not CheckResult(OgaCreateStringArrayFromStrings(@StrArray[0], Length(StrArray), @LAudioPaths)) then Exit;
  try
    if not CheckResult(OgaLoadAudios(LAudioPaths, @FAudios)) then Exit;

  finally
    OgaDestroyStringArray(LAudioPaths);
  end;
end;

function  TPhinx.RunInference(): Boolean;
const
  CID = 'TPhinx.RunInference';
var
  LPrompt: string;

  LTokenStr: string;
  LSequenceCount: NativeUInt;
  LGeneratorParams: POgaGeneratorParams;
  LGenerator: POgaGenerator;
  LInputTensors: POgaNamedTensors;
  LSequences: POgaSequences;
  LSequenceData: PInt32;
  LNewToken: int32;
  LNewTokenStr: PUTF8Char;
  LStartTime, LEndTime: TDateTime;

begin
  OnStatus(CID, CphStatusStart, []);

  Result := False;

  if not FModelLoaded then
  begin
    SetError('Model was not found', []);
    Exit;
  end;

  LPrompt := GetInferencePrompt();
  if LPrompt.IsEmpty then
  begin
    SetError('No inference prompt found', []);
    Exit;
  end;

  try

    FInputTokens := 0;
    FOutputTokens := 0;
    FElapsedTime := 0;
    FTokenSpeed := 0;
    FInferenceResponse := '';

    LGenerator := nil;
    LGeneratorParams := nil;
    LSequences := nil;
    LInputTensors := nil;
    FImages := nil;

    OnStatus(CID, 'Loading images...', []);
    LoadImages();
    LoadAudios();

    OnStatus(CID, 'Creating input tensor...', []);
    if not CheckResult(OgaProcessorProcessImagesAndAudios(FProcessor, phUtils.AsUtf8(LPrompt), FImages, FAudios, @LInputTensors)) then  Exit;

    OnStatus(CID, 'Creating sequences...', []);
    if not CheckResult(OgaCreateSequences(@LSequences)) then Exit;

    OnStatus(CID, 'Tokenizing prompt...', []);
    if not CheckResult(OgaTokenizerEncode(FTokenizer, phUtils.AsUtf8(LPrompt), LSequences)) then Exit;

    OnStatus(CID, 'Getting sequence count...', []);
    FInputTokens := OgaSequencesGetSequenceCount(LSequences, 0);

    OnStatus(CID, 'Creating generator params...', []);
    if not CheckResult(OgaCreateGeneratorParams(FModel, @LGeneratorParams)) then Exit;

    OnStatus(CID, 'Setting generator params...', []);

    if not CheckResult(OgaGeneratorParamsSetSearchNumber(LGeneratorParams, 'diversity_penalty',   FDiversityPenalty)) then Exit;
    if not CheckResult(OgaGeneratorParamsSetSearchBool(LGeneratorParams, 'do_sample',   FDoSample)) then Exit;
    if not CheckResult(OgaGeneratorParamsSetSearchBool(LGeneratorParams, 'early_stopping',   FEarlyStopping)) then Exit;
    if not CheckResult(OgaGeneratorParamsSetSearchNumber(LGeneratorParams, 'length_penalty',   FLengthPenalty)) then Exit;
    if not CheckResult(OgaGeneratorParamsSetSearchNumber(LGeneratorParams, 'max_length',   FMaxLength)) then Exit;
    if not CheckResult(OgaGeneratorParamsSetSearchNumber(LGeneratorParams, 'min_length',   FMinLength)) then Exit;
    if not CheckResult(OgaGeneratorParamsSetSearchNumber(LGeneratorParams, 'no_repeat_ngram_size',   FNoRepeatNumGramSize)) then Exit;
    if not CheckResult(OgaGeneratorParamsSetSearchNumber(LGeneratorParams, 'num_beams',   FNumBeams)) then Exit;
    if not CheckResult(OgaGeneratorParamsSetSearchNumber(LGeneratorParams, 'num_return_sequences',   FNumReturnSequences)) then Exit;
    if not CheckResult(OgaGeneratorParamsSetSearchBool(LGeneratorParams, 'past_present_share_buffer',   FPastPresentShareBuffer)) then Exit;
    if not CheckResult(OgaGeneratorParamsSetSearchNumber(LGeneratorParams, 'repetition_penalty',   FRepetitionPenalty)) then Exit;
    if not CheckResult(OgaGeneratorParamsSetSearchNumber(LGeneratorParams, 'temperature',   FTemperature)) then Exit;
    if not CheckResult(OgaGeneratorParamsSetSearchNumber(LGeneratorParams, 'top_k',   FTopK)) then Exit;
    if not CheckResult(OgaGeneratorParamsSetSearchNumber(LGeneratorParams, 'top_p',   FTopP)) then Exit;

    if not CheckResult(OgaGeneratorParamsSetInputs(LGeneratorParams, LInputTensors)) then Exit;

    OnStatus(CID, 'Creating generator...', []);
    if not CheckResult(OgaCreateGenerator(FModel, LGeneratorParams, @LGenerator)) then Exit;

    OnStatus(CID, 'InferenceStart', []);
    OnInferenceStart();

    // Record start time
    LStartTime := Now;

    while (not OgaGenerator_IsDone(LGenerator)) do
    begin
      if OnCancelInference() then Break;

      CheckResult(OgaGenerator_GenerateNextToken(LGenerator));

      LSequenceCount := OgaGenerator_GetSequenceCount(LGenerator, 0);

      LSequenceData := OgaGenerator_GetSequenceData(LGenerator, 0);

      LNewToken := PInt32(NativeUInt(LSequenceData) + (LSequenceCount - 1) * SizeOf(Int32))^;

      CheckResult(OgaTokenizerStreamDecode(FTokenizerStream, LNewToken, @LNewTokenStr));

      LTokenStr := UTF8ToUnicodeString(LNewTokenStr);

      // Process token string
      case FTokenResponse.AddToken(LTokenStr) of
        tpaWait:
        begin
        end;

        tpaAppend:
        begin
          OnNextToken(FTokenResponse.LastWord(False));
        end;

        tpaNewline:
        begin
          OnNextToken(#10);
          OnNextToken(FTokenResponse.LastWord(True));
        end;
      end;

      // Increment total tokens
      Inc(FOutputTokens);
    end;

    // Record end time
    LEndTime := Now;

    // Calculate elapsed time in seconds
    FElapsedTime := MilliSecondsBetween(LStartTime, LEndTime) / 1000;

    // Calculate tokens per second
    FTokenSpeed := FOutputTokens / FElapsedTime;

    // Process final token string
    if FTokenResponse.Finalize then
    begin
      case FTokenResponse.AddToken('') of
        tpaWait:
        begin
        end;

        tpaAppend:
        begin
          OnNextToken(FTokenResponse.LastWord(False));
        end;

        tpaNewline:
        begin
          OnNextToken(#10);
          OnNextToken(FTokenResponse.LastWord(True));
        end;
      end;
    end;

    OnInferenceEnd();
    OnStatus('TPhinx.RunInference', 'InferenceEnd', []);

  // Clean up allocated resources
  finally
    if Assigned(FAudios) then
    begin
      OgaDestroyAudios(FAudios);
      FAudios := nil;
    end;

    if Assigned(FImages) then
    begin
      OgaDestroyImages(FImages);
      FImages := nil;
    end;

    if Assigned(LGenerator) then
    begin
      OgaDestroyGenerator(LGenerator);
      LGenerator := nil;
    end;

    if Assigned(LGeneratorParams) then
    begin
      OgaDestroyGeneratorParams(LGeneratorParams);
      LGeneratorParams := nil;
    end;

    if Assigned(LSequences) then
    begin
      OgaDestroySequences(LSequences);
      LSequences := nil;
    end;

    if Assigned(LInputTensors) then
    begin
      OgaDestroyNamedTensors(LInputTensors);
      LInputTensors := nil;
    end;
  end;

  Result := True;

  OnStatus(CID, CphStatusEnd, []);
end;

function  TPhinx.GetInferenceResponse(): string;
begin
  Result := FInferenceResponse;
end;

procedure TPhinx.GetPerformance(AInputTokens, AOutputTokens: PUInt32; ASpeed, ATime: PDouble);
begin
  if Assigned(AInputTokens) then
    AInputTokens^ := FInputTokens;

  if Assigned(AOutputTokens) then
    AOutputTokens^ := FOutputTokens;

  if Assigned(ASpeed) then
    ASpeed^ := FTokenSpeed;

  if Assigned(ATime) then
    ATime^ := FElapsedTime;
end;

class function TPhinx.WebSearch(const AQuery: string): string;
begin
  // Return web search result
  Result := phUtils.TavilyWebSearch(phUtils.GetEnvVarValue(CphWebSearchAPIKey), AQuery);
end;

class function TPhinx.TextToSpeech(const AInputText: string; const AOutputFile: string; const AVoice: TphTTSVoices; const ALanguage: TphLanguages): Boolean;
var
  LLang: string;
  LVoice: string;

  function GetVoiceName(Voice: TphTTSVoices): string;
  const
    VoiceNames: array[TphTTSVoices] of string = (
      'heart', 'bella', 'michael', 'alloy', 'aoede', 'kore',
      'jessica', 'nicole', 'nova', 'river', 'sarah', 'sky', 'echo', 'eric',
      'fenrir', 'liam', 'onyx', 'puck', 'adam', 'santa'
    );
  begin
    Result := VoiceNames[Voice];
  end;

begin
  // Get language name
  case ALanguage of
    phUS   : LLang := 'us';
    phUS_GB: LLang := 'us-gb';
  end;

  // Get voice name
  LVoice := GetVoiceName(AVoice);

  // Convert text to speech
  Result := phUtils.LemonfoxTTS(phUtils.GetEnvVarValue(CphTextToSpeechApiKey), AInputText, AOutputFile, LVoice, LLang, 'wav', 1.0, False);
end;

class function TPhinx.Embeddings(const ARole: TphEmbedRole; const AInputs: array of string): TArray<TArray<Single>>;
var
  LRole: string;
begin
  case ARole of
    phDocument: LRole := 'document';
    phQuery   : LRole := 'query';
  end;

  Result := phUtils.JinaEmbeddings(phUtils.GetEnvVarValue(cphJinaApiKey), AInputs, LRole);

end;

procedure TPhinx_BuildModelCallback(const AFilename: PWideChar; const APercentage: Integer; const ANewFile: Boolean; const AUserData: Pointer); cdecl;
var
  LEvent: TphBuildModelProgressEvent;
begin
  LEvent := TphBuildModelProgressEvent(AUserData);
  if Assigned(LEvent) then
    begin
      LEvent(string(AFilename), APercentage, ANewFile);
    end
  else
    begin
      if ANewFile then
        phConsole.PrintLn();
      phConsole.Print(#13'%s(%d%s)...', [string(AFilename), APercentage, '%']);
    end;
end;

class function TPhinx.BuildModel(const AFolder: string; const AFilename: string; const AProgressEvent: TphBuildModelProgressEvent): Boolean;
var
  LFolder: string;
  LFilename: string;
begin
  LFolder := AFolder;
  LFilename := AFilename;
  Result := vfolder_build(PWideChar(LFolder), PWideChar(LFilename), TPhinx_BuildModelCallback, TProc(AProgressEvent));
end;

class procedure TPhinx.PrintLogo(const ATitleColor: string; const AVersionColor: string; const ASubTitleColor: string);
begin
  phConsole.PrintLn('%s   ___ _    _', [ATitleColor]);
  phConsole.PrintLn('%s  | _ \ |_ (_)_ _ __ __™', [ATitleColor]);
  phConsole.PrintLn('%s  |  _/ '' \| | '' \\ \ /', [ATitleColor]);
  phConsole.PrintLn('%s  |_| |_||_|_|_||_/_\_\', [ATitleColor]);
  phConsole.PrintLn('%s         v%s           ', [AVersionColor, CphVersion]);
  phConsole.PrintLn('%s                       ', [ASubTitleColor]);
  phConsole.PrintLn('%s  A High-Performance AI', [ASubTitleColor]);
  phConsole.PrintLn('%s  Inference Library for', [ASubTitleColor]);
  phConsole.PrintLn('%s     ONNX and Phi-4', [ASubTitleColor]);
  phConsole.PrintLn();
end;

{ ============================================================================ }

{$R Phinx.Core.Utils.res}

var
  CCoreUtilsDLLHandle: THandle = 0;
  CCoreUtilsDLLFilename: string = '';

function LoadCoreUtilsDLL(var AError: string): Boolean;
var
  LResStream: TResourceStream;

  function e822790b87354b9791d673c5afcf341f(): string;
  const
    CValue = '63dc65cfbdc34eaeb34ea6702dbf1d68';
  begin
    Result := CValue;
  end;

  procedure SetError(const AText: string; const AArgs: array of const);
  begin
    AError := Format(AText, AArgs);
  end;

begin
  Result := False;
  AError := '';

  if CCoreUtilsDLLHandle <> 0 then Exit;
  try
    if not Boolean((FindResource(HInstance, PChar(e822790b87354b9791d673c5afcf341f()), RT_RCDATA) <> 0)) then
    begin
      SetError('Failed to find CoreUtils DLL resource', []);
      Exit;
    end;

    LResStream := TResourceStream.Create(HInstance, e822790b87354b9791d673c5afcf341f(), RT_RCDATA);
    try
      LResStream.Position := 0;
      CCoreUtilsDLLFilename := TPath.Combine(TPath.GetTempPath, TPath.ChangeExtension(TPath.GetGUIDFileName.ToLower, '.'));

      if not phUtils.HasEnoughDiskSpace(CCoreUtilsDLLFilename, LResStream.Size) then
      begin
        SetError('Not enough disk space to save extracted CoreUtils DLL', []);
        Exit;
      end;

      LResStream.SaveToFile(CCoreUtilsDLLFilename);

      if not TFile.Exists(CCoreUtilsDLLFilename) then
      begin
        SetError('Failed to find extracted CoreUtils DLL', []);
        Exit;
      end;

      CCoreUtilsDLLHandle := LoadLibrary(PChar(CCoreUtilsDLLFilename));
      if CCoreUtilsDLLHandle = 0 then
      begin
        SetError('Failed to load extracted CoreUtils DLL', []);
        Exit;
      end;

      // Get core utils exports
      vfolder_build := GetProcAddress(CCoreUtilsDLLHandle, 'vfolder_build');
      vfolder_new := GetProcAddress(CCoreUtilsDLLHandle, 'vfolder_new');
      vfolder_setVirtualBasePathToEXE := GetProcAddress(CCoreUtilsDLLHandle, 'vfolder_setVirtualBasePathToEXE');
      vfolder_open := GetProcAddress(CCoreUtilsDLLHandle, 'vfolder_open');
      vfolder_openAllFiles := GetProcAddress(CCoreUtilsDLLHandle, 'vfolder_openAllFiles');
      vfolder_getVirtualBasePath := GetProcAddress(CCoreUtilsDLLHandle, 'vfolder_getVirtualBasePath');
      vfolder_close := GetProcAddress(CCoreUtilsDLLHandle, 'vfolder_close');
      vfolder_free := GetProcAddress(CCoreUtilsDLLHandle, 'vfolder_free');

      Result := True;
    finally
      LResStream.Free();
    end;

  except
    on E: Exception do
      SetError('Unexpected error: %s', [E.Message]);
  end;
end;

procedure UnloadCoreUtilsDLL();
begin
  if CCoreUtilsDLLHandle <> 0 then
  begin
    FreeLibrary(CCoreUtilsDLLHandle);
    TFile.Delete(CCoreUtilsDLLFilename);
    CCoreUtilsDLLHandle := 0;
    CCoreUtilsDLLFilename := '';
  end;
end;

initialization
var
  LError: string;
begin
  ReportMemoryLeaksOnShutdown := True;

  SetExceptionMask(GetExceptionMask + [exOverflow, exInvalidOp]);

  if not LoadCoreUtilsDLL(LError) then
  begin
    MessageBox(0, PChar(LError), 'Critical Initialization Error', MB_ICONERROR);
    Halt(1); // Exit the application with a non-zero exit code to indicate failure
  end;

  phConsole.UnitInit();
  phUtils.UnitInit();

end;

finalization
begin
  try
    UnloadCoreUtilsDLL();
  except
    on E: Exception do
    begin
      MessageBox(0, PChar(E.Message), 'Critical Shutdown Error', MB_ICONERROR);
    end;
  end;
end;

end.
