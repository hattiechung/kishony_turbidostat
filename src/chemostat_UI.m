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
global relayBoxes state whichPumps parameters

% initialize which pumps are active 
parameters = varargin{1}; 

% collect indices of first pumps for all active tubes
totalNumTubes = parameters.numTubes; % total number of tubes
whichPumps = [];
for j = 1:totalNumTubes
    whichPumps(end+1) = 3*(j-1)+1;
end

[ai, relayBoxes] = initializemorbidostat;




% --- Outputs from this function are returned to the command line.
function varargout = chemostat_UI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

global state whichPumps 

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

global relayBoxes whichPumps state parameters

secondsOfDilution = parameters.addLiquidTime; % # of seconds to add media
secondsOfPause = parameters.waitTime;

% check states
drawnow; 
pState = get(handles.pause, 'Value'); 
rState = get(handles.refill, 'Value'); 
sState = get(handles.start, 'Value'); 
state = [pState rState sState];

while isequal(state, [0 0 1])
    % turn on active pumps 
    pumps = zeros(1,48);
    for i = whichPumps
        pumps(i) = 1; 
    end
    switchpumps(pumps, relayBoxes);

    % wait appropriate number of seconds
    sprintf('Adding %d seconds of liquid', secondsOfDilution); 
    pause(secondsOfDilution);

    % check states
    drawnow; 
    pState = get(handles.pause, 'Value'); 
    rState = get(handles.refill, 'Value'); 
    sState = get(handles.start, 'Value'); 
    state = [pState rState sState];

    % turn off active pumps 
    switchpumps(zeros(1,48), relayBoxes);

    % check states
    drawnow; 
    pState = get(handles.pause, 'Value'); 
    rState = get(handles.refill, 'Value'); 
    sState = get(handles.start, 'Value'); 
    state = [pState rState sState];
    
    if eq(state, [0 0 1])
        % wait appropriate number of seconds 
        sprintf('Waiting %d seconds before adding liquid again', secondsOfPause); 
        pause(secondsOfPause);
    else
        break 
    end

end
