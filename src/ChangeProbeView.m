function ChangeProbeView(handles,hObject)

type=get(handles.SDGplot_select,'Value');
for i=1:length(handles.Subject.data)
    
    switch(type)
        case('2D View')
            handles.Subject.data(i).probe.defaultdrawfcn='2D';
        case('10-20 View')
            handles.Subject.data(i).probe.defaultdrawfcn='10-20 zoom';
        case('Brain View')
            handles.Subject.data(i).probe.defaultdrawfcn='3D mesh (frontal) zoom';
    end
end


handles.Drawing.SDGhandles=[];

set(handles.BrainRecordIR,'UserData',handles);
guidata(handles.BrainRecordIR,handles);

Update_BrainRecorderAll(handles);
return
