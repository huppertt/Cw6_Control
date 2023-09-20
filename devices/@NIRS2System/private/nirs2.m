function varargout = nirs2(varargin)
	try
   		[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
   	catch
   		disp(lasterr);
   	end
return

%% Initialization
function nirs = init(varargin)
try
    [nirs Options] = loadcfgNIRS2;
catch 
    Options=[];
    Options.Bias=[0 0];
    Options.DeMod=[1 1];  %Default is for Nirs 4x4 config
end

nirs.TestTime=3600;

%daqreset;   % In Case of trouble reset engine.
NIRS2device.nBoards=0;
try 
    n=0;
    flag=0;
    try
        if isfield(Options,'Hardware') & isfield(Options.Hardware,'DAQ_ID')
            for boardIdx=1:length(Options.Hardware.DAQ_ID)
                Binit=Options.Hardware.DAQ_ID{boardIdx}.init;
                info = daqhwinfo(Binit);

                %Try to find this board
                for c=1:length(info.InstalledBoardIds);
                    if strcmp(Options.Hardware.DAQ_ID{boardIdx}.name,info.BoardNames{c}) & ...
                            strcmp(info.InstalledBoardIds{c},Options.Hardware.DAQ_ID{boardIdx}.slotid)
                        n=n+1;
                        boardID{boardIdx}=info.InstalledBoardIds{c};
                        boardInit{boardIdx}=Binit;
                    end
                end

            end

            %Make sure I got what I was looking for
            if n~=length(Options.Hardware.DAQ_ID)
                flag=0;
            else
                flag=1;
            end
        end
        auxflag=1;
        if isfield(Options,'Hardware') & isfield(Options.Hardware,'Aux_ID')
            auxflag=0;
            AuxInit=Options.Hardware.Aux_ID.init;
            info = daqhwinfo(AuxInit);

            %Try to find this board
            for c=1:length(info.InstalledBoardIds);
                if(strcmp(Options.Hardware.Aux_ID.name,info.BoardNames{c})) & ...
                            strcmp(info.InstalledBoardIds{c},Options.Hardware.Aux_ID.slotid)
                    AuxID=info.InstalledBoardIds{c};
                    auxflag=1;
                end
            end
        else
            auxflag=0;
            
        end

        if isfield(Options,'Hardware') & isfield(Options.Hardware,'DAQ_ID')

            %Make sure I got what I was looking for
            if n~=length(Options.Hardware.DAQ_ID)
                flag=0;
                Options.Hardware=rmfield(Options.Hardware,'DAQ_ID');
                if isfield(Options.Hardware,'Aux_ID')
                    Options.Hardware=rmfield(Options.Hardware,'Aux_ID');
                end
            else
                flag=1;
            end
        else
            flag=0;
        end
    catch
         disp('Loading of DAQ boards from config file failed');
         flag=0;
         auxflag=0;
         try
            Options.Hardware=rmfield(Options.Hardware,'DAQ_ID');
            Options.Hardware=rmfield(Options.Hardware,'Aux_ID');
         end
    end
    
    if ~flag %doing this with a flag- lets this be the default if the above fails 
        %Do as defualt
        info = daqhwinfo('mcc');
        n=0;
        for c=1:length(info.InstalledBoardIds);
            if(strcmp('PC-CARD-DAS16/16',info.BoardNames{c}))
                n=n+1;
                boardID{n}=info.InstalledBoardIds{c};
                boardInit{n}='mcc';
                 Options.Hardware.DAQ_ID{n}.name='PC-CARD-DAS16/16';
            elseif strcmp('PCM-DAS16D/16',info.BoardNames{c})
                n=n+1;
                boardID{n}=info.InstalledBoardIds{c};
                boardInit{n}='mcc';
                Options.Hardware.DAQ_ID{n}.name='PCM-DAS16D/16';
            elseif strcmp('PMD-1608FS',info.BoardNames{c})
                n=n+1;
                boardID{n}=info.InstalledBoardIds{c};
                boardInit{n}='mcc';
                Options.Hardware.DAQ_ID{n}.name='PMD-1608FS';
            end;

        end;
    end
    nirs.nBoards=n;
    
    if n>2
        auxflag=1;
        AuxID=boardID{3};
        AuxInit=boardInit{3};
        Options.Hardware.Aux_ID.name=Options.Hardware.DAQ_ID{3}.name;
    end
catch
    h=guihandles(gcf);
    set(h.OptionsStore,'userdata',Options);
    
    warndlg('DAQ cards could not be initialized');
    return
end
    if(~nirs.nBoards)
        warndlg('Error with Daq card- aborting...');
    return;
end;
%%
% Setup AD ==========================================================================
nirs.ai1=analoginput(boardInit{1},boardID{1});          % looking for card #0
addchannel(nirs.ai1,[0:7]);

set(nirs.ai1.Channel,'InputRange',[-5.00, 5.00]);
set(nirs.ai1.Channel,'SensorRange',[-5.00 5.00]);
set(nirs.ai1.Channel,'UnitsRange',[-5.00 5.00]);


set(nirs.ai1, 'TimerFcn',[]); 

set(nirs.ai1, 'TriggerType','immediate');       %set(nirs.ai1, 'TriggerType','Manual');
set(nirs.ai1, 'TriggerRepeat',0);
set(nirs.ai1,'ClockSource','External');

 set(nirs.ai1,'BufferingMode','Auto')

%set(nirs.ai1, 'StopFcn',{'Nirs_BackEnd','StopAction_Callback'}); 
set(nirs.ai1,'Tag','AD1');

% Setup Digital IO ==================================================================
nirs.dio1 = digitalio(boardInit{1},boardID{1});
addline(nirs.dio1,[0:7],'Out');
set(nirs.dio1,'Tag','DIO1');
nirs.dio1.Line.LineName(1)='Data';
nirs.dio1.Line.LineName(2)='Gain Clock';
nirs.dio1.Line.LineName(3)='Gain Latch';
nirs.dio1.Line.LineName(4)='AB Select';
nirs.dio1.Line.LineName(5)='Laser Clock';
nirs.dio1.Line.LineName(6)='Laser Latch';
nirs.dio1.Line.LineName(7)='20Hz Select';
nirs.dio1.Line.LineName(8)='AD Start';
putvalue(nirs.dio1.line(7),[1]);                    % 20Hz Select


% Dummy Buffer to prevent drawnow from stepping on anything else....
nirs.dummy = zeros(10,10);

if(nirs.nBoards >= 2)
    try
        nirs.ai2=analoginput(boardInit{2},boardID{2});
        addchannel(nirs.ai2,[0:7]);
        set(nirs.ai2.Channel,'InputRange',[-5 5]);
        set(nirs.ai2.Channel,'SensorRange',[-5 5]);
        set(nirs.ai2.Channel,'UnitsRange',[-5 5]);

        set(nirs.ai2, 'TimerFcn',[]);
        set(nirs.ai2, 'StopFcn',[]);

        set(nirs.ai2, 'TriggerType','immediate');
        set(nirs.ai2, 'TriggerRepeat',0);
        set(nirs.ai2, 'ClockSource','External');


        %set(nirs.ai2, 'ChannelSkewMode','Equisample');
        set(nirs.ai2,'Tag','AD2');

        % Setup Digital IO
        nirs.dio2 = digitalio(boardInit{2},boardID{2});
        addline(nirs.dio2,[0:7],'Out');
        set(nirs.dio2,'Tag','DIO2');
        nirs.dio2.Line.LineName(1)='Data';
        nirs.dio2.Line.LineName(2)='Gain Clock';
        nirs.dio2.Line.LineName(3)='Gain Latch';
        nirs.dio2.Line.LineName(4)='AB Select';
        nirs.dio2.Line.LineName(5)='Laser Clock';
        nirs.dio2.Line.LineName(6)='Laser Latch';
        nirs.dio2.Line.LineName(7)='20Hz Select';
        nirs.dio2.Line.LineName(8)='AD Start';
        putvalue(nirs.dio2.line(7),[1]);                    % 20Hz Select
    catch
        nirs.nBoards=1;
    end
end;

%Initialize the aux card:
if(auxflag)
    try
    nirs.auxDAQ=analoginput(AuxInit,AuxID);
    addchannel(nirs.auxDAQ,[0:7]);
    set(nirs.auxDAQ.Channel,'InputRange',[-5 5]);
    set(nirs.auxDAQ.Channel,'SensorRange',[-5 5]);
    set(nirs.auxDAQ.Channel,'UnitsRange',[-5 5]);

    set(nirs.auxDAQ, 'TimerFcn',[]);
    set(nirs.auxDAQ, 'StopFcn',[]);

    set(nirs.auxDAQ, 'TriggerType','immediate');
    set(nirs.auxDAQ, 'TriggerRepeat',0);
    set(nirs.auxDAQ, 'ClockSource','internal');

    %set(nirs.auxDAQ, 'ChannelSkewMode','Equisample');
    set(nirs.auxDAQ,'Tag','AuxDAQ');
    setBufferForPMD(nirs.auxDAQ);
    catch
        nirs.nBoards=nirs.nBoards-1;
    end
end

%% SAMPLE RATE
if(~nirs.nBoards)
    tdisp('local_SetSampleRate not implemented yet.');
    return;
end;
rate=setverify(nirs.ai1,'SampleRate',3205/8);          %200Hz * 2 (+/- voltages) %nirs.SampleRate*2);
if(nirs.nBoards>1)
    rate=setverify(nirs.ai2,'SampleRate',3205/8);      %200Hz * 2 (+/- voltages) nirs.SampleRate*2);
end;

if isfield(nirs,'auxDAQ')
    set(nirs.auxDAQ,'SampleRate',3205/16);
end
nirs.SampleRate=rate;

%% local_SetSamplesPerTrigger(nirs);
if(~nirs.nBoards)
    disp('local_SetSampleRate not implemented yet.');
    return;
 end;
 
 itmp = fix(nirs.SampleRate*nirs.TestTime);
 imod = mod(itmp,2);
 itmp = itmp + imod;
 itmp=ceil(itmp/31)*31;
 set(nirs.ai1,'SamplesPerTrigger',itmp);
 if(nirs.nBoards>1)
     set(nirs.ai2,'SamplesPerTrigger',itmp);
 end;
% 

if isfield(nirs,'auxDAQ')
    itmp = fix(nirs.SampleRate*nirs.TestTime/2);
    aiinfo = daqhwinfo(nirs.auxDAQ);
    itmp=ceil(itmp/31)*31;
    set(nirs.auxDAQ,'SamplesPerTrigger',itmp);

end

%% Lasers
function UpdateLaser(Lasers,nirs)
global NUM_SRC;

if(size(Lasers)==1)
    Lasers=repmat(Lasers,NUM_SRC,1);
end
if(~nirs.nBoards)
    disp('local_UpdateLaser not implemented yet.')
    return;
end;

putvalue(nirs.dio1.Line([1,5,6]),[0 0 0]);                      % INIT
for c=4:(-1):1;                                                      % 
    putvalue(nirs.dio1.Line([1]),[Lasers(c)])              % send data
    putvalue(nirs.dio1.Line([1,5]),[Lasers(c) 1]);         % clock it
    putvalue(nirs.dio1.Line([1,5]),[Lasers(c) 0]);         % high, then low
end;
putvalue(nirs.dio1.Line(6),1);                                  % Latch It
putvalue(nirs.dio1.Line(6),0);                                  % high, then low

if(nirs.nBoards>=2)                                             % if 2nd PCM card exists
    putvalue(nirs.dio2.Line([1,5,6]),[0 0 0]);                  % INIT
    for c=4:-1:1;                                                  % 
        putvalue(nirs.dio2.Line([1]),[Lasers(c+4)])        % send data
        putvalue(nirs.dio2.Line([1,5]),[Lasers(c+4) 1]);   % clock it
        putvalue(nirs.dio2.Line([1,5]),[Lasers(c+4) 0]);
    end;
    putvalue(nirs.dio2.Line(6),1);                              % Latch It
    putvalue(nirs.dio2.Line(6),0);                              % high, then low
end;
return;

%% Detectors

function UpdateGain(Det,Value,nirs);
% --------------------------------------------------------------------
% There is a two stage amplifier.
% Each stage has to be configured with a 8 bit binary sting.
% The bit values correspond to the following (word/2)
% D7 D6 D5 D4  D3 D2 D1  D0
% 64 32 16  8   4  2  1 0.5
% The bit string must be sent in a specific sequence and this process
% must end with the transmission of dummy data to flush the data to
% make sure it is properly latched.
% 
% D7 D6 D5 D4  D3 D2 D1  D0 Wr0 Wr1 Wr2 Wr3
% ^last ...                              ^First bit sent
% Wri = channel selection active low
%  1 1 1 0 select channel 3
%  0 1 1 1 select channel 0
%  0 0 0 0 select all channels
%  1 1 1 1 nothing selected (for dummy transmission)
% --------------------------------------------------------------------
% Usage:
%       local_SetGain(Det,Value);
%  Det is a number representing the Detector to change gain on
%  Value is a number between 0 and 255 to send to the Detector for a gain value
% --------------------------------------------------------------------

if(~nirs.nBoards)
    disp('local_SetGain not implemented yet.')
    return;
end;
%-------------------------------------------------------------------------------
% "Value" is overall gain, but here it is mapped to two stages A&B
% by taking the square root.  Also, each stage has a range from 1/2 to 128
% instead of from 1 to 256, therefore, it is left shifted by multiplying by two
%-------------------------------------------------------------------------------
ScaledValue = Value; %2*sqrt(Value);

% We Can not send a zero to Gain Blocks.  But I let them in the GUI because people would get
% Confused if I change things on them.  They wont know the difference anyway.
if(ScaledValue<1) 
    ScaledValue = 1;
end;

if(Det<5)
    ScaledValue = dec2bin(ScaledValue,8);                   % Change ScaledValue to binary
    putvalue(nirs.dio1.Line([4]),[1]);          % Select GainA Block
    putvalue(nirs.dio1.Line([1,2,3]),[0 0 0]);  % Start in known place
    
    % Dummy Data  First set gain to 1 on all channels
    for c=1:4
        putvalue(nirs.dio1.Line(1),1);
        putvalue(nirs.dio1.Line(2),1);      % Clock it
        putvalue(nirs.dio1.Line(2),0);
    end;
    %        64 32 16  8  4  2  1 .5
    %        D7 D6 D5 D4 D3 D2 D1 D0
    dvalue = [0  0  0  0  0  0  1  0 ];
    for c=1:8
        putvalue(nirs.dio1.Line(1),dvalue(c));
        putvalue(nirs.dio1.Line(2),1);      % Clock it
        putvalue(nirs.dio1.Line(2),0);
    end;
    putvalue(nirs.dio1.Line(3),1);          % Latch it;  
    putvalue(nirs.dio1.Line(3),0);

    switch(Det)
    case 1
        Rec = [ 1 1 1 0];
    case 2
        Rec = [ 1 1 0 1];
    case 3
        Rec = [ 1 0 1 1];
    case 4
        Rec = [ 0 1 1 1];
    end; 
    % ------------------------------------------- Send Real Data, 1st for A, then for B
    for AB=1:2
        for c=1:4
            putvalue(nirs.dio1.Line(1),Rec(c)); % active low
            putvalue(nirs.dio1.Line(2),1);      % Clock it
            putvalue(nirs.dio1.Line(2),0);
        end;
        for c=1:8
            putvalue(nirs.dio1.Line(1),str2num(ScaledValue(c)));
            putvalue(nirs.dio1.Line(2),1);      % Clock it
            putvalue(nirs.dio1.Line(2),0);
        end;
        putvalue(nirs.dio1.Line(3),1);          % Latch it;
        putvalue(nirs.dio1.Line(3),0);

        % Send Dummy data again to flush last data and latch it where required
        for c=1:4
            putvalue(nirs.dio1.Line(1),1);      % all high, no channels
            putvalue(nirs.dio1.Line(2),1);      % Clock it
            putvalue(nirs.dio1.Line(2),0);
        end;
        for c=1:8
            putvalue(nirs.dio1.Line(1),str2num(ScaledValue(c)));
            putvalue(nirs.dio1.Line(2),1);      % Clock it
            putvalue(nirs.dio1.Line(2),0);
        end;
        putvalue(nirs.dio1.Line(3),1);          % Latch it;
        putvalue(nirs.dio1.Line(3),0);
        
        
 %       ScaledValue = dec2bin(100,8)                  % FORCE GainB = 100
        putvalue(nirs.dio1.Line([4]),[0]);      % Select GainB Block B=0, A=1
    end;
        %-------------------------------------------------------------------------
        % The following is identical to above, except dio2 instead of dio1 for
        % the 2nd set of detectors using the 2nd DAQ card.
 else   %-------------------------------------------------------------------------
    ScaledValue = dec2bin(ScaledValue,8);                   % Change ScaledValue to binary
    putvalue(nirs.dio2.Line([4]),[1]);          % Select GainA Block
    putvalue(nirs.dio2.Line([1,2,3]),[0 0 0]);  % Start in known place
    
    % Dummy Data  First set gain to 1 on all channels
    for c=1:4
        putvalue(nirs.dio2.Line(1),1);
        putvalue(nirs.dio2.Line(2),1);          % Clock it
        putvalue(nirs.dio2.Line(2),0);
    end;
    dvalue = [0 1 0 0 0 0 0 0 0 0];
    for c=1:8
        putvalue(nirs.dio2.Line(1),dvalue(c));
        putvalue(nirs.dio2.Line(2),1);          % Clock it
        putvalue(nirs.dio2.Line(2),0);
    end;
    putvalue(nirs.dio2.Line(3),1);              % Latch it;  
    putvalue(nirs.dio2.Line(3),0);
    switch((Det-4))                             % active channel is low = 0
    case 1                                      % order is Wr3 Wr2 Wr1 Wr0 
        Rec = [ 1 1 1 0];   %1                  % Where Wr3 is first, Wr0 is last
    case 2
        Rec = [ 1 1 0 1];   %2
    case 3
        Rec = [ 1 0 1 1];   %3
    case 4
        Rec = [ 0 1 1 1];   %4
    end; 
    % ------------------------------------------  Send Real Data;
    for AB=1:2                                  % 1 for GainA, then 2 for GainB
        for c=1:4
            putvalue(nirs.dio2.Line(1),Rec(c));
            putvalue(nirs.dio2.Line(2),1);      % Clock it
            putvalue(nirs.dio2.Line(2),0);
        end;
        for c=1:8
            putvalue(nirs.dio2.Line(1),str2num(ScaledValue(c)));  % Value is now a string of bit values
            putvalue(nirs.dio2.Line(2),1);      % Clock it
            putvalue(nirs.dio2.Line(2),0);
        end;
        putvalue(nirs.dio2.Line(3),1);          % Latch it;
        putvalue(nirs.dio2.Line(3),0);
%       ScaledValue = dec2bin(100,8)                  % FORCE GainB = 100
        putvalue(nirs.dio2.Line([4]),[0]);      % Select GainB Block (B=0, A=1)
    end;

        % ---------------------------------------------------Send Dummy data again
        for c=1:4
            putvalue(nirs.dio2.Line(1),1);
            putvalue(nirs.dio2.Line(2),1);      % Clock it
            putvalue(nirs.dio2.Line(2),0);
        end;
        for c=1:8
            putvalue(nirs.dio2.Line(1),str2num(ScaledValue(c)));
            putvalue(nirs.dio2.Line(2),1);      % Clock it
            putvalue(nirs.dio2.Line(2),0);
        end;
        putvalue(nirs.dio2.Line(3),1);          % Latch it;
        putvalue(nirs.dio2.Line(3),0);
end;
return;

%%
function Start(nirs)
set(nirs.ai1,'ClockSource','External')

% set(nirs.ai1,'ClockSource','Internal')
% warning('using internal clock');

setBufferForPMD(nirs.ai1);  %Matlab 7.0 fix
set(nirs.ai1,'TransferMode','Default')
if nirs.nBoards>=2
    set(nirs.ai2,'ClockSource','External')
    set(nirs.ai2,'TransferMode','InterruptPerPoint')
    setBufferForPMD(nirs.ai2);
end

if  isfield(nirs,'auxDAQ')
    setBufferForPMD(nirs.auxDAQ);

    start(nirs.auxDAQ);  %Record Aux data
end
%set(nirs.ai1,'SampleRate',3205/64);
set(nirs.ai1,'SampleRate',3205/8);

set(nirs.ai1,'BufferingMode','Auto')
setBufferForPMD(nirs.ai1);  %Matlab 7.0 fix

start(nirs.ai1);                            % Start AD Collection
if(nirs.nBoards>=2)
    start(nirs.ai2);
    putvalue(nirs.dio2.Line(8),1);          % Start AD Collection
end;
putvalue(nirs.dio1.Line(8),1);              % Tell remote device to start AD Collection

% tic;
% for idx=1:50000
%     t(idx)=toc;
%     s(idx)=nirs.ai1.SamplesAvailable;
% end
return



%% Stop aquistion
function Stop(nirs)

if(strcmp(lower(get(nirs.ai1,'Running')),'on'))
    stop(nirs.ai1);
end
putvalue(nirs.dio1.Line(8),0);          % Stop AD Collection board 1
if(nirs.nBoards>=2)
    if(strcmp(lower(get(nirs.ai2,'Running')),'on'))
        stop(nirs.ai2);
    end

    putvalue(nirs.dio2.Line(8),0);      % Stop AD Collection board 2
end
%If you were recording aux, stop now
if isfield(nirs,'auxDAQ')  %Stop Aux board
    if(strcmp(lower(get(nirs.auxDAQ,'Running')),'on'))
        stop(nirs.auxDAQ);
    end
end