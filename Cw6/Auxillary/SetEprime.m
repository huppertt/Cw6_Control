function varargout = SetEprime(varargin)
% SETEPRIME M-file for SetEprime.fig
%      SETEPRIME by itself, creates a new SETEPRIME or raises the
%      existing singleton*.
%
%      H = SETEPRIME returns the handle to a new SETEPRIME or the handle to
%      the existing singleton*.
%
%      SETEPRIME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SETEPRIME.M with the given input arguments.
%
%      SETEPRIME('Property','Value',...) creates a new SETEPRIME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SetEprime_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SetEprime_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SetEprime

% Last Modified by GUIDE v2.5 15-Jul-2009 18:52:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SetEprime_OpeningFcn, ...
                   'gui_OutputFcn',  @SetEprime_OutputFcn, ...
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

% --- Executes just before SetEprime is made visible.
function SetEprime_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SetEprime (see VARARGIN)

% Choose default command line output for SetEprime
handles.output=hObject;

% Update handles structure
guidata(hObject, handles);


% Determine the position of the dialog - centered on the callback figure
% if available, else, centered on the screen
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
if isempty(gcbf)
    ScreenUnits=get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize=get(0,'ScreenSize');
    set(0,'Units',ScreenUnits);

    FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
    FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
else
    GCBFOldUnits = get(gcbf,'Units');
    set(gcbf,'Units','pixels');
    GCBFPos = get(gcbf,'Position');
    set(gcbf,'Units',GCBFOldUnits);
    FigPos(1:2) = [(GCBFPos(1) + GCBFPos(3) / 2) - FigWidth / 2, ...
                   (GCBFPos(2) + GCBFPos(4) / 2) - FigHeight / 2];
end
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);


% Show a question icon from dialogicons.mat - variables questIconData
% and questIconMap
[X,map] = imread('Eprime.jpg');
Img=image(X, 'Parent', handles.axes1);
set(handles.figure1, 'Colormap', map);

set(handles.axes1, ...
    'Visible', 'off', ...
    'YDir'   , 'reverse'       , ...
    'XLim'   , get(Img,'XData'), ...
    'YLim'   , get(Img,'YData')  ...
    );
global EPRIME_DIR;
set(handles.eprime_dirname,'string',EPRIME_DIR);

handles2=guihandles(findobj('tag','cw6figure'));
stiminfo=get(handles2.setup_stim,'Userdata');
if(isfield(stiminfo,'linktoeprime'))
    try; set(handles.checkbox_linktoeprime,'value',stiminfo.linktoeprime); end;
end

return

% UIWAIT makes SetEprime wait for user response (see UIRESUME)

% --- Outputs from this function are returned to the command line.
function varargout = SetEprime_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global EPRIME_DIR;
% try
% set(findobj('tag','eprime_file_name'),'Label',EPRIME_DIR);
% end

handles2=guihandles(findobj('tag','cw6figure'));
stiminfo=get(handles2.setup_stim,'Userdata');
stiminfo.linktoeprime=get(handles.checkbox_linktoeprime,'value');
set(handles2.setup_stim,'Userdata',stiminfo);


if(stiminfo.linktoeprime)
    set(findobj('tag','link2eprime'),'checked','on');
else
    set(findobj('tag','link2eprime'),'checked','off');
end

closereq;

% --- Executes on button press in select_eprimedir.
function select_eprimedir_Callback(hObject, eventdata, handles)
% hObject    handle to select_eprimedir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global EPRIME_DIR;
directoryname = uigetdir(EPRIME_DIR, 'Select the Eprime Root Directory');
if~(isempty(directoryname) | directoryname==0)
    EPRIME_DIR=directoryname;
end
set(handles.eprime_dirname,'string',EPRIME_DIR);



return



% --- Executes on button press in checkbox_linktoeprime.
function checkbox_linktoeprime_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_linktoeprime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_linktoeprime

handles2=guihandles(findobj('tag','cw6figure'));
stiminfo=get(handles2.setup_stim,'Userdata');
stiminfo.linktoeprime=get(handles.checkbox_linktoeprime,'value');
set(handles2.setup_stim,'Userdata',stiminfo);

