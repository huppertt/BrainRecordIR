function gains=getgain(foo,DetIdx)
global Cw6device;
if(~exist('DetIdx') | isempty(DetIdx))
    DetIdx=1:Cw6device.SystemInfo.NumDetectors;
end
gains=Cw6device.instrument.GetDetGains(DetIdx);
return
    