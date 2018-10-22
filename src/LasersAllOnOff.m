function LasersAllOnOff(handles,hObject)

state=strcmp(hObject.Value,'On');
for(i=1:length(handles.system.Lasers.Laser2OptodeMapping))
    handles.Instrument=handles.Instrument.setLaserState(i,state);
end

if(state)
    set(handles.Srcspinner(:),'BackgroundColor','r');
    set(handles.SrcButton(:),'Value','on');
else
    set(handles.Srcspinner(:),'BackgroundColor','w');
    set(handles.SrcButton(:),'Value','off');
end

 
if(state)
    for i=1:3
        if(~isempty(properties(handles.LaserAllOn(i))))
            
            set(handles.LaserAllOn(i),'Value','On')
            set(handles.LaserAllOnLamp(i),'Color',[1 0 0]);
        end
    end
else
    for i=1:3
        if(~isempty(properties(handles.LaserAllOn(i))))
            
            set(handles.LaserAllOn(i),'Value','Off')
            set(handles.LaserAllOnLamp(i),'Color',[.7 .7 .7]);
        end
    end
end   



set(handles.BrainRecordIR,'UserData',handles);
guidata(handles.BrainRecordIR,handles);
return