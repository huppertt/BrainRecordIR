function NIRS_timer_main_callback(varargin)
%This is the main timer callack function to handle the real-time processing

figurehandle=findobj('tag','cw6figure');
Cw6_data = get(figurehandle,'UserData');

AquistionButtons=findobj('tag','AquistionButtons');
system=get(AquistionButtons,'Userdata');

if(~isrunning(system.MainDevice))
    return;
end
try
    numSamples=samplesavaliable(system.MainDevice);
catch
    return
end
if(numSamples<=0)
    return
end

handles=guihandles(figurehandle);
SubjInfo=get(handles.RegistrationInfo,'UserData');
SD=SubjInfo.Probe;

for sample=1:numSamples

[currentdata,currenttime]=getsamples(system.MainDevice,1);

if(isempty(currentdata))
    return
end

aux=currentdata(end-5:end,:);
currentdata=currentdata(SD.DataToMLMap,:);

if(~isempty(system.AuxDevice))
    numSamplesAux=samplesavaliable(system.AuxDevice);
    [currentauxdata,currentauxtime]=getsamples(system.AuxDevice,numSamples);
else
    currentauxdata=aux;
    currentauxtime=[currenttime];
end
stim=Cw6_data.data.stim;

if(isfield(Cw6_data,'RTmodules'))
   [currenttime,currentdata,currentauxdata,currentconcdata,stim]=...
        processRTfunctions(currenttime,currentdata,currentauxdata,stim);
else
    currentconcdata=[];
end

%Add back to the data structure
Cw6_data = get(figurehandle,'UserData');
Cw6_data.data.stim=stim;
Cw6_data.data.raw=[Cw6_data.data.raw currentdata];
Cw6_data.data.raw_t=[Cw6_data.data.raw_t currenttime];
Cw6_data.data.conc=[Cw6_data.data.conc currentconcdata];
Cw6_data.data.aux=[Cw6_data.data.aux currentauxdata];

set(figurehandle,'UserData',Cw6_data);

end

ProgressBar=get(findobj('tag','Cw6Progress'),'UserData');
set(ProgressBar,'Value',Cw6_data.data.raw_t(end));

plotmainwindow;

return
