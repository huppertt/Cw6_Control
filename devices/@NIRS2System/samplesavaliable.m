function numsamples=samplesavaliable(foo)
global NIRS2device;

samplerate=NIRS2device.instrument.rate;
%upS=25/samplerate;
upS=200/samplerate;

numsamples=floor((NIRS2device.instrument.ai1.SamplesAvailable)./(2*upS));

return