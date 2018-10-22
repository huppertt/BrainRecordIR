function SetLaser(varargin)

hObject=varargin{1};
[foo,laserIdx]=strtok(get(hObject,'Tag'),'_');
laserIdx=str2num(laserIdx(2:end));

global NUM_SRC;

handles=guihandles(findobj('tag','cw6figure'));
system=get(handles.AquistionButtons,'Userdata');
Javahandles=get(findobj('tag','SrcTabContainer'),'UserData');
handles=guihandles(findobj('tag','cw6figure'));
system=get(handles.AquistionButtons,'Userdata');
Javahandles=get(findobj('tag','SrcTabContainer'),'UserData');

if(~isfield(system,'AQSettings'))
    system.AQSettings.Lasers=zeros(NUM_SRC,1);
elseif(~isfield(system.AQSettings,'Lasers'))
    system.AQSettings.Lasers=zeros(NUM_SRC,1);
end

if(system.AQSettings.Lasers(laserIdx)==1)
    system.AQSettings.Lasers(laserIdx)=0;
    set(Javahandles.Lasers(laserIdx),'ForegroundColor',[0 0 0]);
else
    system.AQSettings.Lasers(laserIdx)=1;
    set(Javahandles.Lasers(laserIdx),'ForegroundColor',[1 0 0]);
end

setlaser(system.MainDevice,laserIdx,system.AQSettings.Lasers(laserIdx));
set(handles.AquistionButtons,'Userdata',system);
return