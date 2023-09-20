function [d,t]=nirsgetdata(nirs,nsamples)
global sampletime;
global NIRS2device;

samplerate=NIRS2device.SystemInfo.rate;
upS=round(75/samplerate);

str='A';
while(str~=10)
    str=fread(nirs,1);
end

str=fread(nirs,85*upS*(nsamples));

d=asci2data(str);
t=sampletime+[1:nsamples]/samplerate;


%d=resample(d',1,upS)';
d=mean(d,2);

t=mean(t)';

sampletime=t(end);
return



