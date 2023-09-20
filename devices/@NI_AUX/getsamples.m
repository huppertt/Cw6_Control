function [d,t]=getsamples(foo,numbersamples);
global NI_Auxdevice;

numbersamples=max([numbersamples 0]);

[d,t]=getdata(NI_Auxdevice.auxDAQ,numbersamples);

d=d';
t=t';

return
