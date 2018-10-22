function Javahandles=createSrctab(parent,NUMSOURCES)


%First make a panel to place the controls into
[Javahandles.Jpanel,Javahandles.JpanelCont]=javacomponent(javax.swing.JPanel);
set(Javahandles.JpanelCont,'Tag','SrcContainer');
set(Javahandles.JpanelCont,'parent',parent);
set(Javahandles.JpanelCont,'units','normalized');
set(Javahandles.JpanelCont,'position',[0 0 1 1]);

Javahandles.ChangeAllLasers=uicontrol('style','pushbutton','tag','ChangeAllLasers',...
    'units','normalized','parent',Javahandles.JpanelCont);
set(Javahandles.ChangeAllLasers,'string','All On','visible','on','position',[.05 .3 .2 .12]);
set(Javahandles.ChangeAllLasers,'Callback',@SetAllLasers);
set(Javahandles.ChangeAllLasers,'UserData',0);

numgroups=floor(NUMSOURCES/8);

hlink=linkprop(Javahandles.JpanelCont,'visible');

cnt=1;
for idx=1:numgroups
    for laser=1:8
        pos=[.3 .1 .7/(numgroups+2) .7/8]+(idx-1)*[.7/(numgroups+2) 0 0 0]+...
            (8-laser)*[0 .7/8 0 0]+floor(idx/3)*[.7/(numgroups+2) 0 0 0];
        if(mod(idx,2)==1)
            wavelength='690';
        else
            wavelength='830';
        end
        Javahandles.Lasers(cnt)=uicontrol('style','pushbutton','tag',['Laser_' num2str(cnt)],...
        'units','normalized');
           set(Javahandles.Lasers(cnt),'string',['Laser ' num2str(cnt) ' (' wavelength 'nm )'],...
               'position',pos,'visible','on');
         set(Javahandles.Lasers(cnt),'Callback',@SetLaser);  
         set(Javahandles.Lasers(cnt),'UserData',0);
         set(Javahandles.Lasers(cnt),'parent',Javahandles.JpanelCont);
        
        hlink.addtarget(Javahandles.Lasers(cnt));
        cnt=cnt+1;
    end
end
set(Javahandles.JpanelCont,'visible','on');
set(parent,'UserData',Javahandles);


return



function SetAllLasers(varargin)

global NUM_SRC;

hObject=findobj('tag','ChangeAllLasers');
handles=guihandles(findobj('tag','cw6figure'));

state=get(gcbo,'UserData');

if(state==0)
    %turn all on
    set(gcbo,'string','All Off');
    set(gcbo,'UserData',1);
else
    set(gcbo,'string','All On');
    set(gcbo,'UserData',0);
end

system=get(handles.AquistionButtons,'Userdata');

if(~isfield(system,'AQSettings'))
    system.AQSettings.Lasers=zeros(NUM_SRC,1);
elseif(~isfield(system.AQSettings,'Lasers'))
    system.AQSettings.Lasers=zeros(NUM_SRC,1);
end
system.AQSettings.Lasers(:)=get(gcbo,'UserData');
set(handles.AquistionButtons,'Userdata',system);

state=get(gcbo,'UserData');
for idx=1:NUM_SRC
    setlaser(system.MainDevice,idx,state);
end

return









