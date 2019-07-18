function SetAllLaserPwr(value)

global BrainRecordIRApp;

  
for i=1:size(BrainRecordIRApp.handles.Lasers,1)
    BrainRecordIRApp.handles.Lasers{i,2}.Value=value;
    BrainRecordIRApp.handles.Lasers{i,5}.Value=value;
    BrainRecordIRApp.Device.setSrcPower(BrainRecordIRApp.handles.Lasers{i,3}.UserData,value);
    BrainRecordIRApp.Device.setSrcPower(BrainRecordIRApp.handles.Lasers{i,6}.UserData,value);
end