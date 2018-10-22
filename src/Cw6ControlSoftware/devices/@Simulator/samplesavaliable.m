function numsamples=samplesavaliable(foo)
global simulatordevice;
numsamples=get(simulatordevice.DAQ.handle,'TasksExecuted')-simulatordevice.lastcalled;
return