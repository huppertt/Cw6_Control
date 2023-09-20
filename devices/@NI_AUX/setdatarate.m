function  setdatarate(foo,rate)
global NI_Auxdevice;

rate=10;

set(NI_Auxdevice.auxDAQ,'SampleRate',rate);
set(NI_Auxdevice.auxDAQ,'SamplesPerTrigger',720*rate);
setBufferForPMD(NI_Auxdevice.auxDAQ);
NI_Auxdevicesamplerate=rate;

return