function varargout = wireless(varargin)
	try
   		[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
   	catch
   		disp(lasterr);
   	end
return

%% Initialization
function nirs = init(varargin)

persistent nirs2;

try
   fclose(nirs2);
end

if(ismac)
    nirs=serial('/dev/tty.usbserial-A601DR98','BaudRate',230400,'tag','TechEnWireless');
else
     disp('COnnecting on COM4; if fails, check device manager')
    nirs=serial('COM4','BaudRate',230400,'tag','TechEnWireless');
   
end

set(nirs,'InputBufferSize',85*75*60);
nirs2=nirs;
try
    fopen(nirs);
    disp('Connected to Wireless NIRS system (COM 4)');
catch
    disp('Connection to Wireless NIRS system failed');
end

sendcmd(nirs,'f75');
sendcmd(nirs,'ft0');
sendcmd(nirs,'DC1');
UpdateLaser(zeros(8,1),nirs);
UpdateLaserPower(9*ones(8,1),nirs);
UpdateGain(ones(6,1),nirs);

return;


%% Lasers
function UpdateLaserPower(Lasers,nirs)

sendcmd(nirs,['l16' num2str(Lasers(1))]);
sendcmd(nirs,['l18' num2str(Lasers(2))]);
sendcmd(nirs,['l26' num2str(Lasers(3))]);
sendcmd(nirs,['l28' num2str(Lasers(4))]);
sendcmd(nirs,['l36' num2str(Lasers(5))]);
sendcmd(nirs,['l38' num2str(Lasers(6))]);
sendcmd(nirs,['l46' num2str(Lasers(7))]);
sendcmd(nirs,['l48' num2str(Lasers(8))]);


function UpdateLaser(Lasers,nirs)
global NUM_SRC;

sendcmd(nirs,['s16' num2str(Lasers(1))]);
sendcmd(nirs,['s18' num2str(Lasers(2))]);
sendcmd(nirs,['s26' num2str(Lasers(3))]);
sendcmd(nirs,['s28' num2str(Lasers(4))]);
sendcmd(nirs,['s36' num2str(Lasers(5))]);
sendcmd(nirs,['s38' num2str(Lasers(6))]);
sendcmd(nirs,['s46' num2str(Lasers(7))]);
sendcmd(nirs,['s48' num2str(Lasers(8))]);


return;

%% Detectors

function UpdateGain(Value,nirs);
sendcmd(nirs,['d1' num2str(Value(1))]);
sendcmd(nirs,['d2' num2str(Value(2))]);
sendcmd(nirs,['d3' num2str(Value(3))]);
sendcmd(nirs,['d4' num2str(Value(4))]);
sendcmd(nirs,['d5' num2str(Value(5))]);
sendcmd(nirs,['d6' num2str(Value(6))]);

return;

%%
function Start(nirs)
global sampletime;
sampletime=0;

flushinput(nirs);
sendcmd(nirs,'run');
str='A';
while(str~=double('$'))
    str=fread(nirs,1);
end
fread(nirs,84);

return



%% Stop aquistion
function Stop(nirs)
sendcmd(nirs,'stp');
return