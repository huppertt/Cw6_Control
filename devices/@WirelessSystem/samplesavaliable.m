function numsamples=samplesavaliable(foo)
global NIRS2device;

samplerate=NIRS2device.SystemInfo.rate;
upS=75/samplerate;
numsamples=floor((get(NIRS2device.instrument,'BytesAvailable')/85)/(2*upS));

return