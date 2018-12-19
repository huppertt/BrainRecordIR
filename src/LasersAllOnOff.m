function LasersAllOnOff

global BrainRecordIRApp;

state= strcmp(BrainRecordIRApp.SwitchSourcesOnOff.Value,'On');

for i=1:size(BrainRecordIRApp.handles.Lasers,1)
    if(state)
        BrainRecordIRApp.handles.Lasers{i,3}.Value='On';
        BrainRecordIRApp.handles.Lasers{i,6}.Value='On';
        BrainRecordIRApp.handles.Lasers{i,4}.Color=[1 0 0];
        BrainRecordIRApp.handles.Lasers{i,7}.Color=[1 0 0];
    else
        BrainRecordIRApp.handles.Lasers{i,3}.Value='Off';
        BrainRecordIRApp.handles.Lasers{i,6}.Value='Off';
        BrainRecordIRApp.handles.Lasers{i,4}.Color=[.6 .6 .6];
        BrainRecordIRApp.handles.Lasers{i,7}.Color=[.6 .6 .6];
    end
    BrainRecordIRApp.Device.setLaserState(BrainRecordIRApp.handles.Lasers{i,3}.UserData,state);
    BrainRecordIRApp.Device.setLaserState(BrainRecordIRApp.handles.Lasers{i,6}.UserData,state);
end

if(state)
    BrainRecordIRApp.SourcesLamp.Color=[1 0 0];
else
    BrainRecordIRApp.SourcesLamp.Color=[.6 .6 .6];
end

return