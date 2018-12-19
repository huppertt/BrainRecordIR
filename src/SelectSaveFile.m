function SelectSaveFile(varargin)

global BrainRecordIRApp;

if(isempty(varargin{1}.SelectedNodes.UserData))
    return
end

if(isa(varargin{1}.SelectedNodes.UserData,'nirs.core.Data'))
    BrainRecordIRApp.Subject.data=varargin{1}.SelectedNodes.UserData;
    
    
    
    if(isempty(BrainRecordIRApp.Subject.data))
        return
    end
    
    BrainRecordIRApp.Drawing.SDGhandles=[];
    BrainRecordIRApp.Drawing.Datahandles=[];
    
    D={};
    stim=BrainRecordIRApp.Subject.data(1).stimulus;
    for i=1:length(stim.keys)
        ss=stim(stim.keys{i});
        for j=1:length(ss.onset)
            D{end+1,1}=ss.name;
            D{end,2}=ss.onset(j);
            D{end,3}=ss.dur(j);
            D{end,4}=ss.amp(j);
        end
    end
    
    
    set(BrainRecordIRApp.UITable,'Data',D);
    set(BrainRecordIRApp.UITable,'ColumnEditable',true(1,5));
    
    set(BrainRecordIRApp.Label_2,'Text',[num2str(size(D,1))]);
    
    types={};
    utypes=unique(BrainRecordIRApp.Subject.data(1).probe.link.type);
    for i=1:length(utypes)
        types{end+1}=['Raw: ' num2str(utypes(i)) 'nm'];
    end
    if(length(BrainRecordIRApp.Subject.data)>1)
        utypes=unique(BrainRecordIRApp.Subject.data(2).probe.link.type);
        for i=1:length(utypes)
            types{end+1}=['dOD: ' num2str(utypes(i)) 'nm'];
        end
    end
    if(length(BrainRecordIRApp.Subject.data)>2)
        utypes=unique(BrainRecordIRApp.Subject.data(3).probe.link.type);
        for i=1:length(utypes)
            types{end+1}=['Hemoglobin: ' utypes{i}];
        end
    end
    set(BrainRecordIRApp.SelectDisplayType,'Items',types);
    cla(BrainRecordIRApp.UIAxesStatsViewPlot);
    BrainRecordIRApp.UIAxesStatsViewPlot.UserData=[];
    Update_BrainRecorderAll();
    
else
    BrainRecordIRApp.Subject.data(1)=varargin{1}.SelectedNodes.UserData.HRF;
    
    BrainRecordIRApp.Drawing.SDGhandles=[];
    BrainRecordIRApp.Drawing.Datahandles=[];
    
    set(BrainRecordIRApp.UITable,'Data',{});
    set(BrainRecordIRApp.UITable,'ColumnEditable',true(1,5));
    set(BrainRecordIRApp.Label_2,'Text','--');
    
    types={};
    utypes=unique(BrainRecordIRApp.Subject.data(1).probe.link.type);
    for i=1:length(utypes)
        types{end+1}=['HRF: ' utypes{i}];
    end
    
    set(BrainRecordIRApp.SelectDisplayType,'Items',types);
    
    
    
    BrainRecordIRApp.UIAxesStatsViewPlot.UserData=varargin{1}.SelectedNodes.UserData;
    Update_BrainRecorderAll();
    
end

return