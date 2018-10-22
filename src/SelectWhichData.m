function SelectWhichData(handles,hObject)

handles.Drawing.Datahandles=[];
set(handles.BrainRecordIR,'UserData',handles);
guidata(handles.BrainRecordIR,handles);
Update_BrainRecorderAll(handles);
