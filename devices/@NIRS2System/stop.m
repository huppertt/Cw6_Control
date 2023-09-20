function stop(foo)


global NIRS2device;


nirs2('Stop',NIRS2device.instrument);

NIRS2device.isrunning=false;


return