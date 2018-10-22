function setML(foo,mlIdx,mlBool)
global Cw6device;

Cw6device.SystemInfo.MeasurementAct(mlIdx)=mlBool;
Cw6device.instrument.SetMLAct(mlIdx-1,mlBool);
Cw6device.samplechannels=length(find(Cw6device.SystemInfo.MeasurementAct==1));

return