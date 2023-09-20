function varargout = RealTimeFilterSetupMenu_export(varargin)
% REALTIMEFILTERSETUPMENU_EXPORT M-file for RealTimeFilterSetupMenu_export.fig
%      REALTIMEFILTERSETUPMENU_EXPORT, by itself, creates a new REALTIMEFILTERSETUPMENU_EXPORT or raises the existing
%      singleton*.
%
%      H = REALTIMEFILTERSETUPMENU_EXPORT returns the handle to a new REALTIMEFILTERSETUPMENU_EXPORT or the handle to
%      the existing singleton*.
%
%      REALTIMEFILTERSETUPMENU_EXPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REALTIMEFILTERSETUPMENU_EXPORT.M with the given input arguments.
%
%      REALTIMEFILTERSETUPMENU_EXPORT('Property','Value',...) creates a new REALTIMEFILTERSETUPMENU_EXPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RealTimeFilterSetupMenu_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RealTimeFilterSetupMenu_export_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help RealTimeFilterSetupMenu_export

% Last Modified by GUIDE v2.5 10-Dec-2014 07:42:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RealTimeFilterSetupMenu_export_OpeningFcn, ...
                   'gui_OutputFcn',  @RealTimeFilterSetupMenu_export_OutputFcn, ...
                   'gui_LayoutFcn',  @RealTimeFilterSetupMenu_export_LayoutFcn, ...
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


function varargout=RealTimeFilterSetupMenu_export_OutputFcn(varargin)

varargout{1}=gcf;

return

% --- Executes just before RealTimeFilterSetupMenu_export is made visible.
function RealTimeFilterSetupMenu_export_OpeningFcn(hObject, eventdata, handles, varargin)
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
    [ExtraHandles.RichText1,ExtraHandles.RichText1Cont]=javacomponent(javax.swing.JEditorPane);

    description=' ';
    for idx=1:size(modules{index}.description,1)
        description=sprintf('%s\n%s',description,mat2str(modules{index}.description(idx,:)));
    end
    %set(handles.activex1,'Text',description);
    set(ExtraHandles.RichText,'Text',description);
    
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

% --- Creates and returns a handle to the GUI figure. 
function h1 = RealTimeFilterSetupMenu_export_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end

appdata = [];
appdata.GUIDEOptions = struct(...
    'active_h', [], ...
    'taginfo', struct(...
    'figure', 2, ...
    'activex', 2, ...
    'text', 5, ...
    'listbox', 3, ...
    'pushbutton', 6), ...
    'override', 1, ...
    'release', 13, ...
    'resize', 'none', ...
    'accessibility', 'on', ...
    'mfile', 1, ...
    'callbacks', 1, ...
    'singleton', 1, ...
    'syscolorfig', 1, ...
    'blocking', 0, ...
    'lastSavedFile', 'C:\Users\CW6_007\Desktop\CW6_control\Cw6\RealTime\RealTimeFilterSetupMenu_export.m', ...
    'lastFilename', 'C:\Users\CW6_007\Desktop\CW6_control\Cw6\RealTime\RealTimeFilterSetupMenu.fig');
appdata.lastValidTag = 'RT_SetupMenu';
appdata.GUIDELayoutEditor = [];
appdata.initTags = struct(...
    'handle', [], ...
    'tag', 'RT_SetupMenu');

h1 = figure(...
'Units','normalized',...
'Color',[0.941176470588235 0.941176470588235 0.941176470588235],...
'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
'DockControls','off',...
'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
'MenuBar','none',...
'Name','RealTimeFilterSetupMenu',...
'NumberTitle','off',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'Position',[0.50625 0.45462962962963 0.302083333333333 0.585185185185185],...
'Resize','off',...
'UserData',[],...
'Tag','RT_SetupMenu',...
'Visible','on',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text1';

h2 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'Position',[0.6 20 31.8 1.61538461538462],...
'String','Description of module',...
'Style','text',...
'Tag','text1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'AvaliableRTModules';

h3 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)RealTimeFilterSetupMenu_export('AvaliableRTModules_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[1.8 22.7692307692308 26.8 10.6923076923077],...
'String','None',...
'Style','listbox',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)RealTimeFilterSetupMenu_export('AvaliableRTModules_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'UserData',[],...
'Tag','AvaliableRTModules');

appdata = [];
appdata.lastValidTag = 'LoadRTModules';

h4 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)RealTimeFilterSetupMenu_export('LoadRTModules_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[44.2 22.7692307692308 26.8 10.6923076923077],...
'String','None',...
'Style','listbox',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)RealTimeFilterSetupMenu_export('LoadRTModules_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'UserData',[],...
'Tag','LoadRTModules');

appdata = [];
appdata.lastValidTag = 'AddModule';

h5 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)RealTimeFilterSetupMenu_export('AddModule_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[29.4 29.5384615384615 13.8 1.76923076923077],...
'String','Load >>',...
'Tag','AddModule',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'RemoveModule';

h6 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)RealTimeFilterSetupMenu_export('RemoveModule_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[29.4 27.1538461538462 13.8 1.76923076923077],...
'String','<<Remove',...
'Tag','RemoveModule',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text2';

h7 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',10,...
'Position',[1.8 33.4615384615385 21.8 1.61538461538462],...
'String','Avaliable Modules',...
'Style','text',...
'Tag','text2',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text3';

h8 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',10,...
'Position',[43.4 33.3846153846154 21.8 1.61538461538462],...
'String','Loaded Modules',...
'Style','text',...
'Tag','text3',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Options';

h9 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)RealTimeFilterSetupMenu_export('Options_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[57.2 20.4615384615385 13.8 1.76923076923077],...
'String','Options',...
'Tag','Options',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Cancel';

h10 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)RealTimeFilterSetupMenu_export('Cancel_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[30.4 2.3076923076923 20.4 2],...
'String','Cancel',...
'Tag','Cancel',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Accept';

h11 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)RealTimeFilterSetupMenu_export('Accept_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[52.2 2.23076923076923 20.4 2],...
'String','Accept',...
'Tag','Accept',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );


hsingleton = h1;


% --- Set application data first then calling the CreateFcn. 
function local_CreateFcn(hObject, eventdata, createfcn, appdata)

if ~isempty(appdata)
   names = fieldnames(appdata);
   for i=1:length(names)
       name = char(names(i));
       setappdata(hObject, name, getfield(appdata,name));
   end
end

if ~isempty(createfcn)
   if isa(createfcn,'function_handle')
       createfcn(hObject, eventdata);
   else
       eval(createfcn);
   end
end


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)

gui_StateFields =  {'gui_Name'
    'gui_Singleton'
    'gui_OpeningFcn'
    'gui_OutputFcn'
    'gui_LayoutFcn'
    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error(message('MATLAB:guide:StateFieldNotFound', gui_StateFields{ i }, gui_Mfile));
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [gui_State.(gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % REALTIMEFILTERSETUPMENU_EXPORT
    % create the GUI only if we are not in the process of loading it
    % already
    gui_Create = true;
elseif local_isInvokeActiveXCallback(gui_State, varargin{:})
    % REALTIMEFILTERSETUPMENU_EXPORT(ACTIVEX,...)
    vin{1} = gui_State.gui_Name;
    vin{2} = [get(varargin{1}.Peer, 'Tag'), '_', varargin{end}];
    vin{3} = varargin{1};
    vin{4} = varargin{end-1};
    vin{5} = guidata(varargin{1}.Peer);
    feval(vin{:});
    return;
elseif local_isInvokeHGCallback(gui_State, varargin{:})
    % REALTIMEFILTERSETUPMENU_EXPORT('CALLBACK',hObject,eventData,handles,...)
    gui_Create = false;
else
    % REALTIMEFILTERSETUPMENU_EXPORT(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = true;
end

if ~gui_Create
    % In design time, we need to mark all components possibly created in
    % the coming callback evaluation as non-serializable. This way, they
    % will not be brought into GUIDE and not be saved in the figure file
    % when running/saving the GUI from GUIDE.
    designEval = false;
    if (numargin>1 && ishghandle(varargin{2}))
        fig = varargin{2};
        while ~isempty(fig) && ~ishghandle(fig,'figure')
            fig = get(fig,'parent');
        end
        
        designEval = isappdata(0,'CreatingGUIDEFigure') || (isscalar(fig)&&isprop(fig,'GUIDEFigure'));
    end
        
    if designEval
        beforeChildren = findall(fig);
    end
    
    % evaluate the callback now
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else       
        feval(varargin{:});
    end
    
    % Set serializable of objects created in the above callback to off in
    % design time. Need to check whether figure handle is still valid in
    % case the figure is deleted during the callback dispatching.
    if designEval && ishghandle(fig)
        set(setdiff(findall(fig),beforeChildren), 'Serializable','off');
    end
else
    if gui_State.gui_Singleton
        gui_SingletonOpt = 'reuse';
    else
        gui_SingletonOpt = 'new';
    end

    % Check user passing 'visible' P/V pair first so that its value can be
    % used by oepnfig to prevent flickering
    gui_Visible = 'auto';
    gui_VisibleInput = '';
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        % Recognize 'visible' P/V pair
        len1 = min(length('visible'),length(varargin{index}));
        len2 = min(length('off'),length(varargin{index+1}));
        if ischar(varargin{index+1}) && strncmpi(varargin{index},'visible',len1) && len2 > 1
            if strncmpi(varargin{index+1},'off',len2)
                gui_Visible = 'invisible';
                gui_VisibleInput = 'off';
            elseif strncmpi(varargin{index+1},'on',len2)
                gui_Visible = 'visible';
                gui_VisibleInput = 'on';
            end
        end
    end
    
    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.

    
    % Do feval on layout code in m-file if it exists
    gui_Exported = ~isempty(gui_State.gui_LayoutFcn);
    % this application data is used to indicate the running mode of a GUIDE
    % GUI to distinguish it from the design mode of the GUI in GUIDE. it is
    % only used by actxproxy at this time.   
    setappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]),1);
    if gui_Exported
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);

        % make figure invisible here so that the visibility of figure is
        % consistent in OpeningFcn in the exported GUI case
        if isempty(gui_VisibleInput)
            gui_VisibleInput = get(gui_hFigure,'Visible');
        end
        set(gui_hFigure,'Visible','off')

        % openfig (called by local_openfig below) does this for guis without
        % the LayoutFcn. Be sure to do it here so guis show up on screen.
        movegui(gui_hFigure,'onscreen');
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        end
    end
    if isappdata(0, genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]))
        rmappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]));
    end

    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);

    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    % Singleton setting in the GUI M-file takes priority if different
    gui_Options.singleton = gui_State.gui_Singleton;

    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
        if gui_Options.syscolorfig
            set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
        end

        % Generate HANDLES structure and store with GUIDATA. If there is
        % user set GUI data already, keep that also.
        data = guidata(gui_hFigure);
        handles = guihandles(gui_hFigure);
        if ~isempty(handles)
            if isempty(data)
                data = handles;
            else
                names = fieldnames(handles);
                for k=1:length(names)
                    data.(char(names(k)))=handles.(char(names(k)));
                end
            end
        end
        guidata(gui_hFigure, data);
    end

    % Apply input P/V pairs other than 'visible'
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        len1 = min(length('visible'),length(varargin{index}));
        if ~strncmpi(varargin{index},'visible',len1)
            try set(gui_hFigure, varargin{index}, varargin{index+1}), catch break, end
        end
    end

    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(gui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end

    feval(gui_State.gui_OpeningFcn, gui_hFigure, [], guidata(gui_hFigure), varargin{:});

    if isscalar(gui_hFigure) && ishghandle(gui_hFigure)
        % Handle the default callbacks of predefined toolbar tools in this
        % GUI, if any
        guidemfile('restoreToolbarToolPredefinedCallback',gui_hFigure); 
        
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);

        % Call openfig again to pick up the saved visibility or apply the
        % one passed in from the P/V pairs
        if ~gui_Exported
            gui_hFigure = local_openfig(gui_State.gui_Name, 'reuse',gui_Visible);
        elseif ~isempty(gui_VisibleInput)
            set(gui_hFigure,'Visible',gui_VisibleInput);
        end
        if strcmpi(get(gui_hFigure, 'Visible'), 'on')
            figure(gui_hFigure);
            
            if gui_Options.singleton
                setappdata(gui_hFigure,'GUIOnScreen', 1);
            end
        end

        % Done with GUI initialization
        if isappdata(gui_hFigure,'InGUIInitialization')
            rmappdata(gui_hFigure,'InGUIInitialization');
        end

        % If handle visibility is set to 'callback', turn it on until
        % finished with OutputFcn
        gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(gui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        gui_Handles = guidata(gui_hFigure);
    else
        gui_Handles = [];
    end

    if nargout
        [varargout{1:nargout}] = feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    else
        feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    end

    if isscalar(gui_hFigure) && ishghandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
    end
end

function gui_hFigure = local_openfig(name, singleton, visible)

% openfig with three arguments was new from R13. Try to call that first, if
% failed, try the old openfig.
if nargin('openfig') == 2
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = matlab.hg.internal.openfigLegacy(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
else
    % Call version of openfig that accepts 'auto' option"
    gui_hFigure = matlab.hg.internal.openfigLegacy(name, singleton, visible);  
    %workaround for CreateFcn not called to create ActiveX
    if feature('HGUsingMATLABClasses')
        peers=findobj(findall(allchild(gui_hFigure)),'type','uicontrol','style','text');    
        for i=1:length(peers)
            if isappdata(peers(i),'Control')
                actxproxy(peers(i));
            end            
        end
    end
end

function result = local_isInvokeActiveXCallback(gui_State, varargin)

try
    result = ispc && iscom(varargin{1}) ...
             && isequal(varargin{1},gcbo);
catch
    result = false;
end

function result = local_isInvokeHGCallback(gui_State, varargin)

try
    fhandle = functions(gui_State.gui_Callback);
    result = ~isempty(findstr(gui_State.gui_Name,fhandle.file)) || ...
             (ischar(varargin{1}) ...
             && isequal(ishghandle(varargin{2}), 1) ...
             && (~isempty(strfind(varargin{1},[get(varargin{2}, 'Tag'), '_'])) || ...
                ~isempty(strfind(varargin{1}, '_CreateFcn'))) );
catch
    result = false;
end


