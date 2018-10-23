function BrainRecordIR=InitializeFigure()

% I haven't decided if I like this look or not
addLasersControls2All=false;  

handles=struct;

folder=fileparts(which('BrainRecordIR.m'));
if(exist(fullfile(folder,'System.config'),'file'))
    system=[];
    load(fullfile(folder,'System.config'),'-MAT');
    handles.system=system;
else
   disp('Default configuration not found: restoring');
   system=restore_default_settings('Simulator');
end

handles.Instrument=NIRSinstrument(handles.system.Type);

position=get(0,'ScreenSize');
position(4)=position(4)*.95;

position=position(1,:);
position(1)=position(3);
position(2)=position(4);

handles.BrainRecordIR=uifigure('tag','BrainRecordIR');
set(handles.BrainRecordIR,'Name','Brain RecordIR','Position',[0 0 1 1].*position);
BrainRecordIR=handles.BrainRecordIR;

% Create the view panels
handles.TabViews = uitabgroup('parent',handles.BrainRecordIR);
set(handles.TabViews,'Position',[.02 .02 .6 .85].*position);

handles.TabViewsSub(1)=uitab(handles.TabViews,'title','Research View');
handles.TabViewsPanel(1) = uiaxes('tag','mainPanel','parent',handles.TabViewsSub(1));
set(handles.TabViewsPanel(1),'Position',[.02 .02 .57 .80].*position,'Box','on');

handles.TabViewsSub(2)=uitab(handles.TabViews,'title','Clinical View');
handles.TabViewsPanel(2) = uiaxes('tag','mainPanel','parent',handles.TabViewsSub(2));
set(handles.TabViewsPanel(2),'Position',[.02 .02 .57 .80].*position,'Box','on');

handles.TabViewsSub(3)=uitab(handles.TabViews,'title','Statistics View');
handles.TabViewsPanel(3) = uiaxes('tag','mainPanel','parent',handles.TabViewsSub(3));
set(handles.TabViewsPanel(3),'Position',[.02 .02 .57 .80].*position,'Box','on');


handles.TabViewsSub(4)=uitab(handles.TabViews,'title','Tiled View');
handles.TabViewsPanel(4) = uiaxes('tag','mainPanel','parent',handles.TabViewsSub(4));
set(handles.TabViewsPanel(4),'Position',[.02 .02 .57 .80].*position,'Box','on');

set(handles.TabViews,'SelectedTab',handles.TabViewsSub(1));


% Create Probe drawing window
handles.SDGPanel = uiaxes('tag','mainSDG','parent',handles.BrainRecordIR);
set(handles.SDGPanel,'Position',[.65 .55 .3 .35].*position,'Box','on','XTick',[],'YTick',[]);

% Create Control tab windows
handles.TabMain = uitabgroup('parent',handles.BrainRecordIR);
set(handles.TabMain,'Position',[.65 .03 .3 .38].*position);


handles.Tab(1)=uitab(handles.TabMain,'title','Sources');
handles.Tab(2)=uitab(handles.TabMain,'title','Detectors');
handles.Tab(3)=uitab(handles.TabMain,'title','Events');
handles.Tab(4)=uitab(handles.TabMain,'title','Real-time');
handles.Tab(5)=uitab(handles.TabMain,'title','File List');



%% Set up the detector panel
handles.TabMainDet = uitabgroup('parent',handles.Tab(2));
set(handles.TabMainDet,'Position',[120 20 430 350]);
set(handles.TabMainDet,'TabLocation','left');
cnt=1;
ndets=length(handles.system.Detectors.Detector2OptodeMapping);
maxpanels = ceil(ndets/8);

for i=1:maxpanels
    if(maxpanels>1)
        handles.DetTab(i)=uitab(handles.TabMainDet,'Title',[num2str((i-1)*8+1) '-' num2str(i*8)]);
    else
        handles.DetTab(i)=handles.TabMainDet;
    end
    for j=1:8
        if(cnt<=ndets)
            handles.DetPanel(cnt)=uipanel('Parent',handles.DetTab(i),'Title',num2str(cnt));
            set(handles.DetPanel(cnt),'Position',[330*(j-1)/8+20 10 330/8 330])
            set(handles.DetPanel(cnt),'FontWeight','bold','TitlePosition','centertop');
            handles.DetSlider(cnt)=uislider('Parent',handles.DetPanel(cnt),'MajorTicks',[]);
            set(handles.DetSlider(cnt),'Orientation','Vertical','Position',[10 40 3 240]);
            handles.DetLamp(cnt)=uilamp('Parent',handles.DetPanel(cnt),'Position',[10 290 15 15]);
            handles.DetSpinner(cnt)=uispinner('Parent',handles.DetPanel(cnt),'Position',[1 10 38 20]);
            
            cnt=cnt+1;
        end
    end
end
% the spinners are too small to see the 3 digits in the gain value, but
% making the font too small to read is better then "255" showing as "2" 
set(handles.DetSpinner(:),'FontSize',6,'FontWeight','BOLD');
set(handles.DetSpinner(:),'Step',5);

if(addLasersControls2All)
    handles.LaserAllOn(2)=uiswitch(handles.Tab(2),'toggle','Orientation','horizontal');
    set(handles.LaserAllOn(2),'Position',[20 320 85 30])
    handles.LaserAllOnLamp(2)=uilamp('Parent',handles.Tab(2));
    set(handles.LaserAllOnLamp(2),'Position',[43 270 40 40])
    set(handles.LaserAllOnLamp(2),'Color',[.7 .7 .7])
    h=uilabel('parent',handles.Tab(2));
    set(h,'Position',[20 355 85 20],'Text','Laser Control','FontWeight','BOLD');
    set(handles.LaserAllOn(2),'ValueChangedFcn','BrainRecordIR(''LasersAllOnOff'');');
end

handles.DetOptimize=uibutton('Parent',handles.Tab(2));
set(handles.DetOptimize,'Text','Auto-Adjust','Position',[20 220 85 30])

handles.ShowSNR=uibutton('Parent',handles.Tab(2));
set(handles.ShowSNR,'Text','Show SNR','Position',[20 180 85 30])


%% set all the callbacks 
for i=1:length(handles.DetSlider)
    range=system.Detectors.Detector2OptodeMapping(i).Range;
   
    set(handles.DetSlider(i),'Limits',range,'Value',1,'Userdata',system.Detectors.Detector2OptodeMapping(i));
    set(handles.DetSlider(i),'ValueChangedFcn','BrainRecordIR(''UpdateDetectorSlider'');');
    set(handles.DetSpinner(i),'Limits',range,'Value',1,'Userdata',system.Detectors.Detector2OptodeMapping(i));
    set(handles.DetSpinner(i),'ValueChangedFcn','BrainRecordIR(''UpdateDetectorSpinner'');');    
    
    if(system.Detectors.Detector2OptodeMapping(i).short_seperation)
        set(handles.DetPanel(i),'Title',[get(handles.DetPanel(i),'Title') '-S']);
    end
    
end

set(handles.DetOptimize,'ButtonPushedFcn','BrainRecordIR(''OptimizeDetectors'');');
set(handles.ShowSNR,'ButtonPushedFcn','BrainRecordIR(''ShowSNRDetectors'');');





%% Set up the Source panel

if(addLasersControls2All)
    handles.LaserAllOn(1)=uiswitch(handles.Tab(1),'toggle','Orientation','horizontal');
    set(handles.LaserAllOn(1),'Position',[20 320 85 30])
    handles.LaserAllOnLamp(1)=uilamp('Parent',handles.Tab(1));
    set(handles.LaserAllOnLamp(1),'Position',[43 270 40 40])
    set(handles.LaserAllOnLamp(1),'Color',[.7 .7 .7])
    h=uilabel('parent',handles.Tab(1));
    set(h,'Position',[20 355 85 20],'Text','Laser Control','FontWeight','BOLD')
    set(handles.LaserAllOn(1),'ValueChangedFcn','BrainRecordIR(''LasersAllOnOff'');');
end

handles.LaserOptimize=uibutton('Parent',handles.Tab(1));
set(handles.LaserOptimize,'Text','Auto-Adjust','Position',[20 220 85 30])

handles.SrcLink=uicheckbox('Parent',handles.Tab(1));
set(handles.SrcLink,'Text','Link Colors','Position',[20 180 85 30])
set(handles.SrcLink,'Value',true)


SrcPos=zeros(length(handles.system.Lasers.Laser2OptodeMapping),3);
for i=1:length(handles.system.Lasers.Laser2OptodeMapping)
    SrcPos(i,1)=handles.system.Lasers.Laser2OptodeMapping(i).Optode;
    SrcPos(i,2)=handles.system.Lasers.Laser2OptodeMapping(i).Laser;
    SrcPos(i,3)=handles.system.Lasers.Laser2OptodeMapping(i).Wavelength;
end

[~,srcOrder]=sort(SrcPos(:,1));
SrcPos=SrcPos(srcOrder,:);
uSrcPos=unique(SrcPos(:,1));
nsrcs= length(uSrcPos);
npanels = ceil(nsrcs/8);

if(npanels>1)
handles.TabMainSrc = uitabgroup('parent',handles.Tab(1));
set(handles.TabMainSrc,'Position',[120 20 430 350]);
set(handles.TabMainSrc,'TabLocation','left');
end

cnt=1;
for i=1:npanels
    if(npanels>1)
        
        handles.SrcTab(i)=uitab(handles.TabMainSrc,'Title',[num2str((i-1)*8+1) '-' num2str(i*8)]);
    else
        handles.SrcTab(i)=uipanel(handles.Tab(1),'Position',[120 20 430 350]);
    end
    for j=1:8
        if(cnt<=nsrcs)
            cnt2=uSrcPos(cnt);
            Lambda=find(SrcPos(:,1)==uSrcPos(cnt));
            handles.SrcPanel(cnt2)=uipanel('Parent',handles.SrcTab(i),'Title',['Source- ' num2str(uSrcPos(cnt))]);
            set(handles.SrcPanel(cnt2),'Position',[20 320-300*j/8 330 330/8])
            set(handles.SrcPanel(cnt2),'FontWeight','bold','TitlePosition','lefttop');
            for k=1:length(Lambda)
                handles.SrcButton(cnt2,k)=uiswitch(handles.SrcPanel(cnt2),'rocker','Orientation','horizontal','Items',{'off','on'});
                set(handles.SrcButton(cnt2,k),'Position',[10+(k-1)*240/length(Lambda) 2 40 18]);
                set(handles.SrcButton(cnt2,k),'FontColor',get(handles.Tab(1),'BackgroundColor'));
                if(handles.system.Lasers.Adjustable)
                    handles.Srcspinner(cnt2,k)=uispinner('Parent',handles.SrcPanel(cnt2));
                    set(handles.Srcspinner(cnt2,k),'Position',[51+(k-1)*240/length(Lambda) 2 39 18]);
                else
                    handles.Srcspinner=[];
                end
                
            end
            cnt=cnt+1;
        end
    end
    
end

useLaserAdjust=system.Lasers.Adjustable;
cnt=1;
for i=1:size(handles.Srcspinner,1)
    for j=1:size(handles.Srcspinner,2)
        if(useLaserAdjust)
            
            set(handles.Srcspinner(i,j),'Limits',handles.system.Lasers.GainRange,'Value',1,'Userdata',handles.system.Lasers.Laser2OptodeMapping(srcOrder(cnt)));
            set(handles.Srcspinner(i,j),'ValueChangedFcn',['BrainRecordIR(''UpdateSourceSpinner(' num2str(i) ',' num2str(j) ')'');']);
        end
        set(handles.SrcButton(i,j),'Userdata',handles.system.Lasers.Laser2OptodeMapping(srcOrder(cnt)));
        set(handles.SrcButton(i,j),'ValueChangedFcn',['BrainRecordIR(''UpdateSourceToggle(' num2str(i) ',' num2str(j) ')'');']);
        cnt=cnt+1;
    end
end

set(handles.LaserOptimize,'ButtonPushedFcn','BrainRecordIR(''OptimizeLasers'');');




%% Set up the Events tab
colnames = {'Name', 'Onset', 'Duration','Amplitude'};
handles.eventtable = uitable( 'Parent', handles.Tab(3), 'ColumnName', colnames);
set(handles.eventtable,'Position',[200 60 350 300]);

handles.eventCOMpanel=uipanel('Parent',handles.Tab(3),'Title','Event Listener');  
set(handles.eventCOMpanel,'Position',[10 270 170 90])
h=uilabel('Parent',handles.eventCOMpanel);               
set(h,'Position',[10 40 150 20],'Text','UDP/IP Address')
handles.COMeditfield = uieditfield('Parent',handles.eventCOMpanel);
set(handles.COMeditfield,'Position',[10 20 150 20],'Value','10.0.0.1');
set(handles.COMeditfield,'ValueChangedFcn','BrainRecordIR(''COMListenerEditChanged'');');


handles.eventbutton(1)=uibutton('parent',handles.Tab(3));
set(handles.eventbutton(1),'Position',[30 200 100 20],'Text','Mark Event-1');
set(handles.eventbutton(1),'UserData',struct('index',1,'stimName','event1'));
set(handles.eventbutton(1),'ButtonPushedFcn','BrainRecordIR(''EventButton(1)'')');
handles.eventlamp(1)=uilamp('Parent',handles.Tab(3));
set(handles.eventlamp(1),'Position',[135 200 20 20])
set(handles.eventlamp(1),'Color',[.7 .7 .7])
warning('off','MATLAB:ui:ToggleSwitch:noSizeChangeForRequestedWidth');
handles.eventtoggle(1)=uiswitch(handles.Tab(3),'toggle','Orientation','horizontal');
set(handles.eventtoggle(1),'Position',[65 220 85 30]);
set(handles.eventbutton(1),'ButtonPushedFcn','BrainRecordIR(''EventToggle(1)'')');


handles.eventbutton(2)=uibutton('parent',handles.Tab(3));
set(handles.eventbutton(2),'Position',[30 150 100 20],'Text','Mark Event-2');
set(handles.eventbutton(2),'UserData',struct('index',2,'stimName','event2'));
set(handles.eventbutton(2),'ButtonPushedFcn','BrainRecordIR(''EventButton(2)'')');
handles.eventlamp(2)=uilamp('Parent',handles.Tab(3));
set(handles.eventlamp(2),'Position',[135 150 20 20])
set(handles.eventlamp(2),'Color',[.7 .7 .7])
warning('off','MATLAB:ui:ToggleSwitch:noSizeChangeForRequestedWidth');
handles.eventtoggle(2)=uiswitch(handles.Tab(3),'toggle','Orientation','horizontal');
set(handles.eventtoggle(2),'Position',[65 170 85 30]);
set(handles.eventbutton(2),'ButtonPushedFcn','BrainRecordIR(''EventToggle(2)'')');

handles.eventbutton(3)=uibutton('parent',handles.Tab(3));
set(handles.eventbutton(3),'Position',[30 100 100 20],'Text','Mark Event-3');
set(handles.eventbutton(3),'UserData',struct('index',3,'stimName','event3'));
set(handles.eventbutton(3),'ButtonPushedFcn','BrainRecordIR(''EventButton(3)'')');
handles.eventlamp(3)=uilamp('Parent',handles.Tab(3));
set(handles.eventlamp(3),'Position',[135 100 20 20])
set(handles.eventlamp(3),'Color',[.7 .7 .7])
warning('off','MATLAB:ui:ToggleSwitch:noSizeChangeForRequestedWidth');
handles.eventtoggle(3)=uiswitch(handles.Tab(3),'toggle','Orientation','horizontal');
set(handles.eventtoggle(3),'Position',[65 120 85 30]);
set(handles.eventbutton(3),'ButtonPushedFcn','BrainRecordIR(''EventToggle(3)'')');



handles.eventbutton(4)=uibutton('parent',handles.Tab(3));
set(handles.eventbutton(4),'Position',[30 50 100 20],'Text','Mark Event-4');
set(handles.eventbutton(4),'UserData',struct('index',4,'stimName','event4'));
set(handles.eventbutton(4),'ButtonPushedFcn','BrainRecordIR(''EventButton(4)'')');
handles.eventlamp(4)=uilamp('Parent',handles.Tab(3));
set(handles.eventlamp(4),'Position',[135 50 20 20])
set(handles.eventlamp(4),'Color',[.7 .7 .7])
warning('off','MATLAB:ui:ToggleSwitch:noSizeChangeForRequestedWidth');
handles.eventtoggle(4)=uiswitch(handles.Tab(3),'toggle','Orientation','horizontal');
set(handles.eventtoggle(4),'Position',[65 70 85 30]);
set(handles.eventbutton(4),'ButtonPushedFcn','BrainRecordIR(''EventToggle(4)'')');


handles.stimwizard=uibutton('parent',handles.Tab(3));
set(handles.stimwizard,'Position',[400 10 150 30],'Text','Edit Stimulus Events');
set(handles.stimwizard,'ButtonPushedFcn','BrainRecordIR(''stimwizard'')');




%% File list page
handles.filelist = uitree('Parent',handles.Tab(5));
set(handles.filelist,'Position',[20 60 540 290]);
set(handles.filelist,'SelectionChangedFcn','BrainRecordIR(''SelectSaveFile'');');

handles.PostAnalysisButton=uibutton('Parent',handles.Tab(5));
set(handles.PostAnalysisButton,'Position',[410 20 150 30],'Text','Analyze Data','FontWeight','Bold');
set(handles.PostAnalysisButton,'ButtonPushedFcn','BrainRecordIR(''PostAnalysis'');');


handles.filelist_raw = uitreenode(handles.filelist,'Text','Raw Files','NodeData',[]);
handles.filelist_loaded = uitreenode(handles.filelist,'Text','Previous Files','NodeData',[]);
handles.filelist_stats = uitreenode(handles.filelist,'Text','Statistics Results','NodeData',[]);


%% Set up the start/stop controls
% aquistion panel
handles.ACQpanel=uipanel('Parent',handles.BrainRecordIR);
set(handles.ACQpanel,'Position',[.65 .42 .3 .12].*position);

handles.StartButton=uibutton('Parent',handles.ACQpanel);
set(handles.StartButton,'Position',[20 80 150 40],'Text','Start Collection','FontWeight','Bold');
set(handles.StartButton,'ButtonPushedFcn','BrainRecordIR(''StartDAQ'');');

handles.progressbar=uiaxes('Parent',handles.ACQpanel);
set(handles.progressbar,'Position',[180 80 200 40]);
set(handles.progressbar,'Box','on','XTick',[],'YTick',[]);

handles.LaserAllOnLamp(3)=uilamp('Parent',handles.ACQpanel);
set(handles.LaserAllOnLamp(3),'Position',[520 65 40 40]);
set(handles.LaserAllOnLamp(3),'Color',[.7 .7 .7]);

handles.SwitchType = uidropdown('parent',handles.ACQpanel);
set(handles.SwitchType,'Position',[20 10 150 30]);
h=uilabel('parent',handles.ACQpanel);
set(h,'Position',[20 40 150 20],'Text','Data Selection');
set(handles.SwitchType,'ValueChangedFcn','BrainRecordIR(''SelectWhichData'');');


warning('off','MATLAB:ui:ToggleSwitch:noSizeChangeForRequestedHeight');
handles.LaserAllOn(3)=uiswitch(handles.ACQpanel,'toggle','Orientation','horizontal');
set(handles.LaserAllOn(3),'Position',[410  65   80  36]);
h=uilabel('parent',handles.ACQpanel);
set(h,'Position',[410 100 150 20],'Text','Laser Control','FontWeight','BOLD');
set(handles.LaserAllOn(3),'ValueChangedFcn','BrainRecordIR(''LasersAllOnOff'');');

handles.eventbutton(5)=uibutton('Parent',handles.ACQpanel);
set(handles.eventbutton(5),'Position',[200 10 150 30],'Text','Mark Event');
handles.numstimlabel=uilabel('parent',handles.ACQpanel);
set(handles.numstimlabel,'Position',[200 40 150 20],'Text','#events=0');
set(handles.eventbutton(5),'ButtonPushedFcn','BrainRecordIR(''EventButton(5)'')');

handles.windowdataedit=uieditfield(handles.ACQpanel,'numeric');
set(handles.windowdataedit,'Position',[410 10 150 30],'FontSize',14,'Value',60)
set(handles.windowdataedit,'ValueChangedFcn','BrainRecordIR(''EditWindowData'')');


handles.windowdatacheck=uicheckbox('parent',handles.ACQpanel);
set(handles.windowdatacheck,'Position',[410 40 150 20],'Text','Window Data');
set(handles.windowdatacheck,'ValueChangedFcn','BrainRecordIR(''CheckWindowData'')');

handles.SDGplot_select=uidropdown('parent',handles.BrainRecordIR);
set(handles.SDGplot_select,'Position',[.85 .9 .098 .03].*position);
set(handles.SDGplot_select,'Items',{'2D View','10-20 View','Brain View'},'Enable','off');
set(handles.SDGplot_select,'ValueChangedFcn','BrainRecordIR(''ChangeProbeView'')');


%% The menu items

handles.menu(1)=uimenu('parent',handles.BrainRecordIR,'Text','File');
handles.menu(2)=uimenu('parent',handles.menu(1),'Text','Register Subject');
set(handles.menu(2),'MenuSelectedFcn','BrainRecordIR(''RegisterSubject'')');
handles.menu(3)=uimenu('parent',handles.menu(1),'Text','Load Saved Data');
set(handles.menu(3),'MenuSelectedFcn','BrainRecordIR(''LoadPrevious'')');


handles.menu(4)=uimenu('parent',handles.menu(1),'Text','Preferences');
set(handles.menu(4),'MenuSelectedFcn','BrainRecordIR(''SystemPreferences'')');
handles.menu(5)=uimenu('parent',handles.menu(1),'Text','Exit');
set(handles.menu(5),'MenuSelectedFcn','BrainRecordIR(''Exit'')');
set(handles.BrainRecordIR,'CloseRequestFcn','BrainRecordIR(''Exit'')');

handles.menu(6)=uimenu('parent',handles.BrainRecordIR,'Text','About');
set(handles.menu(6),'MenuSelectedFcn','BrainRecordIR(''AboutMSG'')');


set(handles.BrainRecordIR,'UserData',handles);
guidata(handles.BrainRecordIR,handles);

return