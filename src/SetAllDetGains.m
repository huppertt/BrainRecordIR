function SetAllDetGains(value)

global BrainRecordIRApp;

for idx=1:size(BrainRecordIRApp.handles.Detectors,1)
    BrainRecordIRApp.handles.Detectors{idx,2}.Value=value;
    BrainRecordIRApp.handles.Detectors{idx,3}.Value=value;
    BrainRecordIRApp.Device.setDetectorGain(idx,value);
end