function UpdateSourceToggle(varargin)

global BrainRecordIRApp;

state=strcmp(varargin{1}.Value,'On');
laserIdx = varargin{1}.UserData;
SrcIdx = get(get(varargin{1},'parent'),'Userdata');

BrainRecordIRApp.Device.setLaserState(laserIdx,state);

linkall=BrainRecordIRApp.LinkColorsCheckBox.Value;

if(state)
    if(BrainRecordIRApp.handles.Lasers{SrcIdx,3}.UserData==laserIdx | linkall)
        BrainRecordIRApp.handles.Lasers{SrcIdx,3}.Value='On';
        BrainRecordIRApp.handles.Lasers{SrcIdx,4}.Color=[1 0 0];
    end
    if(BrainRecordIRApp.handles.Lasers{SrcIdx,6}.UserData==laserIdx | linkall)  
        BrainRecordIRApp.handles.Lasers{SrcIdx,6}.Value='On';
        BrainRecordIRApp.handles.Lasers{SrcIdx,7}.Color=[1 0 0];
    end
else
    if(BrainRecordIRApp.handles.Lasers{SrcIdx,3}.UserData==laserIdx | linkall)
        BrainRecordIRApp.handles.Lasers{SrcIdx,3}.Value='Off';
        BrainRecordIRApp.handles.Lasers{SrcIdx,4}.Color=[0.6 .6 .6];
    end
    if(BrainRecordIRApp.handles.Lasers{SrcIdx,6}.UserData==laserIdx | linkall)  
        BrainRecordIRApp.handles.Lasers{SrcIdx,6}.Value='Off';
        BrainRecordIRApp.handles.Lasers{SrcIdx,7}.Color=[.6 .6 .6];
    end
end

anyon=false;
for i=1:size(BrainRecordIRApp.handles.Lasers,1) 
    anyon=(anyon | strcmp(BrainRecordIRApp.handles.Lasers{i,3}.Value,'On'));
    anyon=(anyon | strcmp(BrainRecordIRApp.handles.Lasers{i,6}.Value,'On'));
end


if(anyon)
    BrainRecordIRApp.SourcesLamp.Color=[1 0 0];
    BrainRecordIRApp.SwitchSourcesOnOff.Value='On';
else
    BrainRecordIRApp.SourcesLamp.Color=[.6 .6 .6];
    BrainRecordIRApp.SwitchSourcesOnOff.Value='Off';
end


return