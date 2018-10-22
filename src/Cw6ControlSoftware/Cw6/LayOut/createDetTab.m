function Javahandles=createDetTab(parent, numDetgroups)

MAXGAIN=255;
MINGAIN=0;

%First make a panel to place the controls into
[Javahandles.Jpanel,Javahandles.JpanelCont]=javacomponent(javax.swing.JPanel);
set(Javahandles.JpanelCont,'Tag','DetectorContainer');
set(Javahandles.JpanelCont,'parent',parent);
set(Javahandles.JpanelCont,'units','normalized');
set(Javahandles.JpanelCont,'position',[0 0 1 1]);


%make AGC button
Javahandles.AGC=uicontrol('style','pushbutton','tag','AGC','parent',Javahandles.JpanelCont);
set(Javahandles.AGC,'units','normalized','position',[.02 .08 .15 .2]);
set(Javahandles.AGC,'string','Automatic Gain Adjust','Callback','AutoAdjustGain');

%make uitab for detector controls
[Javahandles.Jtabpanel,Javahandles.JtabpanelCont]=actxcontrol('MSComctlLib.TabStrip.2');
set(Javahandles.JtabpanelCont,'Tag','DetectorTabContainer');
set(Javahandles.JtabpanelCont,'parent',Javahandles.JpanelCont);

%activeX controls don't handle position info right
set(parent,'units','pixel');
posParent=get(parent,'position');
set(parent,'units','normalized');

pos(1)=posParent(1)+.2*posParent(3);
pos(2)=posParent(2)+.05*posParent(4);
pos(3)=.78*posParent(3);
pos(4)=.9*posParent(4);
%[0.2 .05 .78 .9]
set(Javahandles.JtabpanelCont,'units','pixel');
set(Javahandles.JtabpanelCont,'position',pos);
%set(Javahandles.Jtabpanel,'TabOrientation','fmTabOrientationTop');
for idx=1:Javahandles.Jtabpanel.Tabs.Count
    Javahandles.Jtabpanel.Tabs.Remove(1);
end
set(Javahandles.JtabpanelCont,'units','normalized');

%Now Add tabs
 for idx=1:numDetgroups
       
    Javahandles.Jtabpanel.Tabs.Add;
    set(Javahandles.Jtabpanel.Tabs.Item(idx),'Caption',...
        ['Detectors [' num2str((idx-1)*8+1) '-' num2str((idx)*8) ']' ]);
    
   [Javahandles.tab(idx),Javahandles.tabcont(idx)]=javacomponent(javax.swing.JPanel);
   set(Javahandles.tabcont(idx),'Tag',['DetPanelCont_' num2str(idx)]);
   set(Javahandles.tabcont(idx),'parent',Javahandles.JpanelCont);
   set(Javahandles.tabcont(idx),'units','normalized');
   set(Javahandles.tabcont(idx),'position',[.205 0.055 .75 .75]);
    
   hlink(idx)=linkprop(Javahandles.tabcont(idx),'visible');
   for Det=1:8
        pos=[.05+(Det-1)/8*.9 .05 .1 .1];
        Javahandles.spinner(idx,Det)=uicomponent('style','JSpinner');
        set(Javahandles.spinner(idx,Det),'tag',['DetSpinner_' num2str((idx-1)*8+Det)]);
        set(Javahandles.spinner(idx,Det),'parent',Javahandles.tabcont(idx));
        set(Javahandles.spinner(idx,Det),'units','normalized');
        set(Javahandles.spinner(idx,Det),'position',pos);
        UserData.type='Spinner';
        UserData.DetNum=8*(idx-1)+Det;              
        set(Javahandles.spinner(idx,Det),'UserData',UserData);
        set(Javahandles.spinner(idx,Det),'value',0);
        set(Javahandles.spinner(idx,Det),'StateChangedCallback',['GUIChangeDetector_callback('...
             num2str(idx) ',' num2str(Det) ')']);
         hlink(idx).addtarget(Javahandles.spinner(idx,Det));  
             
        Javahandles.slider(idx,Det)=uicomponent('style','JSlider');
                set(Javahandles.spinner(idx,Det),'tag',['DetSlider_' num2str((idx-1)*8+Det)]);
        set(Javahandles.slider(idx,Det),'orientation',1);
        set(Javahandles.slider(idx,Det),'parent',Javahandles.tabcont(idx));
        set(Javahandles.slider(idx,Det),'units','normalized');
        set(Javahandles.slider(idx,Det),'position',pos+[0 .1 0 .6]);
        set(Javahandles.slider(idx,Det),'Value',0);
        set(Javahandles.slider(idx,Det),'Maximum',MAXGAIN);
        set(Javahandles.slider(idx,Det),'Minimum',MINGAIN);
        set(Javahandles.slider(idx,Det),'StateChangedCallback',['GUIChangeDetector_callback('...
            num2str(idx) ',' num2str(Det) ')']);
        set(Javahandles.slider(idx,Det),'MouseWheelMovedCallback',@Slider_mousewheel);
            
            
            
        UserData.type='Slider';
        UserData.DetNum=8*(idx-1)+Det;              
        set(Javahandles.slider(idx,Det),'UserData',UserData);
        hlink(idx).addtarget(Javahandles.slider(idx,Det));   
                
        Javahandles.LED(idx,Det)=uicontrol('style','edit');
                set(Javahandles.spinner(idx,Det),'tag',['DetLED_' num2str((idx-1)*8+Det)]);
        set(Javahandles.LED(idx,Det),'parent',Javahandles.tabcont(idx));
        set(Javahandles.LED(idx,Det),'units','normalized');
        set(Javahandles.LED(idx,Det),'position',pos+[0 .84 0 -.05]);
        set(Javahandles.LED(idx,Det),'BackgroundColor','g');
        hlink(idx).addtarget(Javahandles.LED(idx,Det));
        
        Javahandles.text(idx,Det)=uicontrol('style','text');
                set(Javahandles.spinner(idx,Det),'tag',['DetText_' num2str((idx-1)*8+Det)]);
        set(Javahandles.text(idx,Det),'parent',Javahandles.tabcont(idx));
        set(Javahandles.text(idx,Det),'units','normalized');
        set(Javahandles.text(idx,Det),'string',num2str((idx-1)*8+Det));
        set(Javahandles.text(idx,Det),'position',pos+[0 .94 0 -.05]);
        hlink(idx).addtarget(Javahandles.text(idx,Det));
        
    end
set(Javahandles.tabcont(idx),'visible','off');
    
end

Javahandles.hlink=hlink;
set(parent,'UserData',Javahandles);

registerevent(Javahandles.Jtabpanel,{'Click' @switchtab});

set(Javahandles.hlink(1).Targets,'visible','on');

return

function switchtab(varargin)

selectedIdx=varargin{1}.SelectedItem.Index;
Javahandles=get(get(findobj('tag','DetectorContainer'),'parent'),'UserData');

for idx=1:length(Javahandles.tabcont)
    if(idx~=selectedIdx)
        set(Javahandles.hlink(idx).Targets,'visible','off');
    end
end
set(Javahandles.hlink(selectedIdx).Targets,'visible','on');


return

function Slider_mousewheel(varargin)

scroll=get(varargin{2},'WheelRotation');
if(scroll==0)
    scroll=1;
end
scroll=-scroll;
comp=get(varargin{2},'Component');
value=get(comp(1),'Value');

if((get(comp(1),'Minimum')<=value+scroll) & (get(comp(1),'Maximum')>=value+scroll))
    set(comp(1),'Value',value+scroll);
end
return
