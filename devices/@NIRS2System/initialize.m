function initialize(foo)

global NIRS2device;
global NUM_SRC;
global NUM_DET;

NIRS2device.data = [];
NIRS2device.data_t = [];
NIRS2device.lastcalled=0;
NIRS2device.samplechannels=256;

NIRS2device.isrunning=false;

NIRS2device.SystemType='NIRS2';
NIRS2device.SystemInfo.NumLasers=NUM_SRC;
NIRS2device.SystemInfo.NumDetectors=NUM_DET;


%% Initialize the instrument

nirs=nirs2('init');
NIRS2device.instrument=nirs;

nirs2('UpdateLaser',0,nirs);

NIRS2device.SystemInfo.Rate=75;
NIRS2device.SystemInfo.MeasurementLst=getdeviceML;
NIRS2device.SystemInfo.MeasurementAct=ones(size(NIRS2device.SystemInfo.MeasurementLst,1),1);
NIRS2device.SystemInfo.NUMMEAS=size(NIRS2device.SystemInfo.MeasurementLst,1);

NIRS2device.SystemInfo.frqMap=[1:NUM_SRC];

NIRS2device.System.LaserStates=false(NIRS2device.SystemInfo.NumLasers,1);
NIRS2device.System.DetGains=zeros(NIRS2device.SystemInfo.NumDetectors,1);

nirs2('UpdateLaser',NIRS2device.System.LaserStates,NIRS2device.instrument);
for idx=1:NUM_DET
    nirs2('UpdateGain',idx,NIRS2device.System.DetGains(idx),NIRS2device.instrument);
end
return