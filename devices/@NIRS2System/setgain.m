function setgain(foo,Gain,DetIdx)

global NIRS2device;

NIRS2device.System.DetGains(DetIdx)=Gain;

%nirs2('UpdateGain',DetIdx,);
Nirs_BackEnd('local_SetGain',DetIdx,.5*NIRS2device.System.DetGains(DetIdx),NIRS2device.instrument);
return