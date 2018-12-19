function AddStimEvent

global BrainRecordIRApp;

stimName=BrainRecordIRApp.TaskDropDown.Value;

stim=BrainRecordIRApp.Subject.data(1).stimulus(stimName);
if(isempty(stim))
    stim=nirs.design.StimulusEvents;
    stim.name=stimName;
end
stim.onset(end+1,1)=BrainRecordIRApp.Subject.data(1).time(end);
stim.dur(end+1,1)=2;
stim.amp(end+1,1)=1;
BrainRecordIRApp.Subject.data(1).stimulus(stimName)=stim;

BrainRecordIRApp.Label_2.Text=num2str(length(stim.onset));

BrainRecordIRApp.UITable.Data{end+1,1}=stimName;
BrainRecordIRApp.UITable.Data{end,2}=stim.onset(end);
BrainRecordIRApp.UITable.Data{end,3}=stim.dur(end);
BrainRecordIRApp.UITable.Data{end,4}=stim.amp(end);

c={'r','g','b','k','c','y'};
c=c{find(ismember(BrainRecordIRApp.TaskDropDown.Items,BrainRecordIRApp.TaskDropDown.Value))};


f=fill(BrainRecordIRApp.MainPlotWindow,...
    [stim.onset(end) stim.onset(end)+stim.dur(end) stim.onset(end)+stim.dur(end) stim.onset(end)],...
    [-9999 -9999 9999 9999],c,'facealpha',.1);


return;