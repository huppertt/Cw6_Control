function stop(foo)


global NIRS2device;


wireless('Stop',NIRS2device.instrument);

NIRS2device.isrunning=false;


return