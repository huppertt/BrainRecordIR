function setlaser(foo,laserIdx,State)

global Cw6device;

Cw6device.System.LaserStates(laserIdx)=State;

Cw6device.instrument.SetLaserState(laserIdx-1,State);

return