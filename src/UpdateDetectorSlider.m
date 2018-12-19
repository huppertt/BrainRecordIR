function UpdateDetectorSlider(app,event)

global BrainRecordIRApp;
app.Value=round(event.Value);
idx=app.UserData;

BrainRecordIRApp.handles.Detectors{idx,3}.Value=app.Value;


BrainRecordIRApp.Device.setDetectorGain(idx,app.Value);

return
