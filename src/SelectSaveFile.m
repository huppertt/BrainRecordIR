function SelectSaveFile(handles,hObject)

handles.Subject.data=get(hObject.SelectedNodes,'userdata');
if(isempty(handles.Subject.data))
    return
end
handles.Drawing.SDGhandles=[];
handles.Drawing.Datahandles=[];

D={};
stim=handles.Subject.data(1).stimulus;
for i=1:length(stim.keys)
    ss=stim(stim.keys{i});
    for j=1:length(ss.onset)
        D{end+1,1}=ss.name;
        D{end,2}=ss.onset(j);
        D{end,3}=ss.dur(j);
        D{end,4}=ss.amp(j);
    end
end
set(handles.eventtable,'Data',D);
set(handles.eventtable,'ColumnEditable',true(1,5));

set(handles.numstimlabel,'Text',['#events=' num2str(size(D,1))]);

types={};
utypes=unique(handles.Subject.data(1).probe.link.type);
for i=1:length(utypes)
    types{end+1}=['Raw: ' num2str(utypes(i)) 'nm'];
end
if(length(handles.Subject.data)>1)
    utypes=unique(handles.Subject.data(2).probe.link.type);
    for i=1:length(utypes)
        types{end+1}=['dOD: ' num2str(utypes(i)) 'nm'];
    end
end
if(length(handles.Subject.data)>2)
    utypes=unique(handles.Subject.data(3).probe.link.type);
    for i=1:length(utypes)
        types{end+1}=['Hemoglobin: ' utypes{i}];
    end
end
set(handles.SwitchType,'Items',types);

set(handles.BrainRecordIR,'UserData',handles);
guidata(handles.BrainRecordIR,handles);
Update_BrainRecorderAll(handles);



return