function StartDAQ(handles,hObject)




if(handles.Instrument.isrunning)
    handles.Instrument.Stop();
    stop(handles.maintimer);
else
    handles.maintimer=timer;
    set(handles.maintimer,'ExecutionMode','fixedRate');
    set(handles.maintimer,'Period',.5);
    set(handles.maintimer,'TimerFcn',@updatedata);
    
    handles.Subject.data.data=[];
    handles.Subject.data.time=[];
    handles.Subject.data.stimulus=Dictionary;
    set(handles.maintimer,'UserData',handles.BrainRecordIR);
    set(handles.StartButton,'Text','Stop Collection');
    handles.Drawing.Datahandles=[];
    cla(handles.progressbar);
    fill(handles.progressbar,[0 1 1 0],[0 0 1 1],'g');
    set(handles.progressbar,'XLim',[0 100]);
    set(handles.BrainRecordIR,'UserData',handles);
    handles.Instrument.Start();
    start(handles.maintimer);
end


return



function updatedata(varargin)