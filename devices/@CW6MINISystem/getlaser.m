function states=getlaser(foo,laserIdx)
global Cw6device;

% if(laserIdx>2)
%     laserIdx=laserIdx+14;
% end

if(~exist('laserIdx') | isempty(laserIdx))
    laserIdx=1:Cw6device.SystemInfo.NumLasers;
end
states=Cw6device.System.LaserStates(laserIdx);
return
    