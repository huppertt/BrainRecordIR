function EventToggle

global BrainRecordIRApp;
stimName=BrainRecordIRApp.TaskDropDown.Value;
stim=BrainRecordIRApp.Subject.data(1).stimulus(stimName);
if(isempty(stim))
    stim=nirs.design.StimulusEvents;
    stim.name=stimName;
end

if(strcmp(BrainRecordIRApp.Switch_33.Value,'On'))
    stim.onset(end+1,1)=BrainRecordIRApp.Subject.data(1).time(end);
    stim.dur(end+1,1)=999;
    stim.amp(end+1,1)=1;
BrainRecordIRApp.UITable.Data{end+1,1}=stimName;
BrainRecordIRApp.UITable.Data{end,2}=stim.onset(end);
BrainRecordIRApp.UITable.Data{end,3}=stim.dur(end);
    BrainRecordIRApp.UITable.Data{end,4}=stim.amp(end);
    
c={'r','g','b','k','c','y'};
c=c{find(ismember(BrainRecordIRApp.TaskDropDown.Items,BrainRecordIRApp.TaskDropDown.Value))};


f=fill(BrainRecordIRApp.MainPlotWindow,...
    [stim.onset(end) stim.onset(end)+stim.dur(end) stim.onset(end)+stim.dur(end) stim.onset(end)],...
    [-9999 -9999 9999 9999],c,'facealpha',.1,'tag',stimName);
    
    
else
    lst=find(stim.dur==999);
    lst=lst(end);
    stim.dur(lst)=BrainRecordIRApp.Subject.data(1).time(end)-stim.onset(lst);
    
    lst2=find(ismember({BrainRecordIRApp.UITable.Data{:,1}},stimName)' & ...
        vertcat(BrainRecordIRApp.UITable.Data{:,3})==999);
    if(~isempty(lst2))
        lst2=lst2(end);
        BrainRecordIRApp.UITable.Data{lst2,3}=stim.dur(end);
    end
    
    ch=get(BrainRecordIRApp.MainPlotWindow,'Children');
    for i=1:length(ch)
        if(strcmp(get(ch(i),'Type'),'patch') & ...
                strcmp(get(ch(i),'Tag'),stimName))
            v=get(ch(i),'Vertices');
            v(:,1)=[stim.onset(end) stim.onset(end)+stim.dur(end) stim.onset(end)+stim.dur(end) stim.onset(end)];
            set(ch(i),'Vertices',v);
            set(ch(i),'Tag','');
        end
    end
    
    
end

BrainRecordIRApp.Subject.data(1).stimulus(stimName)=stim;
BrainRecordIRApp.Label_2.Text=num2str(length(stim.onset));






return