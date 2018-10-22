function handles=LayOutFunction(handles)

global NUM_SRC;
global NUM_DET;

figure(handles.cw6figure);
set(handles.cw6figure,'visible','on');
set(handles.cw6figure,'units','normalized');
set(handles.cw6figure,'position',[-3 0.1 1 .9]);

set(gcf,'name','CW6 Data Aquisition Version 0.l');
import com.mathworks.mde.desk.*
d = MLDesktop.getInstance;
f = d.getClient('Cw6');
img=javax.swing.ImageIcon('Splash.jpg');
r = f.getRootPane;
rp = r.getParent;
rp.setIcon(img); 

%make uitab for detector controls
[Javahandles.Jtabpanel,Javahandles.Jtabpanelactivex2]=actxcontrol('MSComctlLib.TabStrip.2');
set(Javahandles.Jtabpanelactivex2,'tag','noname2');

set(Javahandles.Jtabpanelactivex2,'units',get(handles.tabholder1,'units'));
set(Javahandles.Jtabpanelactivex2,'position',get(handles.tabholder1,'position'));

set(Javahandles.Jtabpanel,'Placement','tabPlacementLeft');
Tabs=Javahandles.Jtabpanel.Tabs;
Tabs.Add([],'Tab2');
Tabs.Add([],'Tab3');
set(Tabs.Item(1),'Caption','Detectors')
set(Tabs.Item(2),'Caption','Lasers')
set(Tabs.Item(3),'Caption','Auxillary')


pos=get(handles.TabContainer,'position');

%Make Detector Tab
[DetTab,DetTabContainer]=javacomponent(javax.swing.JPanel);
set(DetTabContainer,'units','normalized');
set(DetTabContainer,'position',pos);
set(DetTabContainer,'tag','DetTabContainer');
DetJavaHandles=createDetTab(DetTabContainer, ceil(NUM_DET/8));
set(DetTabContainer,'UserData',DetJavaHandles);

%Make Source Tab
[SrcTab,SrcTabContainer]=javacomponent(javax.swing.JPanel);
set(SrcTabContainer,'units','normalized');
set(SrcTabContainer,'position',pos);
set(SrcTabContainer,'tag','SrcTabContainer');
SrcJavaHandles=createSrctab(SrcTabContainer,NUM_SRC);
set(SrcTabContainer,'UserData',SrcJavaHandles);
% 
% 
% % %Make Aux Tab Tab
[AuxTab,AuxTabContainer]=javacomponent(javax.swing.JPanel);
set(AuxTabContainer,'units','normalized');
set(AuxTabContainer,'position',pos);
set(AuxTabContainer,'tag','AuxTabContainer');
% %AuxJavaHandles=createAuxtab(AuxTabContainer,NUMSOURCES);
%set(AuxTabContainer,'UserData',AuxJavaHandles);

registerevent(Javahandles.Jtabpanel,{'Click',@SwitchTab});

tabswitch.SelectedItem.Index=1;
SwitchTab(tabswitch);

set(handles.cw6figure,'visible','on');


%Maximize the window
set(handles.cw6figure,'units','pixels');

%moniters=get(0,'MonitorPositions');
%set(handles.cw6figure,'position',moniters(1,:));
set(handles.cw6figure,'position',[1 10 1680 1000]);

[ProgressBar,ProgressBarContainer]=javacomponent(javax.swing.JProgressBar);
set(ProgressBarContainer,'parent',handles.AquistionButtons);
set(ProgressBarContainer,'units','normalized');
set(ProgressBarContainer,'position',[.02 .4 .64 .3]);
set(ProgressBarContainer,'tag','Cw6Progress');
set(ProgressBarContainer,'userdata',ProgressBar);

return


function SwitchTab(varargin)

selectedIdx=varargin{1}.SelectedItem.Index;

DetTabContainer=findobj('tag','DetTabContainer');
SrcTabContainer=findobj('tag','SrcTabContainer');
AuxTabContainer=findobj('tag','AuxTabContainer');

switch(selectedIdx)
    case(1)
        set(DetTabContainer,'visible','on');
        set(SrcTabContainer,'visible','off');
        set(AuxTabContainer,'visible','off');
        set(get(SrcTabContainer,'children'),'visible','off');
         c=get(get(SrcTabContainer,'children'),'children');
        set(c,'visible','off');
    case(2)
        set(SrcTabContainer,'visible','on');
         set(get(SrcTabContainer,'children'),'visible','on');
        c=get(get(SrcTabContainer,'children'),'children');
        set(c,'visible','on');
        set(DetTabContainer,'visible','off');
        set(AuxTabContainer,'visible','off');
    case(3)
        set(DetTabContainer,'visible','off');
        set(SrcTabContainer,'visible','off');
        set(AuxTabContainer,'visible','on');
        set(get(SrcTabContainer,'children'),'visible','off');
end

return