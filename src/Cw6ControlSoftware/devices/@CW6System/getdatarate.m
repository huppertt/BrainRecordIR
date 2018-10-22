function  rate=getdatarate(foo)
global Cw6device;
rate=Cw6device.instrument.GetDataRate;
return