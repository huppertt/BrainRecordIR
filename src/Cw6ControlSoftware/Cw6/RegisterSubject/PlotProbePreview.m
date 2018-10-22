function PlotProbePreview(SD)
f=findobj('tag','RegSubject');
if(isempty(f))
    return
end
handles=guidata(f);

axes(handles.ProbePreview);
cla;

if isempty(SD)
    set(handles.IsPreview,'String','Preview: ');
    set(handles.activex1,'Text',' ');
    return
end


maxX=max([SD.SrcPos(:,1); SD.DetPos(:,1)]);
minX=min([SD.SrcPos(:,1); SD.DetPos(:,1)]);
maxY=max([SD.SrcPos(:,2); SD.DetPos(:,2)]);
minY=min([SD.SrcPos(:,2); SD.DetPos(:,2)]);

rangeX=maxX-minX;
rangeY=maxY-minY;
maxX=maxX+.25*rangeX;
minX=minX-.25*rangeX;
maxY=maxY+.25*rangeY;
minY=minY-.25*rangeY;


numStates=length(unique(SD.MeasList(:,5)));
colors=bone(numStates);

hL=[];
for idx=1:numStates
    mlLst=find(SD.MeasList(:,5)==idx & SD.MeasList(:,4)==1);
    
    for mIdx=1:length(mlLst)
    sI=SD.MeasList(mlLst(mIdx),1);
    dI=SD.MeasList(mlLst(mIdx),2);
    
    hL(end+1)=line([SD.SrcPos(sI,1) SD.DetPos(dI,1)],...
        [SD.SrcPos(sI,2) SD.DetPos(dI,2)],'color',colors(idx,:));
    end
end
    


for Sidx=1:SD.NumSrc
    hS(Sidx)=text(SD.SrcPos(Sidx,1),SD.SrcPos(Sidx,2),'X','color','b');
end
for Didx=1:SD.NumDet
    hD(Didx)=text(SD.DetPos(Didx,1),SD.DetPos(Didx,2),'O','color','b');
end

set(hD,'FontWeight','bold')
set(hS,'FontWeight','bold')

axis([minX maxX minY maxY]);

[foo,filename,ext]=fileparts(SD.Name);
set(handles.IsPreview,'UserData',SD);

ExtraHandles=get(handles.uipanel2,'UserData');


set(ExtraHandles.RichText1,'Text',SD.Description);

return