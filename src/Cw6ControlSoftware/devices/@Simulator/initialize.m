function initialize(foo)

global simulatordevice;
global NUM_SRC;
global NUM_DET;

simulatordevice.data = [];
simulatordevice.data_t = [];
simulatordevice.lastcalled=0;

simulatordevice.isrunning=false;

simulatordevice.SystemType='Simulator';
simulatordevice.SystemInfo.NumLasers=NUM_SRC;
simulatordevice.SystemInfo.NumDetectors=NUM_DET;

simulatordevice.SystemInfo.MeasurementLst=getdeviceML;
simulatordevice.SystemInfo.NUMMEAS=size(simulatordevice.SystemInfo.MeasurementLst,1);


simulatordevice.System.LaserStates=false(simulatordevice.SystemInfo.NumLasers,1);
simulatordevice.System.DetGains=zeros(simulatordevice.SystemInfo.NumDetectors,1);

writemsg(simulatordevice,'ready to start');


return