function numsamples=samplesavaliable(foo)
global  NI_Auxdevice;

numsamples=NI_Auxdevice.auxDAQ.SamplesAvailable;

return