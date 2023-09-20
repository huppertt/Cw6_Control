function setgain(foo,Gain,DetIdx)
global Cw6device;

global numDetrows;

if(DetIdx>2*numDetrows)
    DetIdx=DetIdx+16-2*numDetrows;
end

Cw6device.System.DetGains(DetIdx)=Gain;
Cw6device.instrument.SetDetGains(DetIdx-1,Gain);

return