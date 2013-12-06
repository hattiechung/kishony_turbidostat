function varargout = morbidostat_UI(varargin)
% MORBIDOSTAT_UI MATLAB code for morbidostat_UI.fig
%      MORBIDOSTAT_UI, by itself, creates a new MORBIDOSTAT_UI or raises the existing
%      singleton*.
%
%      H = MORBIDOSTAT_UI returns the handle to a new MORBIDOSTAT_UI or the handle to
%      the existing singleton*.
%
%      MORBIDOSTAT_UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MORBIDOSTAT_UI.M with the given input arguments.
%
%      MORBIDOSTAT_UI('Property','Value',...) creates a new MORBIDOSTAT_UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before morbidostat_UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to morbidostat_UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
% Edit the above text to modify the response to help morbidostat_UI
%
% Last Modified by GUIDE v2.5 06-Apr-2012 15:26:26
%
% Adapted from turbidostat_UI by Laura Stone 01-Nov-2013

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @morbidostat_UI_OpeningFcn, ...
    'gui_OutputFcn',  @morbidostat_UI_OutputFcn, ...
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


% --- Executes just before morbidostat_UI is made visible.
function morbidostat_UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to morbidostat_UI (see VARARGIN)

% Choose default command line output for morbidostat_UI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZATION
global parameters iPhase pauses nPhase initialization relayBoxes ...
    growthPhaseData dilutionPhaseData state

parameters = varargin{1};

% Initialize variables
[ai, relayBoxes] = initializemorbidostat;
sampleRate = get(ai, 'SampleRate');
experimentStartTime = datenum(clock);
parameters.startTime = experimentStartTime;

% Store initialized variables
initialization.ai = ai;
initialization.sampleRate = sampleRate;
initialization.experimentStartTime = experimentStartTime;

%Initialize Data Structures
nPhase=10000;
for iPhase=1:nPhase
    growthPhaseData(iPhase).sampleOD = zeros(0, 15);
    growthPhaseData(iPhase).sampleTime = zeros(0, 1);
    
    growthPhaseData(iPhase).startOD = zeros(1,15);
    growthPhaseData(iPhase).growthRate = zeros(1,15);
    growthPhaseData(iPhase).endOD = zeros(1,15);
    
    dilutionPhaseData(iPhase).dilution = zeros(1,15);   %this does not appear to be used.
    dilutionPhaseData(iPhase).sampleOD = zeros(0,15);
    dilutionPhaseData(iPhase).sampleTime = zeros(0,1);
    dilutionPhaseData(iPhase).pumpStates = zeros(0,48);
end

% Check for data from previous pauses
if exist('indexfromUI.mat') ~= 0
    oldIndex = load('indexfromUI.mat');
    iPhase = oldIndex.iPhase;
    pauses = oldIndex.pauses;
else
    iPhase = 1;
    pauses = 0;
end



% --- Outputs from this function are returned to the command line.
function varargout = morbidostat_UI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
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

% Declare global variables
global iPhase pauses nPhase state relayBoxes

% Save current state
beep
pauses = pauses+1;
save('indexfromUI.mat', 'iPhase', 'pauses')

% Turn off all pumps
switchpumps(zeros(1,48), relayBoxes);

% --- Executes on button press in refill.
function refill_Callback(hObject, eventdata, handles)
% hObject    handle to refill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Exclusive selection
set(handles.pause, 'Value', 0);
set(handles.start, 'Value', 0);

% Declare global variables
global iPhase pauses nPhase state relayBoxes parameters

for i = parameters.activeCultures
    for k = 1:3
        pumps(parameters.activeCultures(i)*3-3+k) = 1 ;
        % Culture tube 1 corresponds to pumps 1-3, culture tube 2
        % corresponds to pumps 4-6, etc.
        % This turns on all pumps. Is that what we want? LKS
    end
end
% LKS

switchpumps(pumps, relayBoxes);
% Turns on all pumps for active culture tubes.

% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Exclusive selection
set(handles.refill, 'Value', 0);
set(handles.pause, 'Value', 0);

% Declare global variables
global parameters iPhase pauses nPhase initialization relayBoxes ...
    growthPhaseData dilutionPhaseData state

switchpumps(zeros(1,48), relayBoxes);

while iPhase<nPhase
    
    % Check state of UI
    drawnow;
    pState = get(handles.pause, 'Value');
    rState = get(handles.refill, 'Value');
    sState = get(handles.start, 'Value');
    ui_state = [pState rState sState];
    
    if eq(ui_state,[0 0 1])
        % ___ Measure ___ %
        % Maintain target OD with growth and dilution phases
        [growthPhaseData, dilutionPhaseData] = growth_dilution_morbidostat(parameters, iPhase, initialization, ...
            relayBoxes, growthPhaseData, dilutionPhaseData, handles); %LKS
        
        % ___ Plot ___ %
        % Setup plot
        figure(1);
        hold on;
        ylim([0 1.0]);
        % Plot
        for i = parameters.activeCultures
            subplot(5,3,i);
            for j = iPhase
                plot( growthPhaseData(j).sampleTime/3600, growthPhaseData(j).sampleOD(:,i), 'LineWidth', 2 );
                hold on;
                plot( dilutionPhaseData(j).sampleTime/3600, dilutionPhaseData(j).sampleOD(:,i), 'LineWidth', 2 );
                ylim([-0.2 1.0]);
                title( num2str(i), 'FontSize', 16, 'FontWeight', 'bold' );
                xlabel('Time (hours)', 'FontSize', 14, 'FontWeight', 'bold');
                ylabel('OD', 'FontSize', 14, 'FontWeight', 'bold');
            end
        end
        
        % Increment iPhase
        iPhase = iPhase+1;
        
    else
        return
    end
end


