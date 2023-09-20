function states=getlaser(foo,laserIdx)
global NIRS2device;
if(~exist('laserIdx') | isempty(laserIdx))
    laserIdx=1:NIRS2device.SystemInfo.NumLasers;
end
states=NIRS2device.System.LaserStates(laserIdx);
return
    