function stop(foo)

global NI_Auxdevice;
NI_Auxdevice.lastcalled=0;

stop(NI_Auxdevice.auxDAQ);
NI_Auxdevice.isrunning=false;
putvalue(NI_Auxdevice.auxDAQoutput,0);

return