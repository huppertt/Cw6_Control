function setlaserpower(foo,power)

global NIRS2device;

NIRS2device.System.LaserPower=power;
wireless('UpdateLaserPower',NIRS2device.System.LaserPower,NIRS2device.instrument);

return