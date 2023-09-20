function gains=getgain(foo,DetIdx)
global NIRS2device;
if(~exist('DetIdx') | isempty(DetIdx))
    DetIdx=1:NIRS2device.SystemInfo.NumDetectors;
end
gains=NIRS2device.System.DetGains(DetIdx);
return
    