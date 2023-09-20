function varargout = TimeDivMultiMenu(varargin)
% TIMEDIVMULTIMENU M-file for TimeDivMultiMenu.fig
%      TIMEDIVMULTIMENU, by itself, creates a new TIMEDIVMULTIMENU or raises the existing
%      singleton*.
%
%      H = TIMEDIVMULTIMENU returns the handle to a new TIMEDIVMULTIMENU or the handle to
%      the existing singleton*.
%
%      TIMEDIVMULTIMENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TIMEDIVMULTIMENU.M with the given input arguments.
%
%      TIMEDIVMULTIMENU('Property','Value',...) creates a new TIMEDIVMULTIMENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TimeDivMultiMenu_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TimeDivMultiMenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help TimeDivMultiMenu

% Last Modified by GUIDE v2.5 14-Aug-2008 10:31:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TimeDivMultiMenu_OpeningFcn, ...
                   'gui_OutputFcn',  @TimeDivMultiMenu_OutputFcn, ...
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


% --- Executes just before TimeDivMultiMenu is made visible.
function TimeDivMultiMenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TimeDivMultiMenu (see VARARGIN)

global NUM_SRC;
global NUM_DET;

% Choose default command line output for TimeDivMultiMenu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TimeDivMultiMenu wait for user response (see UIRESUME)
% uiwait(handles.TDM_MenuFigure);

Cw6handles=guihandles(findobj('tag','cw6figure'));
SubjInfo=get(Cw6handles.RegistrationInfo,'UserData');
system=get(Cw6handles.AquistionButtons,'Userdata');

numStates=length(unique(SubjInfo.Probe.MeasList(:,5)));
for idx=1:numStates
    str{idx}=sprintf('%s',['State #' num2str(idx)]);
end

if(~isfield(system,'TDMSettings') || ~isfield(system.TDMSettings,'LasersOn'))
    TDMSettings.NumStates=numStates;
    TDMSettings.DwellTimes=zeros(numStates,1);
    TDMSettings.DwellTimes=ones(numStates,1)*str2num(get(handles.DwellTime,'string'));
    TDMSettings.StateSelected=1;
    
    TDMSettings.LasersOn=zeros(NUM_SRC,numStates);
    TDMSettings.DetGains=zeros(NUM_DET,numStates);
       
    if(~isfield(system,'AQSettings'))
        system.AQSettings.Lasers=zeros(NUM_SRC,1);
    elseif(~isfield(system.AQSettings,'Lasers'))
        system.AQSettings.Lasers=zeros(NUM_SRC,1);
    end
    
    Javahandles=get(findobj('tag','DetTabContainer'),'UserData');

    if(~isfield(system,'AQSettings'))
        system.AQSettings.Gains=zeros(NUM_DET,1);
    elseif(~isfield(system.AQSettings,'Gains'))
        system.AQSettings.Gains=zeros(NUM_DET,1);
    end
    Gains=system.AQSettings.Gains;
   
    for state=1:numStates
        mlState=find(SubjInfo.Probe.MeasList(:,5)==state);
        SrcLst=unique(SubjInfo.Probe.MeasList(mlState,1));
        DetLst=unique(SubjInfo.Probe.MeasList(mlState,2));
        
        LaserLst=SubjInfo.Probe.LaserPos(SrcLst(:),:);
        TDMSettings.LasersOn(LaserLst(:),state)=system.AQSettings.Lasers(LaserLst(:));
        TDMSettings.DetGains(DetLst,state)=Gains(DetLst);
    end
    
    system.TDMSettings=TDMSettings;
    set(Cw6handles.AquistionButtons,'Userdata',system);
end
TDMSettings=system.TDMSettings;

set(handles.Select_State,'string',str);
set(handles.Select_State,'value',TDMSettings.StateSelected);
set(handles.DwellTime,'string',num2str(TDMSettings.DwellTimes(TDMSettings.StateSelected)));


ShowTDM_SDG(TDMSettings.StateSelected);



% --- Outputs from this function are returned to the command line.
function varargout = TimeDivMultiMenu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in Select_State.
function Select_State_Callback(hObject, eventdata, handles)
% hObject    handle to Select_State (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Select_State contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Select_State

Cw6handles=guihandles(findobj('tag','cw6figure'));
SubjInfo=get(Cw6handles.RegistrationInfo,'UserData');
system=get(Cw6handles.AquistionButtons,'Userdata');
system.TDMSettings.StateSelected=get(handles.Select_State,'value');
set(Cw6handles.AquistionButtons,'Userdata',system);

set(handles.Select_State,'value',system.TDMSettings.StateSelected);
set(handles.DwellTime,'string',num2str(system.TDMSettings.DwellTimes(system.TDMSettings.StateSelected)));
ShowTDM_SDG(system.TDMSettings.StateSelected);
updateCw6DeviceTDM;

state=system.TDMSettings.StateSelected;
dwelltime=system.TDMSettings.DwellTimes(state);
gains=system.TDMSettings.DetGains(:,state);
lasers=system.TDMSettings.LasersOn(:,state);
SetState(system.MainDevice,state,dwelltime,gains,lasers);

% --- Executes on button press in SetStateValues.
function SetStateValues_Callback(hObject, eventdata, handles)
% hObject    handle to SetStateValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


Cw6handles=guihandles(findobj('tag','cw6figure'));
SubjInfo=get(Cw6handles.RegistrationInfo,'UserData');
system=get(Cw6handles.AquistionButtons,'Userdata');
Javahandles=get(findobj('tag','DetTabContainer'),'UserData');
     
if(~isfield(system,'AQSettings'))
        system.AQSettings.Lasers=zeros(NUM_SRC,1);
elseif(~isfield(system.AQSettings,'Lasers'))
        system.AQSettings.Lasers=zeros(NUM_SRC,1);
end
    
if(~isfield(system,'AQSettings'))
    system.AQSettings.Gains=zeros(NUM_DET,1);
elseif(~isfield(system.AQSettings,'Gains'))
    system.AQSettings.Gains=zeros(NUM_DET,1);
end
Gains=system.AQSettings.Gains;

state=system.TDMSettings.StateSelected;
mlState=find(SubjInfo.Probe.MeasList(:,5)==state);
SrcLst=unique(SubjInfo.Probe.MeasList(mlState,1));
DetLst=unique(SubjInfo.Probe.MeasList(mlState,2));

LaserLst=SubjInfo.Probe.LaserPos(SrcLst(:),:);
system.TDMSettings.LasersOn(LaserLst(:),state)=system.AQSettings.Lasers(LaserLst(:));
system.TDMSettings.DetGains(DetLst,state)=Gains(DetLst);

set(Cw6handles.AquistionButtons,'Userdata',system);

updateCw6DeviceTDM;

dwelltime=system.TDMSettings.DwellTimes(state);
gains=system.TDMSettings.DetGains(:,state);
lasers=system.TDMSettings.LasersOn(:,state);
SetState(system.MainDevice,state,dwelltime,gains,lasers);


function DwellTime_Callback(hObject, eventdata, handles)
% hObject    handle to DwellTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DwellTime as text
%        str2double(get(hObject,'String')) returns contents of DwellTime as a double

Cw6handles=guihandles(findobj('tag','cw6figure'));
SubjInfo=get(Cw6handles.RegistrationInfo,'UserData');
system=get(Cw6handles.AquistionButtons,'Userdata');
system.TDMSettings.DwellTimes(system.TDMSettings.StateSelected)=str2num(get(handles.DwellTime,'string'));
set(Cw6handles.AquistionButtons,'Userdata',system);



