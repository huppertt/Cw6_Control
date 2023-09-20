function start(foo);

global NIRS2device;
NIRS2device.lastcalled=0;

%flushdata(NIRS2device.instrument);
nirs2('Start',NIRS2device.instrument);
NIRS2device.instrument.FirstDataFlag=false;
NIRS2device.isrunning=true;

return