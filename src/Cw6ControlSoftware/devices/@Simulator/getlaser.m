function states=getlaser(foo,laserIdx)
global simulatordevice;
if(~exist('laserIdx') | isempty(laserIdx))
    laserIdx=1:simulatordevice.SystemInfo.NumLasers;
end
states=simulatordevice.System.LaserStates(laserIdx);
return
    