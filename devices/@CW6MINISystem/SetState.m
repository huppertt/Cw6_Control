function SetState(foo,state,dwelltime,gains,lasers);

global Cw6device;

Cw6device.instrument.ChangeState(state-1);
%[1=0,2=8,3=1 ,4=9, ... etc
for idx=1:length(gains); 
    Cw6device.instrument.SetDetGains(idx-1,gains(idx));
end;

% 
% for DetIdx=1:length(gains)
%     setgain(foo,gains(DetIdx),DetIdx);
% end
for laserIdx=1:length(lasers)
    setlaser(foo,laserIdx,lasers(laserIdx));
end

Cw6device.instrument.SetDwellTime(dwelltime);
Cw6device.instrument.SetState(state-1);  
return