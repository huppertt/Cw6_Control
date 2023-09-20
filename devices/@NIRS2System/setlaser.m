function setlaser(foo,laserIdx,State)

global NIRS2device;

NIRS2device.System.LaserStates(laserIdx)=State;
nirs2('UpdateLaser',NIRS2device.System.LaserStates,NIRS2device.instrument);

return