function stimwizard(handles,hObject)

data=get(get(handles.filelist,'SelectedNodes'),'Userdata');
if(isempty(data))
    return;
end

data=nirs.viz.StimUtil(data);
set(get(handles.filelist,'SelectedNodes'),'Userdata',data);
handles.Subject.data=data;

set(handles.BrainRecordIR,'UserData',handles);
SelectSaveFile(handles,handles.filelist);

return