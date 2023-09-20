function ml=getML(foo)
global simulatordevice;

ml=simulatordevice.SystemInfo.MeasurementLst; %(find(simulatordevice.SystemInfo.MeasurementLstAct),:);

return