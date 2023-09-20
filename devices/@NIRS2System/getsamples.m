function [d,t]=getsamples(foo,numbersamples);
global NIRS2device;

numbersamples=max([numbersamples 0]);

[d,t]=nirsgetdata(NIRS2device.instrument,numbersamples);

NIRS2device.instrument.FirstDataFlag=true;
NIRS2device.lastcalled=NIRS2device.lastcalled+numbersamples;

return
