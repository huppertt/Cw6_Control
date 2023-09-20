function setBufferForPMD(analoginputobject)
%SETBUFFERFORPMD Workaround to support PMD device buffer issues
%
%   SETBUFFERFORPMD(ANALOGINPUTOBJECT) is a workaround to handle the buffer pecularities for the
%   MCC PMD series.  At this time, only the PMD-1608FS and PMD-1208FS is affected.  Call
%   this function after you've configured your analoginput object.  This
%   function will change the BufferingConfig associated with the object.
%   ANALOGINPUTOBJECT is the analog input object returned by ANALOGINPUT of
%   the device you wish to have configured.  This function will always return
%   successfully.
%
%   Note:  If the ANALOGINPUTOBJECT is set to continuous acquisition by setting
%   TriggerRepeat = Inf, SETBUFFERFORPMD will allocate enough buffers to
%   hold 10 triggers worth of data.  If SamplesPerTrigger is 
%   set to Inf, SETBUFFERFORPMD will allocate enough buffers to hold 10 
%   seconds worth of data.  You must stop the acquisition, retrieve the
%   data, or delete the data using STOP, GETDATA or FLUSHDATA before the 
%   buffers fill up, or the acquisition will end early.
%
%   Examples
%   Configure the device ai:
%   setBufferForPMD(ai);
%
%   See also ANALOGINPUT, GETDATA, FLUSHDATA, START, STOP

%   Copyright 2004 The MathWorks, Inc.

% Put the whole function in a try block to ensure it will always return
try

    %Check to see if analoginputobject is a DAT analog input object
    if(~isa(analoginputobject,'analoginput'))
        % it isn't: return
        return
    end


    % if for some reason, this gets called on a device that doesn't need
    % it, don't mess with it.  Set the default packetSize to 1.
    packetSize = 1;

    % Get information about the analog input object
    aiinfo = daqhwinfo(analoginputobject);
    
    %Check to see if analoginputobject is a PMD1608FS or PMD-1208FS 
    if(strcmp(aiinfo.DeviceName,'PMD-1608FS')...
            || strcmp(aiinfo.DeviceName,'PMD-1208FS') ||...
            strcmp(aiinfo.DeviceName,'USB-1608FS'))
        % It is a PMD-1608FS or PMD-1208FS.  These devices requires that
        % buffers are an even multiple of 31.
        packetSize = 31;
    end

    if(packetSize ~= 1)
        %First, ensure that the current value in BufferingConfig are valid by
        %switching BufferingMode to automatic
        set(analoginputobject,'BufferingMode','Auto');

        %get the current BufferingConfig.
        BufferingConfig = get(analoginputobject,'BufferingConfig');

        %Find the next largest individual buffer size that is an even muliple
        %of packetSize (31 in the case of PMD-1608FS.)
        newIndivBufferSize = (floor(BufferingConfig(1)/packetSize) + 1) * packetSize;

        % Figure out how many channels there are
        numchannels = prod(size(get(analoginputobject,'Channel')));
        
        %Figure out how many buffers we need of that size.  Are we trying
        %to do continuous acquisition (i.e. TriggerRepeat = Inf)
        if(get(analoginputobject,'TriggerRepeat') == Inf)
            % set the total number of samples to buffer to 10 triggers
            % worth of data.  Hopefully, the user will do a GETDATA or a
            % FLUSHDATA before we run out
            totalBufferNeeded = get(analoginputobject,'SamplesPerTrigger') * 10 * numchannels;
        else
            if(get(analoginputobject,'SamplesPerTrigger') == Inf)
                % set the total number of samples to acquire to be 10 seconds
                % worth of data to acquire
                totalBufferNeeded = get(analoginputobject,'SampleRate') * 10 * numchannels;
            else
                % otherwise, just set the total number of samples to acquire
                % to hold all the data for the acquisition.
                totalBufferNeeded = get(analoginputobject,'SamplesPerTrigger') * ...
                    (get(analoginputobject,'TriggerRepeat') + 1) * numchannels;
            end
        end
        
        % Limit the buffer to 10 million points.
        if(totalBufferNeeded > 10000000)
            totalBufferNeeded = 10000000;
        end
        
        % Determine how many buffers of the target size we need.
        newNumBuffers = floor(totalBufferNeeded/newIndivBufferSize) + 1;

        %Set the buffer config to these new values
        newBufferingConfig = [newIndivBufferSize newNumBuffers];
        set(analoginputobject,'BufferingConfig',newBufferingConfig);
    end % if(packetSize ~= 1)
catch % matches try
    return
end % try/catch block

