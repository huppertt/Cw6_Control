function varargout = MarkStimGUI(varargin)
% MARKSTIMGUI M-file for MarkStimGUI.fig
%      MARKSTIMGUI, by itself, creates a new MARKSTIMGUI or raises the existing
%      singleton*.
%
%      H = MARKSTIMGUI returns the handle toggleStim5 a new MARKSTIMGUI or the handle toggleStim5
%      the existing singleton*.
%
%      MARKSTIMGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MARKSTIMGUI.M with the given input arguments.
%
%      MARKSTIMGUI('Property','Value',...) creates a new MARKSTIMGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied toggleStim5 the GUI before MarkStimGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed toggleStim5 MarkStimGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance toggleStim5 run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text toggleStim5 modify the response toggleStim5 help MarkStimGUI

% Last Modified by GUIDE v2.5 03-Sep-2010 13:48:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MarkStimGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MarkStimGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
% TEST
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before MarkStimGUI is made visible.
function MarkStimGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle toggleStim5 figure
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments toggleStim5 MarkStimGUI (see VARARGIN)

if length(varargin)==1
    handles.numStim = varargin{1};
else
    handles.numStim = 1;
end

handles.maxStim = 5;
if handles.numStim > handles.maxStim
    handles.numStim = handles.maxStim;
end

blank = '';

for i=1:handles.maxStim
    str = ['<HTML><font color="red">Toggle ', num2str(i), ' Off</HTML>'];
    set(findobj('tag', ['toggleStim', num2str(i)]), 'String', str);
    set(findobj('tag', ['pbStim', num2str(i)]), 'Style', 'pushbutton');
    if i <= handles.numStim
        set(findobj('tag', ['pbStim', num2str(i)]), 'Visible', 'on');
        set(findobj('tag', ['editStim', num2str(i)]), 'Visible', 'on');
        set(findobj('tag', ['toggleStim', num2str(i)]), 'Visible', 'on');
        
        eval(['handles.Stim{', num2str(i), '} = cell(0);']);
        eval(['handles.StimName{', num2str(i), '} = blank;']);
    else
        set(findobj('tag', ['pbStim', num2str(i)]), 'Visible', 'off');
        set(findobj('tag', ['editStim', num2str(i)]), 'Visible', 'off');
        set(findobj('tag', ['toggleStim', num2str(i)]), 'Visible', 'off');
    end
end

% Choose default command line output for MarkStimGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MarkStimGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned toggleStim5 the command line.
function varargout = MarkStimGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle toggleStim5 figure
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in toggleStim1.
function toggleStim1_Callback(hObject, eventdata, handles)
% hObject    handle toggleStim5 toggleStim1 (see GCBO)
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleStim1

execToggleStim(hObject, eventdata, handles, 1);


% --- Executes on button press in toggleStim2.
function toggleStim2_Callback(hObject, eventdata, handles)
% hObject    handle toggleStim5 toggleStim2 (see GCBO)
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleStim2

execToggleStim(hObject, eventdata, handles, 2);


% --- Executes on button press in toggleStim3.
function toggleStim3_Callback(hObject, eventdata, handles)
% hObject    handle toggleStim5 toggleStim3 (see GCBO)
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleStim3

execToggleStim(hObject, eventdata, handles, 3);


% --- Executes on button press in toggleStim4.
function toggleStim4_Callback(hObject, eventdata, handles)
% hObject    handle toggleStim5 toggleStim4 (see GCBO)
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleStim4

execToggleStim(hObject, eventdata, handles, 4);


% --- Executes on button press in toggleStim5.
function toggleStim5_Callback(hObject, eventdata, handles)
% hObject    handle toggleStim5 toggleStim5 (see GCBO)
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleStim5

execToggleStim(hObject, eventdata, handles, 5);



% --- Executes on button press in any toggleStim.
function execToggleStim(hObject, eventdata, handles, i)
% Modifies Check Boxes and Push Buttons accordingly.

    cur = get(findobj('tag', ['pbStim', num2str(i)]), 'Value');

    if get(hObject, 'Value')
        set(hObject, 'String', ['<HTML><font color="green">Toggle ', num2str(i), ' On</HTML>']);
        set(findobj('tag', ['pbStim', num2str(i)]), 'Style', 'togglebutton');
    elseif (~get(hObject, 'Value')) && (~cur)
        set(hObject, 'String', ['<HTML><font color="red">Toggle ', num2str(i), ' Off</HTML>']);
        set(findobj('tag', ['pbStim', num2str(i)]), 'Style', 'pushbutton');
    elseif (~get(hObject, 'Value')) && (cur)
        set(hObject, 'Value', 1);
        msgbox(['Stop Stimulus ', num2str(i), ' first.']);
    else
        display('wtf');
    end
    
    guidata(hObject, handles);
    
return




% --- Executes on button press in pbStim1.
function pbStim1_Callback(hObject, eventdata, handles)
% hObject    handle toggleStim5 pbStim1 (see GCBO)
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

execPushStim(hObject, eventdata, handles, 1);


% --- Executes on button press in pbStim2.
function pbStim2_Callback(hObject, eventdata, handles)
% hObject    handle toggleStim5 pbStim2 (see GCBO)
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

execPushStim(hObject, eventdata, handles, 2);


% --- Executes on button press in pbStim3.
function pbStim3_Callback(hObject, eventdata, handles)
% hObject    handle toggleStim5 pbStim3 (see GCBO)
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

execPushStim(hObject, eventdata, handles, 3);


% --- Executes on button press in pbStim4.
function pbStim4_Callback(hObject, eventdata, handles)
% hObject    handle toggleStim5 pbStim4 (see GCBO)
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

execPushStim(hObject, eventdata, handles, 4);


% --- Executes on button press in pbStim5.
function pbStim5_Callback(hObject, eventdata, handles)
% hObject    handle toggleStim5 pbStim5 (see GCBO)
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

execPushStim(hObject, eventdata, handles, 5);


% --- Executes on button press in any pbStim
function execPushStim(hObject, eventdata, handles, i);
% Records Stimulus Accordingly

    try
        mhandles = guihandles(findobj('tag', 'cw6figure'));
        system = get(mhandles.AquistionButtons, 'Userdata');
        if(~strcmp(isrunning(system.MainDevice), 'on'))
            return
        else
            Cw6_data = get(mhandles.cw6figure, 'UserData');
            mark = Cw6_data.data.raw_t(end);
        end
    catch
        display('Error Connecting.');
        mark = NaN;
    end

    if isequal(get(hObject, 'Style'), 'pushbutton')
        event = 'hit';
    elseif isequal(get(hObject, 'Style'), 'togglebutton')
        if get(hObject, 'Value')
            event = 'start';
        else
            event = 'stop';
        end
    end

    eval(['x = size(handles.Stim{', num2str(i), '}, 1);']);
    eval(['handles.Stim{', num2str(i), '}{x+1, 1} = mark;']);
    eval(['handles.Stim{', num2str(i), '}{x+1, 2} = event;']);
    
    if(strcmp(event,'hit'))
        if(isempty(Cw6_data.data.stim{i}))
            Cw6_data.data.stim{i}(1)=mark;
        else
            Cw6_data.data.stim{i}(end+1)=mark;
        end
    end
    
    try
        eval(['Cw6_data.data.MarkStim{', num2str(i), '} = handles.Stim{', num2str(i), '};']);
        eval(['Cw6_data.data.MarkStimName{', num2str(i), '} = handles.StimName{', num2str(i), '};']);
        set(mhandles.cw6figure, 'UserData', Cw6_data);
    catch
        display('Error Saving.');
    end
    
    
    
    disp([event ': ' num2str(mark)])
    guidata(hObject, handles);

return









function editStim1_Callback(hObject, eventdata, handles)
% hObject    handle toggleStim5 editStim1 (see GCBO)
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStim1 as text
%        str2double(get(hObject,'String')) returns contents of editStim1 as a double

execEditStim(hObject, eventdata, handles, 1);


function editStim2_Callback(hObject, eventdata, handles)
% hObject    handle toggleStim5 editStim2 (see GCBO)
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStim2 as text
%        str2double(get(hObject,'String')) returns contents of editStim2 as a double

execEditStim(hObject, eventdata, handles, 2);


function editStim3_Callback(hObject, eventdata, handles)
% hObject    handle toggleStim5 editStim3 (see GCBO)
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStim3 as text
%        str2double(get(hObject,'String')) returns contents of editStim3 as a double

execEditStim(hObject, eventdata, handles, 3);


function editStim4_Callback(hObject, eventdata, handles)
% hObject    handle toggleStim5 editStim4 (see GCBO)
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStim4 as text
%        str2double(get(hObject,'String')) returns contents of editStim4 as a double

execEditStim(hObject, eventdata, handles, 4);


function editStim5_Callback(hObject, eventdata, handles)
% hObject    handle toggleStim5 editStim5 (see GCBO)
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStim5 as text
%        str2double(get(hObject,'String')) returns contents of editStim5 as a double

execEditStim(hObject, eventdata, handles, 5);


% --- Executes on text edit in any editStim
function execEditStim(hObject, eventdata, handles, i)
% Records Stimulus text accordingly.

    str = get(hObject, 'String');
    eval(['handles.StimName{', num2str(i), '} = str;']);

    guidata(hObject, handles);

return











% --- Executes during object creation, after setting all properties.
function editStim1_CreateFcn(hObject, eventdata, handles)
% hObject    handle toggleStim5 editStim1 (see GCBO)
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editStim2_CreateFcn(hObject, eventdata, handles)
% hObject    handle toggleStim5 editStim2 (see GCBO)
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editStim3_CreateFcn(hObject, eventdata, handles)
% hObject    handle toggleStim5 editStim3 (see GCBO)
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editStim4_CreateFcn(hObject, eventdata, handles)
% hObject    handle toggleStim5 editStim4 (see GCBO)
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editStim5_CreateFcn(hObject, eventdata, handles)
% hObject    handle toggleStim5 editStim5 (see GCBO)
% eventdata  reserved - toggleStim5 be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


