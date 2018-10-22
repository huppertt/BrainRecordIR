function states=getlaser(foo,laserIdx)
global Cw6device;
if(~exist('laserIdx') | isempty(laserIdx))
    laserIdx=1:Cw6device.SystemInfo.NumLasers;
end
states=Cw6device.System.LaserStates(laserIdx);
return
    