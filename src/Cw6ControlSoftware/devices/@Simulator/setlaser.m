function setlaser(foo,laserIdx,State)
disp(laserIdx);
global simulatordevice;
    simulatordevice.System.LaserStates(laserIdx)=State;
    writemsg(simulatordevice,['Changed Laser' num2str(laserIdx) '  state=' num2str(State)]);
return