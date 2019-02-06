function NIRS_timer_main_callback(varargin)
%This is the main timer callack function to handle the real-time processing

%global SyncControl;
global DigitalAux;
try
    persistent cnt;

    if(isempty(cnt))
        cnt=1;
    end
    figurehandle=findobj('tag','cw6figure');
    Cw6_data = get(figurehandle,'UserData');

    AquistionButtons=findobj('tag','AquistionButtons');
    system=get(AquistionButtons,'Userdata');

    if(~isrunning(system.MainDevice))
        return;
    end
    try
        numSamples=samplesavaliable(system.MainDevice);
    catch
        return
    end
    if(numSamples<=0)
        return
    end

    %SyncControl.SetAOVoltage(5);

    handles=guihandles(figurehandle);
    SubjInfo=get(handles.RegistrationInfo,'UserData');
    SD=SubjInfo.Probe;

    for sample=1:numSamples
        [currentdata,currenttime]=getsamples(system.MainDevice,1);

        if(isempty(currentdata))
            return
        end

        aux=currentdata(length(SD.DataToMLMap)+1:end,:);
        currentdata=currentdata(SD.DataToMLMap,:);

        if(~isempty(system.AuxDevice))
            numSamplesAux=samplesavaliable(system.AuxDevice);
            if(numSamplesAux>0)
                [currentauxdata,currentauxtime]=getsamples(system.AuxDevice,samplesavaliable(system.AuxDevice));
                currentauxdata=currentauxdata/100;
            else
                currentauxtime=[];
                currentauxdata=[];
            end
        else
            currentauxdata=aux;
            currentauxtime=[currenttime];
        end
        stim=Cw6_data.data.stim;

        try
            dig=getvalue(DigitalAux);
            dig=sum(dig.*2.^[0:length(dig)-1]);
           % disp(['Digital Value: ' num2str(dig)]);
            currentauxdata(end-1,:)=dig;
        end
        
        if(~isempty(currentauxtime))
            stim=catchstim(stim,currentauxdata',currentauxtime);
        end
        if(isfield(Cw6_data,'RTmodules'))
            [currenttime,currentdata,currentauxdata,currentconcdata,stim]=...
                processRTfunctions(currenttime,currentdata,currentauxdata,stim);
        else
            currentconcdata=[];
        end

        %Add back to the data structure
        Cw6_data = get(figurehandle,'UserData');
        Cw6_data.data.stim=stim;
        Cw6_data.data.raw=[Cw6_data.data.raw currentdata];
        Cw6_data.data.raw_t=[Cw6_data.data.raw_t currenttime];
        Cw6_data.data.conc=[Cw6_data.data.conc currentconcdata];
        if(~isempty(currentauxtime))
            
            Cw6_data.data.aux=[Cw6_data.data.aux currentauxdata];
            Cw6_data.data.aux_t=[Cw6_data.data.aux_t currentauxtime];
        end

        set(figurehandle,'UserData',Cw6_data);

    end

    ProgressBar=get(findobj('tag','Cw6Progress'),'UserData');
    set(ProgressBar,'Value',Cw6_data.data.raw_t(end));
    plotmainwindow;

    cnt=cnt+numSamples;

    if(floor(cnt/32)>0)
        cnt=0;
        updateSNR;
    end

%     try
%         SyncControl.SetAOVoltageOff(0);
%     end
catch
    warning('error in main timer');
end
return
