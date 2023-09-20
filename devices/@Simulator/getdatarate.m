function  rate=getdatarate(foo)
global simulatordevice;

rate=1/simulatordevice.DAQ.handle.Period;

writemsg(simulatordevice,['Check Data Rate: ' num2str(rate)]);
return