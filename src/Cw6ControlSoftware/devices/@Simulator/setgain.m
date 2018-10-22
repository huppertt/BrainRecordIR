function setgain(foo,Gain,DetIdx)
global simulatordevice;
simulatordevice.System.DetGains(DetIdx)=Gain;
writemsg(simulatordevice,['Changed Det' num2str(DetIdx) '  gain=' num2str(Gain)]);
return