function start(foo);

global Cw6device;
Cw6device.lastcalled=0;

Cw6device.instrument.StartDAQ;
Cw6device.isrunning=true;

return