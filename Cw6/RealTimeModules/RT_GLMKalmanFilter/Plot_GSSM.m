function varargout = Plot_GSSM(varargin)
% PLOT_GSSM M-file for Plot_GSSM.fig
%      PLOT_GSSM, by itself, creates a new PLOT_GSSM or raises the existing
%      singleton*.
%
%      H = PLOT_GSSM returns the handle to a new PLOT_GSSM or the handle to
%      the existing singleton*.
%
%      PLOT_GSSM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOT_GSSM.M with the given input arguments.
%
%      PLOT_GSSM('Property','Value',...) creates a new PLOT_GSSM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Plot_GSSM_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Plot_GSSM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Plot_GSSM

% Last Modified by GUIDE v2.5 09-Jul-2008 14:13:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Plot_GSSM_OpeningFcn, ...
                   'gui_OutputFcn',  @Plot_GSSM_OutputFcn, ...
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


% --- Executes just before Plot_GSSM is made visible.
function Plot_GSSM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Plot_GSSM (see VARARGIN)

% Choose default command line output for Plot_GSSM
handles.output = hObject;
guidata(hObject, handles);

return



% --- Outputs from this function are returned to the command line.
function varargout = Plot_GSSM_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ShowHbO.
function ShowHbO_Callback(hObject, eventdata, handles)
 plot_GSSM_main(1);
% --- Executes on button press in ShowHbR.
function ShowHbR_Callback(hObject, eventdata, handles)
 plot_GSSM_main(1);

% --- Executes on button press in WindowData.
function WindowData_Callback(hObject, eventdata, handles)
 plot_GSSM_main(1);

function edit1_Callback(hObject, eventdata, handles)
 plot_GSSM_main(1);



function NumberStim_Callback(hObject, eventdata, handles)
 plot_GSSM_main(1);

% --- Executes during object creation, after setting all properties.
function NumberStim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumberStim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RemoteFolderName_Callback(hObject, eventdata, handles)
% hObject    handle to RemoteFolderName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RemoteFolderName as text
%        str2double(get(hObject,'String')) returns contents of RemoteFolderName as a double


% --- Executes during object creation, after setting all properties.
function RemoteFolderName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RemoteFolderName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in WhichDisplay.
function WhichDisplay_Callback(hObject, eventdata, handles)
 plot_GSSM_main(1);


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SaveGSSM_Callback(hObject, eventdata, handles)
% hObject    handle to SaveGSSM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=guihandles(findobj('tag','GSSM_Figure'));
GSSM_data=get(handles.GSSM_Figure,'Userdata');

[filename, pathname] = uiputfile('*.mat', 'Save GSSM Data As:');

if(isempty(filename))
    return
end
save([pathname filename],'GSSM_data','-V6');
