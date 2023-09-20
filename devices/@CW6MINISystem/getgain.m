function gains=getgain(foo,DetIdx)
global Cw6device;
global numDetrows;

if(DetIdx>2*numDetrows)
    DetIdx=DetIdx+16-2*numDetrows;
end

if(~exist('DetIdx') | isempty(DetIdx))
    DetIdx=1:Cw6device.SystemInfo.NumDetectors;
end
gains=Cw6device.System.DetGains(DetIdx);
return
    