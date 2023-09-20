function initialize(foo)
warning('off','daq:daqmex:propertyConfigurationError');

try
    global NI_Auxdevice;
    NI_Auxdevice.samplerate=10;
    NI_Auxdevice.isrunning=false;
    NI_Auxdevice.SystemType='NI Aux';

   % AuxInit='USB-1608FS';
   AuxInit='USB-1208FS'; 
   info = daqhwinfo('mcc');

    %Try to find this board
    for c=1:length(info.InstalledBoardIds);
        if(strcmp(AuxInit,info.BoardNames{c}))
            AuxID=info.InstalledBoardIds{c};
            auxflag=1;
        end
    end

    if(auxflag==0)
        warning('unable to initialize auxillary device');
        return
    end



    %% Initialize the instrument

warning('off','daq:analogoutput:adaptorobsolete');

    %% SAMPLE RATE
    NI_Auxdevice.auxDAQ=analoginput('nidaq','Dev1');
    set(NI_Auxdevice.auxDAQ,'InputType','SingleEnded');
    %NI_Auxdevice.auxDAQ=analoginput('mcc',AuxID);
    addchannel(NI_Auxdevice.auxDAQ,[0:4]);
    set(NI_Auxdevice.auxDAQ.Channel,'InputRange',[-10 10]);
    set(NI_Auxdevice.auxDAQ.Channel,'SensorRange',[-10 10]);
    set(NI_Auxdevice.auxDAQ.Channel,'UnitsRange',[-10 10]);

%     NI_Auxdevice.auxDAQout=analogoutput('mcc',AuxID);
%     addchannel(NI_Auxdevice.auxDAQ,[0:1]);
%     
%         set(NI_Auxdevice.auxDAQ,'TransferMode','InterruptPerPoint')
% %    set(NI_Auxdevice.auxDAQ,'TransferMode','default')
%     set(NI_Auxdevice.auxDAQ,'BufferingMode','manual');

    
    set(NI_Auxdevice.auxDAQ, 'TimerFcn',[]);
    set(NI_Auxdevice.auxDAQ, 'StopFcn',[]);

    set(NI_Auxdevice.auxDAQ, 'TriggerType','immediate');
    set(NI_Auxdevice.auxDAQ, 'TriggerRepeat',0);
    set(NI_Auxdevice.auxDAQ, 'ClockSource','internal');
  %  set(NI_Auxdevice.auxDAQ, 'timeout',10E-3);
    %set(nirs.auxDAQ, 'ChannelSkewMode','Equisample');
    set(NI_Auxdevice.auxDAQ,'Tag','AuxDAQ');

    set(NI_Auxdevice.auxDAQ,'SampleRate',NI_Auxdevice.samplerate);
    
    itmp = fix(NI_Auxdevice.samplerate*720);
    aiinfo = daqhwinfo(NI_Auxdevice.auxDAQ);
    itmp=ceil(itmp/31)*31;
    set(NI_Auxdevice.auxDAQ,'SamplesPerTrigger',itmp);
    setBufferForPMD(NI_Auxdevice.auxDAQ);
    
    %add an output channel
    NI_Auxdevice.auxDAQoutput=digitalio('nidaq','Dev1');
    addline(NI_Auxdevice.auxDAQoutput,[0],'Out');
    putvalue(NI_Auxdevice.auxDAQoutput,0);
%    set(NI_Auxdevice.auxDAQ,'TransferMode','InterruptPerPoint')
%     set(NI_Auxdevice.auxDAQ,'TransferMode','default')
%     set(NI_Auxdevice.auxDAQ,'BufferingMode','manual');
%     set(NI_Auxdevice.auxDAQ,'BufferingConfig',[2 100]);

catch
    error('Cannot start auxillary device');
end

return