function AddStimComment

global BrainRecordIRApp;
comments=BrainRecordIRApp.Subject.data.auxillary('comment');
if(isempty(comments))
    comments=nirs.design.StimulusEvents;
    comments.name='Comments';
end
comments.onset(end+1,1)=BrainRecordIRApp.Subject.data.time(end);
comments.dur(end+1,1)=NaN;
comments.amp(end+1,1)=NaN;

BrainRecordIRApp.Subject.data.auxillary('comment')=comments;

line(BrainRecordIRApp.MainPlotWindow,[comments.onset(end) comments.onset(end)],[-9999 9999],'color','m')

return