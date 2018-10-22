function PostAnalysis(handles,hObject)
% This function processes all the (current and previous loaded) data through a standard pipline


h = waitbar(0,'Processing files');

cnt=0;
if(isfield(handles,'file_list_loadedfiles') && ~isempty(handles.file_list_loadedfiles))
    cnt=cnt+length(handles.file_list_loadedfiles);
end
if(isfield(handles,'file_list_rawfiles') && ~isempty(handles.file_list_rawfiles))
    cnt=cnt+length(handles.file_list_rawfiles);
end


if(cnt==0)
    return
end
cnt=cnt*2+1;
cnt2=0;

if(isfield(handles,'file_list_rawfiles') && ~isempty(handles.file_list_rawfiles))
    for i=1:length(handles.file_list_rawfiles)
        h=waitbar(cnt2/cnt,h);
        
        raw=get(handles.file_list_rawfiles(i),'Userdata');
        raw=raw(1);  % remove existing processing
        
        job = nirs.modules.OpticalDensity;
        job = nirs.modules.Resample(job);
        raw(2,1)=job.run(raw);
        job = nirs.modules.BeerLambertLaw;
        raw(3,1)=job.run(raw(2));
        cnt2=cnt2+1;
        set(handles.file_list_rawfiles(i),'Userdata',raw);
        
        h=waitbar(cnt2/cnt,h);
        job=nirs.modules.GLM;
        SubjStats(cnt2)=job.run(raw(3));
        
        if(~isfield(handles,'file_list_statsfiles'))
            handles.file_list_statsfiles = uitreenode(handles.filelist_stats,'Text',handles.file_list_rawfiles(i).Text,'NodeData',[],'Userdata',SubjStats(cnt2));
        else
            lst=[];
            for j=1:length(handles.file_list_statsfiles)
                if(strcmp(handles.file_list_statsfiles(j).Text,handles.file_list_rawfiles(i).Text))
                    lst=j;
                    break;
                end
            end
            if(~isempty(lst))
                set(handles.file_list_statsfiles(lst),'Userdata',SubjStats(cnt2));
            else
                
                handles.file_list_statsfiles(end+1) = uitreenode(handles.filelist_stats,'Text',handles.file_list_rawfiles(i).Text,'NodeData',[],'Userdata',SubjStast(cnt2));
            end
        end
        
        
    end
end



if(isfield(handles,'file_list_loadedfiles') && ~isempty(handles.file_list_loadedfiles))
    for i=1:length(handles.file_list_loadedfiles)
        h=waitbar(cnt2/cnt,h);
        
        raw=get(handles.file_list_loadedfiles(i),'Userdata');
        raw=raw(1);  % remove existing processing
        
        job = nirs.modules.OpticalDensity;
        job = nirs.modules.Resample(job);
        raw(2,1)=job.run(raw);
        job = nirs.modules.BeerLambertLaw;
        raw(3,1)=job.run(raw(2));
        cnt2=cnt2+1;
        set(handles.file_list_loadedfiles(i),'Userdata',raw);
        
        h=waitbar(cnt2/cnt,h);
        job=nirs.modules.GLM;
        SubjStats(cnt2)=job.run(raw(3));
        
        if(~isfield(handles,'file_list_statsfiles'))
            handles.file_list_statsfiles = uitreenode(handles.filelist_stats,'Text',handles.file_list_loadedfiles(i).Text,'NodeData',[],'Userdata',SubjStats(cnt2));
        else
            lst=[];
            for j=1:length(handles.file_list_statsfiles)
                if(strcmp(handles.file_list_statsfiles(j).Text,handles.file_list_loadedfiles(i).Text))
                    lst=j;
                    break;
                end
            end
            if(~isempty(lst))
                set(handles.file_list_statsfiles(lst),'Userdata',SubjStats(cnt2));
            else
                
                handles.file_list_loadedfiles(end+1) = uitreenode(handles.filelist_stats,'Text',handles.file_list_loadedfiles(i).Text,'NodeData',[],'Userdata',SubjStats(cnt2));
            end
        end
        
        
    end
end

if(length(SubjStats)>1)
    job=nirs.modules.MixedEffects;
    job.formula='beta ~ -1 + cond';
    GroupStats = job.run(SubjStats);
    
    for j=1:length(handles.file_list_statsfiles)
        if(strcmp(handles.file_list_statsfiles(j).Text,'Summary'))
            lst=j;
            break;
        end
    end
    if(~isempty(lst))
        set(handles.file_list_statsfiles(lst),'Userdata',GroupStats);
    else
        
        handles.file_list_loadedfiles(end+1) = uitreenode(handles.filelist_stats,'Text','Summary','NodeData',[],'Userdata',GroupStats);
    end
end


try;
    close(h);
end





handles.Drawing.SDGhandles=[];
handles.Drawing.Datahandles=[];
set(handles.BrainRecordIR,'UserData',handles);
SelectSaveFile(handles,handles.filelist);

return