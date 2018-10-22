function stop(foo)
global simulatordevice;
stop(simulatordevice.DAQ.handle);
writemsg(simulatordevice,'stop function called');
simulatordevice.isrunning=false;

return