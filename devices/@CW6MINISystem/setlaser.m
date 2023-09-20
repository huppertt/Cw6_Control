function setlaser(foo,laserIdx,State)

global Cw6device;

% if(laserIdx>2)
%     laserIdx=laserIdx+14;
% end

Cw6device.System.LaserStates(laserIdx)=State;

Cw6device.instrument.SetLaserState(laserIdx-1,State);

return