function setgain(foo,Gain,DetIdx)
global Cw6device;
Cw6device.System.DetGains(DetIdx)=Gain;
Cw6device.instrument.SetDetGains(DetIdx-1,Gain);
return