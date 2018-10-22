function flag=isrunning(foo)
global simulatordevice;
flag=simulatordevice.DAQ.handle.Running;
return