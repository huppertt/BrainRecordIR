function numsamples=samplesavaliable(foo)
global Cw6device;

numsamples=floor((Cw6device.instrument.samplesavaliable)./(Cw6device.samplechannels+6));

return