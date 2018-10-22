function PlotSDG(handles)
%This figure plots the SDG 

SubjInfo=get(handles.RegistrationInfo,'UserData');
SD=SubjInfo.Probe;

%FIX
SNR=nan(length(SD.MeasList),1);


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

SDGcontextmenu=uicontextmenu('tag','SDGcontextmenu');
set(SDGcontextmenu,'parent',handles.cw6figure);

set(handles.SDG_PlotWindow,'uicontextmenu',SDGcontextmenu);

axes(handles.SDG_PlotWindow);
set(gca,'Color',[.95 .95 .95]);
cla;
hold on;

numMeas=size(SD.MeasList,1);
numStates=length(unique(SD.MeasList(:,5)));
colors=SD.Colors;

PlotLst=SubjInfo.SDGdisplay.PlotLst;
hL=[];

for idx=1:numStates   
    mlLst=PlotLst;
    mlLst=find(SD.MeasList(mlLst,5)==idx);
    mlLst=PlotLst(mlLst);
    for mIdx=1:length(mlLst)
        sI=SD.MeasList(mlLst(mIdx),1);
        dI=SD.MeasList(mlLst(mIdx),2);
        idx2=mod(mlLst(mIdx),numMeas/length(SD.Lambda));
        if(idx2==0); idx2=numMeas/length(SD.Lambda); end
        axes(handles.SDG_PlotWindow);
        hL(end+1)=line([SD.SrcPos(sI,1) SD.DetPos(dI,1)],...
            [SD.SrcPos(sI,2) SD.DetPos(dI,2)],'color',colors(idx2,:));
        menu=uicontextmenu;
        smenu=uimenu('label',['SNR = ' num2str(SNR(mlLst(mIdx)))],'parent',menu);
        set(hL(end),'uicontextmenu',menu);
        set(hL(end),'ButtonDownFcn',@ToggleLine);
        set(hL(end),'Userdata',mlLst(mIdx));
        if~(SubjInfo.SDGdisplay.MLAct(mlLst(mIdx))==1)
            set(hL(end),'LineStyle','--','LineWidth',2);
        else
            set(hL(end),'LineStyle','-','LineWidth',2);
        end
    end
end

for Sidx=1:SD.NumSrc
    axes(handles.SDG_PlotWindow);
    hS(Sidx)=text(SD.SrcPos(Sidx,1),SD.SrcPos(Sidx,2),['S-' num2str(Sidx)],'color','k');
    set(hS(Sidx),'ButtonDownFcn',@SelectSrc);
    set(hS(Sidx),'UserData',Sidx);
end
for Didx=1:SD.NumDet
    axes(handles.SDG_PlotWindow);
    hD(Didx)=text(SD.DetPos(Didx,1),SD.DetPos(Didx,2),['D-' num2str(Didx)],'color','k');
    set(hD(Didx),'ButtonDownFcn',@SelectDet);
    set(hD(Didx),'UserData',Didx);
end
set(hD,'FontWeight','bold')
set(hS,'FontWeight','bold')
axes(handles.SDG_PlotWindow);
axis([minX maxX minY maxY]);
plotmainwindow;
return


function ToggleLine(varargin)
handles=guihandles(findobj('tag','cw6figure'));
idx=get(gcbo,'Userdata');
SubjInfo=get(handles.RegistrationInfo,'UserData');
SubjInfo.SDGdisplay.MLAct(idx)=~SubjInfo.SDGdisplay.MLAct(idx);
set(handles.RegistrationInfo,'UserData',SubjInfo);
PlotSDG(handles);
return


function SelectDet(varargin)

global NUM_LAMBDA;
handles=guihandles(findobj('tag','cw6figure'));
idx=get(gcbo,'UserData');

Lambda=get(handles.WhichDisplay,'value');
if(Lambda>NUM_LAMBDA)
    Lambda=1;
end

SubjInfo=get(handles.RegistrationInfo,'UserData');
SubjInfo.SDGdisplay.PlotLst=find(SubjInfo.Probe.MeasList(:,2)==idx &...
    SubjInfo.Probe.MeasList(:,4)==Lambda);
set(handles.RegistrationInfo,'UserData',SubjInfo);
PlotSDG(handles);
return

function SelectSrc(varargin)
global NUM_LAMBDA;
handles=guihandles(findobj('tag','cw6figure'));
idx=get(gcbo,'UserData');

Lambda=get(handles.WhichDisplay,'value');
if(Lambda>NUM_LAMBDA)
    Lambda=1;
end
SubjInfo=get(handles.RegistrationInfo,'UserData');
SubjInfo.SDGdisplay.PlotLst=find(SubjInfo.Probe.MeasList(:,1)==idx &...
    SubjInfo.Probe.MeasList(:,4)==Lambda);
set(handles.RegistrationInfo,'UserData',SubjInfo);
PlotSDG(handles);
return


