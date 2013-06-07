function varargout = chemostat_UI(varargin)
% CHEMOSTAT_UI M-file for chemostat_UI.fig
%      CHEMOSTAT_UI, by itself, creates a new CHEMOSTAT_UI or raises the existing
%      singleton*.
%
%      H = CHEMOSTAT_UI returns the handle to a new CHEMOSTAT_UI or the handle to
%      the existing singleton*.
%
%      CHEMOSTAT_UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHEMOSTAT_UI.M with the given input arguments.
%
%      CHEMOSTAT_UI('Property','Value',...) creates a new CHEMOSTAT_UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before chemostat_UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to chemostat_UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help chemostat_UI

% Last Modified by GUIDE v2.5 05-Nov-2012 11:41:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @chemostat_UI_OpeningFcn, ...
                   'gui_OutputFcn',  @chemostat_UI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before chemostat_UI is made visible.
function chemostat_UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to chemostat_UI (see VARARGIN)

% Choose default command line output for chemostat_UI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% ___ Initialization ___ %
global relayBoxes state whichPumps parameters growthPhaseData iPhase initialization 

parameters = varargin{1}; 

% collect indices of first pump for all active tubes
% WRITE: Switch between 1st, 2nd, 3rd, or all tubes  
activeTubes = parameters.activeCultures; 
whichPumps = [];
for j = activeTubes
    whichPumps(end+1) = 3*(j-1)+1;  % <--- change here for other pumps
end

% Initialize variables
[ai, relayBoxes] = initializemorbidostat;
sampleRate = get(ai, 'SampleRate'); 
experimentStartTime = datenum(clock); 
parameters.startTime = experimentStartTime; 

% Store initialized var
initialization.ai = ai; 
initialization.sampleRate = sampleRate; 
initialization.experimentStartTime = experimentStartTime; 

% Initialize OD saving data structure
nPhase = 10000; 
for iPhase = 1:nPhase
    growthPhaseData(iPhase).sampleOD = zeros(0,15); 
    growthPhaseData(iPhase).sampleTime = zeros(0,1); 

    growthPhaseData(iPhase).startOD = zeros(1,15); 
    growthPhaseData(iPhase).growthRate = zeros(1,15); 
    growthPhaseData(iPhase).endOD = zeros(1,15); 
end

iPhase = 1; 


% --- Outputs from this function are returned to the command line.
function varargout = chemostat_UI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

global state

% Grab radio button states
pState = get(handles.pause, 'Value'); 
rState = get(handles.refill, 'Value'); 
sState = get(handles.start, 'Value'); 
state = [pState rState sState];


% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
% hObject    handle to pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Exclusive selection 
set(handles.refill, 'Value', 0); 
set(handles.start, 'Value', 0);

% print statement
disp('Entering pause state'); 

% Declare global variables
global state relayBoxes whichPumps 

% Save current state
beep 

% Turn off all pumps
% putvalue(relaybox1.Line(1:24),0); 
% putvalue(relaybox2.Line(1:24),0); 
switchpumps(zeros(1,48), relayBoxes);


% --- Executes on button press in refill.
function refill_Callback(hObject, eventdata, handles)
% hObject    handle to refill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Exclusive selection
set(handles.pause, 'Value', 0); 
set(handles.start, 'Value', 0); 

% print statement
disp('Entering refill state'); 

global state relayBoxes whichPumps

% turn on active pumps 
pumps = zeros(1,48);
for i = whichPumps
    pumps(i) = 1; 
end
switchpumps(pumps, relayBoxes);


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Exclusive selection
set(handles.pause, 'Value', 0); 
set(handles.refill, 'Value', 0); 

% print statement
disp('Entering start state'); 

global parameters iPhase initialization relayBoxes growthPhaseData whichPumps state

secondsOfDilution = parameters.addLiquidTime; % # of seconds to add media
secondsOfPause = parameters.waitTime;

pState = get(handles.pause, 'Value'); 
rState = get(handles.refill, 'Value'); 
sState = get(handles.start, 'Value'); 
state = [pState rState sState];
    
while isequal(state, [0 0 1])
    % Measure OD (time is an implicit variable) 
    growthPhaseData = ODmeter(parameters, iPhase, initialization, ...
            relayBoxes, growthPhaseData, handles); 
    
    % Setup plot 
    figure(1); hold on; 

    % Plot
    for i = parameters.activeCultures
        subplot(5,3,i); 
        for j = iPhase
            plot( growthPhaseData(j).sampleTime/3600, growthPhaseData(j).sampleOD(:,i), 'LineWidth', 2); 
            hold on; 
            ylim([-0.2 1.0]); 
            title( num2str(i), 'FontSize', 16, 'FontWeight', 'bold'); 
            xlabel('Time (hr)', 'FontSize', 14, 'FontWeight', 'bold');
            ylabel('OD', 'FontSize', 14, 'FontWeight', 'bold'); 
        end
    end

    % ___ DILUTION ___ %
    % turn on active pumps 
    pumps = zeros(1,48);
    pumps(whichPumps) = 1; 
    switchpumps(pumps, relayBoxes);
    % dilute
    sprintf('Adding %d seconds of liquid', secondsOfDilution); 
    pause(secondsOfDilution);

    % ___ WAITING ___ %
    % turn off active pumps 
    switchpumps(zeros(1,48), relayBoxes);

    % check states
    drawnow; 
    pState = get(handles.pause, 'Value'); 
    rState = get(handles.refill, 'Value'); 
    sState = get(handles.start, 'Value'); 
    state = [pState rState sState];
    
    if eq(state, [0 0 1])
        % WAIT  
        sprintf('Waiting %d seconds before adding liquid again', secondsOfPause); 
        pause(secondsOfPause);
        % Get OD  
    else
        % Save Data 
        disp('exiting'); 
        break 
    end

    iPhase = iPhase+1; 

end
