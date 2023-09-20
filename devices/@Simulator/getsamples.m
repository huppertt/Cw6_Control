function [d,t]=getsamples(foo,numbersamples);
global simulatordevice;

tasks=simulatordevice.lastcalled+1:simulatordevice.lastcalled+numbersamples;
simulatordevice.lastcalled=get(simulatordevice.DAQ.handle,'TasksExecuted');
t=get(simulatordevice.DAQ.handle,'Period')*tasks;

numchan=length(find(simulatordevice.SystemInfo.MeasurementLstAct==1));

d=rand(numchan,numbersamples);


return
