function PostAnalysis
% This function processes all the (current and previous loaded) data through a standard pipline

global BrainRecordIRApp;

h = waitbar(0,'Processing files');

cnt=0;
cnt=cnt+length(get(BrainRecordIRApp.LoadedFilesNode,'children'));
cnt=cnt+length(get(BrainRecordIRApp.RecordedFilesNode,'children'));


if(cnt==0)
    return
end
cnt=cnt*2+1;
cnt2=0; cnt3=1;

childs=get(BrainRecordIRApp.LoadedFilesNode,'children');
if(isempty(childs))
    childs=get(BrainRecordIRApp.RecordedFilesNode,'children');
else
    childs=[childs; get(BrainRecordIRApp.RecordedFilesNode,'children')];
end
    
clo(BrainRecordIRApp.AnalyzedResultsNode);      
    
for i=1:length(childs)
    h=waitbar(cnt2/cnt,h);
    
    raw=get(childs(i),'Userdata');
    raw=raw(1);  % remove existing processing
    
    job = nirs.modules.OpticalDensity;
    job = nirs.modules.Resample(job);
    raw(2,1)=job.run(raw);
    job = nirs.modules.BeerLambertLaw;
    raw(3,1)=job.run(raw(2));
    cnt2=cnt2+1;
    set(childs(i),'Userdata',raw);
    
    if(~isempty(raw(3).stimulus))
        h=waitbar(cnt2/cnt,h);
        job=nirs.modules.GLM;
        SubjStats(cnt3,1)=job.run(raw(3));
        a=uitreenode(BrainRecordIRApp.AnalyzedResultsNode,'Text',['Stats: ' SubjStats(cnt3,1).description],'NodeData',[],'Userdata',SubjStats(cnt3,1));
        set(BrainRecordIRApp.Tree,'SelectionChangedFcn',@SelectSaveFile)
        
        cnt3=cnt3+1;
        
    end
    
end




if(exist('SubjStats') && length(SubjStats)>1)
    job=nirs.modules.MixedEffects;
    job.formula='beta ~ -1 + cond';
    GroupStats = job.run(SubjStats);
    a=uitreenode(BrainRecordIRApp.AnalyzedResultsNode,'Text','Stats: ALL FILES','NodeData',[],'Userdata',GroupStats);
    set(BrainRecordIRApp.Tree,'SelectionChangedFcn',@SelectSaveFile)
    
end


try;
    close(h);
end


return