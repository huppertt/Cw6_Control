function varargout = Cw6(varargin)
% CW6 M-file for Cw6.fig
%      CW6, by itself, creates a new CW6 or raises the existing
%      singleton*.
%
%      H = CW6 returns the handle to a new CW6 or the handle to
%      the existing singleton*.
%
%      CW6('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CW6.M with the given input arguments.
%
%      CW6('Property','Value',...) creates a new CW6 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Cw6_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Cw6_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help Cw6

% Last Modified by GUIDE v2.5 04-Mar-2010 12:27:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Cw6_OpeningFcn, ...
    'gui_OutputFcn',  @Cw6_OutputFcn, ...
    'gui_LayoutFcn',  @Cw6_LayoutFcn, ...
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


function varargout = Cw6_OutputFcn(varargin)

if nargout>0
    varargout{1:nargout}=1;
end

return

% --- Executes just before Cw6 is made visible.
function Cw6_OpeningFcn(hObject, eventdata, handles, varargin)
global EPRIME_DIR;

set(hObject,'visible','off');
try
    %     Splash=LaunchSplash('Splash.jpg');
    %     Splash.setVisible(true);
    
    % label=Splash.getContentPane;
    %label=get(label(1),'Components');
    %label(1).setText('Loading configuration file...');
    set(hObject,'visible','off');
    guidata(hObject, handles);
    
    loadCw6ConfigFile(handles);
    
    %label(1).setText('Loading GUI...');
    handles=LayOutFunction(handles);
    
    
    global BOOL_ADJ_LASERS;
    handles=guihandles(handles.cw6figure);
    if(BOOL_ADJ_LASERS)
        c(1)=handles.LaserIntenSpinner_1;
        c(2)=handles.LaserIntenSpinner_2;
        c(3)=handles.LaserIntenSpinner_3;
        c(4)=handles.LaserIntenSpinner_4;
        c(5)=handles.LaserIntenSpinner_5;
        c(6)=handles.LaserIntenSpinner_6;
        c(7)=handles.LaserIntenSpinner_7;
        c(8)=handles.LaserIntenSpinner_8;
        
        for idx=1:8
            set(c(idx),'Parent',gcf)
            set(c(idx),'Position',[.174 .262 .04 .025]+[0 -.025 0 0]*(idx-1));
        end
        linkprop([handles.Laser_1 c],'visible');
    end
    
    %label(1).setText('Initializing system...');
    Cw6_BackEnd('Initialize',handles);
    
    set(handles.cw6figure,'visible','on');
    
    global PROBE_DIR;
    if(exist([PROBE_DIR filesep 'RealTimeModules'])==0)
        set(handles.RTProcessing,'enable','off');
    end
    
    h=findobj(handles.cw6figure);
    for idx=1:length(h);
        try; set(h(idx),'enable','off'); end;
    end;
    set(handles.RegSubj_Menu,'enable','on');
    set(handles.File_Menu,'enable','on');
    set(handles.Help_Menu_Outer,'enable','on');
    set(handles.Help_Menu,'enable','on');
    set(handles.About_Menu,'enable','on');
    set(handles.SystemInfo_Menu,'enable','on');
    set(handles.SubjID,'enable','on');
    set(handles.SaveSettings,'enable','on');
    set(handles.LoadSettings,'enable','on');
    set(handles.ExitProgram,'enable','on');
    set(handles.AddComments,'enable','on');
    set(handles.SubjectHdr,'enable','on');
    set(handles.ChangeSystemSettings,'enable','on')
    set(handles.SetDataCOM,'enable','off')
    set(handles.RegSubjContextCallback,'enable','on');
    set(handles.LoadSettings,'enable','on');
    set(handles.SystemInfo,'enable','on');
    set(findobj('tag','AGC'),'String','<HTML><CENTER>Automatic Gain Adjust</HTML>');
    
    str=get(handles.WhichDisplay,'string');
    
    str2={};
    global LAMBDA;
    for idx=1:length(LAMBDA)
        str2{idx}=['Intensity ' num2str(LAMBDA(idx)) 'nm'];
    end
    %
    %     for idx=1:length(str)-3
    %         str2{idx}=str{idx};
    %     end
    if(length(LAMBDA)>1)
        str2{end+1}='<HTML><font color="red"> Hemoglobin (HbO) </HTML>';
        str2{end+1}='<HTML><font color="blue"> Hemoglobin (HbR) </HTML>';
    end
    set(handles.WhichDisplay,'value',1)
    set(handles.WhichDisplay,'string',str2);
    set(handles.text4,'position',[0.6894    0.8462    0.3106    0.1238]);
    set(handles.text11,'position',[0.0773    0.7426    0.2847    0.2289]);
    set(get(handles.MainPlotWindow,'XLabel'),'visible','off');
    set(get(handles.MainPlotWindow,'YLabel'),'visible','off');
    set(handles.WindowDataEdit,'ButtonDownFcn','Cw6(''rescale_now_Callback'',gcbo,[],guidata(gcbo))');
    h=uicontrol('Style','pushbutton','tag','rescale_now','visible','off','enable','off');
    
    if(~isempty(EPRIME_DIR) & ~isnan(EPRIME_DIR))
        set(handles.eprime_file_name,'Label',EPRIME_DIR);
    end
    
    
    f=handles.cw6figure;
    handles=guihandles(f);
    guidata(f,handles);
    set(hObject,'visible','on');
    %     try;  Splash.dispose(); end  % close the splash screen
catch
    %This destroys the splash if a problem occured
    warning('Error loading GUI');
    disp(lasterr);
    try;  Splash.dispose(); end  % close the splash screen
end

return


% --- Executes on button press in WindowData.
function WindowData_Callback(hObject, eventdata, handles)



function WindowDataEdit_Callback(hObject, eventdata, handles)
% hObject    handle to WindowDataEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WindowDataEdit as text
%        str2double(get(hObject,'String')) returns contents of WindowDataEdit as a double


% --- Executes during object creation, after setting all properties.
function WindowDataEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WindowDataEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in WhichDisplay.
function WhichDisplay_Callback(hObject, eventdata, handles)
global NUM_LAMBDA;
handles=guihandles(findobj('tag','cw6figure'));
Lambda=get(handles.WhichDisplay,'value');

Cw6_data = get(handles.cw6figure,'UserData');

if(isempty(Cw6_data))
    set(handles.WhichDisplay,'value',2);
    return
end

if(Lambda>NUM_LAMBDA)
    if(isempty(Cw6_data.data.conc))
        Lambda=1;
        set(handles.WhichDisplay,'value',2);
    else
        Lambda=Lambda-NUM_LAMBDA;
    end
end
SubjInfo=get(handles.RegistrationInfo,'UserData');
for id=1:length(SubjInfo.SDGdisplay.PlotLst)
    pl=find(SubjInfo.Probe.MeasList(:,1)==SubjInfo.Probe.MeasList(SubjInfo.SDGdisplay.PlotLst(id),1) &...
        SubjInfo.Probe.MeasList(:,2)==SubjInfo.Probe.MeasList(SubjInfo.SDGdisplay.PlotLst(id),2) &...
        SubjInfo.Probe.MeasList(:,4)==Lambda);
    SubjInfo.SDGdisplay.PlotLst(id)=pl;
end
set(handles.RegistrationInfo,'UserData',SubjInfo);
PlotSDG(handles);

labels=get(handles.WhichDisplay,'string');
set(get(handles.MainPlotWindow,'YLabel'),'string',labels(get(handles.WhichDisplay,'value'),:));

% --- Executes on button press in ShowStimulus.
function ShowStimulus_Callback(hObject, eventdata, handles)
% hObject    handle to ShowStimulus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ShowStimulus
plotmainwindow;



% --- Executes during object creation, after setting all properties.
function SDG_PlotWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SDG_PlotWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate SDG_PlotWindow




% --- Executes on button press in MarkStim.
function MarkStim_Callback(hObject, eventdata, handles)
% hObject    handle to MarkStim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

system=get(handles.AquistionButtons,'Userdata');
if(~strcmp(isrunning(system.MainDevice),'on'))
    return
end
Cw6_data = get(handles.cw6figure,'UserData');
cTpt=Cw6_data.data.raw_t(end);
Cw6_data.data.stim{end}=[Cw6_data.data.stim{end} cTpt];
set(handles.cw6figure,'UserData',Cw6_data);

numStim=str2num(get(handles.NumberStimuliText,'string'));
set(handles.NumberStimuliText,'string',num2str(numStim+1));

return


% --------------------------------------------------------------------
function ExitProgram_Callback(hObject, eventdata, handles)
%TODO: Add Cw6 deconstructors here.

global SyncControl;
system=get(handles.AquistionButtons,'Userdata');

try; stop(system.MainTimer); end;
try; stop(system.AuxDevice); end;
try; stop(system.MainDevice); end;
try; stop(timerfind); end;
try; SyncControl.SetAOVoltageOff(0); end
closereq;

% --------------------------------------------------------------------
function ExportFileHdr_Callback(hObject, eventdata, handles)
% hObject    handle to ExportFileHdr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SendDataText_Callback(hObject, eventdata, handles)
% hObject    handle to SendDataText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Cw6_data = get(handles.cw6figure,'UserData');
if(isempty(Cw6_data))
    return
end
SubjInfo=get(findobj('tag','RegistrationInfo'),'UserData');

[filename, pathname] = uiputfile({'*.txt';'*.*'},'Pick a file');
if(filename==0)
    return
end
filen=[pathname filesep filename];
fid=fopen(filen,'w');

fprintf(fid,'CW6 Data text file');
fprintf(fid,'\rSubject ID: %s',SubjInfo.SubjID);
fprintf(fid,'\rInvestigator: %s',SubjInfo.Investigator);
fprintf(fid,'\rStudy: %s',SubjInfo.Study);
fprintf(fid,'\rData Directory: %s',SubjInfo.DataDir);
fprintf(fid,'\r\rLABELS\r');

fprintf(fid,'time\t');

for idx=1:size(SubjInfo.Probe.MeasList,1)
    str=sprintf('Src-%d:Det-%d:%dnm',SubjInfo.Probe.MeasList(idx,1),SubjInfo.Probe.Lambda(SubjInfo.Probe.MeasList(idx,4)));
    fprintf(fid,'%s\t',str);
end
str=[];
for idx=1:1+size(Cw6_data.data.raw,1)
    str=[str,'%f\t'];
end

fprintf(fid,'\r\rSTART DATA\r');

str=[str,'\r'];
fprintf(fid,str,[Cw6_data.data.raw_t; Cw6_data.data.raw]);

fprintf(fid,'\rEND DATA\r\r');

if(~isempty(Cw6_data.data.aux))
    str=[];
    for idx=1:1+size(Cw6_data.data.aux,1)
        str=[str,'%f\t'];
    end

    fprintf(fid,'\r\rSTART AUX\r');

    str=[str,'\r'];
    fprintf(fid,str,[Cw6_data.data.aux_t; Cw6_data.data.aux]);

    fprintf(fid,'\rEND AUX\r\r');
end

fclose(fid);
return

% --------------------------------------------------------------------
function SendDataHOMER_Callback(hObject, eventdata, handles)
% hObject    handle to SendDataHOMER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global rTest
rTest = 1;

%set(homerhandle,'Position',get(homerhandle,'position')+[1024 0 0 0]);

SubjInfo=get(handles.RegistrationInfo,'UserData');
filename=dir([SubjInfo.SubjID '-' SubjInfo.Study '-scan' num2str(SubjInfo.Scan-1) '-*.nirs']);
if(length(filename)==0)
    return;
end
homerhandle=HOMER;
HOMerMenu('HOMer_menu_File_Open_Callback',[],[],guihandles(homerhandle),filename.name);
rTest = 0;
% --------------------------------------------------------------------
function SetDataCOM_Callback(hObject, eventdata, handles)
% hObject    handle to SetDataCOM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SaveSettings_Callback(hObject, eventdata, handles,filename)
% hObject    handle to SaveSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=guihandles(findobj('tag','cw6figure'));
system=get(handles.AquistionButtons,'Userdata');
system.SubjInfo=get(findobj('tag','RegistrationInfo'),'UserData');

system.Lasers=getlaser(system.MainDevice);
system.Detectors=getgain(system.MainDevice);
system.datarate=getdatarate(system.MainDevice);
system.measlist=getML(system.MainDevice);
cw6figure=findobj('tag','cw6figure');
system.cw6info=get(cw6figure,'UserData');

if(~exist('filename'))
[filename, pathname] = uiputfile('Cw6_System.sys', 'Save System Settings as:');
filename=[pathname filesep filename];
end
save(filename,'system','-MAT');

return

% --------------------------------------------------------------------
function LoadSettings_Callback(hObject, eventdata, handles)
% hObject    handle to LoadSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global NUM_DET;
global NUM_SRC;

handles=guihandles(findobj('tag','cw6figure'));
[filename, pathname] = uigetfile('*.sys', 'Select System Settings File:');

if(isempty(filename) | filename==0)
    return;
end

load([pathname filesep filename],'-MAT');
set(findobj('tag','RegistrationInfo'),'UserData',system.SubjInfo);
Cw6LoadSubjInfo(system.SubjInfo);


setlaser(system.MainDevice,[1:length(system.Lasers)],system.Lasers);

%Fix gains
if(~isempty(system.Detectors))
    setgain(system.MainDevice,[1:length(system.Detectors)],system.Detectors);
    Javahandles=get(findobj('tag','DetTabContainer'),'UserData');
    [nPanels,nDet]=size(Javahandles.spinner);
    cnt=1;
    nDet=min(NUM_DET,nDet);
    for Tab=1:nPanels
        for Det=1:nDet
            set(Javahandles.spinner(Tab,Det),'Value',system.Detectors(cnt));
            cnt=cnt+1;
        end
    end
end
setdatarate(system.MainDevice,system.datarate);


cw6figure=findobj('tag','cw6figure');
set(cw6figure,'UserData',system.cw6info);

if(any(getlaser(system.MainDevice)))
     set(findobj('tag','LaserLED'),'BackgroundColor','r');
else
     set(findobj('tag','LaserLED'),'BackgroundColor',[.6 .6 .6]);
end


return

% --------------------------------------------------------------------
function SubjectHdr_Callback(hObject, eventdata, handles)
% hObject    handle to SubjectHdr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function AddComments_Callback(hObject, eventdata, handles)
f=figure;
set(f,'Toolbar','none');
set(f,'tag','AddComments');
set(f,'Name','Add Comments');
set(f,'NumberTitle','off');

[ExtraHandles.RichText2,ExtraHandles.RichText2Cont]=actxcontrol('RICHTEXT.RichtextCtrl.1');
set(ExtraHandles.RichText2Cont,'units','normalized');
set(ExtraHandles.RichText2Cont,'position',[.05 .15 .9 .8]);

buttonSave=uicontrol('style','pushbutton');
set(buttonSave,'units','normalized');
set(buttonSave,'position',[.75 .02 .2 .1]);
set(buttonSave,'FontSize',16);
set(buttonSave,'string','Save');
set(buttonSave,'Callback','SaveComments(gcbo)');
set(buttonSave,'UserData',ExtraHandles.RichText2);

buttonCancel=uicontrol('style','pushbutton');
set(buttonCancel,'units','normalized');
set(buttonCancel,'position',[.5 .02 .2 .1]);
set(buttonCancel,'FontSize',16);
set(buttonCancel,'string','Cancel');
set(buttonCancel,'Callback','closereq');




% --------------------------------------------------------------------
function UnseenSet_AGC_Callback(hObject, eventdata, handles)
% hObject    handle to UnseenSet_AGC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Unseen_AllOn_Callback(hObject, eventdata, handles)
% hObject    handle to Unseen_AllOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function TDM_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to TDM_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SetUp_TDM_Callback(hObject, eventdata, handles)
% hObject    handle to SetUp_TDM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TimeDivMultiMenu;
set(handles.UseTDM,'enable','on');

% --------------------------------------------------------------------
function UseTDM_Callback(hObject, eventdata, handles)
% hObject    handle to UseTDM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

updateCw6DeviceTDM;
if(strcmp(get(gcbo,'checked'),'on'))
    set(gcbo,'checked','off');
    SetTDM_toDevice(false);
else
    set(gcbo,'checked','on');
    SetTDM_toDevice(true);
end


% --------------------------------------------------------------------
function ChangeSystemSettings_Callback(hObject, eventdata, handles)
% hObject    handle to ChangeSystemSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SystemSettings;



% --- Executes on button press in MarkComment.
function MarkComment_Callback(hObject, eventdata, handles)

system=get(handles.AquistionButtons,'Userdata');
if(~strcmp(isrunning(system.MainDevice),'on'))
    return
end
Cw6_data = get(handles.cw6figure,'UserData');
cTpt=Cw6_data.data.raw_t(end);
Cw6_data.data.comment_times=[Cw6_data.data.comment_times cTpt];
set(handles.cw6figure,'UserData',Cw6_data);



% --- Executes on button press in ShowComments.
function ShowComments_Callback(hObject, eventdata, handles)
% hObject    handle to ShowComments (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ShowComments
plotmainwindow;


function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function ForceSave_Callback(hObject, eventdata, handles)
% hObject    handle to ForceSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function forcesavedata_Callback(hObject, eventdata, handles)
% hObject    handle to forcesavedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Cw6_data=get(handles.cw6figure,'UserData');
saveNIRSData(Cw6_data,[]);



% --------------------------------------------------------------------
function AddCommentText_Callback(hObject, eventdata, handles)
% This function will allow the user to add comments to the file

Cw6_data=get(handles.cw6figure,'UserData');

timeClickedOn=get(gca,'CurrentPoint');
timeClickedOn=mean(timeClickedOn(:,1));

stim=[];
for idx=1:length(Cw6_data.data.stim)
    stim=[stim Cw6_data.data.stim{idx}]; 
end



[time2,CommentIdx2]=min(abs(timeClickedOn-Cw6_data.data.comment_times));
[time,CommentIdx]=min(abs(timeClickedOn-stim));

if(isempty(time))
    time=time2;
    CommentIdx=CommentIdx2;
    usestim=false;
elseif(isempty(time2))
    usestim=stim;
elseif(time2<time)
    time=time2;
    CommentIdx=CommentIdx2;
    usestim=false;
else
    usestim=true;
end

if(usestim)
    str='Stimulus';
else
    str='Comment';
end

if(~usestim)
    time=Cw6_data.data.comment_times(CommentIdx);
else
    time=stim(CommentIdx);
end
prompt='Enter the Comment';
name=[str ' (@' num2str(time) 'sec)'];

comment=inputdlg(prompt,name,20);

if(isempty(comment))
    return
end

if(~usestim)
    Cw6_data.data.comment_text{CommentIdx}=comment;
end

text=strvcat(sprintf('%s At %f sec:',str, time),comment{1});

fid=fopen('Comments.txt','a');
fprintf(fid,'\n****************************************');
fprintf(fid,'\nComments Added: %s\n\n',datestr(now));
for idx=1:size(text,1)
fprintf(fid,'\n%s',text(idx,:));
end
fclose(fid);

return






% --- Creates and returns a handle to the GUI figure.
function h1 = Cw6_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end
LayOutFcn;

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
    warning('off','MATLAB:dispatcher:InexactMatch');
    eval(createfcn);
end


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)


%   GUI_MAINFCN provides these command line APIs for dealing with GUIs
%
%      CW6, by itself, creates a new CW6 or raises the existing
%      singleton*.
%
%      H = CW6 returns the handle to a new CW6 or the handle to
%      the existing singleton*.
%
%      CW6('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CW6.M with the given input arguments.
%
%      CW6('Property','Value',...) creates a new CW6 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".

%   Copyright 1984-2006 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $ $Date: 2006/10/10 02:22:41 $

gui_StateFields =  {'gui_Name'
    'gui_Singleton'
    'gui_OpeningFcn'
    'gui_OutputFcn'
    'gui_LayoutFcn'
    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error('MATLAB:gui_mainfcn:FieldNotFound', 'Could not find field %s in the gui_State struct in GUI M-file %s', gui_StateFields{i}, gui_Mfile);
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [gui_State.(gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % CW6
    % create the GUI only if we are not in the process of loading it
    % already
    gui_Create = true;
elseif local_isInvokeActiveXCallback(gui_State, varargin{:})
    % CW6(ACTIVEX,...)
    vin{1} = gui_State.gui_Name;
    vin{2} = [get(varargin{1}.Peer, 'Tag'), '_', varargin{end}];
    vin{3} = varargin{1};
    vin{4} = varargin{end-1};
    vin{5} = guidata(varargin{1}.Peer);
    feval(vin{:});
    return;
elseif local_isInvokeHGCallbak(gui_State, varargin{:})
    % CW6('CALLBACK',hObject,eventData,handles,...)
    gui_Create = false;
else
    % CW6(...)
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
        while ~isempty(fig) && ~isa(handle(fig),'figure')
            fig = get(fig,'parent');
        end

        designEval = isappdata(0,'CreatingGUIDEFigure') | isprop(fig,'__GUIDEFigure');
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
    if designEval & ishandle(fig)
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
    rmappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]));

    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);

    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    % Singleton setting in the GUI M-file takes priority if different
    gui_Options.singleton = gui_State.gui_Singleton;

    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
%         if gui_Options.syscolorfig
%             set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
%         end

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

    if isscalar(gui_hFigure) && ishandle(gui_hFigure)
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
        rmappdata(gui_hFigure,'InGUIInitialization');
    end

    % If handle visibility is set to 'callback', turn it on until finished with
    % OutputFcn
    if isscalar(gui_hFigure) && ishandle(gui_hFigure)
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

    if isscalar(gui_hFigure) && ishandle(gui_hFigure)
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
    gui_hFigure = openfig(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
else
    gui_hFigure = openfig(name, singleton, visible);
end

function result = local_isInvokeActiveXCallback(gui_State, varargin)

try
    result = ispc && iscom(varargin{1}) ...
        && isequal(varargin{1},gcbo);
catch
    result = false;
end

function result = local_isInvokeHGCallbak(gui_State, varargin)

try
    fhandle = functions(gui_State.gui_Callback);
    result = ~isempty(findstr(gui_State.gui_Name,fhandle.file)) || ...
        (ischar(varargin{1}) ...
        && isequal(ishandle(varargin{2}), 1) ...
        && ~isempty(strfind(varargin{1},[get(varargin{2}, 'Tag'), '_'])));
catch
    result = false;
end


% --- Executes on button press in rescale_now.
function rescale_now_Callback(hObject, eventdata, handles)
% hObject    handle to rescale_now (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guihandles(findobj('tag','cw6figure'));
Cw6_data = get(handles.cw6figure,'UserData');
if(isempty(Cw6_data) | isempty(Cw6_data.data.raw))
    return
end
cTpt=Cw6_data.data.raw_t(end);
set(handles.rescale_now,'Userdata',cTpt);


% --------------------------------------------------------------------
function Paradigm_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Paradigm_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuMarkStimGUI_Callback(hObject, eventdata, handles)
% hObject    handle to menuMarkStimGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Added 09/03/10 Davneet
numStim = 5; % Placeholder for importing number of stimuli from cw6.cfg
handles.markStim = MarkStimGUI(numStim);
guidata(hObject, handles);


% --------------------------------------------------------------------
function setup_stim_Callback(hObject, eventdata, handles)
% hObject    handle to setup_stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

SelectAuxillary;

% --------------------------------------------------------------------
function link2eprime_Callback(hObject, eventdata, handles)
% hObject    handle to link2eprime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EPRIME_DIR;
SetEprime;
if(~isempty(EPRIME_DIR))
    set(handles.eprime_file_name,'Label',EPRIME_DIR);
end

% --------------------------------------------------------------------
function eprime_file_name_Callback(hObject, eventdata, handles)
% hObject    handle to eprime_file_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function SystemInfo_Callback(hObject, eventdata, handles)
% hObject    handle to SystemInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function uimenu_stimulswzd_Callback(hObject, eventdata, handles)
% hObject    handle to uimenu_stimulswzd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

return


