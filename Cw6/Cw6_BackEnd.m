function Cw6_BackEnd(varargin)

if ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK
    
        try
		    [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
	    catch
            disp(lasterr); 
        end

end

return


function Initialize(handles)
%This function intializes the 
global SYSTEM_TYPE;
global SAMPLE_RATE;

%Make the system structure
system.MainDevice=TechEnDAQ(SYSTEM_TYPE,'0');
if(false)
try
    system.AuxDevice=TechEnDAQ('NI_Aux','0');
    if(isempty(system.AuxDevice))
        warning('Auxillary device not found');
    else
        initialize(system.AuxDevice);
        setdatarate(system.AuxDevice,SAMPLE_RATE);
    end
catch
    system.AuxDevice=[];
end
else
    system.AuxDevice=[];
end


system.MainTimer=timer('TimerFcn',@NIRS_timer_main_callback, 'Period', 0.5,...
    'TasksToExecute',72000,'ExecutionMode','fixedRate','BusyMode','Drop');  %Will run for up to an hour

initialize(system.MainDevice);
%the remainder of the initialization needs to wait for the probe design
setdatarate(system.MainDevice,SAMPLE_RATE);

set(handles.AquistionButtons,'Userdata',system);

return


function TestTime_Callback(hObject, eventdata, handles)
% hObject    handle to TestTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TestTime as text
%        str2double(get(hObject,'String')) returns contents of TestTime as a double

% --- Executes on button press in FreeRunCheckBox.
function FreeRunCheckBox_Callback(hObject, eventdata, handles)

if(get(hObject,'value'))
    set(handles.TestTime,'enable','off');
else
    set(handles.TestTime,'enable','on');
end


% --- Executes on button press in StartAQ.
function StartAQ_Callback(hObject, eventdata, handles,TestScanOnly)
%This function runs everything

if(~exist('TestScanOnly'))
    TestScanOnly=false;
end

global SyncControl;
global NIOutput;

global NUM_DET;
Javahandles=get(findobj('tag','DetTabContainer'),'UserData');
system=get(handles.AquistionButtons,'Userdata');

if(~validatesystem(system))
    warndlg('Unable to start system');
    return
end


if(~any(getlaser(system.MainDevice)) & ~TestScanOnly)
    resp=questdlg('WARNING: No Lasers are on','','Cancel','Continue','Cancel');
    if(strcmp(resp,'Cancel'))
        return
    end
end


usetime=0;
if(~get(handles.FreeRunCheckBox,'value'))

    ScanTime=str2num(get(handles.TestTime,'string'));
    if(~isempty(ScanTime))
      
        aqtimer=timer('TimerFcn',@localStopTimer,'tag','runtimer',...
            'TasksToExecute',1,'Period',.2,'StartDelay',ScanTime+5);
        usetime=1;
    else
        set(handles.FreeRunCheckBox,'value',1)
    end
else
    ScanTime=7200;  %Two-hour max
end


try
    putdata(NIOutput,0);
    start(NIOutput);
    pause(.1);
    putdata(NIOutput,5);
end

ProgressBar=get(findobj('tag','Cw6Progress'),'UserData');
set(ProgressBar,'Maximum',ScanTime);
set(ProgressBar,'Value',0);
set(handles.rescale_now,'Userdata',0);

set(system.MainTimer,'TasksToExecute',ceil(ScanTime/get(system.MainTimer,'Period'))+2);

set(handles.FreeRunCheckBox,'enable','off');
set(handles.StartAQ,'enable','off');
set(handles.StopAQ,'enable','on');

%Save a copy of the temp data before you erase it
Cw6_data=get(handles.cw6figure,'UserData');
SubjInfo=get(handles.RegistrationInfo,'UserData');
%save('Temp','Cw6_data','SubjInfo');
Cw6('SaveSettings_Callback',hObject, eventdata, handles,'Temp.sys')


%Reset Data
Cw6_data.data.raw=[];
Cw6_data.data.raw_t=[];
Cw6_data.data.conc=[];
Cw6_data.data.aux=[];
Cw6_data.data.aux_t=[];
Cw6_data.data.stim={};
Cw6_data.data.MarkStim={};
for idx=1:5
    Cw6_data.data.stim{idx}=[];
end
Cw6_data.data.X=[];
Cw6_data.data.comment_times=[];
Cw6_data.data.comment_text={};

catchstim([],[],[]);
[time,data,auxdata,concdata]=processRTfunctions([],[],[],[]);

set(handles.NumberStimuliText,'string','0');

set(handles.cw6figure,'UserData',Cw6_data);

axes(handles.MainPlotWindow);
cla;
set(handles.MainPlotWindow,'UserData',[]);

if(strcmp(get(handles.UseTDM,'checked'),'on'))
    SetTDM_toDevice(true);
    for DetIdx=1:NUM_DET
    Tab=1+floor(DetIdx/9);
    Det=mod(DetIdx,8);
     if(Det==0); Det=8; end;
         set(Javahandles.slider(Tab,Det),'enabled',0);
         set(Javahandles.spinner(Tab,Det),'enabled',0);
     end
else
    SetTDM_toDevice(false);
end
pause(1);

SubjInfo=get(handles.RegistrationInfo,'UserData');
SD=SubjInfo.Probe;
ml_Device=getML(system.MainDevice);
ml_probe=SD.MeasList;
SD.mlMap=zeros(size(ml_probe,1),1);

for idx=1:size(ml_probe,1); 
    SrcIdx=ml_probe(idx,1);
    DetIdx=ml_probe(idx,2);
    LambdaIdx=ml_probe(idx,4);
    LaserIdx=SD.LaserPos(SrcIdx,LambdaIdx);
    SD.mlMap(idx)=find(ml_Device(:,1)==LaserIdx & ml_Device(:,2)==DetIdx);
end

SD.DataToMLMap=SendML2Cw6(ml_probe,SD,ml_Device);

SubjInfo.Probe=SD;
set(handles.RegistrationInfo,'UserData',SubjInfo);



%initialize(system.MainDevice);
if(~isempty(system.AuxDevice))
   
    start(system.AuxDevice);
end
tic;
if(~TestScanOnly)
disp(['Data Aquistion Started at: ' datestr(now)]);
end
if(~SubjInfo.IsTestOnly & ~TestScanOnly)
    disp(['Data will be saved to file: '  SubjInfo.CurrentFileName]); 
end

if(TestScanOnly)
    set(handles.MainPlotWindow,'visible','off');
else
    set(handles.MainPlotWindow,'visible','on');
end

start(system.MainDevice);
start(system.MainTimer);

if(usetime)
    start(aqtimer);
end

try; SyncControl.SetAOVoltage(5); end;

try
    start(NIOutput);
end
return



% --- Executes on button press in StopAQ.
function StopAQ_Callback(hObject, eventdata, handles,TestScanOnly)
% hObject    handle to StopAQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if(~exist('TestScanOnly'))
    TestScanOnly=false;
end

global SyncControl;
global NIOutput;
set(handles.StopAQ,'enable','off');

system=get(handles.AquistionButtons,'Userdata');

try; disp(['... stopped after ' num2str(toc) 's']); end;

try; stop(system.MainTimer); end;
try; stop(system.MainDevice); end;
try; stop(timerfind); end;

try
    SyncControl.SetAOVoltageOff(0);
end

try
    putdata(NIOutput,0);
    start(NIOutput);
end

pause(1);
try; stop(system.AuxDevice); end;

%Make sure we got all the data
try
if(samplesavaliable(system.AuxDevice)>0)
    NIRS_timer_main_callback;
end
end

if(TestScanOnly)
    set(handles.MainPlotWindow,'visible','on');
end

delete(timerfind('tag','runtimer'));
set(handles.FreeRunCheckBox,'enable','on');
set(handles.StartAQ,'enable','on');
set(handles.StopAQ,'enable','off');

SubjInfo=get(handles.RegistrationInfo,'UserData');
Cw6_data=get(handles.cw6figure,'UserData');
if(~TestScanOnly)
    saveNIRSData(Cw6_data,SubjInfo, system);
end
if(~SubjInfo.IsTestOnly & ~TestScanOnly)
   SubjInfo.Scan=SubjInfo.Scan+1;
    SubjInfo.CurrentFileName=[SubjInfo.SubjID '-' SubjInfo.Study '-scan' num2str(SubjInfo.Scan) '-<DateTime>'];
    set((handles.CurDataFileName),'string',SubjInfo.CurrentFileName);
    set(handles.RegistrationInfo,'UserData',SubjInfo);
end

system.TDMSettings.StateSelected=1;
set(handles.AquistionButtons,'Userdata',system);
updateCw6DeviceTDM;

try; stop(system.MainDevice); end;
try; stop(system.MainDevice); end;


function SetGain(varagin)

global NUM_DET;
global NUM_SRC;
global MAX_DET_GAIN;

handles=guihandles(findobj('tag','cw6figure'));
system=get(handles.AquistionButtons,'Userdata');

Javahandles=get(findobj('tag','DetTabContainer'),'UserData');

if(~isfield(system,'AQSettings'))
    system.AQSettings.Gains=zeros(NUM_DET,1);
elseif(~isfield(system.AQSettings,'Gains'))
    system.AQSettings.Gains=zeros(NUM_DET,1);
end
GainsOld=system.AQSettings.Gains;
%[nPanels,nDet]=size(Javahandles.spinner);
nPanels=4;
nDet=8;

cnt=1;

nDet=min(NUM_DET,nDet);
for Tab=1:nPanels
    for Det=1:nDet
        if(get(Javahandles.slider(Tab,Det),'ValueIsAdjusting'))
            %not done.
            return;
        end
        system.AQSettings.Gains(cnt)=get(Javahandles.slider(Tab,Det),'Value');
        cnt=cnt+1;
    end
end

system.AQSettings.Gains=min(system.AQSettings.Gains,MAX_DET_GAIN);

lstchanged=find(system.AQSettings.Gains-GainsOld~=0);
set(handles.AquistionButtons,'Userdata',system);

if(isfield(system,'TDMSettings'))  
    %Even if there is no TDM. this field needs to exist
    SubjInfo=get(handles.RegistrationInfo,'UserData');
    numStates=length(unique(SubjInfo.Probe.MeasList(:,5)));
    TDMSettings.DwellTimes=ones(numStates,1)*10;
    TDMSettings.StateSelected=1;
    TDMSettings.LasersOn=zeros(NUM_SRC,numStates);
    TDMSettings.DetGains=zeros(NUM_DET,numStates);
end
for idx=1:length(lstchanged)
    setgain(system.MainDevice,lstchanged(idx),system.AQSettings.Gains(lstchanged(idx)));
    if(isfield(system,'TDMSettings') && isfield(system.TDMSettings,'StateSelected')) 
        state=system.TDMSettings.StateSelected;
    else
        state=1;
    end
    system.TDMSettings.DetGains(lstchanged(idx),state)=system.AQSettings.Gains(lstchanged(idx));
end

set(handles.AquistionButtons,'Userdata',system);


return

