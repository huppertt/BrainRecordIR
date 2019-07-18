function UpdateSourceSpinner(app,event)


global BrainRecordIRApp;
app.Value=round(event.Value);
idx=app.UserData;

BrainRecordIRApp.handles.Lasers{idx,2}.Value=app.Value;


BrainRecordIRApp.Device.setSrcPower(idx,app.Value);



return