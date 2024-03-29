function StartDAQ(handles,hObject)

global BrainRecordIRApp;


if(BrainRecordIRApp.Device.isrunning)
    BrainRecordIRApp.Device.Stop();
    BrainRecordIRApp.MainTimer.stop();
    
    try; stop(timerfindall); end;
    try; delete(timerfindall); end;
      SystemMessage('Stopping Instrument');
  
    
    BrainRecordIRApp.Tree.Enable='on';   
    BrainRecordIRApp.ShowNoiseMapButton.Enable='on';
    BrainRecordIRApp.ShowQualityMenu.Enable='on';
    
    %set(handles.stimwizard,'Enable','off')
    BrainRecordIRApp.RunAnalysisButton.Enable='on';
    BrainRecordIRApp.RegisterProbe.Enable='on';
    BrainRecordIRApp.RegisterNewSubjectMenu.Enable='on';
    BrainRecordIRApp.LoadSavedDataMenu.Enable='on';
    
    BrainRecordIRApp.StartButton.Text='Start Collection';
    
    % save data
    p=fullfile(BrainRecordIRApp.Folders.DefaultData,...
        BrainRecordIRApp.Subject.data(1).demographics('investigator'),...
        BrainRecordIRApp.Subject.data(1).demographics('study'),...
        BrainRecordIRApp.Subject.data(1).demographics('subject'),...
        datestr(now,'mmm-dd-yyyy'));
        
 
        scannum=length(get(BrainRecordIRApp.RecordedFilesNode,'children'))+1;
        
        filename=[ BrainRecordIRApp.Subject.data(1).demographics('subject') ...
            '-scan' num2str(scannum) '-' datestr(now,'mmm-dd-yyyy-HH-MM-PM') ];
        if(~exist(p,'dir'))
            mkdir(p);
        end
        filename(strfind(filename,' '))=[];
        if(ismember('.nirs',BrainRecordIRApp.Folders.DefaultFileType))
            nirs.io.saveDotNirs(BrainRecordIRApp.Subject.data(1),[],fullfile(p,[filename '.nirs']));
            filen=fullfile(p,[filename '.nirs']);
             SystemMessage(['Data saved as: ' filen]);
        end
        if(ismember('.snirf',BrainRecordIRApp.Folders.DefaultFileType))
            nirs.io.saveNIR5(BrainRecordIRApp.Subject.data(1),fullfile(p,[filename '.nir5']));
             filen=fullfile(p,[filename '.nir5']);
             SystemMessage(['Data saved as: ' filen]);
        end
         
        Subject.data(1).description=filename;
        a=uitreenode(BrainRecordIRApp.RecordedFilesNode,'Text',filename,'NodeData',[],'Userdata',BrainRecordIRApp.Subject.data);
        set(BrainRecordIRApp.Tree,'SelectionChangedFcn',@SelectSaveFile)
        BrainRecordIRApp.Tree.SelectedNodes=a;
        
        
        
else
    % turn off some things that should not be clicked while running
    BrainRecordIRApp.Tree.Enable='off';   
    BrainRecordIRApp.ShowNoiseMapButton.Enable='off';
    BrainRecordIRApp.ShowQualityMenu.Enable='off';
    
    %set(handles.stimwizard,'Enable','off')
    BrainRecordIRApp.RunAnalysisButton.Enable='off';
    BrainRecordIRApp.RegisterProbe.Enable='off';
    BrainRecordIRApp.RegisterNewSubjectMenu.Enable='off';
    BrainRecordIRApp.LoadSavedDataMenu.Enable='off';
    
    fs=BrainRecordIRApp.Device.sample_rate;
    BrainRecordIRApp.Realtime.BPF = BPF;
    lpf=BrainRecordIRApp.LowPassEditField.Value;
    hpf=BrainRecordIRApp.HighPassEditField.Value;
    if(BrainRecordIRApp.CheckBox.Value & BrainRecordIRApp.CheckBox_2.Value)
        [fa,fb]=butter(4,[hpf lpf]*2/fs);  %bandpass
        BrainRecordIRApp.Realtime.BPF.initfilter(fa,fb);
    elseif(~BrainRecordIRApp.CheckBox.Value & BrainRecordIRApp.CheckBox_2.Value)
        [fa,fb]=butter(4,[lpf]*2/fs); % low pass only
        BrainRecordIRApp.Realtime.BPF.initfilter(fa,fb);
    elseif(BrainRecordIRApp.CheckBox.Value & ~BrainRecordIRApp.CheckBox_2.Value)
        [fa,fb]=butter(4,[hpf]*2/fs,'high'); % high pass only
        BrainRecordIRApp.Realtime.BPF.initfilter(fa,fb);
    else
        BrainRecordIRApp.Realtime.BPF=[];
    end
    
    link=BrainRecordIRApp.Subject.defaultdata.probe.link;
    for i=1:height(link)
        BrainRecordIRApp.Realtime.SNR(i)=SNI;
        BrainRecordIRApp.Realtime.SNR(i).initfilter;
    end
    
    
    BrainRecordIRApp.Realtime.OpticalDensity=OpticalDensity;
    BrainRecordIRApp.Realtime.MBLL = MBLL;
    BrainRecordIRApp.Realtime.MBLL.initialize(BrainRecordIRApp.Subject.defaultdata.probe);
    
    BrainRecordIRApp.Realtime.GLM = KalmanGLM;
    BrainRecordIRApp.Realtime.GLM.initfilter(BrainRecordIRApp.Realtime.MBLL.probeout);
    
    BrainRecordIRApp.Realtime.SO2 = CalcSO2;
    
    %% TODO
    
    nsrc=size(BrainRecordIRApp.Realtime.MBLL.probeout.srcPos,1);
    lst1=[1:floor(nsrc/2)]';
    lst2=[ceil(nsrc/2)+1:nsrc]';
    
    ROI{1}=table(lst1,NaN(size(lst1)),'VariableNames',{'source','detector'});
    ROI{2}=table(lst2,NaN(size(lst2)),'VariableNames',{'source','detector'});
   
    BrainRecordIRApp.Realtime.SO2.initfilter(BrainRecordIRApp.Realtime.MBLL.probeout,ROI);
    
    types={};
    utypes=unique(BrainRecordIRApp.Subject.data(1).probe.link.type);
for i=1:length(utypes)
    types{end+1}=['Raw: ' num2str(utypes(i)) 'nm'];
end
for i=1:length(utypes)
    types{end+1}=['dOD: ' num2str(utypes(i)) 'nm'];
end
types{end+1}='Hemoglobin: hbo';
types{end+1}='Hemoglobin: hbr';

set(BrainRecordIRApp.SelectDisplayType,'Items',types);
    
    
    try; stop(timerfindall); end;
    try; delete(timerfindall); end;
    
    BrainRecordIRApp.MainTimer=timer;
    set(BrainRecordIRApp.MainTimer,'ExecutionMode','fixedRate');
    set(BrainRecordIRApp.MainTimer,'Period',.5);
    set(BrainRecordIRApp.MainTimer,'TimerFcn',@updatedata);
    
    BrainRecordIRApp.Subject.data=BrainRecordIRApp.Subject.defaultdata;
    BrainRecordIRApp.Subject.data.data=[];
    BrainRecordIRApp.Subject.data.time=[];
    BrainRecordIRApp.Subject.data.stimulus=Dictionary;
    BrainRecordIRApp.Subject.data(2)=BrainRecordIRApp.Subject.data(1);
    BrainRecordIRApp.Subject.data(3)=BrainRecordIRApp.Subject.data(1);
    BrainRecordIRApp.Subject.data(3).probe=BrainRecordIRApp.Realtime.MBLL.probeout;
    
    BrainRecordIRApp.StartButton.Text='Stop Collection';
    BrainRecordIRApp.Drawing.Datahandles=[];
    cla(BrainRecordIRApp.Progressbar);
    fill(BrainRecordIRApp.Progressbar,[0 1 1 0],[0 0 1 1],'g');
    set(BrainRecordIRApp.Progressbar,'XLim',[0 100]);
   
    BrainRecordIRApp.UITable.Data={};
    BrainRecordIRApp.Label_2.Text='0';

    SystemMessage('Starting Instrument');
    cla(BrainRecordIRApp.MainPlotWindow);
    BrainRecordIRApp.Device=BrainRecordIRApp.Device.sendMLinfo(BrainRecordIRApp.Subject.defaultdata.probe);
    BrainRecordIRApp.Device.Start();
    BrainRecordIRApp.MainTimer.start();
end


return



function updatedata(varargin)
global BrainRecordIRApp;



try

if(BrainRecordIRApp.Device.samples_avaliable>0)
    [d,t]=BrainRecordIRApp.Device.get_samples(BrainRecordIRApp.Device.samples_avaliable);
    % d=f.update(d')';
    if(isempty(t))
        return
    end
    
    BrainRecordIRApp.Subject.data(1).data=[BrainRecordIRApp.Subject.data(1).data; d];
    BrainRecordIRApp.Subject.data(1).time=[BrainRecordIRApp.Subject.data(1).time; t];
    
    for i=1:size(d,2)
        SNR(i)=BrainRecordIRApp.Realtime.SNR(i).update(d(:,i));
    end
    link=BrainRecordIRApp.Subject.data(1).probe.link;
    det=unique(link.detector);
    for i=1:length(det)
        ss(i)=mean(SNR(find(link.detector==det(i))));
        if(ss(i)>3)
            BrainRecordIRApp.handles.Detectors{i,4}.Color=[0 1 0];
        elseif(ss(i)>1)
            BrainRecordIRApp.handles.Detectors{i,4}.Color=[.7 1 .7];
        elseif(ss(i)>.5)
            BrainRecordIRApp.handles.Detectors{i,4}.Color=[.7 .7 0];
        else
            BrainRecordIRApp.handles.Detectors{i,4}.Color=[1 0 0];
        end
    end
    
    for i=1:size(d,1)
        d1(i,:)=BrainRecordIRApp.Realtime.OpticalDensity.update(d(i,:)')';
        if(~isempty(BrainRecordIRApp.Realtime.BPF))
            d1(i,:)=BrainRecordIRApp.Realtime.BPF.update(d1(i,:)')';
        end
    end
    BrainRecordIRApp.Subject.data(2).stimulus=BrainRecordIRApp.Subject.data(1).stimulus;
    BrainRecordIRApp.Subject.data(2).data=[BrainRecordIRApp.Subject.data(2).data; d1];
    BrainRecordIRApp.Subject.data(2).time=[BrainRecordIRApp.Subject.data(2).time; t];
    for i=1:size(d,1)
        d2(i,:)=BrainRecordIRApp.Realtime.MBLL.update(d1(i,:)')';
    end
    
    BrainRecordIRApp.Subject.data(3).stimulus=BrainRecordIRApp.Subject.data(1).stimulus;
    BrainRecordIRApp.Subject.data(3).data=[BrainRecordIRApp.Subject.data(3).data; d2];
    BrainRecordIRApp.Subject.data(3).time=[BrainRecordIRApp.Subject.data(3).time; t];
    
    BrainRecordIRApp.Realtime.GLM.update(BrainRecordIRApp.Subject.data(3),t);
    BrainRecordIRApp.UIAxesStatsViewPlot.UserData=BrainRecordIRApp.Realtime.GLM.Stats;
    
    if(~isempty(BrainRecordIRApp.UIAxesStatsViewPlot.UserData.conditions))
    set(BrainRecordIRApp.ListBoxWhichContrast,'Items',BrainRecordIRApp.UIAxesStatsViewPlot.UserData.conditions);
    else
        set(BrainRecordIRApp.ListBoxWhichContrast,'Items',{});
    end
    for i=1:size(d,1)
        so2(i,:)=BrainRecordIRApp.Realtime.SO2.update(d2(i,:)')';
    end
    
    
end




str=BrainRecordIRApp.SelectDisplayType.Value;
if(contains(str,'Raw'))
    selected=1;
elseif(contains(str,'dOD'))
    selected=2;
else
    selected=3;
end

if(isempty(BrainRecordIRApp.Drawing.Datahandles))
    Update_BrainRecorderAll();
else
    for i=1:length(BrainRecordIRApp.Drawing.Datahandles)
        x=get(BrainRecordIRApp.Drawing.Datahandles(i),'Xdata');
        y=get(BrainRecordIRApp.Drawing.Datahandles(i),'Ydata');
        
        if(selected==1)
            set(BrainRecordIRApp.Drawing.Datahandles(i),'Xdata',[x t'],'Ydata',[y d(:,i)']);
        elseif(selected==2)
            set(BrainRecordIRApp.Drawing.Datahandles(i),'Xdata',[x t'],'Ydata',[y d1(:,i)']);
        else
            set(BrainRecordIRApp.Drawing.Datahandles(i),'Xdata',[x t'],'Ydata',[y d2(:,i)']);
        end
        
        
    end
    
    xlim=[0 t(end)];
    if(get(BrainRecordIRApp.WindowDataCheckBox,'value'))
        v=get(BrainRecordIRApp.WindowDataEditField,'value');
        xlim(1)=max(0,xlim(2)-v);
    else
        xlim(1)=0;
        
    end
    
    
    link=BrainRecordIRApp.Subject.data(selected).probe.link;
     str=BrainRecordIRApp.SelectDisplayType.Value;
   if(selected==3)
        type=cellstr(str(strfind(str,':')+2:end));
   elseif(contains(str,'HRF'))
       type=cellstr(str(strfind(str,':')+2:end));
    else
        type=str2double(str(strfind(str,':')+1:end-2));
   end
   
   lstNull=~ismember(link.type,type);
   lstGood=find(ismember(link.type,type));
   link(lstNull,:)=[];
   
   if(BrainRecordIRApp.AutoscaleYaxisCheckBox.Value)
       lst2=find(ismember(BrainRecordIRApp.Subject.data(selected).probe.link,link(BrainRecordIRApp.Drawing.MeasListAct,:)));
   else
       lst2=1:height(link);
   end
   
   lst=find(BrainRecordIRApp.Subject.data(selected).time>=xlim(1) & BrainRecordIRApp.Subject.data(selected).time<=xlim(end));
    
    set(BrainRecordIRApp.MainPlotWindow,'XLim',xlim);
    %handles.Drawing.MeasListAct
    ylim(1)=min(min(BrainRecordIRApp.Subject.data(selected).data(lst,lst2)));
    ylim(2)=max(max(BrainRecordIRApp.Subject.data(selected).data(lst,lst2)));
    if(ylim(1)==ylim(2))
        ylim(2)=ylim(1)+1;
    end
    %     ylim(1)=floor(ylim(1)/5)*5;
    %     ylim(2)=ceil(ylim(2)/5)*5;
    
    set(BrainRecordIRApp.MainPlotWindow,'YLim',ylim);
    
    n=mod(get(varargin{1},'TasksExecuted'),10);
    set(BrainRecordIRApp.Progressbar,'XLim',[0 10/(n+1)]);
    
    try
        BrainRecordIRApp.RightSO2EditField.Value=.1*round(1000*so2(end,1));
        BrainRecordIRApp.LeftSO2EditField.Value=.1*round(1000*so2(end,2));
        for i=1:2
            x=get(BrainRecordIRApp.Drawing.Clinical(i),'Xdata');
            y=get( BrainRecordIRApp.Drawing.Clinical(i),'Ydata');
            set(BrainRecordIRApp.Drawing.Clinical(i),'Xdata',[x t'],'Ydata',[y 100*so2(:,i)']);
        end
        set(BrainRecordIRApp.UIAxesClinicalView,'XLim',xlim);
        set(BrainRecordIRApp.UIAxesClinicalView,'YLim',[50 100]);
    end
    ChangeProbeViewStats;
    
end

catch
    Update_BrainRecorderAll();
end
return