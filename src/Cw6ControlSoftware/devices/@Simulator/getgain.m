function gains=getgain(foo,DetIdx)
global simulatordevice;
if(~exist('DetIdx') | isempty(DetIdx))
    DetIdx=1:simulatordevice.SystemInfo.NumDetectors;
end
gains=simulatordevice.System.DetGains(DetIdx);
return
    