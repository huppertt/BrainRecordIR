function start(foo);
global simulatordevice;
start(simulatordevice.DAQ.handle);
writemsg(simulatordevice,'start function called');
simulatordevice.isrunning=true;
