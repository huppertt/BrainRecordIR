function UpdateSourceToggle(handles,hObject,oI,wI)

src=get(hObject,'UserData');
src.State=strcmp(get(hObject,'Value'),'on');

if(~handles.SrcLink.Value)
    handles.Instrument=handles.Instrument.setLaserState(src.Laser,src.State);
    if(src.State)
        set(handles.Srcspinner(oI,wI),'BackgroundColor','r');
    else
        set(handles.Srcspinner(oI,wI),'BackgroundColor','w');
    end
else
    for(i=1:length(handles.system.Lasers.Laser2OptodeMapping))
        if(handles.system.Lasers.Laser2OptodeMapping(i).Optode==src.Optode)
            handles.Instrument=handles.Instrument.setLaserState(i,src.State);
        end
    end
    
    if(src.State)
        set(hObject,'FontColor',[1 0 0]);
        set(handles.Srcspinner(oI,:),'BackgroundColor','r');
        set(handles.SrcButton(oI,:),'Value','on')
        
    else
        set(hObject,'FontColor',[1 0 0]);
        set(handles.Srcspinner(oI,:),'BackgroundColor','w');
        set(handles.SrcButton(oI,:),'Value','off');
        
    end
    
    

end
set(handles.SrcButton(:),'FontColor',get(handles.Tab(1),'BackgroundColor'));

if(any(handles.Instrument.laserstates))
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