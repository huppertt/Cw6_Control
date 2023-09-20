function  rate=getdatarate(foo)
global NI_Auxdevice;

rate=NI_Auxdevice.auxDAQ.SampleRate;
return