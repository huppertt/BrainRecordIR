function UpdateDetectorSlider(handles,hObject)

value=round(get(hObject,'Value'));
set(hObject,'Value',value);

det=get(hObject,'UserData');
set(handles.DetSpinner(det.Optode),'Value',value);

handles.Instrument=handles.Instrument.setDetectorGain(det.Optode,value);


set(handles.BrainRecordIR,'UserData',handles);
guidata(handles.BrainRecordIR,handles);
return
