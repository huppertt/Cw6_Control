function  setdatarate(foo,rate)
global simulatordevice;

simulatordevice.DAQ.handle.Period=1/rate;

writemsg(simulatordevice,['Set Data Rate' num2str(rate)]);

return