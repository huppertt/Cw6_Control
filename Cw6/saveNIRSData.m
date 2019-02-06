function saveNIRSData(Cw6_data,SubjInfo, system)
%This function creates a NIRS probe file for HOMER

global SYSTEM_TYPE;
global EPRIME_DIR;

try
    handles=guihandles(findobj('tag','cw6figure'));
    if(~isempty(SubjInfo) && SubjInfo.IsTestOnly)
        return
    end


    d=Cw6_data.data.raw;
    t=Cw6_data.data.raw_t;
    aux=Cw6_data.data.aux';
    
    %The aux data is potentially a different sample rate from the main data
    %fix this
    aux=[];
    for idx=1:size(Cw6_data.data.aux,1)
        aux(:,idx)=interp1(Cw6_data.data.aux_t,Cw6_data.data.aux(idx,:)',t);
    end
    
    
    stiminfo=get(handles.setup_stim,'Userdata');
    stiminfo.system=SYSTEM_TYPE;
    stiminfo.eprime_dir=EPRIME_DIR;
    
    if(isfield(Cw6_data.data,'stim'))
        s=zeros(length(t),0);
        for chan=1:length(Cw6_data.data.stim)
            flag=false;
        for idx=1:length(Cw6_data.data.stim{chan})
            [foo,id]=min(abs(t-Cw6_data.data.stim{chan}(idx)));
            if(flag)
                s(id,end)=1;
            else
                flag=true;
                s(id,end+1)=1;
            end
        end
        end
    else
        s=zeros(length(t),1);
    end

    if(size(s,2)==0)
         s=zeros(length(t),1);
    end
    
    if(isempty(SubjInfo))
        SubjInfo=get(findobj('tag','RegistrationInfo'),'UserData');
        SD=SubjInfo.Probe;

        [filename, pathname] = uiputfile( ...
            {'*.nirs'}, ...
            'Save Data As');
        filename=strtok(filename,'.');
        filename=[pathname filesep filename];
    else
        SD=SubjInfo.Probe;

        filename=[SubjInfo.SubjID '-' SubjInfo.Study '-scan' num2str(SubjInfo.Scan) '-' datestr(now,'yyyymmddTHHMMSS') ...
            '-' SYSTEM_TYPE];
    end

    ml=SD.MeasList(:,1:4);
    save([filename '.nirs'],'d','ml','s','t','aux','SD','stiminfo','-MAT');
    save([filename '.mat'],'Cw6_data','SubjInfo', 'system');

    
    %attempt to transfer Eprime files
    if(~isempty(stiminfo) & isfield(stiminfo,'linktoeprime') & stiminfo.linktoeprime)
            disp('Locating eprime files.');
            persistent recursion;
            if(isempty(recursion))
                recursion=4;
            end
            file=findrecent(EPRIME_DIR,{'.PDAT' '.txt'},recursion);  
            recursion=1;
            if(datenum(file.date)> now-t(end)/24/60-1/24/60) 
                stiminfo.eprimefile=file;
                disp(['Found file: ' file.name]);
                
                [EPRIME_DIR,file2,ext]=fileparts(file.name);
                disp(['Saving as: ' filename '_eprime_' file2 ext]);
                copyfile(file.name,[filename '_eprime_' file2 ext]);
                set(handles.eprime_file_name,'label',EPRIME_DIR);
                stiminfo.eprime_dir=EPRIME_DIR;
                stiminfo.eprime_file=[filename '_eprime_' file2 ext];
                save([filename '.nirs'],'stiminfo','-MAT','-APPEND');
            end
        end
       
    
catch
    warndlg('Save Failed');
end

return