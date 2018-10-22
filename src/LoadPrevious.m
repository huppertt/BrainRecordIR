function LoadPrevious(handles,hObject)

[filename, pathname] = uigetfile({'*.nirs';'*.nir5'}, 'Pick a NIRS data file','MultiSelect', 'on');
if isequal(filename,0) || isequal(pathname,0)
    return
end

if(~iscellstr(filename))
    filename=cellstr(filename);
end

for i=1:length(filename)
    if(~isempty(strfind(filename{i},'.nirs')))
        raw=nirs.io.loadDotNirs(fullfile(pathname,filename{i}));
    else
        raw=nirs.io.loadNIR5(fullfile(pathname,filename{i}));
    end
    if(isa(raw.probe,'nirs.core.Probe1020'));
        raw.probe.defaultdrawfcn='2D';
        raw.probe=raw.probe.SetFiducialsVisibility(false);
        m=raw.probe.getmesh;
        m(1:end-1)=[];
         raw.probe=raw.probe.register_mesh2probe(m,true);
    end
    
    if(~isfield(handles,'file_list_loadedfiles'))
        handles.file_list_loadedfiles = uitreenode(handles.filelist_loaded,'Text',filename{i},'NodeData',[],'Userdata',raw);
    else
        handles.file_list_loadedfiles(end+1) = uitreenode(handles.filelist_loaded,'Text',filename{i},'NodeData',[],'Userdata',raw);
    end
end
    
handles.Subject.data=raw;


set(handles.BrainRecordIR,'UserData',handles);
guidata(handles.BrainRecordIR,handles);
SelectSaveFile(handles,handles.filelist);    
return
