function start(foo);

global NI_Auxdevice;
NI_Auxdevice.lastcalled=0;
% 

% set(NI_Auxdevice.auxDAQ,'BufferingConfig',[1 10]);
setBufferForPMD(NI_Auxdevice.auxDAQ);
start(NI_Auxdevice.auxDAQ);
putvalue(NI_Auxdevice.auxDAQoutput,1);
% start(NI_Auxdevice.auxDAQoutput);
NI_Auxdevice.isrunning=true;

return