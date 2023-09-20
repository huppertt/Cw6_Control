function setML(foo,mlIdx,bool)
global simulatordevice;

simulatordevice.SystemInfo.MeasurementLstAct(mlIdx)=bool;

return