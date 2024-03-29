function Update_BrainRecorderAll(type)
global BrainRecordIRApp;


if(isfield(BrainRecordIRApp.Drawing,'MeasListAct') && ~any(BrainRecordIRApp.Drawing.MeasListAct))
    set(BrainRecordIRApp.Drawing.SDGhandles(:),'Color',[.7 .7 .7]);
    set(BrainRecordIRApp.Drawing.SDGhandles(:),'LineStyle','-');
    set(BrainRecordIRApp.Drawing.Datahandles(:),'Visible','off');
    
    return
end

% TODO-
str=BrainRecordIRApp.SelectDisplayType.Value;
if(contains(str,'Raw'))
    selected=1;
    str2=' [unfiltered]';
elseif(contains(str,'dOD'))
    selected=2;
    str2=' [filtered]';
elseif(contains(str,'HRF'))
    selected=1;
    str2=' [filtered]';
else
    selected=3;
    str2=' [filtered]';
end


if(nargin<1)
    if(selected==3)
        type=cellstr(str(strfind(str,':')+2:end));
        
    elseif(contains(str,'HRF'))
        type=cellstr(str(strfind(str,':')+2:end));
        
    else
        type=str2double(str(strfind(str,':')+1:end-2));
        
    end
end


set(BrainRecordIRApp.Raw690nmunfilteredLabel,'Text',[str str2]);
set(BrainRecordIRApp.Raw690nmunfilteredLabel,'FontWeight','bold');

% use try/catch blocks here to handle any possible reasons why the
% drawings may be messed up and reset
try
    get(BrainRecordIRApp.Drawing.SDGhandles(1),'LineStyle');
catch
    BrainRecordIRApp.Drawing.SDGhandles=[];
end

try
    get(BrainRecordIRApp.Drawing.Datahandles(1),'LineStyle');
catch
    BrainRecordIRApp.Drawing.Datahandles=[];
end


type2=BrainRecordIRApp.DrawMode4Probe.Value;
if(isa(BrainRecordIRApp.Subject.data(selected).probe,'nirs.core.Probe1020'))
    switch(type2)
        case('Flat View')
            BrainRecordIRApp.Subject.data(selected).probe.defaultdrawfcn='2D';
        case('10-20 View')
            BrainRecordIRApp.Subject.data(selected).probe.defaultdrawfcn='10-20 zoom';
        case('3D View')
            BrainRecordIRApp.Subject.data(selected).probe.defaultdrawfcn='3D mesh';
    end
else
    type2='2D View';
    set(BrainRecordIRApp.DrawMode4Probe,'Value','2D View');
    set(BrainRecordIRApp.DrawMode4Probe,'Enable','off');
end
set(BrainRecordIRApp.SDGPlotWindow,'BackgroundColor','w');

if(~isfield(BrainRecordIRApp,'Drawing') || ~isfield(BrainRecordIRApp.Drawing,'SDGhandles') || isempty(BrainRecordIRApp.Drawing.SDGhandles))
    cla(BrainRecordIRApp.SDGPlotWindow);
    BrainRecordIRApp.Drawing.SDGhandles=BrainRecordIRApp.Subject.data(selected).probe.draw([],[],BrainRecordIRApp.SDGPlotWindow);
    if(strcmp(type2,'10-20 View'))
        set(BrainRecordIRApp.SDGPlotWindow,'YDir','normal');
        set(BrainRecordIRApp.SDGPlotWindow,'XDir','reverse');
        
    elseif(strcmp(type2,'Flat View'))
        view(BrainRecordIRApp.SDGPlotWindow,0,90);
        set(BrainRecordIRApp.SDGPlotWindow,'YDir','normal');
        set(BrainRecordIRApp.SDGPlotWindow,'XDir','reverse');
    else
        set(BrainRecordIRApp.SDGPlotWindow,'YDir','normal');
        set(BrainRecordIRApp.SDGPlotWindow,'XDir','normal');
        nirs.util.lightsurface(BrainRecordIRApp.SDGPlotWindow);
    end
    
    if(strcmp(type2,'10-20 View'))
        set(BrainRecordIRApp.UIAxesStatsViewPlot,'YDir','normal');
        set(BrainRecordIRApp.UIAxesStatsViewPlot,'XDir','reverse');
        text(BrainRecordIRApp.SDGPlotWindow,.95,.1,'R','units','normalized','FontWeight','BOLD','fontsize',28);

    elseif(strcmp(type2,'Flat View'))
        view(BrainRecordIRApp.SDGPlotWindow,0,90);
        set(BrainRecordIRApp.UIAxesStatsViewPlot,'YDir','normal');
        set(BrainRecordIRApp.UIAxesStatsViewPlot,'XDir','reverse');
        text(BrainRecordIRApp.SDGPlotWindow,0,0,'R','units','normalized','FontWeight','BOLD','fontsize',28);

    else
        set(BrainRecordIRApp.UIAxesStatsViewPlot,'YDir','normal');
        set(BrainRecordIRApp.UIAxesStatsViewPlot,'XDir','normal');
        text(BrainRecordIRApp.SDGPlotWindow,0,.1,'R','units','normalized','FontWeight','BOLD','fontsize',28);

    end
    
end



link=BrainRecordIRApp.Subject.data(selected).probe.link;
lstNull=~ismember(link.type,type);
lstGood=find(ismember(link.type,type));
link(lstNull,:)=[];

if( ~isfield(BrainRecordIRApp.Drawing,'SDcolors'))
    BrainRecordIRApp.Drawing.SDcolors=nirs.util.makeSDcolors(link);
end

if( ~isfield(BrainRecordIRApp.Drawing,'MeasListAct'))
    BrainRecordIRApp.Drawing.MeasListAct=false(height(link),1);
    BrainRecordIRApp.Drawing.MeasListAct(1)=true;
end

if(~isempty(BrainRecordIRApp.Subject.data(selected).data))
    if(~isfield(BrainRecordIRApp,'Drawing') || ~isfield(BrainRecordIRApp.Drawing,'Datahandles') || isempty(BrainRecordIRApp.Drawing.Datahandles))
        warning('off','MATLAB:legend:IgnoringExtraEntries');
        cla(BrainRecordIRApp.MainPlotWindow)
        lstAll=1:height(BrainRecordIRApp.Subject.data(selected).probe.link);
        BrainRecordIRApp.Drawing.Datahandles=BrainRecordIRApp.Subject.data(selected).draw(lstAll,[],BrainRecordIRApp.MainPlotWindow);
        legend(BrainRecordIRApp.MainPlotWindow,'off')
    end
    
    
    
    set(BrainRecordIRApp.Drawing.Datahandles(:),'Visible','off');
    set(BrainRecordIRApp.Drawing.Datahandles(lstGood(BrainRecordIRApp.Drawing.MeasListAct)),'Visible','on');
end


for i=1:length(BrainRecordIRApp.Drawing.SDGhandles)
    set(BrainRecordIRApp.Drawing.SDGhandles(i),'Tag',['S' num2str(i)]);
    if(~isempty(BrainRecordIRApp.Drawing.Datahandles))
        set(BrainRecordIRApp.Drawing.Datahandles(BrainRecordIRApp.Subject.data(selected).probe.link.source==link.source(i) & ...
            BrainRecordIRApp.Subject.data(selected).probe.link.detector==link.detector(i)),'Color',BrainRecordIRApp.Drawing.SDcolors(i,:));
    end
    if(BrainRecordIRApp.Drawing.MeasListAct(i))
        set(BrainRecordIRApp.Drawing.SDGhandles(i),'Color',BrainRecordIRApp.Drawing.SDcolors(i,:));
        set(BrainRecordIRApp.Drawing.SDGhandles(i),'LineStyle','-');
    else
        set(BrainRecordIRApp.Drawing.SDGhandles(i),'Color',[.7 .7 .7]);
        set(BrainRecordIRApp.Drawing.SDGhandles(i),'LineStyle','-');
    end
end

set(BrainRecordIRApp.Drawing.SDGhandles(:),'ButtonDownFcn',@ClickSDGLines);

if(isa(BrainRecordIRApp.Subject.data(selected).probe,'nirs.core.Probe1020'))
    set(BrainRecordIRApp.DrawMode4Probe,'Enable','on');
end


try
    cla(BrainRecordIRApp.UIAxesClinicalView); hold(BrainRecordIRApp.UIAxesClinicalView,'on');
    BrainRecordIRApp.Drawing.Clinical(1)=plot(BrainRecordIRApp.UIAxesClinicalView,-10,0,'g');
    BrainRecordIRApp.Drawing.Clinical(2)=plot(BrainRecordIRApp.UIAxesClinicalView,-10,0,'g');
end

if(~isempty(BrainRecordIRApp.UIAxesStatsViewPlot.UserData))
    cla(BrainRecordIRApp.UIAxesStatsViewPlot);
    Stats=BrainRecordIRApp.UIAxesStatsViewPlot.UserData;
    
    if(isa(Stats.probe,'nirs.core.Probe'))
        BrainRecordIRApp.DrawMode4StatsView.Items={'2D HbO2','2D HbR'};
    else
        BrainRecordIRApp.DrawMode4StatsView.Items={'2D HbO2','2D HbR',...
            '10-20 HbO2','10-20 HbR','3D HbO2','3D HbR'};
    end
    view2=BrainRecordIRApp.DrawMode4StatsView.Value;
    if(isa(Stats.probe,'nirs.core.Probe1020'))
        if(contains(view2,'2D'))
            Stats.probe.defaultdrawfcn='2D';
        elseif(contains(view,'10-20'))
            Stats.probe.defaultdrawfcn='10-20';
        else
            Stats.probe.defaultdrawfcn='3D mesh';
        end
    end
    BrainRecordIRApp.Drawing.StatsHandles=Stats.probe.draw([],[],BrainRecordIRApp.UIAxesStatsViewPlot);
    ChangeProbeViewStats;
end



l=text(BrainRecordIRApp.SDGPlotWindow,.01,1,'ROI-RIGHT','units','normalized','FontWeight','BOLD');
r=text(BrainRecordIRApp.SDGPlotWindow,.01,.9,'ROI-LEFT','units','normalized','FontWeight','BOLD');
set(l,'ButtonDownFcn',@ClickROI1);
set(r,'ButtonDownFcn',@ClickROI2);

return



function ClickSDGLines(varargin)

global BrainRecordIRApp;

idx=get(gcbo,'Tag');
idx=str2double(idx(2:end));

if(~BrainRecordIRApp.Drawing.MeasListAct(idx))
    %turning on, see if the shift key is down
    if(varargin{2}.Button==1)
        BrainRecordIRApp.Drawing.MeasListAct(:)=false;
        
    end
    BrainRecordIRApp.Drawing.MeasListAct(idx)=true;
else
    BrainRecordIRApp.Drawing.MeasListAct(idx)=~BrainRecordIRApp.Drawing.MeasListAct(idx);
end
Update_BrainRecorderAll;

return


function ClickROI1(varargin)

global BrainRecordIRApp;
str=BrainRecordIRApp.SelectDisplayType.Value;
if(contains(str,'Raw'))
    selected=1;
elseif(contains(str,'dOD'))
    selected=2;
elseif(contains(str,'HRF'))
    selected=1;
else
    selected=3;
end
if(selected==3)
    type=cellstr(str(strfind(str,':')+2:end));
    
elseif(contains(str,'HRF'))
    type=cellstr(str(strfind(str,':')+2:end));
    
else
    type=str2double(str(strfind(str,':')+1:end-2));
    
end
link=BrainRecordIRApp.Subject.data(selected).probe.link;
lstNull=~ismember(link.type,type);
link(lstNull,:)=[];
lst=find(ismember(link.source,[1 2]));
if(sum(1*BrainRecordIRApp.Drawing.MeasListAct(lst)/length(lst))>=.5)
    BrainRecordIRApp.Drawing.MeasListAct(lst)=false;
else
    BrainRecordIRApp.Drawing.MeasListAct(lst)=true;
end
Update_BrainRecorderAll;


return

function ClickROI2(varargin)

global BrainRecordIRApp;
str=BrainRecordIRApp.SelectDisplayType.Value;
if(contains(str,'Raw'))
    selected=1;
elseif(contains(str,'dOD'))
    selected=2;
elseif(contains(str,'HRF'))
    selected=1;
else
    selected=3;
end
if(selected==3)
    type=cellstr(str(strfind(str,':')+2:end));
    
elseif(contains(str,'HRF'))
    type=cellstr(str(strfind(str,':')+2:end));
    
else
    type=str2double(str(strfind(str,':')+1:end-2));
    
end
link=BrainRecordIRApp.Subject.data(selected).probe.link;
lstNull=~ismember(link.type,type);
link(lstNull,:)=[];
lst=find(ismember(link.source,[3 4]));
if(sum(1*BrainRecordIRApp.Drawing.MeasListAct(lst)/length(lst))>=.5)
    BrainRecordIRApp.Drawing.MeasListAct(lst)=false;
else
    BrainRecordIRApp.Drawing.MeasListAct(lst)=true;
end
Update_BrainRecorderAll;

return
