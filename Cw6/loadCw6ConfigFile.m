function loadCw6ConfigFile(handles,cfgfile)

global PROBE_DIR;
global DATA_DIR;
global SYSTEM_TYPE;
global NUM_SRC;
global NUM_DET;
global NUM_LAMBDA;
global LAMBDA;
global SAMPLE_RATE;
global EPRIME_DIR;
global MAX_DET_GAIN;
global BOOL_ADJ_LASERS;  
global MAX_LASER_INTEN;


if(~exist('cfgfile'))
    cfgfile=which('cw6.cfg');
end

if(isempty(cfgfile))
    %load defaults
    PROBE_DIR='D:\Cw6';
    DATA_DIR='D:\Cw6\Data';
else
    fid=fopen(cfgfile,'r');
    while(1)
        line=fgetl(fid);
        if(line==-1); break; end;
        if(isempty(strfind(line,'#')))
            try; eval(line); end;
        end
    end
    fclose(fid);
end

s=whos;
if(any((vertcat(s([1:end]).bytes)==0)))
    warning('Missing Config parameters');
end

if(exist('UseStimChannels'))
    stiminfo=get(handles.setup_stim,'Userdata');
    stiminfo.usestim=UseStimChannels;
    set(handles.setup_stim,'Userdata',stiminfo);
end
if(exist('StimChan'))
    stiminfo=get(handles.setup_stim,'Userdata');
    
    for idx=1:5
        stiminfo.names{idx}=['Aux-' num2str(idx)];
    end
    for idx=1:length(StimChan)
        if(~isempty(StimChan(idx).name))
            stiminfo.names{idx}=StimChan(idx).name;
        end
    end
    set(handles.setup_stim,'Userdata',stiminfo);
end

   
return