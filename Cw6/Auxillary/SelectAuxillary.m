function varargout = SelectAuxillary(varargin)
% SELECTAUXILLARY M-file for SelectAuxillary.fig
%      SELECTAUXILLARY, by itself, creates a new SELECTAUXILLARY or raises the existing
%      singleton*.
%
%      H = SELECTAUXILLARY returns the handle to a new SELECTAUXILLARY or the handle to
%      the existing singleton*.
%
%      SELECTAUXILLARY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECTAUXILLARY.M with the given input arguments.
%
%      SELECTAUXILLARY('Property','Value',...) creates a new SELECTAUXILLARY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SelectAuxillary_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SelectAuxillary_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SelectAuxillary

% Last Modified by GUIDE v2.5 14-Jul-2009 22:15:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SelectAuxillary_OpeningFcn, ...
    'gui_OutputFcn',  @SelectAuxillary_OutputFcn, ...
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

function CloseFcn_Callback(hObject, eventdata, handles, varargin)
try
    handles=guihandles(findobj('tag','cw6figure'));
    stiminfo=get(handles.setup_stim,'Userdata');

    %Find the stimulus names
    stiminfo.usestim=[];
    for idx=1:5
        stiminfo.names{idx}=get(findobj('tag',['edit' num2str(idx)]),'string');
        if(get(findobj('tag',['checkbox' num2str(idx)]),'value')); stiminfo.usestim=[stiminfo.usestim idx]; end;
    end
    handleslocal=guihandles(gcbo);
    stiminfo.comments=get(handleslocal.activex1,'text');
    set(handles.setup_stim,'Userdata',stiminfo);
end
closereq;



% --- Executes just before SelectAuxillary is made visible.
function SelectAuxillary_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SelectAuxillary (see VARARGIN)

% Choose default command line output for SelectAuxillary
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SelectAuxillary wait for user response (see UIRESUME)
% uiwait(handles.figure1);
handles2=guihandles(findobj('tag','cw6figure'));
stiminfo=get(handles2.setup_stim,'Userdata');

%Find the stimulus names
try, stiminfo.usestim(1); 
catch, stiminfo.usestim=1; stiminfo.comments='';
end

try
    for idx=1:5
        try; set(findobj('tag',['edit' num2str(idx)]),'string',stiminfo.names{idx}); end;
        set(findobj('tag',['checkbox' num2str(idx)]),'value',0);
    end
    for idx=1:length(stiminfo.usestim)
        try; set(findobj('tag',['checkbox' num2str(stiminfo.usestim(idx))]),'value',1); end;
    end
    set(handles.activex1,'text',stiminfo.comments);
end

% --- Outputs from this function are returned to the command line.
function varargout = SelectAuxillary_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
% set(handles.checkbox1,'value',1);
% set(handles.checkbox2,'value',0);
% set(handles.checkbox3,'value',0);
% set(handles.checkbox4,'value',0);
% set(handles.checkbox5,'value',0);

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
% set(handles.checkbox1,'value',0);
% set(handles.checkbox2,'value',1);
% set(handles.checkbox3,'value',0);
% set(handles.checkbox4,'value',0);
% set(handles.checkbox5,'value',0);

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
% set(handles.checkbox1,'value',0);
% set(handles.checkbox2,'value',0);
% set(handles.checkbox3,'value',1);
% set(handles.checkbox4,'value',0);
% set(handles.checkbox5,'value',0);

% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
% set(handles.checkbox1,'value',0);
% set(handles.checkbox2,'value',0);
% set(handles.checkbox3,'value',0);
% set(handles.checkbox4,'value',1);
% set(handles.checkbox5,'value',0);


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
% set(handles.checkbox1,'value',0);
% set(handles.checkbox2,'value',0);
% set(handles.checkbox3,'value',0);
% set(handles.checkbox4,'value',0);
% set(handles.checkbox5,'value',1);


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


