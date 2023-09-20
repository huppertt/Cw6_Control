function setML(foo,mlIdx,mlBool)
global NIRS2device;

NIRS2device.SystemInfo.MeasurementAct(mlIdx)=mlBool;
%NIRS2device.instrument.SetMLAct(mlIdx-1,mlBool);
NIRS2device.samplechannels=length(find(NIRS2device.SystemInfo.MeasurementAct==1));

return