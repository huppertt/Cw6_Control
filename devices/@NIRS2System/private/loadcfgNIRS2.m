function [nirs Options] = loadcfgNIRS2
%This function loads the config options for the NIRS setup

Options=[];
nirs=[];

cfgFile='nirs.cfg';

if ~(exist(cfgFile,'file')==2)
    %Stay with the hard-coded defaults
    return
end
    
fid=fopen(cfgFile,'r');


%parse the file line by line
while(1)
    line=fgetl(fid);

    if line==-1
       %Done
        break;
    end
    if isempty(line)
        continue;
    end
    
    if ~strcmp(line(1),'#')
        %This is not a comment line
        nextline=fgetl(fid);
        [Options nirs] = switchline(line,nextline,Options,nirs,fid); 
        
    end

end

% 
% h=guihandles(gcf);       % get the handles for the GUI
% set(h.OptionsStore,'userdata',Options);


return


function [Options nirs] = switchline(line,nextline,Options,nirs,fid)
%This line preforms the parsing of valid lines in the config file

line(find(line==' '))=[];

switch(line)
    case 'Systemtype'
        Options.Hardware.SystemType=nextline;
    case 'SampleFrequency'
        nirs.SampleRate=str2num(nextline);
    case 'InputRange'
%         h=guihandles(gcf);       % get the handles for the GUI
% 
%         switch(str2num(nextline))
%             case 1.25
%                 set(h.InputRange,'value',1);
%             case 2.5
%                 set(h.InputRange,'value',2);
%             case 5
%                 set(h.InputRange,'value',3);
%             otherwise
%                 disp('Invalid Input range');
%                 set(h.InputRange,'value',3);
%         end
    case 'DAQBoard1'
        Options.Hardware.DAQ_ID{1}.name=nextline;
        Options.Hardware.DAQ_ID{1}.init=fgetl(fid);
        slotid=fgetl(fid);
        [foo,slotid]=strtok(slotid);
        Options.Hardware.DAQ_ID{1}.slotid=strtok(slotid);
    case 'DAQBoard2'
        Options.Hardware.DAQ_ID{2}.name=nextline;
        Options.Hardware.DAQ_ID{2}.init=fgetl(fid);
        slotid=fgetl(fid);
        [foo,slotid]=strtok(slotid);
        Options.Hardware.DAQ_ID{2}.slotid=strtok(slotid);
    case 'AuxBoard'
        Options.Hardware.Aux_ID.name=nextline;
        Options.Hardware.Aux_ID.init=fgetl(fid);
        slotid=fgetl(fid);
        [foo,slotid]=strtok(slotid);
        Options.Hardware.Aux_ID.slotid=strtok(slotid);
    case 'Probe'
        Options.defaultprobe=nextline;
    case 'SynchPulse'
%         h=guihandles(gcf);       % get the handles for the GUI
%         if strcmp(lower(nextline),'true')
%             set(h.SendSyncDIO,'value',1);
%         else
%             set(h.SendSyncDIO,'value',0);
%         end
    case 'StreamDisk'
        if strcmp(lower(nextline),'true')
            Options.Stream2File=1;
        else
            Options.Stream2File=0;
        end
        
    case 'RecordAux'
        if strcmp(lower(nextline),'true')
            Options.RecordAux=1;
        else
            Options.RecordAux=0;
        end
    case 'Bias'
        Options.Bias=str2num(nextline);
        if length(Options.Bias)~=2;
            Options.Bias(2)=Options.Bias(1);
        end
    case 'Demod'
        Options.DeMod=str2num(nextline);
    case 'SampleFreq'
        Options.ResampleData=1;
        Options.SampleRate=str2num(nextline);


end

return