function StartDAQ(handles,hObject)




if(handles.Instrument.isrunning)
    handles.Instrument.Stop();
    stop(handles.maintimer);
    
    set(handles.filelist,'Enable','on');
    set(handles.ShowSNR,'Enable','on');
    set(handles.stimwizard,'Enable','on')
    set(handles.PostAnalysisButton,'Enable','on');
    set(handles.menu(2),'Enable','on');
    set(handles.menu(3),'Enable','on');
    set(handles.StartButton,'Text','Start Collection');
    
    % save data
    p=fullfile(handles.system.Folders.DefaultData,...
        handles.Subject.data.demographics('Investigator'),...
        handles.Subject.data.demographics('study'),...
        handles.Subject.data.demographics('subject'),...
        datestr(now,'mmm-dd-yyyy'));
        scannum=length(get(handles.filelist_raw,'children'))+1;
        filename=[ handles.Subject.data.demographics('subject') ...
            '-scan' num2str(scannum) '-' datestr(now,'mmm-dd-yyyy-HH-MM-PM') ];
        if(~exist(p,'dir'))
            mkdir(p);
        end
        filename(strfind(filename,' '))=[];
        if(ismember('.nirs',handles.system.Folders.DefaultFileType))
            nirs.io.saveDotNirs(handles.Subject.data,[],fullfile(p,[filename '.nirs']));
        end
        if(ismember('.snirf',handles.system.Folders.DefaultFileType))
            nirs.io.saveNIR5(handles.Subject.data,fullfile(p,[filename '.nir5']));
        end
        
        if(~isfield(handles,'file_list_loadedfiles'))
            handles.file_list_rawfiles = uitreenode(handles.filelist_raw,'Text',filename,'NodeData',[],'Userdata',handles.Subject.data);
        else
            handles.file_list_rawfiles(end+1) = uitreenode(handles.filelist_loaded,'Text',filename,'NodeData',[],'Userdata',handles.Subject.data);
        end
        set(handles.BrainRecordIR,'UserData',handles);
        guidata(handles.BrainRecordIR,handles);
        SelectSaveFile(handles,handles.filelist);
        
        
else
    % turn off some things that should not be clicked while running
    set(handles.filelist,'Enable','off');
    set(handles.ShowSNR,'Enable','off');
    set(handles.stimwizard,'Enable','off')
    set(handles.PostAnalysisButton,'Enable','off');
    set(handles.menu(2),'Enable','off');
    set(handles.menu(3),'Enable','off');

    
    
    handles.maintimer=timer;
    set(handles.maintimer,'ExecutionMode','fixedRate');
    set(handles.maintimer,'Period',.5);
    set(handles.maintimer,'TimerFcn',@updatedata);
    
    handles.Subject.data.data=[];
    handles.Subject.data.time=[];
    handles.Subject.data.stimulus=Dictionary;
    
    set(handles.StartButton,'Text','Stop Collection');
    handles.Drawing.Datahandles=[];
    cla(handles.progressbar);
    fill(handles.progressbar,[0 1 1 0],[0 0 1 1],'g');
    set(handles.progressbar,'XLim',[0 100]);
    set(handles.BrainRecordIR,'UserData',handles);
    handles.Instrument=handles.Instrument.sendMLinfo( handles.Subject.data.probe);
    set(handles.maintimer,'UserData',handles.BrainRecordIR);
    handles.Instrument.Start();
    start(handles.maintimer);
end


return



function updatedata(varargin)
handles=get(get(varargin{1},'userdata'),'userdata');

if(handles.Instrument.samples_avaliable>0)
    [d,t]=handles.Instrument.get_samples(handles.Instrument.samples_avaliable);
    try
    handles.Subject.data.data=[handles.Subject.data.data; d];
    handles.Subject.data.time=[handles.Subject.data.time; t];

    end
    if(isempty(handles.Drawing.Datahandles))
        set(handles.BrainRecordIR,'UserData',handles);
        Update_BrainRecorderAll(handles);
    else
        for i=1:length(handles.Drawing.Datahandles)
            x=get(handles.Drawing.Datahandles(i),'Xdata');
            y=get(handles.Drawing.Datahandles(i),'Ydata');
            try
                set(handles.Drawing.Datahandles(i),'Xdata',[x t'],'Ydata',[y d(:,i)']);
            end
            
        end
         
        xlim=[0 t(end)];
        if(get(handles.windowdatacheck,'value'))
            v=get(handles.windowdataedit,'value');
            xlim(1)=max(0,xlim(2)-v);
        else
            xlim(1)=0;
            
        end
        lst=find(handles.Subject.data.time>=xlim(1) & handles.Subject.data.time<=xlim(end));
        
        set(handles.TabViewsPanel(1),'XLim',xlim);
        %handles.Drawing.MeasListAct
        ylim(1)=min(min(handles.Subject.data.data(lst,:)));
        ylim(2)=max(max(handles.Subject.data.data(lst,:)));
        if(ylim(1)==ylim(2))
            ylim(2)=ylim(1)+1;
        end
        ylim(1)=floor(ylim(1)/5)*5;
        ylim(2)=ceil(ylim(2)/5)*5;
                
        set(handles.TabViewsPanel(1),'YLim',ylim);
        
        n=mod(get(varargin{1},'TasksExecuted'),10);
        set(handles.progressbar,'XLim',[0 10/(n+1)]);
    end
end
 set(handles.BrainRecordIR,'UserData',handles);
    
return