function varargout = RegisterSubject(varargin)



if nargin == 0  % LAUNCH GUI
    fig = openfig('RegisterSubject.fig','new');
    % Generate a structure of handles to pass to callbacks, and store it.
    handles = guihandles(fig);
    guidata(fig, handles);
    figure(fig);
    Initialize(handles);
    if nargout > 0
        varargout{1} = fig;
    end
else
    try
        [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
    catch
        disp(lasterr);  %Otherwise display error to command window only
    end
    % End initialization code - DO NOT EDIT
end


function Initialize(handles);
global PROBE_DIR;
global DATA_DIR;

if(isempty(DATA_DIR))
    DATA_DIR='C:\';
end


%[ExtraHandles.RichText1,ExtraHandles.RichText1Cont]=actxcontrol('MSMask.MaskEdBox.1');
%[ExtraHandles.RichText1,ExtraHandles.RichText1Cont]=actxcontrol('RICHTEXT.RichtextCtrl.1');
[ExtraHandles.RichText1,ExtraHandles.RichText1Cont]=javacomponent(javax.swing.JEditorPane);

set(ExtraHandles.RichText1Cont,'parent',handles.uipanel1);
set(ExtraHandles.RichText1Cont,'units','normalized');
set(ExtraHandles.RichText1Cont,'position',[.39 .05 .23 .5]);

%[ExtraHandles.RichText2,ExtraHandles.RichText2Cont]=actxcontrol('RICHTEXT.RichtextCtrl.1');
%[ExtraHandles.RichText2,ExtraHandles.RichText2Cont]=actxcontrol('MSMask.MaskEdBox.1');
[ExtraHandles.RichText2,ExtraHandles.RichText2Cont]=javacomponent(javax.swing.JEditorPane);

set(ExtraHandles.RichText2Cont,'units','normalized');
set(ExtraHandles.RichText2Cont,'position',[.615 .58 .35 .35]);

[ExtraHandles.Investigators_ComboBox,ExtraHandles.Investigators_ComboBoxContainer] =...
    javacomponent(javax.swing.JComboBox);
set(ExtraHandles.Investigators_ComboBoxContainer,'parent',handles.uipanel2);
set(handles.SubjID_Edit,'units','normalized');
pos=get(handles.SubjID_Edit,'position');
set(ExtraHandles.Investigators_ComboBoxContainer,'units','normalized');
set(ExtraHandles.Investigators_ComboBoxContainer,'position',pos+[0 -.18 0 0]);
set(ExtraHandles.Investigators_ComboBox,'editable',true)
set(ExtraHandles.Investigators_ComboBox,'ActionPerformedCallback',@PopulateStudiesComboBox);

[ExtraHandles.DenoteGroup_ComboBox,ExtraHandles.DenoteGroup_ComboBoxContainer] =...
    javacomponent(javax.swing.JComboBox);
pos3=get(handles.checkbox_denoteasgroup,'position');
pos2=get(ExtraHandles.Investigators_ComboBoxContainer,'position');
set(ExtraHandles.DenoteGroup_ComboBoxContainer,'parent',handles.uipanel2);
set(ExtraHandles.DenoteGroup_ComboBoxContainer,'units','normalized');
set(ExtraHandles.DenoteGroup_ComboBoxContainer,'position',[pos2(1) pos3(2)+pos3(4)/3 pos2(3) pos2(4)]);
set(ExtraHandles.DenoteGroup_ComboBox,'editable',true)
set(handles.checkbox_denoteasgroup,'string','<html><center>Denote as<br>sub-group</html>');

%Populate the Invesitagor pulldown:
folders=dir(DATA_DIR);
ExtraHandles.Investigators_ComboBox.addItem('Add New');
for idx=1:length(folders)
    if(~any(strcmp(folders(idx).name,{'.' '..'})))
        if(folders(idx).isdir)
            ExtraHandles.Investigators_ComboBox.addItem(folders(idx).name);
        end
    end
end

[ExtraHandles.Study_ComboBox,ExtraHandles.Study_ComboBoxContainer] =...
    javacomponent(javax.swing.JComboBox);
set(ExtraHandles.Study_ComboBoxContainer,'parent',handles.uipanel2);
set(ExtraHandles.Study_ComboBoxContainer,'units','normalized');
set(ExtraHandles.Study_ComboBoxContainer,'position',pos+[0 -.34 0 0]);
set(ExtraHandles.Study_ComboBox,'editable',true);
set(ExtraHandles.Study_ComboBox,'ActionPerformedCallback',@ChangeStudiesComboBox);

ExtraHandles.ProbeTree=UITree_ted(PROBE_DIR,'.sdg',...
    @PreviewProbe_Callback,handles.SDG_TreeView);

set(handles.uipanel2,'UserData',ExtraHandles);

PopulateStudiesComboBox;
ChangeStudiesComboBox;

return

function ChangeStudiesComboBox(varargin)
global PROBE_DIR;
global DATA_DIR;

f=findobj('tag','RegSubject');
if(isempty(f))
    return
end
handles=guidata(f(1));

ExtraHandles=get(handles.uipanel2,'UserData');
LocalDir=ExtraHandles.Investigators_ComboBox.SelectedItem;
StudyDir=ExtraHandles.Study_ComboBox.SelectedItem;

probeFiles=dir([DATA_DIR filesep LocalDir filesep StudyDir filesep '*.sdg']);
if(~isempty(probeFiles))
    probeFile=[DATA_DIR filesep LocalDir filesep StudyDir filesep probeFiles(1).name];
    LoadProbe_Callback([],[],handles,probeFile);
end

DescFiles=dir([DATA_DIR filesep LocalDir filesep StudyDir filesep 'Description']);
if(~isempty(DescFiles))
    DescFile=[DATA_DIR filesep LocalDir filesep StudyDir filesep DescFiles(1).name];
    fid=fopen(DescFile,'r');
    text=fgets(fid);
    fclose(fid);
    set(ExtraHandles.RichText2,'Text',text);
else
    set(ExtraHandles.RichText2,'Text',' ');
end

%Sub-groups
folders=dir([DATA_DIR filesep LocalDir filesep StudyDir filesep]);
ExtraHandles.DenoteGroup_ComboBox.removeAllItems();
flag=0;
for idx=1:length(folders)
    if(~any(strcmp(folders(idx).name,{'.' '..'})) & isempty(strfind(folders(idx).name,strtok(folders(idx).date))))
        %Note "isempty(strfind(folders(idx).name,strtok(folders(idx).date))" checks for data folder format w/ date in title 
        if(folders(idx).isdir)
            ExtraHandles.DenoteGroup_ComboBox.addItem(folders(idx).name);
            flag=1;
        end
    end
end
ExtraHandles.DenoteGroup_ComboBox.addItem('Add New');

set(handles.checkbox_denoteasgroup,'value',0);
set(ExtraHandles.DenoteGroup_ComboBox,'visible',flag);




return



function PopulateStudiesComboBox(varargin)
global PROBE_DIR;
global DATA_DIR;

f=findobj('tag','RegSubject');
if(isempty(f))
    return
end
handles=guidata(f(1));

ExtraHandles=get(handles.uipanel2,'UserData');

LocalDir=ExtraHandles.Investigators_ComboBox.SelectedItem;
ExtraHandles.Study_ComboBox.removeAllItems();
folders=dir([DATA_DIR filesep LocalDir filesep '*']);
for idx=1:length(folders)
    if(~any(strcmp(folders(idx).name,{'.' '..'})))
        if(folders(idx).isdir)
            ExtraHandles.Study_ComboBox.addItem(folders(idx).name);
        end
    end
end
ExtraHandles.Study_ComboBox.addItem('Add New');

ExtraHandles.DenoteGroup_ComboBox.removeAllItems();
ExtraHandles.DenoteGroup_ComboBox.addItem('Add New');

set(ExtraHandles.DenoteGroup_ComboBox,'visible',get(handles.checkbox_denoteasgroup,'value'));


return


function PreviewProbe_Callback(varargin)

path = GetSelectedTree;
if(~isempty(strfind(path,'.sdg')))
    probeFile=path;
    %SDG=LoadSDG(probeFile);
    %PlotProbePreview(SDG);
    f=findobj('tag','RegSubject');
    if(isempty(f))
        return
    end
    handles=guidata(f);

    LoadProbe_Callback([],[],handles,probeFile);
end

return

function path = node2path(node)
path = node.getPath;
for i=1:length(path);
    p{i} = char(path(i).getName);
end
if length(p) > 1
    path = fullfile(p{:});
else
    path = p{1};
end
return

function path = GetSelectedTree
f=findobj('tag','RegSubject');
if(isempty(f))
    return
end
handles=guidata(f);

ExtraHandles=get(handles.uipanel2,'UserData');
nodes = ExtraHandles.ProbeTree.SelectedNodes;
if isempty(nodes)
    path=[];
    return
end
node = nodes(1);
path = node2path(node);

return

% --- Executes on button press in LoadProbe.
function LoadProbe_Callback(hObject, eventdata, handles,probeFile)
% hObject    handle to LoadProbe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(~exist('probeFile'))
    path = GetSelectedTree;
    [p,f,ext]=fileparts(path);
    if(~strcmp(ext,'.sdg'))
        set(handles.LoadedProbeName,'string',' ');
        PlotProbePreview([]);
        return
    end
    probeFile=path;
end

SDG=LoadSDG(probeFile);
[foo,filename,ext]=fileparts(SDG.Name);

filename=[filename ext];

set(handles.LoadedProbeName,'string',filename);

PlotProbePreview(SDG);
return


% --- Executes on button press in Finished.
function Finished_Callback(hObject, eventdata, handles)


ExtraHandles=get(handles.uipanel2,'UserData');

%Check required fields
isOkay=1;
NeedsFixing=' ';
ProbeMissing=false;
if(strcmp(get(handles.SubjID_Edit,'string'),'Not Specified'))
    isOkay=0;
    NeedsFixing=sprintf('%s\n%s',NeedsFixing,'Invalid: Subject ID');
end
if(strcmp(get(handles.LoadedProbeName,'string'),'No Probe Selected'))
    isOkay=0;
    ProbeMissing=true;
    NeedsFixing=sprintf('%s\n%s',NeedsFixing,'Invalid: Probe Name');
end
if(strcmp(ExtraHandles.Investigators_ComboBox.SelectedItem,'Add New'))
    isOkay=0;
    NeedsFixing=sprintf('%s\n%s',NeedsFixing,'Invalid: Invesigator Name');
end
if(strcmp(ExtraHandles.Study_ComboBox.SelectedItem,'Add New'))
    isOkay=0;
    NeedsFixing=sprintf('%s\n%s',NeedsFixing,'Invalid: Study Name');
end

SubjInfo.IsTestOnly=get(handles.DontSave,'value');

if(~SubjInfo.IsTestOnly)
if(~isOkay)
    NeedsFixing=sprintf('%s\n%s','Required Registration Fields Missing!',NeedsFixing);
    warndlg(NeedsFixing)
    return
end
else
    if(ProbeMissing)
        warndlg('Probe must be specified');
        return
    end
    %Otherwise, we are testing so allow quick transfer of defaults
end

global DATA_DIR;

%Gather Registration info:
SubjInfo.SubjID=get(handles.SubjID_Edit,'string');
SubjInfo.Probe=get(handles.IsPreview,'UserData');
SubjInfo.Investigator=ExtraHandles.Investigators_ComboBox.SelectedItem;
SubjInfo.Study=ExtraHandles.Study_ComboBox.SelectedItem;
SubjInfo.RootDataDir=DATA_DIR;
SubjInfo.DataDir=[DATA_DIR filesep SubjInfo.Investigator filesep SubjInfo.Study];

if(get(handles.checkbox_denoteasgroup,'value'))
   Folder=ExtraHandles.DenoteGroup_ComboBox.SelectedItem;
   SubjInfo.DataDir=[SubjInfo.DataDir filesep Folder];
   if(~exist(SubjInfo.DataDir,'dir'))
       mkdir(SubjInfo.DataDir);
   end
end


SubjInfo.DataDir(strfind(SubjInfo.DataDir,' '))='_';
if(get(handles.AppendDate,'value')==1)
    SubjInfo.DataDir=[SubjInfo.DataDir filesep SubjInfo.SubjID '_' datestr(now)];
end

SubjInfo.Comments=get(ExtraHandles.RichText2,'Text');

SubjInfo.IsTestOnly=get(handles.DontSave,'value');

Cw6LoadSubjInfo(SubjInfo);
close(handles.RegSubject);
return

% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
%User cancel- just return
close(handles.RegSubject);
return


% --- Executes on button press in DontSave.
function DontSave_Callback(hObject, eventdata, handles)
% hObject    handle to DontSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DontSave

if(get(hObject,'value'))
    h=warndlg('Data will not be saved');
    uiwait(h);
end


    
% --- Executes on button press in checkbox_denoteasgroup.
function checkbox_denoteasgroup_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_denoteasgroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_denoteasgroup
ExtraHandles=get(handles.uipanel2,'UserData');
if(get(gcbo,'value'))
    set(ExtraHandles.DenoteGroup_ComboBox,'visible',1);
else
    set(ExtraHandles.DenoteGroup_ComboBox,'visible',0);
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


