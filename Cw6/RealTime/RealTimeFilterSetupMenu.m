function varargout = RealTimeFilterSetupMenu(varargin)
% REALTIMEFILTERSETUPMENU M-file for RealTimeFilterSetupMenu.fig
%      REALTIMEFILTERSETUPMENU, by itself, creates a new REALTIMEFILTERSETUPMENU or raises the existing
%      singleton*.
%
%      H = REALTIMEFILTERSETUPMENU returns the handle to a new REALTIMEFILTERSETUPMENU or the handle to
%      the existing singleton*.
%
%      REALTIMEFILTERSETUPMENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REALTIMEFILTERSETUPMENU.M with the given input arguments.
%
%      REALTIMEFILTERSETUPMENU('Property','Value',...) creates a new REALTIMEFILTERSETUPMENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RealTimeFilterSetupMenu_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RealTimeFilterSetupMenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help RealTimeFilterSetupMenu

% Last Modified by GUIDE v2.5 07-Mar-2008 12:59:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RealTimeFilterSetupMenu_OpeningFcn, ...
                   'gui_OutputFcn',  @RealTimeFilterSetupMenu_OutputFcn, ...
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


function varargout=RealTimeFilterSetupMenu_OutputFcn(varargin)

varargout{1}=gcf;

return

% --- Executes just before RealTimeFilterSetupMenu is made visible.
function RealTimeFilterSetupMenu_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

guidata(hObject, handles);

handles=guihandles(findobj('tag','RT_SetupMenu'));
AvaliableRTModules_Callback(handles.AvaliableRTModules, [], handles);
LoadRTModules_Callback(handles.LoadRTModules, [], handles);

return


% --- Executes on selection change in AvaliableRTModules.
function AvaliableRTModules_Callback(hObject, eventdata, handles)
handles=guihandles(findobj('tag','RT_SetupMenu'));

index=get(handles.AvaliableRTModules,'value');
modules=get(handles.AvaliableRTModules,'UserData');

if(isempty(modules))
    return
end

if(isstruct(modules{end}))
    description=' ';
    for idx=1:size(modules{index}.description,1)
        description=sprintf('%s\n%s',description,mat2str(modules{index}.description(idx,:)));
    end
    set(handles.activex1,'Text',description);
end

return


% --- Executes during object creation, after setting all properties.
function AvaliableRTModules_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Get list of avaliable modules
global PROBE_DIR;

RTDIR=[PROBE_DIR filesep 'RealTimeModules'];
files=dir(RTDIR);

modulecnt=0;
modules={};
for idx=1:length(files)
    if(files(idx).isdir & ~strcmp(files(idx).name,'.') & ~strcmp(files(idx).name,'..'))
        
        localmodule.name=files(idx).name;
        if(exist([RTDIR filesep files(idx).name filesep 'Description_' files(idx).name '.txt'])~=0)
            try
                fid=fopen(['Description_' files(idx).name '.txt'],'r');
                localmodule.description=[];
                while(1)
                    line=fgetl(fid);
                    if(line==-1); break; end
                    localmodule.description=strvcat(localmodule.description,line);
                end
                fclose(fid);
            catch
                localmodule.description='No description avaliable';
            end
        else
            localmodule.description='No description avaliable';
        end
        if(exist([RTDIR filesep files(idx).name filesep 'Options_' files(idx).name '.m'])~=0)
            localmodule.hasoptions=1;
            localmodule.optionsfunction=['Options_' files(idx).name];
        else
            localmodule.hasoptions=0;
        end
         if(exist([RTDIR filesep files(idx).name filesep 'functioncallback_' files(idx).name '.m'])~=0)
            localmodule.callfunction=['functioncallback_' files(idx).name '.m'];
            modulecnt=modulecnt+1;
            modules{modulecnt}=localmodule;
        end
    end
end



Modulelst=[];
for idx=1:length(modules)
    Modulelst=strvcat(Modulelst,modules{idx}.name);
end

if(isempty(Modulelst))
    Modulelst='None';
end

handles=guihandles(findobj('tag','RT_SetupMenu'));
set(handles.AvaliableRTModules,'string',Modulelst);
set(handles.AvaliableRTModules,'value',1);
set(handles.AvaliableRTModules,'UserData',modules);

return




% --- Executes on selection change in LoadRTModules.
function LoadRTModules_Callback(hObject, eventdata, handles)

index=get(handles.LoadRTModules,'value');
modules=get(handles.LoadRTModules,'userdata');

if(isempty(modules))
    set(handles.Options,'enable','off');
elseif(modules{index}.hasoptions)
    set(handles.Options,'enable','on');
    warning('off','MATLAB:dispatcher:InexactMatch');
    set(handles.Options,'callback',@(varargin)run(strtok(modules{index}.optionsfunction)));
else
    set(handles.Options,'enable','off');
end

return

% --- Executes during object creation, after setting all properties.
function LoadRTModules_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LoadRTModules (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

cw6figure=findobj('tag','cw6figure');

cw6info=get(cw6figure,'UserData');

if(~isfield(cw6info,'RTmodules'))
    %No modules loaded
    modules={};
else
    modules=cw6info.RTmodules;
end

Modulelst=[];
for idx=1:length(modules)
    Modulelst=strvcat(Modulelst,modules{idx}.name);
end

if(isempty(Modulelst))
    Modulelst='None';
end

handles=guihandles(findobj('tag','RT_SetupMenu'));
set(handles.LoadRTModules,'string',Modulelst);
set(handles.LoadRTModules,'UserData',modules);

return


% --- Executes on button press in AddModule.
function AddModule_Callback(hObject, eventdata, handles)

handles=guihandles(findobj('tag','RT_SetupMenu'));
index=get(handles.AvaliableRTModules,'value');
modules=get(handles.AvaliableRTModules,'UserData');

loadedmodules=get(handles.LoadRTModules,'userdata');

loadedmodules{end+1}=modules{index};

Modulelst=[];
for idx=1:length(loadedmodules)
    Modulelst=strvcat(Modulelst,loadedmodules{idx}.name);
end

if(isempty(Modulelst))
    Modulelst='None';
end
set(handles.LoadRTModules,'userdata',loadedmodules);
set(handles.LoadRTModules,'string',Modulelst);
set(handles.LoadRTModules,'value',length(loadedmodules));
LoadRTModules_Callback(handles.LoadRTModules, [], handles);

return



% --- Executes on button press in RemoveModule.
function RemoveModule_Callback(hObject, eventdata, handles)

handles=guihandles(findobj('tag','RT_SetupMenu'));
index=get(handles.LoadRTModules,'value');
modules=get(handles.LoadRTModules,'userdata');

loadedmodules={};
for idx=1:index-1
    loadedmodules{end+1}=modules{idx};
end
for idx=index+1:length(modules)
    loadedmodules{end+1}=modules{idx};
end

Modulelst=[];
for idx=1:length(loadedmodules)
    Modulelst=strvcat(Modulelst,loadedmodules{idx}.name);
end

if(isempty(Modulelst))
    Modulelst='None';
end
set(handles.LoadRTModules,'userdata',loadedmodules);
set(handles.LoadRTModules,'value',max([length(loadedmodules) 1]));
set(handles.LoadRTModules,'string',Modulelst);
LoadRTModules_Callback(handles.LoadRTModules, [], handles);




% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
close(findobj('tag','RT_SetupMenu'));

% --- Executes on button press in Accept.
function Accept_Callback(hObject, eventdata, handles)
modules=get(handles.LoadRTModules,'userdata');

cw6figure=findobj('tag','cw6figure');
cw6info=get(cw6figure,'UserData');
cw6info.RTmodules=modules;

for idx=1:length(cw6info.RTmodules)
    cw6info.RTmodules{idx}.fhandle=str2func(strtok(cw6info.RTmodules{idx}.callfunction,'.'));
end
set(cw6figure,'UserData',cw6info);
close(findobj('tag','RT_SetupMenu'));

return