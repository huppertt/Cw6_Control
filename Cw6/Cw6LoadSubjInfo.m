function Cw6LoadSubjInfo(SubjInfo)
%This function loads the registration info from the sub-GUI

global PROBE_DIR;
global DATA_DIR;
global SYSTEM_TYPE;
global NUM_SRC;
global NUM_DET;
global NUM_LAMBDA;
global LAMBDA;

handles=guihandles(findobj('tag','cw6figure'));

%Create a Data folder if not exist:
SubjInfo.DataDir(strfind(SubjInfo.DataDir,' '))='_';
SubjInfo.DataDir(2+strfind(SubjInfo.DataDir(3:end),':'))='_';

if(exist(SubjInfo.DataDir)==7)
    cd(SubjInfo.DataDir);
    files=dir('*-scan*.mat');
    SubjInfo.Scan=length(files);
else
mkdir(SubjInfo.DataDir);
SubjInfo.Scan=1;
cd(SubjInfo.DataDir);
end

%Look for a local config file and use if avaliable
%Start in the root directiry and work inward
localconfigfile=[];
str=DATA_DIR;
while(1)
    files=dir([str filesep '*.cfg']);
    if(length(files)>0)
         localconfigfile=[str filesep files(1).name];
    end
    str=[str filesep strtok(SubjInfo.DataDir(length(str)+1:end),filesep)];
    if(strcmp(str,SubjInfo.DataDir))
        break;
    end
end

if(~isempty(localconfigfile))
    disp(['Loading config file: ' localconfigfile]);
    loadCw6ConfigFile(handles,localconfigfile);
end


set(handles.SubjID,'string',SubjInfo.SubjID);
set(handles.SubjID,'enable','on');

SubjInfo.CurrentFileName=[SubjInfo.SubjID '-' SubjInfo.Study '-scan' num2str(SubjInfo.Scan) '-<DateTime>'];
set((handles.CurDataFileName),'string',SubjInfo.CurrentFileName);
set((handles.CurDataFileName),'enable','on');
set(handles.StartAQ,'enable','on');


SubjInfo.Probe.Lambda=LAMBDA;
SubjInfo.Probe.Colors=jet(length(find(SubjInfo.Probe.MeasList(:,4)==1)));
SubjInfo.Probe.Colors=[SubjInfo.Probe.Colors(1:2:end,:); SubjInfo.Probe.Colors(2:2:end,:)];
SubjInfo.SDGdisplay.selectedLambda=1;
SubjInfo.SDGdisplay.MLAct=ones(length(SubjInfo.Probe.MeasList),1);
lowSrc=min(SubjInfo.Probe.MeasList(:,1));
SubjInfo.SDGdisplay.PlotLst=find(SubjInfo.Probe.MeasList(:,4)==2 & SubjInfo.Probe.MeasList(:,1)==lowSrc);


set(handles.RegistrationInfo,'UserData',SubjInfo);

h=findobj(handles.cw6figure);
for idx=1:length(h); 
    try; set(h(idx),'enable','on'); end;
end;

global PROBE_DIR;
if(exist([PROBE_DIR filesep 'RealTimeModules'])==0)
    set(handles.RTProcessing,'enable','off');
end

numStates=length(unique(SubjInfo.Probe.MeasList(:,5)));
if(numStates<2)
    set(handles.TDM_Menu,'enable','off');
end
set(handles.UseTDM,'enable','off');
set(handles.UseTDM,'checked','off');

%turn off the unused laser controls
for SrcIdx=1:64
   las=findobj('tag',['Laser_' num2str(SrcIdx)]);
   if(~isempty(las))
    set(las,'enable','off');
   end
end
for SrcIdx=1:NUM_SRC
    [OptIdx LambdaIdx]=find(SubjInfo.Probe.LaserPos==SrcIdx);
    las=findobj('tag',['Laser_' num2str(SrcIdx)]);
    if(isempty(OptIdx))
        set(las,'enable','off');
    else
        set(las,'enable','on');
       LambdaIdx=unique(LambdaIdx);
        set(las,'string',['Source ' num2str(OptIdx') ' ( ' num2str(SubjInfo.Probe.Lambda(LambdaIdx)) ' nm)']);
    end        
end

%Turn off unusuable detectors

Javahandles=get(findobj('tag','DetTabContainer'),'UserData');
set(Javahandles.slider,'Enabled',1);
set(Javahandles.spinner,'Enabled',1);

Dets=unique(SubjInfo.Probe.MeasList(:,2));
for idx=1:4
    for idx2=1:8
        dI=(idx-1)*8+idx2;
        if(~ismember(dI,Dets))
            set(Javahandles.slider(idx,idx2),'Enabled',0);
             set(Javahandles.spinner(idx,idx2),'Enabled',0);
             set(Javahandles.LED(idx,idx2),'BackgroundColor',[.7 .7 .7]);
        end
    end
end

PlotSDG(handles);

if(SubjInfo.IsTestOnly)
    set(handles.SubjID,'string','Testing');
    set(handles.SubjID,'enable','off');
    set(handles.CurDataFileName,'string','Data not saved');
    set(handles.SendDataHOMER,'enable','off');
%     set(handles.Paradigm_menu,'enable','off');
    
end
set(handles.SetDataCOM,'enable','off');
set(handles.CurDataFileName,'UIContextmenu',handles.ForceSave);

%RUn a quick scan to initialize everything
Cw6_BackEnd('StartAQ_Callback',findobj('tag','cw6figure'), [], guihandles(findobj('tag','cw6figure')),true);
pause(2);
Cw6_BackEnd('StopAQ_Callback',findobj('tag','cw6figure'), [], guihandles(findobj('tag','cw6figure')),true);
 

return