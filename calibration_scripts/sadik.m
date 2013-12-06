function varargout = sadik(varargin)
% SADIK MATLAB code for sadik.fig
%      SADIK, by itself, creates a new SADIK or raises the existing
%      singleton*.
%
%      H = SADIK returns the handle to a new SADIK or the handle to
%      the existing singleton*.
%
%      SADIK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SADIK.M with the given input arguments.
%
%      SADIK('Property','Value',...) creates a new SADIK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sadik_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sadik_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sadik

% Last Modified by GUIDE v2.5 06-Feb-2012 11:41:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @sadik_OpeningFcn, ...
    'gui_OutputFcn',  @sadik_OutputFcn, ...
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


% --- Executes just before sadik is made visible.
function sadik_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sadik (see VARARGIN)



%
clear global;
goIcon = importdata('images\PerspectiveButtonGoIcon.jpg');
stopIcon = importdata('images\PerspectiveButtonStopIcon.jpg');
shutdownIcon = importdata('images\ShutdownIcon.jpg');
greenDrugIcon = importdata('images\Green-Poison.jpg');
pinkDrugIcon = importdata('images\Love-Poison.jpg');

set(handles.pushbutton1,'CDATA',stopIcon);
set(handles.pushbutton3,'CDATA',stopIcon);
set(handles.pushbutton5,'CDATA',stopIcon);
set(handles.pushbutton2,'CDATA',goIcon);
set(handles.pushbutton4,'CDATA',goIcon);
set(handles.pushbutton6,'CDATA',goIcon);
set(handles.pushbutton7,'CDATA',shutdownIcon);

set(handles.pushbuttonTube1,'CDATA',pinkDrugIcon);
set(handles.pushbuttonTube2,'CDATA',pinkDrugIcon);
set(handles.pushbuttonTube3,'CDATA',pinkDrugIcon);
set(handles.pushbuttonTube4,'CDATA',pinkDrugIcon);
set(handles.pushbuttonTube5,'CDATA',pinkDrugIcon);
set(handles.pushbuttonTube6,'CDATA',pinkDrugIcon);
set(handles.pushbuttonTube7,'CDATA',pinkDrugIcon);
set(handles.pushbuttonTube8,'CDATA',pinkDrugIcon);
set(handles.pushbuttonTube9,'CDATA',pinkDrugIcon);
set(handles.pushbuttonTube10,'CDATA',pinkDrugIcon);
set(handles.pushbuttonTube11,'CDATA',pinkDrugIcon);
set(handles.pushbuttonTube12,'CDATA',pinkDrugIcon);
set(handles.pushbuttonTube13,'CDATA',pinkDrugIcon);
set(handles.pushbuttonTube14,'CDATA',pinkDrugIcon);
set(handles.pushbuttonTube15,'CDATA',pinkDrugIcon);

set(handles.pushbuttonTube1b,'CDATA',greenDrugIcon);
set(handles.pushbuttonTube2b,'CDATA',greenDrugIcon);
set(handles.pushbuttonTube3b,'CDATA',greenDrugIcon);
set(handles.pushbuttonTube4b,'CDATA',greenDrugIcon);
set(handles.pushbuttonTube5b,'CDATA',greenDrugIcon);
set(handles.pushbuttonTube6b,'CDATA',greenDrugIcon);
set(handles.pushbuttonTube7b,'CDATA',greenDrugIcon);
set(handles.pushbuttonTube8b,'CDATA',greenDrugIcon);
set(handles.pushbuttonTube9b,'CDATA',greenDrugIcon);
set(handles.pushbuttonTube10b,'CDATA',greenDrugIcon);
set(handles.pushbuttonTube11b,'CDATA',greenDrugIcon);
set(handles.pushbuttonTube12b,'CDATA',greenDrugIcon);
set(handles.pushbuttonTube13b,'CDATA',greenDrugIcon);
set(handles.pushbuttonTube14b,'CDATA',greenDrugIcon);
set(handles.pushbuttonTube15b,'CDATA',greenDrugIcon);
%
set(handles.calibrationPanel,'visible','off');
set(handles.turbidostatPanel,'visible','off');
set(handles.uipanelExpAlgo,'SelectionChangeFcn',...
    {@uipanelExpAlgo_SelectionChangeFcn,handles}); 
%
global ai;


global relaybox1;

global relaybox2;

defineDaqDevices();

%putvalue(relaybox1.Line(1:24), 0)
% putvalue(relaybox2.Line(1:24), 0)

% Choose default command line output for sadik
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sadik wait for user response (see UIRESUME)
% uiwait(handles.figureMain);

function defineDaqDevices()

global ai relaybox1 relaybox2;

ai = analoginput('mcc',0); %This line adds an analog device (USB-1616FS) with ID=1.

channels=addchannel(ai,0:14);%adds a channel, USB1616FS has 16 differential channels (0...15)

relaybox1 = digitalio('mcc',1);%This line adds a digital I/O device (USB-ERB24) with ID=2.

pumpset1 = addline(relaybox1, 0:7,0, 'out',{'pump1';'pump2';'pump3';'pump4';'pump5';'pump6';'pump7';'pump8'});
pumpset2= addline(relaybox1, 0:7,1, 'out',{'pump9';'pump10';'pump11';'pump12';'pump13';'pump14';'pump15';'pump16'});
pumpset3 = addline(relaybox1, 0:3,2, 'out',{'pump17';'pump18';'pump19';'pump20'});
pumpset4 = addline(relaybox1, 0:3,3, 'out',{'pump21';'pump22';'pump23';'pump24'});%relaybox lines are defined

relaybox2 = digitalio('mcc',2);%This line adds a digital I/O device (USB-ERB24) with ID=2.

pumpset5 = addline(relaybox2, 0:7,0, 'out',{'pump25';'pump26';'pump27';'pump28';'pump29';'pump30';'pump31';'pump32'});
pumpset6= addline(relaybox2, 0:7,1, 'out',{'pump33';'pump34';'pump35';'pump36';'pump37';'pump38';'pump39';'pump40'});
pumpset7 = addline(relaybox2, 0:3,2, 'out',{'pump41';'pump42';'pump43';'pump44'});
pumpset8 = addline(relaybox2, 0:3,3, 'out',{'pump45';'pump46';'pump47';'pump48'});%relaybox lines are defined

%% Stop all pumps
putvalue(relaybox1.Line(1:24), 0)
putvalue(relaybox2.Line(1:23), 0)

%% Suction pump put 1- turn on
putvalue(relaybox2.Line(24), 0)

% --- Outputs from this function are returned to the command line.
function varargout = sadik_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function togglebuttonOutflow_Callback(hObject, eventdata, handles)


function togglebuttonMedia_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1
global relaybox1;
global relaybox2;
button_state = get(hObject,'Value');

if strcmp( get(get(hObject,'parent'), 'Title') , 'Media')
    % get(hObject,'Value')=1 if opened now, =0 if closed now
    position = (3 * str2num(get(hObject,'String')) - 2);
    if position <= 24
        putvalue(relaybox1.Line(position), button_state );
    else
        putvalue(relaybox2.Line(mod(position,24)), button_state);
    end
    
    if button_state %%change the color of button
        set(hObject,'BackgroundColor', [0.408 1.0 0.35]);
    else
        set(hObject,'BackgroundColor', [0.408 0.729 0.35]);
    end
else if strcmp( get(get(hObject,'parent'), 'Title') , 'Drug A')
        % get(hObject,'Value')=1 if opened now, =0 if closed now
        position = (3 * str2num(get(hObject,'String')) - 1);
        if position <= 24
            putvalue(relaybox1.Line(position), button_state );
        else
            putvalue(relaybox2.Line(mod(position,24)), button_state);
        end
        
        if button_state %%change the color of button
            set(hObject,'BackgroundColor', [1.0 1.0 0]);
        else
            set(hObject,'BackgroundColor', [1 0.808 0]);
        end
    else if strcmp( get(get(hObject,'parent'), 'Title') , 'Drug B')
            % get(hObject,'Value')=1 if opened now, =0 if closed now
            position = 3 * str2num(get(hObject,'String'));
            if position <= 24
                putvalue(relaybox1.Line(position), button_state );
            else
               putvalue(relaybox2.Line(position-24), button_state);
            end
            
            if button_state %%change the color of button
                set(hObject,'BackgroundColor', [1.0 0.192 0.192]);
            else
                set(hObject,'BackgroundColor', [0.792 0.118 0]);
            end
        end
    end
end

guidata(hObject, handles);

function buttonOnAllDrugB_Callback(hObject, eventdata, handles)

global relaybox1;
global relaybox2;

for i=31:45 %togglebutton tag numbers
    indexTag = sprintf('togglebutton%d', i);
    object = findobj('Tag',indexTag);
    button_state = get(object,'Value');
    if ~button_state
        set(object,'Value',1);
        sadik('togglebuttonMedia_Callback',object,eventdata,guidata(object))
    end
end



function buttonOffAllDrugB_Callback(hObject, eventdata, handles)

global relaybox1;
global relaybox2;

for i=31:45 %togglebutton tag numbers
    indexTag = sprintf('togglebutton%d', i);
    object = findobj('Tag',indexTag);
    button_state = get(object,'Value');
    if button_state
        set(object,'Value',0);
        sadik('togglebuttonMedia_Callback',object,eventdata,guidata(object))
    end
end

function buttonOnAllDrugA_Callback(hObject, eventdata, handles)

global relaybox1;
global relaybox2;

for i=16:30 %togglebutton tag numbers
    indexTag = sprintf('togglebutton%d', i);
    object = findobj('Tag',indexTag);
    button_state = get(object,'Value');
    if ~button_state
        set(object,'Value',1);
        sadik('togglebuttonMedia_Callback',object,eventdata,guidata(object))
    end
end

function buttonOffAllDrugA_Callback(hObject, eventdata, handles)

global relaybox1;
global relaybox2;

for i=16:30 %togglebutton tag numbers
    indexTag = sprintf('togglebutton%d', i);
    object = findobj('Tag',indexTag);
    button_state = get(object,'Value');
    if button_state
        set(object,'Value',0);
        sadik('togglebuttonMedia_Callback',object,eventdata,guidata(object))
    end
end


function buttonOnAllMedia_Callback(hObject, eventdata, handles)

global relaybox1;
global relaybox2;

for i=1:15
    indexTag = sprintf('togglebutton%d', i);
    object = findobj('Tag',indexTag);
    button_state = get(object,'Value');
    if ~button_state
        set(object,'Value',1);
        sadik('togglebuttonMedia_Callback',object,eventdata,guidata(object))
    end
end

function buttonOffAllMedia_Callback(hObject, eventdata, handles)

global relaybox1;
global relaybox2;

for i=1:15
    indexTag = sprintf('togglebutton%d', i);
    object = findobj('Tag',indexTag);
    button_state = get(object,'Value');
    if button_state
        set(object,'Value',0);
        sadik('togglebuttonMedia_Callback',object,eventdata,guidata(object))
    end
end


% --- Executes on button press in pushbutton7.
function shutdown_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global relaybox1;
global relaybox2;

for i=1:45 %togglebutton tag numbers
    indexTag = sprintf('togglebutton%d', i);
    object = findobj('Tag',indexTag);
    button_state = get(object,'Value');
    if button_state
        set(object,'Value',0);
        sadik('togglebuttonMedia_Callback',object,eventdata,guidata(object))
    end
end

putvalue(relaybox2.Line(24),1)

% --- Executes on button press in pushbuttonExperiment.
function pushbuttonExperiment_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonExperiment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.calibrationPanel,'visible','off');
set(handles.pumpsPanel,'visible','off');
set(handles.turbidostatPanel,'visible','on');

% DECLARATIONS OF PARAMETERS

global activeTubes;
global activeTubeNumber;
global activeTubeIndices;
global firstIndiceOfSecondRelayBox;

global threshold;
global dilutionfactor;
global dilthr;
global tcycle;
global tgrowth;
global tdil;
global Algo;
global maxGrowth;
%DRUGS
global Labels;
global SecType;
global expConsts;
%ADVANCED
global map;
global w;
global toffset;
global plotupdate;
global delaytime;
global datasave;
global listbg;

global days;
global experiment;

global label;
global time0;
global dumpData;
global smoothData;
global cycle;

global rParametersReady;

global listratio;

%ASSIGN DEFAULT PARAMETERS

activeTubeIndices = 1:15;
activeTubeNumber = 15;
activeTubes = ones(1,15);
rParametersReady = 0; % it equals one if parameters are all loaded successfully
listbg = zeros(1,15);

dilutionfactor=ones(1,15)*0.83; %Dilution strenght   
Algo = ones(1,15)*400;% Injection algorithm %21 is drug A->B->A->..,   22 is AA->BB->AA->BB ,  11 is A->A->A...
threshold = ones(1,15) * 1000; % starts with chemostat
maxGrowth=0.000001;%max growth within a cycle if it starts from threshold and grows in maximum rate
%DRUGS
Labels = {'CHL','DOXY','TMP','growth rate'}; %Drug label struct
SecType = 4*ones(1,15); %For i, matches the label of the secondary graph of i to SecType{i}
expConsts.stockA=[4000 4000 4000 4000 4000 200 200 200 200 200 2000 2000 2000 2000 2000; 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; %%Contents of Bottles A
expConsts.stockB=[4000 4000 4000 4000 4000 200 200 200 200 200 2000 2000 2000 2000 2000; 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];%%Contents of Bottles B

for i=1:15
    setOneTube(i,'',Labels(1),cellstr(num2str(expConsts.stockA(i))));
    setOneTube(i,'b',Labels(2),cellstr(num2str(expConsts.stockB(i))));
end

%ADVANCED
map = [.662 0.2 0.166; 0.54 0.133 0.36; 0.38 0.12 0.45; 0.29 0.14 0.46; 0.16 0.18 0.47; 0.14 0.25 0.45; 0.12 0.31 0.43; 0.10 0.41 0.40; 0.11 0.48 0.28; 0.27 0.58 0.14; 0.43 0.62 0.15; 0.54 0.65 0.16; 0.67 0.60 0.16; 0.67 0.44 0.16; 0.67 0.16 0.17];%Color for the primary graph.
w=10;%Smoothing window size
toffset=0;%change this number if the program crashes for some reason. i.e. the program crashed after 2 days and 4 hours, toffset= 2*86400+4*3600;
datasave=1200;

listratio =   [0.5000  0.4180  0.4430  0.6100  0.4900 0.5290  0.4860 0.4610  0.4410  0.3700  0.5770 0.4870 0.5070  0.5120 0.4480]; %% listratio taken in 12.14.2011, 3.58pm in g002
%=[1.018,1.688,1.117,0.895,1.109,0.728,0.792,2.653,0.920,0.997,0.844,1.428,1.884,1.211,0.978];%take from the calibration gui
% --- Executes on button press in pushbuttonPumps.
function pushbuttonPumps_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPumps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.calibrationPanel,'visible','off');
set(handles.turbidostatPanel,'visible','off');
set(handles.pumpsPanel,'visible','on');

% --- Executes on button press in pushbuttonCalibration.
function pushbuttonCalibration_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCalibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pumpsPanel,'visible','off');
set(handles.turbidostatPanel,'visible','off');
set(handles.calibrationPanel,'visible','on');
set(handles.pushbuttonAddSample,'UserData',1);
set(handles.pushbuttonLineFit,'Enable','off');


% Load numbers into matlab!
% sounds(j) are numbers 1,16 for j=1:16., j=17 is beep, j=18 is gong.

global sounds;
global ai; 
global data;
global realod;



for i=1:16
    fileloc = ['numbers/' num2str(i) '.wav'];
    sounds(i).y = readwav(fileloc);
end
fileloc = ['numbers/' 'beep' '.wav'];
sounds(17).y = readwav(fileloc);

fileloc = ['numbers/' 'gong' '.wav'];
sounds(18).y = readwav(fileloc);

% --- Executes during object creation, after setting all properties.
function editTubeNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTubeNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function editBlockbg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBlockbg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function editDurationbg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDurationbg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonAddSample.
function pushbuttonAddSample_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonAddSample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ai;
global sounds;
global data;
global realod;
global tubeNum;


pass = get(hObject,'UserData'); % if it is first sample or it has been reset

if pass == 1 % if it is first sample or it has been reset
    tubeNum = str2double(get(handles.editTubeNum,'String'));
end
tubeDelay = str2double(get(handles.editDelayTubes,'String'));

blockbg = 600;
durationbg = 10;
sampleRate = 1000;

listratio = ones(1,tubeNum);

set(ai,'sampleRate',sampleRate);
set(ai,'SamplesPerTrigger',blockbg*durationbg);

%
set(handles.textStatus,'String','Calibration is running...');
guidata(hObject,handles);
%
% Calibration
if pass == 1 % if it is first sample or it has been reset
    data = zeros(30,tubeNum); %Blank data array
    realod = zeros(1,30);
end

set(handles.textStatus,'String',['Calibration ',num2str(pass),' in progress']);
set(handles.textMonitorSample,'String',num2str(pass));

for i=1:tubeNum
    set(handles.textMonitorTube,'String',num2str(i));
    wavplay(sounds(i).y,8000)
        pause(tubeDelay);
    wavplay(sounds(17).y,8000);
    
    %Acquire the data
    start(ai);
    tmpraw_0=median(getdata(ai));
    set(handles.textStatus,'String',['Data is acquired for tube ',num2str(i),'.']);
    
    %Copy the data do the proper slots
    data(pass,i) = tmpraw_0(i);
    wavplay(sounds(18).y,8000);
end
set(handles.textStatus,'String',['Calibration ended for sample ', num2str(pass), '. Waiting for OD input...']);
prompt={'OD for this pass was :'};
name='Result for OD';
numlines=1;
defaultanswer={'0.0'};
answer_od=inputdlg(prompt,name,numlines,defaultanswer);
realod(pass) = str2double(answer_od);

pass = pass + 1;
set(hObject,'UserData',pass);
if(pass >= 3)
    set(handles.pushbuttonLineFit,'Enable','on');
end

data = data(find(realod),:);
realod = realod(find(realod));

[r,c]=size(data);
od=transpose(realod);

factor=zeros(2,tubeNum);
odfit=zeros(r,tubeNum);

if(get(handles.pushbuttonLineFit,'UserData'))
    for i=1:tubeNum
        cal=robustfit(data(:,i),od);
        factor(1,i)=cal(1);
        factor(2,i)=cal(2);
        odfit(:,i)=factor(1,i)+factor(2,i)*data(:,i);
    end
end

for i=1:tubeNum
    subplot(5,3,i)
    plot(data(:,i),od,'rs','LineWidth',2,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','g',...
        'MarkerSize',10)
    xlabel('volts','FontSize',8)
    ylabel('OD','FontSize',8)
    %xlim([0 1.2])
    %legend('num2str(factor(2,i))')
    
    hold on
    if(get(handles.pushbuttonLineFit,'UserData'))
        plot(data(:,i),odfit(:,i),'-r')
        grid on
        text(.6,0.6,['1 Volt = ',num2str(factor(2,i), 2),'  OD'],'FontSize',8);
    end
end

if(get(handles.pushbuttonLineFit,'UserData'))
    listratio=0.001*floor(1000*factor(2,:));
end
set(handles.editTubeNum, 'Enable','off'); %lock the tubeNum

function editDelayTubes_Callback(hObject, eventdata, handles)
% hObject    handle to editDelayTubes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDelayTubes as text
%        str2double(get(hObject,'String')) returns contents of editDelayTubes as a double


% --- Executes during object creation, after setting all properties.
function editDelayTubes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDelayTubes (see GCBOa)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonStopCalibration.
function pushbuttonStopCalibration_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonStopCalibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbuttonResetCalibration.
function pushbuttonResetCalibration_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonResetCalibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.pushbuttonAddSample,'UserData',1);
set(handles.editTubeNum, 'Enable','on');
set(handles.pushbuttonLineFit,'Enable','off');
%delete(handles.axes1);
guidata(hObject,handles);

% --- Executes on button press in pushbuttonLineFit.
function pushbuttonLineFit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonLineFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject,'UserData', get(hObject,'Value'));
guidata(hObject,handles);


% --- Executes on button press in pushbuttonEnterFreshBackground.
function pushbuttonEnterFreshBackground_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonEnterFreshBackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global listbg;
global activeTubeNumber;
global activeTubeIndices;

prompt_list = cell(size(15));
for i=1:activeTubeNumber
    prompt_list(i) = cellstr(strcat(num2str(activeTubeIndices(i)),': '));
end
prompt = prompt_list;
dlg_title = ['Enter Fresh Background Values'];
num_lines = 1;

%load last old data
tmp = load('oldBackgroundValues.mat', '-regexp', 'oldBg*');
fields = fieldnames(tmp);

tmp =  tmp.(fields{numel(fields)});

def = cell(size(15));
for i=1:activeTubeNumber
    def(i) = cellstr(num2str(tmp(activeTubeIndices(i))));
end
%def = {'0.144502937361715','0.0907911802853434','0.212863355458914','0.144502937361715','0.0907911802853434','0.212863355458914'};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer = inputdlg(prompt,dlg_title,num_lines,def,options);

temp = str2num(char(answer));
for i=1:activeTubeNumber
    listbg(activeTubeIndices(i))=temp(i);
end

logtemp = strcat({'Fresh background values have taken: '},num2str(listbg(find(listbg))));
pushLog(char(logtemp),handles);

function updateCurrentActiveTubeNumbers()

    global activeTubeNumber;
    global activeTubeIndices;
    
    global firstIndiceOfSecondRelaybox;
    
    totalActive = 0;
    activeTubeIndices = zeros(1,15);
    for i=1:15
        checkTag = 'checkboxTube';
        checkTag = strcat(checkTag,num2str(i));
        checkObj = findobj('Tag',checkTag);
        totalActive = totalActive + get(checkObj,'Value');
        if get(checkObj,'Value') 
            activeTubeIndices(totalActive) = i;
        end
    end
    
    activeTubeNumber = totalActive;
    
    for i=1:15
        if activeTubeIndices(i>8)
            firstIndiceOfSecondRelaybox = i;
            break;
        end
    end
        
% --- Executes on button press in pushbutton21.
function pushbuttonSetDrugConcs_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.uipanelDrugConcs,'visible') , 'off')
    set(handles.uipanelDrugConcs,'visible','on');
else
    set(handles.uipanelDrugConcs,'visible','off');
end
function editThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to editThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editThreshold as text
%        str2double(get(hObject,'String')) returns contents of editThreshold as a double


% --- Executes during object creation, after setting all properties.
function editThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function editDilthr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDilthr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function editTcycle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTcycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTdil_Callback(hObject, eventdata, handles)
% hObject    handle to editTdil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTdil as text
%        str2double(get(hObject,'String')) returns contents of editTdil as a double


% --- Executes during object creation, after setting all properties.
function editTdil_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTdil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function editDelaytime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDelaytime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editPlotupdate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPlotupdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbuttonLoadParameters.
function pushbuttonLoadParameters_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonLoadParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ai relaybox1 relaybox2;
global threshold dilthr tcycle tdil delaytime plotupdate days; %manuals
global dilutionfactor tgrowth Algo maxGrowth; %params
global Labels SecType expConsts; %drugs
global map w toffset datasave time0 dumpData smoothData cycle listratio label;
global CycleData Flags LogicChoice;
global experiment Fig;

global blockbg durationbg offset listbg tmp_0 block duration t0;

    if strcmp(get(handles.editThreshold,'Enable'),'on')
        threshold = ones(1,15) * str2num(get(handles.editThreshold,'String'));  %Drug injection threshold
    end
    dilthr = ones(1,15) * str2num(get(handles.editDilthr,'String')); %Dilution will stop if OD<dilthr
    tcycle = ones(1,15) * str2num(get(handles.editTcycle,'String')); %Growth Cycle Duration (time betweend dilutions)
    tdil = str2num(get(handles.editTdil,'String')); %dilution time sec
    tgrowth=tcycle(1); %growth time


for i=1:15
    setOneTube(i,'',Labels(1),cellstr(num2str(expConsts.stockA(i))));
    setOneTube(i,'b',Labels(2),cellstr(num2str(expConsts.stockB(i))));
end

%ADVANCED
    plotupdate = str2num(get(handles.editPlotupdate,'String'));%%refreshes the plot every ## seconds
    delaytime = str2num(get(handles.editDelaytime,'String'));% sec dilutions won't start before that many seconds pass, delay should be larger than 30 seconds.
	days = str2num(get(handles.editDays,'String'));
    experiment=floor(days*24*60*60);

label=datenum(now); %% generates a time Label for experiment
time0=zeros(1,15);
dumpData = zeros(experiment,16);%%preallocate a matrix for decision making and fitting operations
smoothData = zeros(1,16);%preallocate a matrix for decision making and fitting operationstic

cycle=ones(1,15)*2;%%????

%get listratio from calibration gui
daqreset;

defineDaqDevices();

pushLog('Daq devices are initialized.',handles);
%%
%read background (either read freshly or load from past data)
blockbg = 600;
durationbg = 10;
set(ai,'SampleRate',1000,'SamplesPerTrigger',blockbg*durationbg);
start(ai);tmpraw_0=median(getdata(ai));
offset=0*[0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1];

%load last old data
tmp = load('oldBackgroundValues.mat', '-regexp', 'oldBg*');
fields = fieldnames(tmp);

listbg =  tmp.(fields{numel(fields)});

listbg=-6*ones(1,15);
%listbg=tmpraw_0;
%%
tmp_0=(tmpraw_0 - listbg).*(listratio)+offset;%%this sets the very first value of the graph
%%
block=480;duration=1;
set(ai,'SampleRate',1000,'SamplesPerTrigger',block*duration);
t0=clock;
%%
%%
for i=1:15
    CycleData(i).startTime = zeros(1,floor(experiment/tcycle(i)));%%start time of the growth cycle, it is updated at the end of the dilution
    CycleData(i).dilTime = zeros(1,floor(experiment/tcycle(i)));
    CycleData(i).endTime = zeros(1,floor(experiment/tcycle(i)));%%ending time of the growth cycle, it is updated at the end of the dilution
    CycleData(i).startT = zeros(1,floor(experiment/tcycle(i)));
    CycleData(i).startT(2) = delaytime; %DELAY IS HERE NOW!
    CycleData(i).dilT = zeros(1,floor(experiment/tcycle(i)));
    CycleData(i).endT = zeros(1,floor(experiment/tcycle(i)));%%indice of the endTime
    CycleData(i).finalOD = zeros(1,floor(experiment/tcycle(i)));%%the last OD value of each cycle, it is calculated from the fit
    CycleData(i).targetOD = zeros(1,floor(experiment/tcycle(i)));%%targeted OD value for dilution, targetOD=dil*finalOD
    CycleData(i).gRate = zeros(1,floor(experiment/tcycle(i)));
    CycleData(i).gCons = zeros(1,floor(experiment/tcycle(i)));
    CycleData(i).boolValue = zeros(1,floor(experiment/tcycle(i)));
    CycleData(i).boolGrowth = zeros(1,floor(experiment/tcycle(i)));
    CycleData(i).boolDGrowth = zeros(1,floor(experiment/tcycle(i)));
    CycleData(i).Proportion = zeros(1,floor(experiment/tcycle(i)));
    CycleData(i).Integral = zeros(1,floor(experiment/tcycle(i)));
    CycleData(i).Derivative = zeros(1,floor(experiment/tcycle(i)));
    CycleData(i).PID = zeros(1,floor(experiment/tcycle(i)));
    CycleData(i).drugUsed = zeros(1,floor(experiment/tcycle(i)));
    CycleData(i).DrugA = zeros(1,floor(experiment/tcycle(i)));
    CycleData(i).DrugB = zeros(1,floor(experiment/tcycle(i)));
    Flags(i).Inject = 2;%%initial value is set to 2, it is set to 0 at the end of each growth cycle
    LogicChoice(i).DrugA = 0;
    LogicChoice(i).DrugB = 0;
    LogicChoice(i).Media = 0;
    LogicChoice(i).Summary = 0;
end

global rParametersReady;
rParametersReady = 1;
pushLog('Parameters are loaded.',handles);

function pushLog(newString, handles)

global pushbuttonPreviousString;
ct = clock;

newString = strcat(num2str(ct(4)),':',num2str(ct(5)),':',num2str(floor(ct(6))),{' - '},newString);
pushbuttonPreviousString = sprintf('%s\n%s',char(newString),pushbuttonPreviousString);
set(handles.editLog,'String',pushbuttonPreviousString);

% --- Executes during object creation, after setting all properties.
function editDays_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDays (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editLog_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonSaveLog.
function pushbuttonSaveLog_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSaveLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbuttonClearLog.
function pushbuttonClearLog_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonClearLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pushbuttonClearLog
global pushbuttonPreviousString;
pushbuttonPreviousString = '';
set(handles.editLog,'String',pushbuttonPreviousString);

guidata(hObject,handles);


% --- Executes on button press in pushbuttonInitializeDaqDevices.
function pushbuttonInitializeDaqDevices_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonInitializeDaqDevices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function setOneTube(tubeNum, tubeCategory,drugName,drugConc)

textTag = ['textTube',num2str(tubeNum),tubeCategory]; %'' for a, 'b' for b
textObj = findobj('Tag',textTag);
textString{2,1} = sprintf('Conc: %s',drugConc{1});
textString{1,1} = sprintf('Culture %d - %s',tubeNum,drugName{1});

set(textObj,'String',textString);


function pushbuttonSetTubes_Callback(hObject, eventdata, handles)

global expConsts;

objTag = get(hObject,'Tag');
textTag = 'textTube';
if objTag(length(objTag)) == 'b'
    tubeCategory = 'b';
    tubeNum = str2num(objTag(15: (length(objTag)-1)));
    textTag = [textTag,num2str(tubeNum),'b'];
else
    tubeCategory = 'a';
    tubeNum = str2num(objTag(15:(length(objTag))));
    textTag = [textTag,num2str(tubeNum)];
end

textObj = findobj('Tag',textTag);
textString = get(textObj,'String');
textString1 = char(textString(1));
textString2 = char(textString(2));
dashIndice = strfind(textString1,'-'); 
colonIndice = strfind(textString2,':');
drugName = textString1((dashIndice+2):length(textString1));
drugConc = str2num(textString2((colonIndice+2):length(textString2)));

if(tubeCategory == 'a')
    expConsts.stockA(tubeNum) = drugConc;
else
    expConsts.stockB(tubeNum) = drugConc;
end

prompt = {'Enter drug name:','Enter concentration:'};
dlg_title = ['Input for Culture ',num2str(tubeNum),' Drug ',drugName];
num_lines = 1;
cDrugName = cellstr(drugName);
cDrugConc = cellstr(num2str(drugConc));
def = {cDrugName{1},cDrugConc{1}};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer = inputdlg(prompt,dlg_title,num_lines,def,options);
try
textString{2,1} = sprintf('Conc: %s',answer{2});
textString{1,1} = sprintf('Culture %d - %s',tubeNum,answer{1});

set(textObj,'String',textString);

guidata(hObject,handles);

textTag = 'textTube';
if objTag(length(objTag)) == 'b'
    tubeCategory = 'b';
    tubeNum = str2num(objTag(15: (length(objTag)-1)));
    textTag = [textTag,num2str(tubeNum),'b'];
else
    tubeCategory = 'a';
    tubeNum = str2num(objTag(15:(length(objTag))));
    textTag = [textTag,num2str(tubeNum)];
end

textObj = findobj('Tag',textTag);
textString = get(textObj,'String');
textString1 = char(textString(1));
textString2 = char(textString(2));
dashIndice = strfind(textString1,'-'); 
colonIndice = strfind(textString2,':');
drugName = textString1((dashIndice+2):length(textString1));

drugConc = str2num(textString2((colonIndice+2):length(textString2)));

if(tubeCategory == 'a')
    expConsts.stockA(tubeNum) = drugConc;
    tempstr = strcat({'Culture '},num2str(tubeNum),{' stock A updated: Drug-> '},drugName,{' Conc-> '},num2str(drugConc));
else
    expConsts.stockB(tubeNum) = drugConc;
    tempstr = strcat({'Culture '},num2str(tubeNum),{' stock B updated: Drug-> '},drugName,{' Conc-> '},num2str(drugConc));
end


pushLog(char(tempstr),handles);

catch
end



function editTubeNum_Callback(hObject, eventdata, handles)
% hObject    handle to editTubeNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTubeNum as text
%        str2double(get(hObject,'String')) returns contents of editTubeNum as a double


% --- Executes on button press in pushbuttonTube1.
function pushbuttonTube1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonTube1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbuttonTurbidostatStartExperiment.
function pushbuttonTurbidostatStartExperiment_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonTurbidostatStartExperiment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global ai relaybox1 relaybox2;
global threshold dilutionfactor dilthr tcycle tgrowth tdil Algo;
%DRUGS
global expConsts;
%ADVANCED
global map w toffset  plotupdate delaytime datasave;
global experiment;
global label dumpData smoothData cycle;
global listratio;
global CycleData Flags LogicChoice Fig;
global offset listbg t0 maxGrowth;
global Labels SecType tmp_0;

global rParametersReady;
global activeTubeIndices;
tubeIndices = activeTubeIndices(find(activeTubeIndices));

if(~rParametersReady)
        pushLog({'Experiment couldn''t be started: Parameters are not loaded.'},handles);
else
figure(5);
Fig = FigCreate(Labels,SecType,tmp_0); %%generates the plot using FigCreate.m , tmp_0 is the first data point of the figure


t=0;
tic
while t<experiment
    time1=etime(clock,t0);%starting point of each data acquisition within a second
    t = t+1;%t is the counter that's used for decision making
    ttotal=t+toffset;%USED?
    tdown=max(1,t-w+1);%tdown is calculated to smooth data
    start(ai);%fires the device to acquire ## of data points within each cycle
    rawdata=median(getdata(ai));%we use median of the ##500 data points acquired within 1 second in order to filter noise
    data=(rawdata - listbg).*(listratio)+offset;%%voltage readings are converted to OD
    time=etime(clock,t0);%time is measured
    dumpData(t,:) = [data time];%time and OD values are appended to the preallocated dumpData array
    smoothData(1,:)=median(dumpData(tdown:t,:));%average the data within w seconds to avoid noise interfering with decisions
    
    if (mod(t-2,tcycle(1)+tdil)==tgrowth-15 && t>=delaytime) %Stops vacuum pump
        putvalue(relaybox2.Line(24), 1)%fix it later 
        
    elseif mod(t-2,tcycle(1)+tdil)==tgrowth-1 && t>=delaytime; %Computes parameters.
        for J=tubeIndices
            CycleData(J).endTime(cycle(J)) = time;%%here the ending time of the growth cycle is updated
            CycleData(J).endT(cycle(J)) = t;%%indice of the endTime
            CycleData = DataAnalysis(t,time,tcycle*ones(1,1),cycle,J,dumpData,dilutionfactor,dilthr,threshold,CycleData); %%This calls, DataAnalysis onto the struct CycleData, note the J paramater is specified within the function call.
            CycleData(J).Proportion(cycle(J))= CycleData(J).finalOD(cycle(J))-threshold(1,J);
            CycleData(J).Derivative(cycle(J))= CycleData(J).finalOD(cycle(J))-CycleData(J).finalOD(max(1,cycle(J)-1));
            CycleData(J).Integral(cycle(J))=sum(CycleData(J).Proportion(max(1,cycle(J)-5):cycle(J)));
            CycleData(J).PID(cycle(J))=(CycleData(J).Proportion(cycle(J))>maxGrowth)*1e5-(CycleData(J).Proportion(cycle(J))<0)*1e5 ......
                +0.001*CycleData(J).Integral(cycle(J))...
                +CycleData(J).Derivative(cycle(J));
            
            %CycleData contains all the information necessary for decision and post analysis
            cycle(J) = cycle(J) + 1; %%CYCLE OFFICIAL END
            Flags(J).Inject = 0;%%
            LogicChoice = LogicDecision(Algo(J),J,cycle,expConsts,CycleData,LogicChoice,ttotal);
        end
        
    elseif mod(t-2,tcycle(1)+tdil)==tgrowth && t>=delaytime; %Starts the dilution with the correct pump
        for J=tubeIndices
            if(J>8) 
                break;
            end
            CycleData(J).injectTime(cycle(J))= time;
            CycleData(J).injectT(cycle(J)) = t;
            
            if LogicChoice(J).Media == 1 %% Activates Pumps
                putvalue(relaybox1.Line(1+3*(J-1)),1);
            elseif LogicChoice(J).DrugA == 1
                putvalue(relaybox1.Line(2+3*(J-1)), 1);
            elseif LogicChoice(J).DrugB == 1
                putvalue(relaybox1.Line(3+3*(J-1)), 1);
            end
            CycleData(J).drugUsed(cycle(J)) = LogicChoice(J).Summary; %Updates CycleData
        end
        for J=tubeIndices
            if J <= 8
                continue;
            end
            CycleData(J).injectTime(cycle(J))= time;
            CycleData(J).injectT(cycle(J)) = t;
            
            if LogicChoice(J).Media == 1 %% Activates Pumps
                putvalue(relaybox2.Line(1+3*(J-9)), 1);
            elseif LogicChoice(J).DrugA == 1
                putvalue(relaybox2.Line(2+3*(J-9)), 1);
            elseif LogicChoice(J).DrugB == 1
                putvalue(relaybox2.Line(3+3*(J-9)), 1);
            end
            CycleData(J).drugUsed(cycle(J)) = LogicChoice(J).Summary; %Updates CycleData
        end
        
    elseif mod(t-2,tcycle(1)+tdil)==0 && t>=delaytime %Start growth sequence, stops the pumps
        putvalue(relaybox1.Line(1:24),0)
        putvalue(relaybox2.Line(1:22),0)
        
        for J=tubeIndices
            CycleData(J).startT(cycle(J)) = t;
            CycleData(J).startTime(cycle(J)) = time;
            CycleData = UpdConc(J,cycle,expConsts,dilutionfactor,LogicChoice,CycleData); %%UPDATES THE DRUG CONCENTRATIONS
        end
        
    elseif mod(t-2,tcycle(1)+tdil)==10 && t>=delaytime  %Restarts the suction pump
        putvalue(relaybox2.Line(24),1) % turns on suction pumps
        
    end
    
    
    pumps = [getvalue(relaybox1.Line(1:24)) getvalue(relaybox2.Line(1:24))];
    
    if mod(t-2,datasave) == 0 %%Saves the workspace to disk every 15 minutes
        save(['work_',num2str(label),'.mat'])
    end
    
    if mod(t-2,plotupdate)==0
        for j=tubeIndices
            Fig.chMain{j} = get(Fig.Main{j},'Children');
            Fig.chSec{j} = get(Fig.Sec{j},'Children');
            Fig.MnewY(j) = data(1,j);
            Fig.MnewX(j) = t/3600;
            Fig.MnewC{j} = map(j,:);
            
            
            Fig.Mmark{j} = 'none';
            Fig.SnewY(j) = CycleData(j).gRate(max(cycle(j)-1,1));
            %             if CycleData(j).gRate(cycle(j))==0
            %                 Fig.SnewY(j) = 0;%CycleData(j).DrugA(cycle(j)-1);
            %             end
            Fig.SnewX(j) = t/3600;
            Fig.SnewC{j} = [1 0 1];
            Fig.Smark{j} = 'none';
            
            
        end
        
        
        for j=tubeIndices
            set(Fig.chMain{j},'XData',[get(Fig.chMain{j},'XData') Fig.MnewX(j)],'YData',[get(Fig.chMain{j},'YData') Fig.MnewY(j)],'Color',Fig.MnewC{j},'Marker',Fig.Smark{j});
            %set(Fig.chMain{j},'XData',[get(Fig.chMain{j},'XData') Fig.MnewX(j)],'YData',[get(Fig.chMain{j},'YData') Fig.MnewY(j)]);
            set(Fig.chSec{j},'XData',[get(Fig.chSec{j},'XData') Fig.SnewX(j)],'YData',[get(Fig.chSec{j},'YData') Fig.SnewY(j)],'Color',Fig.SnewC{j},'Marker',Fig.Smark{j});
            %set(Fig.chSec{j},'XData',[get(Fig.chSec{j},'XData') Fig.SnewX(j)],'YData',[get(Fig.chSec{j},'YData') Fig.SnewY(j)]);
        end
        
        drawnow;
        
    end
    
    
    time2=etime(clock,t0);
    dt=max(0,1-(time2-time1));%%dt is the amouSect of time the program will wait before executing the next cycle. Waiting time is necessary to make time pointsas close as 1 sec
    %java.lang.Runtime.getRuntime.freeMemory
    pause(dt);
end
toc
putvalue(relaybox1.Line(1:24), 0)
putvalue(relaybox2.Line(1:23), 0)
putvalue(relaybox2.Line(24), 1) %% suction pump turns off if the value is 1
end


function editTcycle_Callback(hObject, eventdata, handles)
% hObject    handle to editTcycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTcycle as text
%        str2double(get(hObject,'String')) returns contents of editTcycle as a double



function editDays_Callback(hObject, eventdata, handles)
% hObject    handle to editDays (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDays as text
%        str2double(get(hObject,'String')) returns contents of editDays as a double



function editPlotupdate_Callback(hObject, eventdata, handles)
% hObject    handle to editPlotupdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPlotupdate as text
%        str2double(get(hObject,'String')) returns contents of editPlotupdate as a double



function editDelaytime_Callback(hObject, eventdata, handles)
% hObject    handle to editDelaytime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDelaytime as text
%        str2double(get(hObject,'String')) returns contents of editDelaytime as a double



function editDilthr_Callback(hObject, eventdata, handles)
% hObject    handle to editDilthr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDilthr as text
%        str2double(get(hObject,'String')) returns contents of editDilthr as a double


% --- Executes on button press in checkboxTube1.
function changeTubeActivation_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxTube1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxTube1

global activeTubes;

buttonTag = 'pushbuttonTube';
tag = get(hObject,'Tag');
number = str2num(tag(13:length(tag)));

buttonTag = strcat(buttonTag,num2str(number));
buttonTagB = strcat(buttonTag,'b');
buttonObj = findobj('Tag',buttonTag);
buttonObjB = findobj('Tag',buttonTagB);

activeTubes(number) = ~activeTubes(number);
if(strcmp(get(buttonObj,'enable'),'on'))
    set(buttonObj,'enable','off');
else
    set(buttonObj,'enable','on');
end

if(strcmp(get(buttonObjB,'enable'),'on'))
    set(buttonObjB,'enable','off');
else
    set(buttonObjB,'enable','on');
end

updateCurrentActiveTubeNumbers();

% --- Executes on button press in checkboxTube2.
function checkboxTube2_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxTube2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxTube2


% --- Executes on button press in checkboxTube3.
function checkboxTube3_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxTube3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxTube3


% --- Executes on button press in checkboxTube4.
function checkboxTube4_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxTube4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxTube4


% --- Executes on button press in checkboxTube5.
function checkboxTube5_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxTube5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxTube5


% --- Executes on button press in checkboxTube6.
function checkboxTube6_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxTube6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxTube6


% --- Executes on button press in checkboxTube7.
function checkboxTube7_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxTube7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxTube7


% --- Executes on button press in checkboxTube8.
function checkboxTube8_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxTube8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxTube8


% --- Executes on button press in checkboxTube9.
function checkboxTube9_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxTube9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxTube9


% --- Executes on button press in checkboxTube10.
function checkboxTube10_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxTube10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxTube10


% --- Executes on button press in checkboxTube11.
function checkboxTube11_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxTube11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxTube11


% --- Executes on button press in checkboxTube12.
function checkboxTube12_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxTube12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxTube12


% --- Executes on button press in checkboxTube13.
function checkboxTube13_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxTube13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxTube13


% --- Executes on button press in checkboxTube14.
function checkboxTube14_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxTube14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxTube14


% --- Executes on button press in checkboxTube15.
function checkboxTube15_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxTube15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxTube15


% --- Executes on button press in pushbuttonSelectAll.
function pushbuttonSelectAll_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSelectAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global activeTubes;

for i=1:15
    buttonTag = 'pushbuttonTube';
    checkTag = 'checkboxTube';
    
    checkTag = strcat(checkTag,num2str(i));
    checkObj = findobj('Tag',checkTag);
    set(checkObj,'Value',1);
    
    buttonTag = strcat(buttonTag,num2str(i));
    buttonTagB = strcat(buttonTag,'b');
    buttonObj = findobj('Tag',buttonTag);
    buttonObjB = findobj('Tag',buttonTagB);

    activeTubes(i) = 1;
    set(buttonObj,'enable','on');
    set(buttonObjB,'enable','on');
end

updateCurrentActiveTubeNumbers();

% --- Executes on button press in pushbuttonDeselectAll.
function pushbuttonDeselectAll_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonDeselectAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global activeTubes;

for i=1:15
    buttonTag = 'pushbuttonTube';
    checkTag = 'checkboxTube';
    checkTag = strcat(checkTag,num2str(i));
    checkObj = findobj('Tag',checkTag);
    set(checkObj,'Value',0);
    
    buttonTag = strcat(buttonTag,num2str(i));
    buttonTagB = strcat(buttonTag,'b');
    buttonObj = findobj('Tag',buttonTag);
    buttonObjB = findobj('Tag',buttonTagB);

    activeTubes(i) = 0;
    set(buttonObj,'enable','off');
    set(buttonObjB,'enable','off');
end

updateCurrentActiveTubeNumbers();

% --- Executes on button press in pushbuttonSelectActiveTubes.
function pushbuttonSelectActiveTubes_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSelectActiveTubes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function uipanelExpAlgo_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanelExpAlgo
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

global Algo threshold;

if strcmp(get(eventdata.NewValue,'String'),'Chemostat')
    Algo = ones(1,15)*400;
    threshold = ones(1,15)*1000;
    set(handles.editThreshold,'Enable','off');
else if strcmp(get(eventdata.NewValue,'String'),'Turbidostat')
        Algo = ones(1,15)*402;
        set(handles.editThreshold,'Enable','on');
        threshold = ones(1,15)*str2num(get(handles.editThreshold,'String'));
        %%threshold is manual
    else if strcmp(get(eventdata.NewValue,'String'),'Morbidostat')
            Algo = ones(1,15)*400;
            set(handles.editThreshold,'Enable','on');
            threshold = ones(1,15)*str2num(get(handles.editThreshold,'String'));
            %%threshold is manual
        end
    end
end


% --------------------------------------------------------------------
function uipanelExpAlgo_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanelExpAlgo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbuttonSaveCalibrationData.
function pushbuttonSaveCalibrationData_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSaveCalibrationData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data realod;
% ct = clock;
% strcat('calibration_data_',num2str(ct(1)),':',num2str(ct(2)),':',num2str(floor(ct(3))),{'-'},num2str(ct(4)),':',num2str(ct(5)),':',num2str(floor(ct(6))));
% timestamp = datestr(clock,'yyyy_mm_dd_HH'); 

location = 'N:\KISHONY LAB\_Equipment\Morbidostat\scripts\calibration_data\';
[FileName, PathName, ~] = uiputfile(location, 'Please enter calibration name'); 
save([PathName,FileName], 'data', 'realod'); 
% save(strcat(location, '_', timestamp), 'data', 'realod');

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbuttonSaveCalibrationData.
function pushbuttonSaveCalibrationData_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbuttonSaveCalibrationData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
