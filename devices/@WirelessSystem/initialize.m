function initialize(foo)

global NIRS2device;
global NUM_SRC;
global NUM_DET;
global MAX_LASER_INTEN;

NIRS2device.data = [];
NIRS2device.data_t = [];
NIRS2device.lastcalled=0;
NIRS2device.samplechannels=256;

NIRS2device.isrunning=false;

NIRS2device.SystemType='Wireless';
NIRS2device.SystemInfo.NumLasers=NUM_SRC;
NIRS2device.SystemInfo.NumDetectors=NUM_DET;


%% Initialize the instrument

nirs=wireless('init');
NIRS2device.instrument=nirs;

wireless('UpdateLaser',zeros(NUM_SRC,1),nirs);

NIRS2device.SystemInfo.rate=75;
NIRS2device.SystemInfo.MeasurementLst=getdeviceML;
NIRS2device.SystemInfo.MeasurementAct=ones(size(NIRS2device.SystemInfo.MeasurementLst,1),1);
NIRS2device.SystemInfo.NUMMEAS=size(NIRS2device.SystemInfo.MeasurementLst,1);

NIRS2device.SystemInfo.frqMap=[1:NUM_SRC];

NIRS2device.System.LaserStates=false(NIRS2device.SystemInfo.NumLasers,1);
NIRS2device.System.LaserPower=MAX_LASER_INTEN*ones(NIRS2device.SystemInfo.NumLasers,1);
NIRS2device.System.DetGains=zeros(NIRS2device.SystemInfo.NumDetectors,1);

wireless('UpdateLaser',NIRS2device.System.LaserStates,NIRS2device.instrument);
wireless('UpdateLaserPower',NIRS2device.System.LaserPower,NIRS2device.instrument);
wireless('UpdateGain',NIRS2device.System.DetGains,NIRS2device.instrument);
return