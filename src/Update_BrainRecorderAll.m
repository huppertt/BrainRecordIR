function Update_BrainRecorderAll(handles,type)


% TODO-
str=get(handles.SwitchType,'Value');
if(~isempty(strfind(str,'Raw')))
    selected=1;
elseif(~isempty(strfind(str,'dOD')))
    selected=2;
else
    selected=3;
end



if(nargin<2)
   if(selected==3)
        type=cellstr(str(strfind(str,':')+2:end));
    else
        type=str2num(str(strfind(str,':')+1:end-2));
    end
end

try
    get(handles.Drawing.SDGhandles(1),'LineStyle');
catch
    handles.Drawing.SDGhandles=[];
end

try
    get(handles.Drawing.Datahandles(1),'LineStyle');
catch
    handles.Drawing.Datahandles=[];
end


    type2=get(handles.SDGplot_select,'Value');
    if(isa(handles.Subject.data(selected).probe,'nirs.core.Probe1020'))
        switch(type2)
            case('2D View')
                handles.Subject.data(selected).probe.defaultdrawfcn='2D';
            case('10-20 View')
                handles.Subject.data(selected).probe.defaultdrawfcn='10-20 zoom';
            case('Brain View')
                handles.Subject.data(selected).probe.defaultdrawfcn='3D mesh';
        end
    else
        type2='2D View';
        set(handles.SDGplot_select,'Value','2D View');
        set(handles.SDGplot_select,'Enable','off');
    end
    
    if(~isfield(handles,'Drawing') || ~isfield(handles.Drawing,'SDGhandles') || isempty(handles.Drawing.SDGhandles))
        cla(handles.SDGPanel)
        handles.Drawing.SDGhandles=handles.Subject.data(selected).probe.draw([],[],handles.SDGPanel);
        if(strcmp(type2,'10-20 View'))
            set(handles.SDGPanel,'YDir','reverse');
            set(handles.SDGPanel,'XDir','normal');
        elseif(strcmp(type2,'2D View'))
            set(handles.SDGPanel,'YDir','normal');
            set(handles.SDGPanel,'XDir','reverse');
        else
            set(handles.SDGPanel,'YDir','normal');
            set(handles.SDGPanel,'XDir','normal');
        end
    end
    
    
    
    link=handles.Subject.data(selected).probe.link;
    lstNull=find(~ismember(link.type,type));
    lstGood=find(ismember(link.type,type));
    link(lstNull,:)=[];
    
    if(~isfield(handles,'Drawing') || ~isfield(handles.Drawing,'SDcolors'))
        handles.Drawing.SDcolors=nirs.util.makeSDcolors(link);
    end
    
    if(~isfield(handles,'Drawing') || ~isfield(handles.Drawing,'MeasListAct'))
        handles.Drawing.MeasListAct=false(height(link),1);
        handles.Drawing.MeasListAct(1)=true;
    end
    
    if(~isempty(handles.Subject.data(selected).data))
        if(~isfield(handles,'Drawing') || ~isfield(handles.Drawing,'Datahandles') || isempty( handles.Drawing.Datahandles))
            warning('off','MATLAB:legend:IgnoringExtraEntries');
            cla(handles.TabViewsPanel(1))
            lstAll=1:height(handles.Subject.data(selected).probe.link);
            handles.Drawing.Datahandles=handles.Subject.data(selected).draw(lstAll,[],handles.TabViewsPanel(1));
            legend(handles.TabViewsPanel(1),'off')
        end
        
        
        
        set(handles.Drawing.Datahandles(:),'Visible','off');
        set(handles.Drawing.Datahandles(lstGood(handles.Drawing.MeasListAct)),'Visible','on');
    end
    
    
    for i=1:length(handles.Drawing.SDGhandles)
        set(handles.Drawing.SDGhandles(i),'Tag',['S' num2str(i)]);
        if(~isempty(handles.Drawing.Datahandles))
            set(handles.Drawing.Datahandles(find(handles.Subject.data(selected).probe.link.source==link.source(i) & ...
                handles.Subject.data(selected).probe.link.detector==link.detector(i))),'Color',handles.Drawing.SDcolors(i,:));
        end
        if(handles.Drawing.MeasListAct(i))
            set(handles.Drawing.SDGhandles(i),'Color',handles.Drawing.SDcolors(i,:));
            set(handles.Drawing.SDGhandles(i),'LineStyle','-');
        else
            set(handles.Drawing.SDGhandles(i),'Color',[.7 .7 .7]);
            set(handles.Drawing.SDGhandles(i),'LineStyle','-');
        end
    end
    
    set(handles.Drawing.SDGhandles(:),'ButtonDownFcn',@ClickSDGLines);
    
    if(isa(handles.Subject.data(selected).probe,'nirs.core.Probe1020'))
        set(handles.SDGplot_select,'Enable','on');
    end


set(handles.BrainRecordIR,'UserData',handles);
guidata(handles.BrainRecordIR,handles);
return



function ClickSDGLines(varargin)

handles=get(get(get(gcbo,'Parent'),'Parent'),'userdata');
idx=get(gcbo,'Tag');
idx=str2num(idx(2:end));

if(~handles.Drawing.MeasListAct(idx))
    %turning on, see if the shift key is down
    if(varargin{2}.Button==1);
        handles.Drawing.MeasListAct(:)=false;
        
    end
    handles.Drawing.MeasListAct(idx)=true;
else
    handles.Drawing.MeasListAct(idx)=~handles.Drawing.MeasListAct(idx);
end
Update_BrainRecorderAll(handles);

return





