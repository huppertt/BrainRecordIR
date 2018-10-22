function initialize(foo)

global Cw6device;
global NUM_SRC;
global NUM_DET;

Cw6device.data = [];
Cw6device.data_t = [];
Cw6device.lastcalled=0;
Cw6device.samplechannels=256;

Cw6device.isrunning=false;

Cw6device.SystemType='Cw6';
Cw6device.SystemInfo.NumLasers=NUM_SRC;
Cw6device.SystemInfo.NumDetectors=NUM_DET;
Cw6device.instrument=actxcontrol('CW6CONTROLACTIVEX.Cw6ControlactivexCtrl.1',[0 0 .01 .01]);


Cw6device.instrument.SetDataRate(10);
Cw6device.instrument.AllOff;
Cw6device.instrument.SetUseTDML(0);

Cw6device.SystemInfo.MeasurementLst=getdeviceML;
Cw6device.SystemInfo.MeasurementAct=ones(size(Cw6device.SystemInfo.MeasurementLst,1),1);
Cw6device.SystemInfo.NUMMEAS=size(Cw6device.SystemInfo.MeasurementLst,1);

Cw6device.SystemInfo.frqMap=[1 9 2 10 3 11 4 12 5 13 6 14 7 15 8 16 17 25 18 26 19 27 20 28 21 29 22 30 23 31 24 32];

Cw6device.System.LaserStates=false(Cw6device.SystemInfo.NumLasers,1);
Cw6device.System.DetGains=zeros(Cw6device.SystemInfo.NumDetectors,1);


return