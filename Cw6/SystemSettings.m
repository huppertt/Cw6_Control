function varargout = SystemSettings(varargin)
% SYSTEMSETTINGS M-file for SystemSettings.fig
%      SYSTEMSETTINGS, by itself, creates a new SYSTEMSETTINGS or raises the existing
%      singleton*.
%
%      H = SYSTEMSETTINGS returns the handle to a new SYSTEMSETTINGS or the handle to
%      the existing singleton*.
%
%      SYSTEMSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYSTEMSETTINGS.M with the given input arguments.
%
%      SYSTEMSETTINGS('Property','Value',...) creates a new SYSTEMSETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SystemSettings_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SystemSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help SystemSettings

% Last Modified by GUIDE v2.5 27-Nov-2013 10:25:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SystemSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @SystemSettings_OutputFcn, ...
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


% --- Executes just before SystemSettings is made visible.
function SystemSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SystemSettings (see VARARGIN)

% Choose default command line output for SystemSettings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SystemSettings wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global SAMPLE_RATE;
set(handles.SetSampleRate,'string',num2str(SAMPLE_RATE));

% --- Outputs from this function are returned to the command line.
function varargout = SystemSettings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function SetSampleRate_Callback(hObject, eventdata, handles)
% hObject    handle to SetSampleRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SetSampleRate as text
%        str2double(get(hObject,'String')) returns contents of SetSampleRate as a double
global SAMPLE_RATE;
Cw6handles=guihandles(findobj('tag','cw6figure'));
system=get(Cw6handles.AquistionButtons,'Userdata');

SAMPLE_RATE=str2num(get(gcbo,'string'));
setdatarate(system.MainDevice,SAMPLE_RATE);

if(~isempty(system.AuxDevice))
setdatarate(system.AuxDevice,SAMPLE_RATE);
end

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1





function edit_datadir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_datadir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_datadir as text
%        str2double(get(hObject,'String')) returns contents of edit_datadir as a double
global PROBE_DIR;
global DATA_DIR;
DATA_DIR=get(hObject,'String');
return

% --- Executes during object creation, after setting all properties.
function edit_datadir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_datadir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global PROBE_DIR;
global DATA_DIR;
set(hObject,'String',DATA_DIR);
return

function edit_probedir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_probedir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_probedir as text
%        str2double(get(hObject,'String')) returns contents of edit_probedir as a double
global PROBE_DIR;
global DATA_DIR;
PROBE_DIR=get(hObject,'String');
return

% --- Executes during object creation, after setting all properties.
function edit_probedir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_probedir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global PROBE_DIR;
global DATA_DIR;
set(hObject,'String',PROBE_DIR);
return

% --- Executes on button press in pushbutton_datadir.
function pushbutton_datadir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_datadir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PROBE_DIR;
global DATA_DIR;
DATA_DIR = uigetdir(DATA_DIR, 'Select Default Data Directory');
set(handles.edit_datadir,'string',DATA_DIR);
return

% --- Executes on button press in pushbutton_probedir.
function pushbutton_probedir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_probedir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PROBE_DIR;
global DATA_DIR;
PROBE_DIR = uigetdir(DATA_DIR, 'Select Default Data Directory');
set(handles.edit_probedir,'string',PROBE_DIR);
return
